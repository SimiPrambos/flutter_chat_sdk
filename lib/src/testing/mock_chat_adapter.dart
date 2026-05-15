// lib/src/testing/mock_chat_adapter.dart

import 'dart:async';

import 'package:flutter_chat_sdk/src/adapters/chat_adapter.dart';
import 'package:flutter_chat_sdk/src/domain/domain.dart';
import 'package:flutter_chat_sdk/src/domain/entities/file_attachment.dart';
import 'package:flutter_chat_sdk/src/domain/entities/presence_result.dart';

/// An in-memory [ChatAdapter] for use in tests and example apps.
///
/// All operations succeed immediately. No network calls are made.
/// Incoming events can be simulated with the `simulate*` helper methods.
///
/// ```dart
/// final adapter = MockChatAdapter();
/// final chat = await Chat.create(
///   databasePath: ':memory:',
///   adapter: adapter,
///   identityProvider: StaticIdentityProvider('user-1'),
/// );
/// // Simulate an incoming message from another user:
/// adapter.simulateIncomingMessage(
///   conversationId: 'room-1',
///   senderId: 'user-2',
///   content: 'Hello!',
/// );
/// ```
class MockChatAdapter implements ChatAdapter {
  final _conversations = <String, Conversation>{};
  final _messages = <String, List<Message>>{};
  final _connectionStateController =
      StreamController<ChatConnectionState>.broadcast();
  final _eventController = StreamController<ChatEvent>.broadcast();
  bool _connected = false;

  @override
  String get name => 'MockChatAdapter';

  @override
  bool get isConnected => _connected;

  @override
  Stream<ChatConnectionState> get connectionState =>
      _connectionStateController.stream;

  @override
  Stream<ChatEvent> get eventStream => _eventController.stream;

  @override
  Future<void> initialize() async {}

  @override
  Future<void> connect() async {
    _connected = true;
    _connectionStateController.add(ChatConnectionState.connected);
  }

  @override
  Future<void> disconnect() async {
    _connected = false;
    _connectionStateController.add(ChatConnectionState.disconnected);
  }

  @override
  Future<void> dispose() async {
    await _connectionStateController.close();
    await _eventController.close();
  }

  @override
  Future<SyncResult> initialSync() async => SyncResult(
        conversations: _conversations.values.toList(),
        messages: _messages.values.expand((m) => m).toList(),
        nextSyncToken: 'mock-token',
      );

  @override
  Future<SyncResult> incrementalSync(String sinceToken) async =>
      const SyncResult.empty();

  @override
  Future<SyncResult> syncConversation(String conversationId) async =>
      SyncResult(
        messages: _messages[conversationId] ?? const [],
        nextSyncToken: 'mock-token',
      );

  @override
  Future<Conversation> createConversation(
      CreateConversationParams params,) async {
    final conversation = Conversation(
      id: 'conv-${DateTime.now().millisecondsSinceEpoch}',
      type: params.type,
      mode: params.mode,
      name: params.name,
    );
    _conversations[conversation.id] = conversation;
    _messages[conversation.id] = [];
    return conversation;
  }

  @override
  Future<Conversation?> getConversation(String conversationId) async =>
      _conversations[conversationId];

  @override
  Future<Conversation> updateConversation(
      String conversationId, UpdateConversationParams params,) async {
    final existing = _conversations[conversationId];
    if (existing == null) throw Exception('Conversation not found');
    final updated = existing.copyWith(
      name: params.name ?? existing.name,
      avatarUrl: params.avatarUrl ?? existing.avatarUrl,
    );
    _conversations[conversationId] = updated;
    return updated;
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    _conversations.remove(conversationId);
    _messages.remove(conversationId);
  }

  @override
  Future<void> archiveConversation(String conversationId) async {}

  @override
  Future<void> unarchiveConversation(String conversationId) async {}

  @override
  Future<void> addParticipants(
    String conversationId,
    List<String> userIds,
  ) async {}

  @override
  Future<void> removeParticipant(
    String conversationId,
    String userId,
  ) async {}

  @override
  Future<void> updateParticipantStatus(
    String conversationId,
    String userId,
    ParticipantStatus status,
  ) async {}

  @override
  Future<List<Participant>> getPendingRequests(
    String conversationId,
  ) async =>
      [];

  @override
  Future<Message> sendMessage(SendMessageParams params) async {
    final message = Message(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      conversationId: params.conversationId,
      senderId: 'mock-sender',
      content: MessageContent(plainText: params.content),
      type: params.type,
      clientTimestamp: DateTime.now(),
      serverTimestamp: DateTime.now(),
      serverId: 'srv-${DateTime.now().millisecondsSinceEpoch}',
      status: MessageStatus.sent,
    );
    _messages.putIfAbsent(params.conversationId, () => []).add(message);
    _eventController.add(
      MessageEvent(
        eventId: 'evt-${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        message: message,
      ),
    );
    return message;
  }

  @override
  Future<void> deleteMessage(
    String conversationId,
    String messageId,
  ) async {
    _messages[conversationId]?.removeWhere((m) => m.id == messageId);
  }

  @override
  Future<LoadMessagesResult> loadMessages(
    String conversationId, {
    String? before,
    int? limit,
  }) async =>
      LoadMessagesResult(messages: _messages[conversationId] ?? const []);

  @override
  Future<String> starMessage(
    String conversationId,
    String messageId,
  ) async =>
      'star-$messageId';

  @override
  Future<void> unstarMessage(String messageId) async {}

  @override
  Future<List<Message>> getStarredMessages() async => [];

  @override
  Future<List<Message>> getStarredMessagesByConversation(
    String conversationId,
  ) async =>
      [];

  @override
  Future<void> pinMessage(
    String conversationId,
    String messageId,
    Duration? duration,
  ) async {}

  @override
  Future<void> unpinMessage(
    String conversationId,
    String messageId,
  ) async {}

  @override
  Future<List<Message>> getPinnedMessages(String conversationId) async => [];

  @override
  Future<void> addReaction(String messageId, String emoji) async {}

  @override
  Future<void> removeReaction(String messageId, String reactionId) async {}

  @override
  Future<void> sendTyping(
    String conversationId, {
    required bool isTyping,
  }) async {}

  @override
  Future<void> markAsRead(String conversationId, String messageId) async {}

  @override
  Future<void> subscribePresence(String userId) async {}

  @override
  Future<void> unsubscribePresence(String userId) async {}

  @override
  Future<PresenceResult> getPresence(String userId) async =>
      PresenceResult(userId: userId, active: false);

  @override
  Stream<FileUploadProgress> uploadFile(UploadFileParams params) =>
      const Stream.empty();

  @override
  void startHeartbeat(String userId, Duration interval) {}

  @override
  void stopHeartbeat() {}

  // ─── Simulation helpers ────────────────────────────────────────────────────

  /// Simulate an incoming message from another user.
  void simulateIncomingMessage({
    required String conversationId,
    required String senderId,
    required String content,
  }) {
    final message = Message(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      conversationId: conversationId,
      senderId: senderId,
      content: MessageContent(plainText: content),
      clientTimestamp: DateTime.now(),
      serverTimestamp: DateTime.now(),
      status: MessageStatus.sent,
    );
    _messages.putIfAbsent(conversationId, () => []).add(message);
    _eventController.add(
      MessageEvent(
        eventId: 'evt-${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        message: message,
      ),
    );
  }

  /// Simulate a connection state change.
  void simulateConnectionState(ChatConnectionState state) {
    _connected = state == ChatConnectionState.connected;
    _connectionStateController.add(state);
  }
}
