import 'dart:async';

import 'package:flutter_chat_sdk/src/adapters/chat_adapter.dart';
import 'package:flutter_chat_sdk/src/config/chat_logger.dart';
import 'package:flutter_chat_sdk/src/core/database/chat_database.dart';
import 'package:flutter_chat_sdk/src/core/event_bus/chat_event_bus.dart';
import 'package:flutter_chat_sdk/src/domain/domain.dart';
import 'package:uuid/uuid.dart';

/// Interface for sync engine operations.
///
/// Manages synchronization between local database and remote server.
abstract class SyncEngine {
  /// Performs full sync.
  Future<void> sync();

  /// Syncs a specific conversation. Returns the [SyncResult] if successful.
  Future<SyncResult?> syncConversation(String conversationId);

  /// Handles incoming event from adapter.
  void handleEvent(ChatEvent event, {String? currentUserId});

  /// Stream of sync status.
  Stream<SyncStatus> get syncStatus;

  /// Disposes sync engine.
  Future<void> dispose();
}

/// Implementation of [SyncEngine].
class SyncEngineImpl implements SyncEngine {
  /// Creates a sync engine.
  SyncEngineImpl({
    required ChatAdapter adapter,
    required ChatDatabase database,
    required ChatEventBus eventBus,
  })  : _adapter = adapter,
        _database = database,
        _eventBus = eventBus;

  final ChatAdapter _adapter;
  final ChatDatabase _database;
  final ChatEventBus _eventBus;

  final _syncStatusController = StreamController<SyncStatus>.broadcast();
  SyncState? _lastSyncState;

  // Sync coalescing: prevents concurrent syncs and batches rapid requests.
  bool _isSyncing = false;
  bool _syncPending = false;

  @override
  Stream<SyncStatus> get syncStatus => _syncStatusController.stream;

  @override
  Future<void> sync() async {
    // Coalesce rapid sync calls: if a sync is already in-flight, just flag that
    // another round is needed.  When the current sync finishes it will see the
    // flag and run once more — catching any data that arrived in the meantime.
    if (_isSyncing) {
      _syncPending = true;
      ChatLogger.info('Sync already in progress — deferred');
      return;
    }
    _isSyncing = true;

    try {
      await _doSync();

      // Catch-up: if another sync was requested while we were running, do one
      // final round to pick up anything that arrived in the window.
      if (_syncPending) {
        _syncPending = false;
        ChatLogger.info('Running deferred catch-up sync');
        await _doSync();
      }
    } finally {
      _isSyncing = false;
    }
  }

  /// Core sync logic (called by [sync] with coalescing guards).
  Future<void> _doSync() async {
    _syncStatusController.add(SyncStatus.syncing);
    ChatLogger.info('Starting sync');

    try {
      // Get current sync state
      _lastSyncState = await _database.getSyncState();

      final SyncResult result;
      if (_lastSyncState == null ||
          !_lastSyncState!.isInitialSyncComplete ||
          _lastSyncState!.lastSyncToken == null) {
        // Initial sync (or no sync token available)
        ChatLogger.info('Performing initial sync');
        result = await _adapter.initialSync();
      } else {
        // Incremental sync
        ChatLogger.info(
          'Performing incremental sync since ${_lastSyncState!.lastSyncToken}',
        );
        result = await _adapter.incrementalSync(
          _lastSyncState!.lastSyncToken!,
        );
      }

      // Save all data atomically within a transaction
      await _database.runInTransaction(() async {
        // Save conversations to database
        for (final conversation in result.conversations) {
          await _database.insertConversation(conversation);
        }

        // Save messages to database
        for (final message in result.messages) {
          await _database.insertMessage(message);
        }

        // Update sync state
        await _database.updateSyncState(
          SyncState(
            lastSyncToken: result.nextSyncToken,
            lastSyncAt: DateTime.now(),
            isInitialSyncComplete: true,
          ),
        );
      });

      // Hydrate conversations that arrived without state (incremental sync only
      // returns timeline events, not full conversation metadata).  Fetch full
      // details for any conversation that is still missing participants after
      // the transaction.
      for (final conversation in result.conversations) {
        if (conversation.participants.isEmpty) {
          await _ensureConversationExists(conversation.id);
        }
      }

      _syncStatusController.add(SyncStatus.completed);
      ChatLogger.info('Sync completed');
    } catch (e, s) {
      ChatLogger.error('Sync failed', e, s);
      _syncStatusController.add(SyncStatus.error);
      rethrow;
    }
  }

  @override
  Future<SyncResult?> syncConversation(String conversationId) async {
    _syncStatusController.add(SyncStatus.syncing);
    ChatLogger.info('Syncing conversation $conversationId');

    try {
      final result = await _adapter.syncConversation(conversationId);

      // Save all data atomically within a transaction
      await _database.runInTransaction(() async {
        // Save conversations to database
        for (final conversation in result.conversations) {
          await _database.insertConversation(conversation);
        }

        // Save messages to database
        for (final message in result.messages) {
          await _database.insertMessage(message);
        }

        // Update the conversation's last message to the newest message from
        // the sync.  Without this, the conversation list preview stays stale
        // because only the socket path (handleEvent → _handleMessageEvent)
        // called updateConversationLastMessage.  The newer-than guard in
        // updateConversationLastMessage ensures we never overwrite with an
        // older one.
        if (result.messages.isNotEmpty) {
          final newest = result.messages.reduce((a, b) {
            final aTime = a.serverTimestamp ?? a.clientTimestamp;
            final bTime = b.serverTimestamp ?? b.clientTimestamp;
            return aTime.isAfter(bTime) ? a : b;
          });
          final newestTime = newest.serverTimestamp ?? newest.clientTimestamp;
          await _database.updateConversationLastMessage(
            conversationId,
            messageId: newest.id,
            messageAt: newestTime,
            incrementUnread: false,
          );
        }
      });

      _syncStatusController.add(SyncStatus.completed);
      ChatLogger.info('Conversation sync completed: $conversationId');
      return result;
    } catch (e, s) {
      ChatLogger.error('Conversation sync failed: $conversationId', e, s);
      _syncStatusController.add(SyncStatus.error);
      rethrow;
    }
  }

  @override
  void handleEvent(ChatEvent event, {String? currentUserId}) {
    ChatLogger.debug('Handling event: ${event.runtimeType}');

    // Handle different event types
    if (event is MessageEvent) {
      _handleMessageEvent(event, currentUserId: currentUserId)
          .catchError((Object e, StackTrace s) {
        ChatLogger.error('Failed to handle message event', e, s);
      });
    } else if (event is ConversationUpdateEvent) {
      _handleConversationUpdateEvent(event, currentUserId: currentUserId)
          .catchError((Object e, StackTrace s) {
        ChatLogger.error('Failed to handle conversation update event', e, s);
      });
    } else if (event is ReactionEvent) {
      // Fire and forget - errors are logged internally
      _handleReactionEvent(event).catchError((Object e, StackTrace s) {
        ChatLogger.error('Failed to handle reaction event', e, s);
      });
    } else if (event is ReceiptEvent) {
      _handleReceiptEvent(event, currentUserId: currentUserId)
          .catchError((Object e, StackTrace s) {
        ChatLogger.error('Failed to handle receipt event', e, s);
      });
    } else if (event is PinEvent) {
      _handlePinEvent(event, currentUserId: currentUserId)
          .catchError((Object e, StackTrace s) {
        ChatLogger.error('Failed to handle pin event', e, s);
      });
    } else if (event is TypingEvent) {
      // Typing events are transient, don't persist
      _eventBus.emit(event);
    } else {
      // Other events (presence, etc.) just broadcast
      _eventBus.emit(event);
    }
  }

  Future<void> _handleMessageEvent(
    MessageEvent event, {
    String? currentUserId,
  }) async {
    final message = event.message;
    await _ensureConversationMetadataForIncomingMessage(
      message,
      currentUserId: currentUserId,
    );
    final actualId = await _database.insertMessage(message);

    // Update conversation's last message using the actual PK from dedup.
    // During dedup, the original client UUID is preserved as PK, so we
    // must use actualId (not message.id which may be the server ID).
    final isOwnMessage =
        currentUserId != null && message.senderId == currentUserId;
    final messageAt = message.serverTimestamp ?? message.clientTimestamp;
    await _database.updateConversationLastMessage(
      message.conversationId,
      messageId: actualId,
      messageAt: messageAt,
      incrementUnread: !isOwnMessage,
    );

    _eventBus.emit(event);
  }

  Future<void> _handleConversationUpdateEvent(
    ConversationUpdateEvent event, {
    String? currentUserId,
  }) async {
    final conversation = await _resolveConversationUpdate(
      event.conversation,
      currentUserId: currentUserId,
    );

    await _database.insertConversation(conversation);
    _eventBus.emit(ConversationUpdateEvent(
      eventId: event.eventId,
      timestamp: event.timestamp,
      conversation: conversation,
      updateType: event.updateType,
      participant: event.participant,
    ));
  }

  Future<void> _ensureConversationMetadataForIncomingMessage(
    Message message, {
    String? currentUserId,
  }) async {
    final existingConversation =
        await _database.getConversation(message.conversationId);

    if (!_needsConversationMetadataRefresh(
      existingConversation,
      currentUserId: currentUserId,
      incomingSenderId: message.senderId,
    )) {
      return;
    }

    final remoteConversation =
        await _fetchRemoteConversation(message.conversationId);
    if (remoteConversation != null
        // Assume that remote conversation metadata is more up-to-date than
        // local, so we don't check
        // &&
        //     !_needsConversationMetadataRefresh(
        //       remoteConversation,
        //       currentUserId: currentUserId,
        //       incomingSenderId: message.senderId,
        //     )
        ) {
      await _database.insertConversation(remoteConversation);
      return;
    }

    final fallbackConversation = _buildFallbackConversationFromMessage(
      existingConversation: existingConversation,
      message: message,
      currentUserId: currentUserId,
    );
    if (fallbackConversation != null) {
      await _database.insertConversation(fallbackConversation);
    }
  }

  Future<Conversation> _resolveConversationUpdate(
    Conversation incomingConversation, {
    String? currentUserId,
  }) async {
    if (!_needsConversationMetadataRefresh(
      incomingConversation,
      currentUserId: currentUserId,
    )) {
      return incomingConversation;
    }

    final remoteConversation =
        await _fetchRemoteConversation(incomingConversation.id);
    if (remoteConversation != null &&
        !_needsConversationMetadataRefresh(
          remoteConversation,
          currentUserId: currentUserId,
        )) {
      return remoteConversation;
    }

    final existingConversation =
        await _database.getConversation(incomingConversation.id);
    if (existingConversation != null &&
        !_needsConversationMetadataRefresh(
          existingConversation,
          currentUserId: currentUserId,
        )) {
      return existingConversation.copyWith(
        lastMessage:
            incomingConversation.lastMessage ?? existingConversation.lastMessage,
        lastMessageAt: incomingConversation.lastMessageAt ??
            existingConversation.lastMessageAt,
        unreadCount: incomingConversation.unreadCount > 0
            ? incomingConversation.unreadCount
            : existingConversation.unreadCount,
        updatedAt:
            incomingConversation.updatedAt ?? existingConversation.updatedAt,
      );
    }

    return incomingConversation;
  }

  Future<Conversation?> _fetchRemoteConversation(String conversationId) async {
    try {
      return await _adapter.getConversation(conversationId);
    } catch (e, s) {
      ChatLogger.warning(
          'Failed to hydrate conversation metadata for $conversationId: $e');
      ChatLogger.error('Conversation metadata hydration error', e, s);
      return null;
    }
  }

  bool _needsConversationMetadataRefresh(
    Conversation? conversation, {
    String? currentUserId,
    String? incomingSenderId,
  }) {
    if (conversation == null) {
      return true;
    }

    if (conversation.participants.isEmpty) {
      return true;
    }

    if (!conversation.isDirect) {
      return false;
    }

    if (currentUserId == null || currentUserId.isEmpty) {
      return conversation.participants.length < 2;
    }

    final hasOtherParticipant = conversation.participants.any(
      (participant) => participant.userId != currentUserId,
    );
    if (!hasOtherParticipant) {
      return true;
    }

    if (incomingSenderId != null &&
        incomingSenderId != currentUserId &&
        !conversation.participants.any(
          (participant) => participant.userId == incomingSenderId,
        )) {
      return true;
    }

    return conversation.participants.any(
      (participant) =>
          participant.userId != currentUserId &&
          participant.displayName.trim().isEmpty,
    );
  }

  Conversation? _buildFallbackConversationFromMessage({
    required Conversation? existingConversation,
    required Message message,
    required String? currentUserId,
  }) {
    if (currentUserId == null ||
        currentUserId.isEmpty ||
        message.senderId == currentUserId) {
      return existingConversation;
    }

    final senderName = (message.senderName ?? '').trim();
    final fallbackParticipant = Participant(
      id: '${message.conversationId}_${message.senderId}',
      userId: message.senderId,
      displayName: senderName.isNotEmpty ? senderName : 'Unknown User',
      avatarUrl: message.senderAvatar,
    );

    final mergedParticipants = <Participant>[
      if (existingConversation != null) ...existingConversation.participants,
      if (existingConversation == null ||
          !existingConversation.participants.any(
            (participant) => participant.userId == message.senderId,
          ))
        fallbackParticipant,
    ];

    if (existingConversation != null) {
      return existingConversation.copyWith(
        participants: mergedParticipants,
        updatedAt: message.timestamp,
      );
    }

    return Conversation(
      id: message.conversationId,
      type: ConversationType.direct,
      mode: ConversationMode.standard,
      status: ConversationStatus.active,
      participants: mergedParticipants,
      createdAt: message.timestamp,
      updatedAt: message.timestamp,
    );
  }

  Future<void> _handleReactionEvent(ReactionEvent event) async {
    // Persist reaction to database
    if (event.isRemoved) {
      await _database.removeReaction(event.messageId, event.reaction.id);
    } else {
      await _database.addReaction(event.messageId, event.reaction);
    }

    // Emit event for UI updates
    _eventBus.emit(event);
  }

  /// Fetches and saves full conversation details from the server if the
  /// conversation is missing from the local DB or has no participants.  Called
  /// from both the sync loop (for conversations that arrive without state) and
  /// socket event handlers (for events that reference a conversation the client
  /// has never seen before).
  Future<void> _ensureConversationExists(String conversationId) async {
    if (conversationId.isEmpty) return;
    final existing = await _database.getConversation(conversationId);
    if (existing == null || existing.participants.isEmpty) {
      final remoteConversation =
          await _fetchRemoteConversation(conversationId);
      if (remoteConversation != null) {
        await _database.insertConversation(remoteConversation);
      }
    }
  }

  Future<void> _handleReceiptEvent(
    ReceiptEvent event, {
    String? currentUserId,
  }) async {
    ChatLogger.debug(
        'Handling receipt event: type=${event.type}, messageId=${event.messageId}, conversationId=${event.conversationId}');
    // A receipt can arrive before sync for a brand-new conversation (e.g. first
    // message from a new contact).  Ensure the conversation exists locally first.
    await _ensureConversationExists(event.conversationId);
    if (event.messageId.isEmpty) {
      // Conversation-level receipt — the other user's device received or read
      // the messages you sent.  Only promote YOUR sent messages; leave received
      // messages untouched.
      if (event.type == ReceiptType.read) {
        await _database.markConversationMessagesAsRead(
          event.conversationId,
          senderIdFilter: currentUserId,
        );
      } else if (event.type == ReceiptType.delivered) {
        await _database.markConversationMessagesAsDelivered(
          event.conversationId,
          senderIdFilter: currentUserId,
        );
      }
    } else {
      // Per-message receipt — update individual message status.
      final status = event.type == ReceiptType.read
          ? MessageStatus.read
          : MessageStatus.delivered;
      ChatLogger.debug('Updating message ${event.messageId} status to $status');
      await _database.updateMessage(event.messageId, status: status);
    }
    _eventBus.emit(event);
  }

  // Future<void> _handlePinEvent(PinEvent event) async {
  //   if (event.isPinned) {
  //     await _database.replacePinnedMessage(
  //       event.conversationId,
  //       event.messageId,
  //       pinnedUntil: event.pinnedUntil,
  //     );
  //   } else {
  //     await _database.updateMessage(
  //       event.messageId,
  //       isPinned: false,
  //     );
  //   }
  //   _eventBus.emit(event);
  // }

  Future<void> _handlePinEvent(PinEvent event, {String? currentUserId}) async {
    // Update the message's pinned status
    await _database.updateMessage(
      event.messageId,
      isPinned: event.isPinned,
      pinnedUntil: event.pinnedUntil,
    );

    // Get the message to find conversationId
    final message = await _database.getMessage(event.messageId);
    if (message == null) {
      ChatLogger.warning('Message ${event.messageId} not found for pin event');
      _eventBus.emit(event);
      return;
    }

    if (event.isPinned) {
      // Create a new pinned event record
      // Use pinnedBy from event if available, otherwise fall back to currentUserId or message sender
      final pinnedBy = event.pinnedBy ?? currentUserId ?? message.senderId;

      final pinnedEvent = PinnedEvent(
        id: const Uuid().v4(),
        messageId: event.messageId,
        roomId: event.conversationId,
        pinnedBy: pinnedBy,
        pinnedAt: event.timestamp,
      );
      await _database.insertPinnedEvent(pinnedEvent);
    } else {
      // Find the active pinned event for this message and mark as unpinned
      final pinnedEvents =
          await _database.getPinnedEvents(event.conversationId);
      final activeEvent = pinnedEvents.firstWhere(
        (e) => e.messageId == event.messageId && e.isActive,
        orElse: () => throw StateError(
            'No active pinned event found for message ${event.messageId}'),
      );
      await _database.updatePinnedEvent(activeEvent.id,
          unpinnedAt: event.timestamp);
    }

    _eventBus.emit(event);
  }

  @override
  Future<void> dispose() async {
    _syncStatusController.close();
  }
}
