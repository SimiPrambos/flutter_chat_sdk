import 'dart:async';

import 'package:flutter_chat_sdk/src/config/chat_config.dart';
import 'package:flutter_chat_sdk/src/config/chat_identity_provider.dart';
import 'package:flutter_chat_sdk/src/config/chat_registry.dart';
import 'package:flutter_chat_sdk/src/core/database/chat_database.dart';
import 'package:flutter_chat_sdk/src/core/queue/outbound_queue.dart';
import 'package:flutter_chat_sdk/src/domain/domain.dart';

import 'mock_adapters.dart';

/// Fake in-memory database for testing.
class FakeChatDatabase implements ChatDatabase {
  final _conversations = <String, Conversation>{};
  final _messages = <String, List<Message>>{};
  final _pinnedEvents = <String, List<PinnedEvent>>{};
  final _conversationsController =
      StreamController<List<Conversation>>.broadcast();
  final _messagesController = <String, StreamController<List<Message>>>{};
  final _pinnedEventsControllers =
      <String, StreamController<List<PinnedEvent>>>{};
  final _starredMessagesController =
      StreamController<List<Message>>.broadcast();

  @override
  Future<void> initialize() async {}

  @override
  Future<void> close() async {
    await _conversationsController.close();
    await _starredMessagesController.close();
    for (final controller in _messagesController.values) {
      await controller.close();
    }
    for (final controller in _pinnedEventsControllers.values) {
      await controller.close();
    }
  }

  @override
  Stream<List<Conversation>> watchConversations({ConversationFilter? filter}) {
    return _conversationsController.stream.map((conversations) {
      if (filter == null) return conversations;
      return conversations
          .where((c) => _matchesFilter(c, filter))
          .toList();
    });
  }

  @override
  Future<List<Conversation>> getAllConversations(
      {ConversationFilter? filter}) async {
    var conversations = _conversations.values.toList();
    if (filter != null) {
      conversations = conversations
          .where((c) => _matchesFilter(c, filter))
          .toList();
    }
    return conversations;
  }

  @override
  Future<Conversation?> getConversation(String conversationId) async =>
      _conversations[conversationId];

  @override
  Future<void> insertConversation(Conversation conversation) async {
    _conversations[conversation.id] = conversation;
    _emitConversations();
  }

  @override
  Future<void> updateConversation(Conversation conversation) async {
    _conversations[conversation.id] = conversation;
    _emitConversations();
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    _conversations.remove(conversationId);
    _messages.remove(conversationId);
    _participants.remove(conversationId);
    _pinnedEvents.remove(conversationId);
    _emitConversations();
    _emitMessages(conversationId);
    _emitPinnedEvents(conversationId);
  }

  @override
  Future<void> updateConversationLastMessage(
    String conversationId, {
    required String messageId,
    required DateTime messageAt,
    bool incrementUnread = true,
  }) async {
    final conversation = _conversations[conversationId];
    if (conversation == null) return;
    _conversations[conversationId] = conversation.copyWith(
      lastMessageAt: messageAt,
      unreadCount: incrementUnread
          ? conversation.unreadCount + 1
          : conversation.unreadCount,
    );
    _emitConversations();
  }

  @override
  Future<void> resetConversationUnreadCount(String conversationId) async {
    final conversation = _conversations[conversationId];
    if (conversation == null) return;
    _conversations[conversationId] =
        conversation.copyWith(unreadCount: 0);
    _emitConversations();
  }

  @override
  Future<void> markConversationMessagesAsRead(String conversationId,
      {String? senderIdFilter}) async {
    for (final entry in _messages.entries) {
      if (entry.key == conversationId) {
        _messages[conversationId] = entry.value.map((m) {
          if ((m.status == MessageStatus.sent ||
                  m.status == MessageStatus.delivered) &&
              (senderIdFilter == null ||
                  senderIdFilter.isEmpty ||
                  m.senderId == senderIdFilter)) {
            return m.copyWith(status: MessageStatus.read);
          }
          return m;
        }).toList();
      }
    }
    _emitMessages(conversationId);
  }

  @override
  Future<void> markConversationMessagesAsDelivered(String conversationId,
      {String? senderIdFilter}) async {
    for (final entry in _messages.entries) {
      if (entry.key == conversationId) {
        _messages[conversationId] = entry.value.map((m) {
          if (m.status == MessageStatus.sent &&
              (senderIdFilter == null ||
                  senderIdFilter.isEmpty ||
                  m.senderId == senderIdFilter)) {
            return m.copyWith(status: MessageStatus.delivered);
          }
          return m;
        }).toList();
      }
    }
    _emitMessages(conversationId);
  }

  // ─── Participants ─────────────────────────────────────────────────────────

  final _participants = <String, List<Participant>>{};

  @override
  Future<List<Participant>> getParticipantsForConversation(
      String conversationId) async {
    return List.from(_participants[conversationId] ?? []);
  }

  @override
  Future<void> upsertParticipants(
    String conversationId,
    List<Participant> participants,
  ) async {
    _participants[conversationId] = List.from(participants);
  }

  @override
  Future<void> deleteParticipants(String conversationId) async {
    _participants.remove(conversationId);
  }

  @override
  Stream<List<Message>> watchMessages(String conversationId) {
    _messagesController.putIfAbsent(
      conversationId,
      () => StreamController<List<Message>>.broadcast(),
    );
    return _messagesController[conversationId]!.stream;
  }

  @override
  Future<List<Message>> getMessagesByConversation(String conversationId,
      {int limit = 50}) async {
    final messages =
        List<Message>.from(_messages[conversationId] ?? []);
    if (messages.length > limit) {
      return messages.sublist(0, limit);
    }
    return messages;
  }

  @override
  Future<Message?> getMessage(String messageId) async {
    for (final messages in _messages.values) {
      final message = messages.cast<Message?>().firstWhere(
            (m) => m?.id == messageId,
            orElse: () => null,
          );
      if (message != null) return message;
    }
    return null;
  }

  @override
  Future<String> insertMessage(Message message) async {
    _messages
        .putIfAbsent(message.conversationId, () => [])
        .add(message);
    _emitMessages(message.conversationId);
    return message.id;
  }

  @override
  Future<void> updateMessage(
    String messageId, {
    String? serverId,
    String? content,
    MessageStatus? status,
    DateTime? serverTimestamp,
    bool? isDeleted,
    bool? isEdited,
    bool? isStarred,
    bool? isPinned,
    DateTime? pinnedUntil,
  }) async {
    for (final conversationId in _messages.keys) {
      final messages = _messages[conversationId]!;
      final index = messages.indexWhere((m) => m.id == messageId);
      if (index != -1) {
        final message = messages[index];
        _messages[conversationId]![index] = message.copyWith(
          serverId: serverId ?? message.serverId,
          content: content != null
              ? MessageContent(plainText: content)
              : message.content,
          status: status ?? message.status,
          serverTimestamp: serverTimestamp ?? message.serverTimestamp,
          isDeleted: isDeleted ?? message.isDeleted,
          isEdited: isEdited ?? message.isEdited,
          isStarred: isStarred ?? message.isStarred,
          isPinned: isPinned ?? message.isPinned,
          pinnedUntil: pinnedUntil ?? message.pinnedUntil,
        );
        _emitMessages(conversationId);
        break;
      }
    }
  }

  @override
  Future<void> replacePinnedMessage(
    String conversationId,
    String messageId, {
    DateTime? pinnedUntil,
  }) async {
    final messages = _messages[conversationId];
    if (messages == null) return;

    final index = messages.indexWhere(
      (m) => m.id == messageId || m.serverId == messageId,
    );

    _messages[conversationId] = messages
        .map((m) => m.copyWith(isPinned: false, pinnedUntil: null))
        .toList();

    if (index != -1) {
      final target = _messages[conversationId]![index];
      _messages[conversationId]![index] = target.copyWith(
        isPinned: true,
        pinnedUntil: pinnedUntil,
      );
    }

    _emitMessages(conversationId);
  }

  @override
  Future<void> deleteMessages(String conversationId) async {
    _messages[conversationId] = [];
    _emitMessages(conversationId);
  }

  @override
  Stream<List<Message>> watchStarredMessages() {
    return _starredMessagesController.stream;
  }

  @override
  Stream<List<Message>> watchPinnedMessages(String conversationId) {
    return watchMessages(conversationId).map(
      (messages) => messages.where((m) => m.isPinned).toList(),
    );
  }

  @override
  Stream<List<PinnedEvent>> watchPinnedEvents(String conversationId) {
    _pinnedEventsControllers.putIfAbsent(
      conversationId,
      () => StreamController<List<PinnedEvent>>.broadcast(),
    );
    return _pinnedEventsControllers[conversationId]!.stream;
  }

  @override
  Future<List<PinnedEvent>> getPinnedEvents(String conversationId) async {
    return List<PinnedEvent>.from(
        _pinnedEvents[conversationId] ?? const []);
  }

  @override
  Future<void> insertPinnedEvent(PinnedEvent event) async {
    final events =
        _pinnedEvents.putIfAbsent(event.roomId, () => []);
    final index =
        events.indexWhere((existing) => existing.id == event.id);
    if (index == -1) {
      events.add(event);
    } else {
      events[index] = event;
    }
    _emitPinnedEvents(event.roomId);
  }

  @override
  Future<void> updatePinnedEvent(
    String eventId, {
    DateTime? unpinnedAt,
  }) async {
    for (final entry in _pinnedEvents.entries) {
      final index =
          entry.value.indexWhere((event) => event.id == eventId);
      if (index == -1) {
        continue;
      }

      final existing = entry.value[index];
      entry.value[index] = existing.copyWith(
        unpinnedAt: unpinnedAt ?? existing.unpinnedAt,
      );
      _emitPinnedEvents(entry.key);
      break;
    }
  }

  @override
  Future<void> deletePinnedEventsForMessage(String messageId) async {
    for (final entry in _pinnedEvents.entries) {
      entry.value.removeWhere((event) => event.messageId == messageId);
      _emitPinnedEvents(entry.key);
    }
  }

  @override
  Future<void> deletePinnedEvents(String conversationId) async {
    _pinnedEvents.remove(conversationId);
    _emitPinnedEvents(conversationId);
  }

  SyncState _syncState = const SyncState(
    lastSyncToken: null,
    lastSyncAt: null,
    isInitialSyncComplete: false,
  );

  @override
  Future<SyncState?> getSyncState() async => _syncState;

  @override
  Future<void> updateSyncState(SyncState state) async {
    _syncState = state;
  }

  void _emitConversations() {
    _conversationsController.add(_conversations.values.toList());
  }

  void _emitMessages(String conversationId) {
    final controller = _messagesController[conversationId];
    if (controller != null) {
      controller
          .add(List<Message>.from(_messages[conversationId] ?? []));
    }
  }

  void _emitPinnedEvents(String conversationId) {
    final controller = _pinnedEventsControllers[conversationId];
    if (controller != null) {
      controller.add(List<PinnedEvent>.from(
          _pinnedEvents[conversationId] ?? const []));
    }
  }

  bool _matchesFilter(Conversation conversation, ConversationFilter filter) {
    if (filter.mode != null && conversation.mode != filter.mode) return false;
    if (filter.status != null && conversation.status != filter.status)
      return false;
    if (filter.type != null && conversation.type != filter.type) return false;
    if (filter.searchQuery != null &&
        filter.searchQuery!.isNotEmpty &&
        conversation.name
                ?.toLowerCase()
                .contains(filter.searchQuery!.toLowerCase()) !=
            true) {
      return false;
    }
    return true;
  }

  // =========================================================================
  // Reaction Operations
  // =========================================================================

  final _reactions = <String, List<Reaction>>{};

  @override
  Future<List<Reaction>> getReactionsForMessage(String messageId) async {
    return List.from(_reactions[messageId] ?? []);
  }

  @override
  Future<void> addReaction(String messageId, Reaction reaction) async {
    _reactions.putIfAbsent(messageId, () => []).add(reaction);
  }

  @override
  Future<void> removeReaction(String messageId, String reactionId) async {
    _reactions[messageId]?.removeWhere((r) => r.id == reactionId);
  }

  // =========================================================================
  // Outbound Queue Operations
  // =========================================================================

  final _operations = <OutboundOperation>[];

  @override
  Future<List<OutboundOperation>> getPendingOperations() async {
    return _operations
        .where(
          (o) =>
              o.status == OutboundOperationStatus.pending ||
              o.status == OutboundOperationStatus.failed,
        )
        .toList();
  }

  @override
  Future<void> insertOperation(OutboundOperation operation) async {
    final index = _operations.indexWhere((o) => o.id == operation.id);
    if (index >= 0) {
      _operations[index] = operation;
    } else {
      _operations.add(operation);
    }
  }

  @override
  Future<void> updateOperation(OutboundOperation operation) async {
    final index = _operations.indexWhere((o) => o.id == operation.id);
    if (index >= 0) {
      _operations[index] = operation;
    }
  }

  @override
  Future<void> deleteOperation(String operationId) async {
    _operations.removeWhere((o) => o.id == operationId);
  }

  @override
  Future<void> deleteCompletedOperations() async {
    _operations.removeWhere(
      (o) => o.status == OutboundOperationStatus.completed,
    );
  }

  // =========================================================================
  // Transaction Support
  // =========================================================================

  @override
  Future<T> runInTransaction<T>(Future<T> Function() action) async {
    // For testing, just execute the action directly
    return action();
  }

  // =========================================================================
  // Test Helpers
  // =========================================================================

  /// Get all messages for a conversation (for testing).
  List<Message> getMessages(String conversationId) =>
      List.from(_messages[conversationId] ?? []);

  /// Clear all data (for testing).
  void clear() {
    _conversations.clear();
    _messages.clear();
    _pinnedEvents.clear();
    _reactions.clear();
    _operations.clear();
    _syncState = const SyncState.initial();
  }

  @override
  Future<void> clearSyncState() async {
    _syncState = const SyncState.initial();
  }
}

class FakeChatIdentityProvider implements ChatIdentityProvider {
  FakeChatIdentityProvider([this._userId]);

  String? _userId;
  final _controller = StreamController<String?>.broadcast();

  @override
  Future<String?> getCurrentUserId() async => _userId;

  @override
  Stream<String?> get userIdChanges => _controller.stream;

  void setUserId(String? userId) {
    _userId = userId;
    _controller.add(userId);
  }

  Future<void> dispose() => _controller.close();
}

/// Creates a test ChatRegistry with fake components.
ChatRegistry createTestRegistry({
  String? userId,
  ChatDatabase? database,
  FakeChatAdapter? adapter,
}) {
  final config = ChatConfig(
    databasePath: ':memory:',
  );
  final effectiveUserId = userId ?? 'test-user-123';

  return ChatRegistry.custom(
    config: config,
    adapter: adapter ?? FakeChatAdapter(userId: effectiveUserId),
    identityProvider: FakeChatIdentityProvider(effectiveUserId),
    database: database ?? FakeChatDatabase(),
  );
}

/// Creates a test message with default values.
Message createTestMessage({
  String? id,
  String? conversationId,
  String? senderId,
  String? content,
  MessageType? type,
  MessageStatus? status,
}) {
  return Message(
    id: id ?? 'msg-${DateTime.now().millisecondsSinceEpoch}',
    conversationId: conversationId ?? 'room-123',
    senderId: senderId ?? 'user-123',
    content: MessageContent(plainText: content ?? 'Test message'),
    type: type ?? MessageType.text,
    status: status ?? MessageStatus.pending,
    clientTimestamp: DateTime.now(),
  );
}

/// Creates a test conversation with default values.
Conversation createTestConversation({
  String? id,
  String? name,
  ConversationType? type,
  ConversationMode? mode,
}) {
  return Conversation(
    id: id ?? 'room-${DateTime.now().millisecondsSinceEpoch}',
    type: type ?? ConversationType.group,
    mode: mode ?? ConversationMode.standard,
    name: name ?? 'Test Room',
    myUserId: 'user-123',
    myRole: ParticipantRole.admin,
  );
}

/// Creates a test participant.
Participant createTestParticipant({
  String? id,
  String? userId,
  String? displayName,
  ParticipantRole? role,
  ParticipantStatus? status,
}) {
  return Participant(
    id: id ?? 'part-${DateTime.now().millisecondsSinceEpoch}',
    userId: userId ?? 'user-123',
    displayName: displayName ?? 'Test User',
    role: role ?? ParticipantRole.member,
    status: status ?? ParticipantStatus.approved,
  );
}

/// Wait for a stream to emit a value matching the predicate.
Future<T> waitForStream<T>(
  Stream<T> stream,
  bool Function(T) predicate, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  final completer = Completer<T>();

  StreamSubscription<T>? subscription;
  subscription = stream.listen(
    (value) {
      if (predicate(value) && !completer.isCompleted) {
        subscription?.cancel();
        completer.complete(value);
      }
    },
    onError: (Object error, StackTrace stackTrace) {
      subscription?.cancel();
      if (!completer.isCompleted) {
        completer.completeError(error, stackTrace);
      }
    },
  );

  final timer = Timer(timeout, () {
    subscription?.cancel();
    if (!completer.isCompleted) {
      completer.completeError(
        TimeoutException('Stream did not emit matching value within $timeout'),
      );
    }
  });

  try {
    return await completer.future;
  } finally {
    timer.cancel();
    await subscription.cancel();
  }
}

/// Collects emissions from a stream for a duration.
Future<List<T>> collectStream<T>(
  Stream<T> stream, {
  Duration duration = const Duration(milliseconds: 100),
}) async {
  final values = <T>[];

  final subscription = stream.listen(values.add);

  await Future<void>.delayed(duration);
  await subscription.cancel();

  return values;
}
