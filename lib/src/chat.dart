import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat_sdk/src/adapters/chat_adapter.dart';
import 'package:flutter_chat_sdk/src/config/chat_config.dart';
import 'package:flutter_chat_sdk/src/config/chat_identity_provider.dart';
import 'package:flutter_chat_sdk/src/config/chat_logger.dart';
import 'package:flutter_chat_sdk/src/config/chat_registry.dart';
import 'package:flutter_chat_sdk/src/core/database/chat_database.dart';
import 'package:flutter_chat_sdk/src/core/encryption/encryption_service.dart';
import 'package:flutter_chat_sdk/src/core/event_bus/chat_event_bus.dart';
import 'package:flutter_chat_sdk/src/core/queue/outbound_queue.dart';
import 'package:flutter_chat_sdk/src/core/security/database_key_config.dart';
import 'package:flutter_chat_sdk/src/core/sync/sync_engine.dart';
import 'package:flutter_chat_sdk/src/domain/domain.dart';
import 'package:flutter_chat_sdk/src/domain/entities/file_attachment.dart';
import 'package:flutter_chat_sdk/src/domain/entities/presence_result.dart';
import 'package:flutter_chat_sdk/src/exceptions/chat_exception.dart';
import 'package:uuid/uuid.dart';

/// Current user-scoped readiness of the chat SDK.
enum ChatSessionState {
  /// Local SDK services are initialized, but no current user is known yet.
  initialized,

  /// Current user is known; offline user-scoped data can be presented.
  identified,

  /// Current user is known and the realtime connection is connected.
  connected,
}

/// Main entry point for Chat SDK.
///
/// This is the facade class that provides all chat functionality.
/// It follows a backend-agnostic pattern with offline-first support.
///
/// ## Features
/// - Backend-agnostic (use any backend via adapters)
/// - Offline-first with outbound queue
/// - Real-time updates via event bus
/// - Reactive streams for UI
/// - Early initialization support (init before user login)
///
/// ## Example
/// ```dart
/// // At app startup
/// final chat = await Chat.create(
///   databasePath: 'chat.db',
///   adapter: MyBackendAdapter(),
///   identityProvider: MyIdentityProvider(),
///   autoConnect: false, // Don't connect until user logs in
/// );
///
/// // After login, identityProvider emits the authenticated user id.
/// await chat.connect();
/// ```
class Chat {
  /// Creates a new [Chat] instance.
  ///
  /// Use [ChatRegistry] to configure the chat SDK.
  Chat(this._registry);
  final ChatRegistry _registry;

  /// Creates, initializes, and optionally connects a Chat instance.
  ///
  /// This is the simplest way to get started with the Chat SDK.
  ///
  /// The SDK can initialize before login. User-scoped APIs become active when
  /// [identityProvider] returns or emits a user id.
  ///
  /// ```dart
  /// // Early initialization (at app startup)
  /// final chat = await Chat.create(
  ///   databasePath: 'chat.db',
  ///   adapter: MyBackendAdapter(),
  ///   identityProvider: MyIdentityProvider(),
  /// );
  /// ```
  static Future<Chat> create({
    required String databasePath,
    required ChatAdapter adapter,
    required ChatIdentityProvider identityProvider,
    DatabaseEncryptionConfig? encryptionConfig,
    bool? autoConnect,
  }) async {
    final config = ChatConfig(
      databasePath: databasePath,
    );

    final registry = ChatRegistry.withAdapter(
      config: config,
      adapter: adapter,
      identityProvider: identityProvider,
      databaseEncryptionConfig: encryptionConfig,
    );

    final chat = Chat(registry);
    await chat.initialize();

    final shouldAutoConnect = autoConnect ?? false;
    if (shouldAutoConnect) {
      await chat.connect();
    }

    return chat;
  }

  // Core services (initialized lazily)
  late final ChatDatabase _database;
  late final SyncEngine _syncEngine;
  late final OutboundQueue _outboundQueue;
  late final ChatEventBus _eventBus;
  late final EncryptionService _encryption;

  // State notifiers
  final _connectionState = ValueNotifier<ChatConnectionState>(
    ChatConnectionState.disconnected,
  );
  final _syncStatus = ValueNotifier<SyncStatus>(SyncStatus.idle);
  final _pendingCount = ValueNotifier<int>(0);
  final _sessionState = ValueNotifier<ChatSessionState>(
    ChatSessionState.initialized,
  );

  // Stream controllers
  final _eventController = StreamController<ChatEvent>.broadcast();
  final _identityChanged = StreamController<void>.broadcast();

  // Stream subscriptions (to be cancelled on dispose)
  final _subscriptions = <StreamSubscription<dynamic>>[];

  bool _isInitialized = false;
  String? _userId;

  // In-memory pagination cursor tracking per conversation
  final Map<String, String?> _conversationPrevBatch = {};

  // ═══════════════════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Whether the SDK is initialized.
  bool get isInitialized => _isInitialized;

  /// The registry containing configuration and dependencies.
  ChatRegistry get registry => _registry;

  /// The current user ID.
  ///
  /// Returns null if the identity provider has no current user yet.
  String? get currentUserId => _userId;

  /// Initialize the chat SDK.
  ///
  /// Must be called before using any other methods.
  /// Typically called during app startup.
  Future<void> initialize() async {
    if (_isInitialized) return;

    ChatLogger.info('Initializing Chat SDK');

    try {
      // Initialize core services
      _database = await _registry.createDatabase();
      _encryption = _registry.createEncryption();
      await _registry.adapter.initialize();
      _eventBus = ChatEventBusImpl();
      _outboundQueue = OutboundQueueImpl(
        adapter: _registry.adapter,
        database: _database,
      );
      await _outboundQueue.initialize();
      _syncEngine = SyncEngineImpl(
        adapter: _registry.adapter,
        database: _database,
        eventBus: _eventBus,
      );

      // Listen to internal event bus and forward to public stream
      _subscriptions
        ..add(
          _eventBus.eventStream.listen(_eventController.add),
        )
        // Listen to identity provider and refresh user-scoped projections.
        ..add(
          _registry.identityProvider.userIdChanges.listen(
            _handleIdentityChanged,
          ),
        )
        // Listen to adapter events and process via sync engine
        ..add(
          _registry.adapter.eventStream.listen(_handleAdapterEvent),
        )
        // Listen to connection state
        ..add(
          _registry.adapter.connectionState.listen((state) {
            _connectionState.value = state;
            if (state == ChatConnectionState.connected) {
              _sessionState.value = _sessionStateForCurrentConnection();
              _syncEngine.sync();
              _outboundQueue.processQueue();
              startHeartbeat();
            } else if (state == ChatConnectionState.disconnected) {
              _sessionState.value = _sessionStateForCurrentConnection();
              stopHeartbeat();
            }
          }),
        )
        // Listen to sync status
        ..add(
          _syncEngine.syncStatus.listen((status) {
            _syncStatus.value = status;
          }),
        )
        // Listen to pending count
        ..add(
          _outboundQueue.pendingCount.listen((count) {
            _pendingCount.value = count;
          }),
        );

      _isInitialized = true;
      await _handleIdentityChanged(
        await _registry.identityProvider.getCurrentUserId(),
      );

      ChatLogger.info('Chat SDK initialized');
    } catch (e, s) {
      // Clean up any subscriptions that were added before the error
      ChatLogger.error('Failed to initialize Chat SDK', e, s);
      await _cleanupSubscriptions();
      rethrow;
    }
  }

  Future<void> _cleanupSubscriptions() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
  }

  /// Connect to backend.
  Future<void> connect() async {
    _ensureInitialized();
    await _handleIdentityChanged(
      await _registry.identityProvider.getCurrentUserId(),
    );
    if (_userId == null) {
      ChatLogger.warning('Skipping connect: no user ID available');
      return;
    }
    await _registry.adapter.connect();
  }

  /// Disconnect from backend.
  Future<void> disconnect() async {
    _ensureInitialized();
    await _registry.adapter.disconnect();
  }

  /// Dispose all resources.
  Future<void> dispose() async {
    // Cancel all stream subscriptions
    await _cleanupSubscriptions();

    stopHeartbeat();
    await _registry.adapter.disconnect();
    await _database.close();
    await _encryption.dispose();
    _eventBus.dispose();
    await _eventController.close();
    await _identityChanged.close();
    await _syncEngine.dispose();
    await _outboundQueue.dispose();
    _connectionState.dispose();
    _syncStatus.dispose();
    _pendingCount.dispose();
    _sessionState.dispose();
    _isInitialized = false;
    ChatLogger.info('Chat SDK disposed');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STATE NOTIFIERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Connection state notifier.
  ValueNotifier<ChatConnectionState> get connectionState => _connectionState;

  /// Sync status notifier.
  ValueNotifier<SyncStatus> get syncStatus => _syncStatus;

  /// Pending operations count notifier.
  ValueNotifier<int> get pendingCount => _pendingCount;

  /// User-scoped readiness notifier.
  ValueNotifier<ChatSessionState> get sessionState => _sessionState;

  // ═══════════════════════════════════════════════════════════════════════════
  // EVENT STREAMS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Stream of chat events (messages, typing, presence, etc.).
  Stream<ChatEvent> get onEvent => _eventController.stream;

  /// Stream of specific event type.
  Stream<T> on<T extends ChatEvent>() =>
      _eventController.stream.where((e) => e is T).cast<T>();

  // ═══════════════════════════════════════════════════════════════════════════
  // CONVERSATION OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Watch all conversations.
  ///
  /// Returns a reactive stream that updates when conversations change.
  Stream<List<Conversation>> watchConversations({ConversationFilter? filter}) {
    _ensureInitialized();
    return _watchPresentedConversations(filter);
  }

  Stream<List<Conversation>> _watchPresentedConversations(
      ConversationFilter? filter,) {
    late final StreamController<List<Conversation>> controller;
    StreamSubscription<List<Conversation>>? conversationsSubscription;
    StreamSubscription<void>? identitySubscription;
    List<Conversation>? latestConversations;

    void emitPresentedConversations() {
      final conversations = latestConversations;
      if (conversations == null || controller.isClosed) return;
      controller.add(_presentConversations(conversations, filter));
    }

    controller = StreamController<List<Conversation>>(
      onListen: () {
        conversationsSubscription =
            _database.watchConversations(filter: filter).listen(
          (conversations) {
            latestConversations = conversations;
            emitPresentedConversations();
          },
          onError: controller.addError,
        );
        identitySubscription = _identityChanged.stream.listen(
          (_) => emitPresentedConversations(),
          onError: controller.addError,
        );
      },
      onCancel: () async {
        await conversationsSubscription?.cancel();
        await identitySubscription?.cancel();
      },
    );

    return controller.stream;
  }

  List<Conversation> _presentConversations(
      List<Conversation> conversations, ConversationFilter? filter,) {
    if (_userId == null) return const [];

    var filtered = conversations
        .where((conversation) => conversation.id.trim().isNotEmpty)
        .map(_stampCurrentUser);

    if (filter?.mode == ConversationMode.ephemeral) {
      filtered =
          filtered.where((e) => !e.isExpired && _isCurrentUserApproved(e));
    }

    return filtered.toList();
  }

  /// Returns true if the current user's participant status is approved.
  bool _isCurrentUserApproved(Conversation conversation) {
    // If no userId set, show all conversations (fallback behavior)
    if (_userId == null) return true;

    // No participant data loaded yet — don't hide the conversation.
    // The filter is intended to remove conversations where the user was
    // explicitly removed, not to hide conversations with missing metadata.
    if (conversation.participants.isEmpty) return true;

    // Find current user's participant
    final myParticipant = conversation.participants.firstWhereOrNull(
      (p) => p.userId == _userId,
    );

    // If user not in participants, hide conversation
    if (myParticipant == null) return false;

    // Only show conversations where user is approved
    return myParticipant.status == ParticipantStatus.approved;
  }

  /// Get conversation by ID.
  Future<Conversation?> getConversation(String conversationId) async {
    _ensureInitialized();
    if (conversationId.trim().isEmpty) {
      return null;
    }
    final conversation = await _database.getConversation(conversationId);
    return conversation != null ? _stampCurrentUser(conversation) : null;
  }

  /// Join conversation via code.
  Future<Conversation> joinConversation({
    required String code,
    required String displayName,
    String? avatarUrl,
  }) async {
    _ensureInitialized();
    final conversation = await _registry.adapter.joinConversation(
      JoinConversationParams(
        code: code,
        displayName: displayName,
        avatarUrl: avatarUrl,
      ),
    );
    await _database.insertConversation(conversation);
    return _stampCurrentUser(conversation);
  }

  /// Create a new conversation.
  ///
  /// [mode] is required. [type] defaults to [ConversationType.group].
  /// [expiresIn] is optional expiry duration for ephemeral conversations.
  Future<Conversation> createConversation({
    required ConversationMode mode,
    ConversationType type = ConversationType.group,
    String? name,
    List<String>? participantIds,
    Duration? expiresIn,
    Map<String, dynamic>?
        extra, // For future extensibility (e.g. displayName, avatarUrl)
  }) async {
    _ensureInitialized();
    final createdConversation = await _registry.adapter.createConversation(
      CreateConversationParams(
        type: type,
        mode: mode,
        name: name,
        participantIds: participantIds,
        expiresIn: expiresIn,
        extra: extra,
      ),
    );
    final conversation =
        await _registry.adapter.getConversation(createdConversation.id);
    await _database.insertConversation(conversation!);
    return _stampCurrentUser(conversation);
  }

  /// Get share code for conversation.
  Future<String> getShareCode(String conversationId) {
    _ensureInitialized();
    return _registry.adapter.getShareCode(conversationId);
  }

  /// Delete/leave conversation.
  Future<void> deleteConversation(String conversationId) async {
    _ensureInitialized();
    await _database.deleteConversation(conversationId);
    unawaited(
      _outboundQueue
          .enqueue(OutboundOperation.deleteConversation(conversationId)),
    );
  }

  /// Archive a conversation (hide from main list but keep data).
  Future<void> archiveConversation(String conversationId) async {
    _ensureInitialized();
    final conversation = await _database.getConversation(conversationId);
    if (conversation != null) {
      await _database.updateConversation(
          conversation.copyWith(status: ConversationStatus.archived),);
    }
    unawaited(
      _outboundQueue
          .enqueue(OutboundOperation.archiveConversation(conversationId)),
    );
  }

  /// Unarchive a conversation (restore to main list).
  Future<void> unarchiveConversation(String conversationId) async {
    _ensureInitialized();
    final conversation = await _database.getConversation(conversationId);
    if (conversation != null) {
      await _database.updateConversation(
          conversation.copyWith(status: ConversationStatus.active),);
    }
    unawaited(
      _outboundQueue
          .enqueue(OutboundOperation.unarchiveConversation(conversationId)),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CONVENIENCE METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get all conversations (one-shot, not a stream).
  ///
  /// For reactive updates, use [watchConversations] instead.
  Future<List<Conversation>> getConversations(
      {ConversationFilter? filter,}) async {
    _ensureInitialized();
    final conversations = await _database.getAllConversations(filter: filter);
    return _presentConversations(conversations, filter)
        .where(_isCurrentUserApproved)
        .toList();
  }

  /// Get a conversation by ID (one-shot).
  Future<Conversation?> getConversationById(String conversationId) {
    _ensureInitialized();
    return getConversation(conversationId);
  }

  /// Get messages for a conversation (one-shot, not a stream).
  ///
  /// For reactive updates, use [watchMessages] instead.
  Future<List<Message>> getMessages(String conversationId,
      {int limit = 50,}) async {
    _ensureInitialized();
    return _database.getMessagesByConversation(conversationId, limit: limit);
  }

  /// Get a specific message by ID (one-shot).
  Future<Message?> getMessage(String messageId) {
    _ensureInitialized();
    return _database.getMessage(messageId);
  }

  /// Stream of total unread count across all conversations.
  Stream<int> get totalUnreadCount {
    _ensureInitialized();
    return watchConversations().map(
      (conversations) => conversations.fold<int>(
          0, (sum, conversation) => sum + conversation.unreadCount,),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PARTICIPANT OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Add participants to conversation.
  Future<void> addParticipants(String conversationId, List<String> userIds) {
    _ensureInitialized();
    return _registry.adapter.addParticipants(conversationId, userIds);
  }

  /// Remove participant from conversation.
  Future<void> removeParticipant(String conversationId, String userId) {
    _ensureInitialized();
    return _registry.adapter.removeParticipant(conversationId, userId);
  }

  /// Get pending join requests.
  Future<List<Participant>> getPendingRequests(String conversationId) {
    _ensureInitialized();
    return _registry.adapter.getPendingRequests(conversationId);
  }

  /// Update participant status (approve/reject).
  Future<void> updateParticipantStatus(
    String conversationId,
    String userId,
    ParticipantStatus status,
  ) {
    _ensureInitialized();
    return _registry.adapter
        .updateParticipantStatus(conversationId, userId, status);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MESSAGE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Watch messages for a conversation.
  ///
  /// Returns a reactive stream that updates when messages change.
  Stream<List<Message>> watchMessages(String conversationId) {
    _ensureInitialized();
    return _database.watchMessages(conversationId);
  }

  /// Load more messages (pagination).
  ///
  /// Fetches older messages, persists them to DB (so [watchMessages] picks
  /// them up), and tracks the pagination cursor for the next call.
  ///
  /// Returns the result including [LoadMessagesResult.hasMore] to indicate
  /// whether more history is available.
  Future<LoadMessagesResult> loadMoreMessages(String conversationId,
      {String? beforeId,}) async {
    _ensureInitialized();
    final cursor = beforeId ?? _conversationPrevBatch[conversationId];
    final result =
        await _registry.adapter.loadMessages(conversationId, before: cursor);

    // Persist to DB so watchMessages() picks them up
    for (final message in result.messages) {
      await _database.insertMessage(message);
    }

    // Track cursor for next pagination call
    _conversationPrevBatch[conversationId] = result.prevBatch;

    return result;
  }

  /// Send a message.
  ///
  /// Message is queued locally first, then sent when online.
  /// Returns immediately with optimistic message.
  Future<Message> sendMessage({
    required String conversationId,
    required String content,
    MessageType type = MessageType.text,
    String? replyToId,
  }) async {
    return sendMessageWithParams(
      SendMessageParams(
        conversationId: conversationId,
        content: content,
        type: type,
        replyToId: replyToId,
      ),
    );
  }

  /// Send a message with full params (including attachments).
  ///
  /// Message is queued locally first, then sent when online.
  /// Returns immediately with optimistic message.
  ///
  /// Throws [UserIdNotSetException] if the identity provider has no user id.
  Future<Message> sendMessageWithParams(SendMessageParams params) async {
    _ensureInitialized();
    _ensureUserId();

    final content = params.nonce != null
        ? MessageContent(
            plainText: params.content,
            cipherText: params.content,
            nonce: params.nonce,
          )
        : MessageContent(plainText: params.content);
    final messageId = _generateId();

    // Build optimistic attachments (placeholder until upload/sync).
    final attachments = params.attachments
        ?.map(
          (a) => FileAttachment(
            id: '$messageId-${a.fileName}',
            url: '',
            name: a.fileName,
            extension: a.fileName.split('.').lastOrNull ?? '',
            size: 0,
            mimeType: a.mimeType,
            uploadStatus: FileUploadStatus.uploading,
          ),
        )
        .toList();

    final message = Message(
      id: messageId,
      conversationId: params.conversationId,
      senderId: _userId!,
      content: content,
      type: params.type,
      clientTimestamp: DateTime.now(),
      replyToId: params.replyToId,
      attachments: attachments ?? const [],
    );

    await _database.insertMessage(message);
    await _database.updateConversationLastMessage(
      message.conversationId,
      messageId: message.id,
      messageAt: message.clientTimestamp,
      incrementUnread: false,
    );

    unawaited(
      _outboundQueue.enqueue(
        OutboundOperation.sendMessage(
          messageId: message.id,
          conversationId: params.conversationId,
          content: params.content,
          type: params.type,
          replyToId: params.replyToId,
          attachments: params.attachments,
          nonce: params.nonce,
          extra: params.extra,
        ),
      ),
    );

    return message;
  }

  /// Delete message.
  Future<void> deleteMessage(String conversationId, String messageId) async {
    _ensureInitialized();
    await _database.updateMessage(messageId, isDeleted: true);
    await _registry.adapter.deleteMessage(conversationId, messageId);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MESSAGE FEATURES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Star/unstar message. Returns the star ID when starring, empty string when unstarring.
  Future<String> starMessage(
    String conversationId,
    String messageId, {
    bool star = true,
  }) async {
    _ensureInitialized();
    if (star) {
      // Update local state immediately for optimistic UI
      await _database.updateMessage(messageId, isStarred: true);
      // Call adapter directly and return the star ID
      return _registry.adapter.starMessage(conversationId, messageId);
    } else {
      // For unstarring, caller should use unstarMessage with starId
      return '';
    }
  }

  /// Unstar message using the star record ID.
  Future<void> unstarMessage(String starId) async {
    _ensureInitialized();
    // Get starred messages to find the message ID associated with this star
    // This is needed to update the local database
    final starred = await _registry.adapter.getStarredMessages();
    final targetStar = starred.firstWhere(
      (msg) => msg.metadata?['message_star_id'] == starId,
      orElse: () => throw ArgumentError('Star not found: $starId'),
    );

    // Update local state immediately for optimistic UI
    await _database.updateMessage(targetStar.id, isStarred: false);
    await _registry.adapter.unstarMessage(starId);
  }

  /// Watch starred messages.
  Stream<List<Message>> watchStarredMessages() {
    _ensureInitialized();
    return _database.watchStarredMessages();
  }

  /// Get starred messages (one-shot).
  Future<List<Message>> getStarredMessages() {
    _ensureInitialized();
    return _registry.adapter.getStarredMessages();
  }

  /// Get starred messages by conversation (one-shot).
  Future<List<Message>> getStarredMessagesByConversation(
      String conversationId,) {
    _ensureInitialized();
    return _registry.adapter.getStarredMessagesByConversation(conversationId);
  }

  /// Pin message.
  Future<void> pinMessage(
    String conversationId,
    String messageId, {
    Duration? duration,
  }) async {
    _ensureInitialized();
    await _database.replacePinnedMessage(
      conversationId,
      messageId,
      pinnedUntil: duration != null ? DateTime.now().add(duration) : null,
    );
    unawaited(
      _outboundQueue.enqueue(
        OutboundOperation.pinMessage(conversationId, messageId, duration),
      ),
    );
  }

  /// Unpin message.
  Future<void> unpinMessage(String conversationId, String messageId) async {
    _ensureInitialized();
    await _database.updateMessage(messageId, isPinned: false);
    unawaited(
      _outboundQueue.enqueue(
        OutboundOperation.unpinMessage(conversationId, messageId),
      ),
    );
  }

  /// Watch pinned messages for conversation.
  Stream<List<Message>> watchPinnedMessages(String conversationId) {
    _ensureInitialized();
    return _database.watchPinnedMessages(conversationId);
  }

  /// Watch pinned events for conversation (for displaying pin notifications
  /// in stream).
  Stream<List<PinnedEvent>> watchPinnedEvents(String conversationId) {
    _ensureInitialized();
    return _database.watchPinnedEvents(conversationId);
  }

  /// Get pinned events for conversation (one-shot).
  Future<List<PinnedEvent>> getPinnedEvents(String conversationId) {
    _ensureInitialized();
    return _database.getPinnedEvents(conversationId);
  }

  /// Add reaction to message.
  Future<void> addReaction(String messageId, String emoji) async {
    _ensureInitialized();
    final reaction = Reaction(
      id: const Uuid().v4(),
      emoji: emoji,
      userId: _userId!,
      createdAt: DateTime.now(),
    );
    await _database.addReaction(messageId, reaction);
    unawaited(
      _outboundQueue.enqueue(
        OutboundOperation.addReaction(messageId, emoji),
      ),
    );
  }

  /// Remove reaction from message.
  Future<void> removeReaction(
      String messageId, String reactionIdOrEmoji,) async {
    _ensureInitialized();
    var reactionId = reactionIdOrEmoji;
    final reactions = await _database.getReactionsForMessage(messageId);
    final match = reactions
        .where(
          (r) =>
              r.id == reactionIdOrEmoji ||
              (r.emoji == reactionIdOrEmoji && r.userId == _userId),
        )
        .firstOrNull;
    if (match != null) {
      reactionId = match.id;
    }
    await _database.removeReaction(messageId, reactionId);
    unawaited(
      _outboundQueue.enqueue(
        OutboundOperation.removeReaction(messageId, reactionId),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REAL-TIME FEATURES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Send typing indicator.
  Future<void> sendTyping(String conversationId, {bool isTyping = true}) {
    _ensureInitialized();
    return _registry.adapter.sendTyping(conversationId, isTyping: isTyping);
  }

  /// Subscribe to presence updates for a user.
  ///
  /// After subscribing, you will receive [PresenceEvent] via [onEvent]
  /// when the user goes online or offline.
  Future<void> subscribePresence(String userId) {
    _ensureInitialized();
    return _registry.adapter.subscribePresence(userId);
  }

  /// Unsubscribe from presence updates for a user.
  Future<void> unsubscribePresence(String userId) {
    _ensureInitialized();
    return _registry.adapter.unsubscribePresence(userId);
  }

  /// Query the current presence status of a user.
  Future<PresenceResult> getPresence(String userId) {
    _ensureInitialized();
    return _registry.adapter.getPresence(userId);
  }

  /// Start the presence heartbeat.
  ///
  /// Call this after connecting. The heartbeat keeps the user
  /// marked as online on the backend. Call [stopHeartbeat] when
  /// the app goes to background.
  void startHeartbeat() {
    _ensureInitialized();
    ChatLogger.debug(
      'Starting presence heartbeat: ${_registry.config.heartbeatInterval}',
    );
    _registry.adapter.startHeartbeat(
      _userId ?? '',
      _registry.config.heartbeatInterval,
    );
  }

  /// Stop the presence heartbeat.
  ///
  /// Call this when the app goes to background. The backend will
  /// mark the user as offline after the TTL expires.
  void stopHeartbeat() {
    _ensureInitialized();
    ChatLogger.debug('Stopping presence heartbeat');
    _registry.adapter.stopHeartbeat();
  }

  /// Mark messages as read.
  ///
  /// Optimistically resets the local unread count to zero so the badge
  /// clears immediately, then queues the remote call.
  Future<void> markAsRead(String conversationId, String messageId) async {
    _ensureInitialized();
    await _database.resetConversationUnreadCount(conversationId);
    await _outboundQueue.enqueue(
      OutboundOperation.markRead(conversationId, messageId),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SYNC OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Force sync.
  Future<void> sync() {
    _ensureInitialized();
    return _syncEngine.sync();
  }

  /// Sync specific conversation.
  Future<void> syncConversation(String conversationId) async {
    _ensureInitialized();

    final existingConversation =
        await _database.getConversation(conversationId);
    if (_shouldRefreshConversationMetadata(existingConversation)) {
      final remoteConversation =
          await _registry.adapter.getConversation(conversationId);
      if (remoteConversation != null) {
        await _database.insertConversation(remoteConversation);
      }
    }

    final result = await _syncEngine.syncConversation(conversationId);
    // Seed pagination cursor from initial conversation sync
    if (result != null && _conversationPrevBatch[conversationId] == null) {
      _conversationPrevBatch[conversationId] = result.nextSyncToken;
    }
  }

  /// Clears the sync state.
  ///
  /// This should be called on logout to ensure the next sync after login
  /// is an initial sync rather than an incremental sync.
  Future<void> clearSyncState() {
    _ensureInitialized();
    return _database.clearSyncState();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIVATE METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Stamps the current user's ID and role on a Conversation before returning
  /// to callers.
  Conversation _stampCurrentUser(Conversation conversation) {
    if (_userId == null) return conversation;

    // Find current user's participant to derive their role
    final myParticipant =
        conversation.participants.cast<Participant?>().firstWhere(
              (p) => p!.userId == _userId,
              orElse: () => null,
            );

    return conversation.copyWith(
      myUserId: _userId,
      myRole: myParticipant?.role,
    );
  }

  Future<void> _handleIdentityChanged(String? userId) async {
    final nextUserId = userId?.trim();
    final normalizedUserId =
        nextUserId == null || nextUserId.isEmpty ? null : nextUserId;

    if (_userId == normalizedUserId) return;

    _userId = normalizedUserId;
    _sessionState.value = _sessionStateForCurrentConnection();
    _identityChanged.add(null);

    if (_userId == null) {
      if (_connectionState.value == ChatConnectionState.connected) {
        await disconnect();
      }
      ChatLogger.info('User ID cleared');
      return;
    }

    ChatLogger.info('User ID set: $_userId');

    if (_isInitialized &&
        _connectionState.value == ChatConnectionState.connected) {
      unawaited(_syncEngine.sync());
    }
  }

  ChatSessionState _sessionStateForCurrentConnection() {
    if (_userId == null) return ChatSessionState.initialized;
    return _connectionState.value == ChatConnectionState.connected
        ? ChatSessionState.connected
        : ChatSessionState.identified;
  }

  bool _shouldRefreshConversationMetadata(Conversation? conversation) {
    if (conversation == null) {
      return true;
    }

    if (conversation.participants.isEmpty) {
      return true;
    }

    if (!conversation.isDirect || _userId == null || _userId!.isEmpty) {
      return false;
    }

    return !conversation.participants.any(
      (participant) => participant.userId != _userId,
    );
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw const ChatNotInitializedException();
    }
  }

  void _ensureUserId() {
    if (_userId == null) {
      throw const UserIdNotSetException();
    }
  }

  void _handleAdapterEvent(ChatEvent event) {
    // Process event via sync engine (saves to database, then emits to event
    // bus). The event bus listener will forward to _eventController for the
    // public API.
    _syncEngine.handleEvent(event, currentUserId: _userId);
  }

  String _generateId() {
    // Use UUID v4 for globally unique IDs (no userId dependency)
    return const Uuid().v4();
  }
}
