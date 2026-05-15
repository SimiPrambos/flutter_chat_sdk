import 'dart:async';

import 'package:flutter_chat_sdk/src/adapters/chat_adapter.dart';
import 'package:flutter_chat_sdk/src/domain/domain.dart';
import 'package:flutter_chat_sdk/src/domain/entities/file_attachment.dart';
import 'package:flutter_chat_sdk/src/domain/entities/presence_result.dart';

/// Mock implementation of ChatAdapter for testing.
class MockChatAdapter {
  // For use with mocktail - this class provides the type
}

/// Fake in-memory adapter for integration tests.
class FakeChatAdapter implements ChatAdapter {
  FakeChatAdapter({required this.userId});

  final String userId;
  final _conversations = <String, Conversation>{};
  final messages = <String, List<Message>>{};
  final _eventController = StreamController<ChatEvent>.broadcast();
  final _connectionStateController =
      StreamController<ChatConnectionState>.broadcast();

  bool _isConnected = false;

  @override
  String get name => 'FakeChatAdapter';

  @override
  bool get isConnected => _isConnected;

  @override
  Future<void> initialize() async {}

  @override
  void startHeartbeat(String userId, Duration interval) {}

  @override
  void stopHeartbeat() {}

  @override
  Future<void> dispose() async {
    await _eventController.close();
    await _connectionStateController.close();
  }

  @override
  Future<void> connect() async {
    _isConnected = true;
    _connectionStateController.add(ChatConnectionState.connected);
  }

  @override
  Future<void> disconnect() async {
    _isConnected = false;
    _connectionStateController.add(ChatConnectionState.disconnected);
  }

  @override
  Stream<ChatConnectionState> get connectionState =>
      _connectionStateController.stream;

  @override
  Stream<ChatEvent> get eventStream => _eventController.stream;

  @override
  Future<SyncResult> initialSync() async {
    final allMessages = <Message>[];
    for (final msgList in messages.values) {
      allMessages.addAll(msgList);
    }
    return SyncResult(
      conversations: _conversations.values.toList(),
      messages: allMessages,
      nextSyncToken: 'token-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<SyncResult> incrementalSync(String sinceToken) async {
    return SyncResult(
      nextSyncToken: 'token-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<SyncResult> syncConversation(String conversationId) async {
    return SyncResult(
      messages: messages[conversationId] ?? const [],
      nextSyncToken: 'token-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<Conversation> createConversation(
    CreateConversationParams params,
  ) async {
    final conversation = Conversation(
      id: 'conversation-${DateTime.now().millisecondsSinceEpoch}',
      type: params.type,
      mode: params.mode,
      name: params.name,
      myUserId: userId,
      myRole: ParticipantRole.admin,
    );
    _conversations[conversation.id] = conversation;
    messages[conversation.id] = [];
    _emitConversationUpdate(conversation, ConversationUpdateType.created);
    return conversation;
  }

  @override
  Future<Conversation?> getConversation(String conversationId) async =>
      _conversations[conversationId];

  @override
  Future<Conversation> updateConversation(
    String conversationId,
    UpdateConversationParams params,
  ) async {
    final conversation = _conversations[conversationId];
    if (conversation == null) throw Exception('Conversation not found');
    final updated = conversation.copyWith(
      name: params.name,
      avatarUrl: params.avatarUrl,
    );
    _conversations[conversationId] = updated;
    _emitConversationUpdate(updated, ConversationUpdateType.updated);
    return updated;
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    final conversation = _conversations[conversationId];
    if (conversation != null) {
      _conversations.remove(conversationId);
      messages.remove(conversationId);
      _emitConversationUpdate(conversation, ConversationUpdateType.deleted);
    }
  }

  @override
  Future<void> archiveConversation(String conversationId) async {
    final conversation = _conversations[conversationId];
    if (conversation != null) {
      _conversations[conversationId] =
          conversation.copyWith(status: ConversationStatus.archived);
      _emitConversationUpdate(
        _conversations[conversationId]!,
        ConversationUpdateType.updated,
      );
    }
  }

  @override
  Future<void> unarchiveConversation(String conversationId) async {
    final conversation = _conversations[conversationId];
    if (conversation != null) {
      _conversations[conversationId] =
          conversation.copyWith(status: ConversationStatus.active);
      _emitConversationUpdate(
        _conversations[conversationId]!,
        ConversationUpdateType.updated,
      );
    }
  }

  @override
  Future<String> getShareCode(String conversationId) async =>
      'SHARE-$conversationId';

  @override
  Future<Conversation> joinConversation(JoinConversationParams params) async {
    final conversation = Conversation(
      id: 'conversation-${DateTime.now().millisecondsSinceEpoch}',
      type: ConversationType.group,
      mode: ConversationMode.ephemeral,
      name: params.displayName,
      myUserId: userId,
    );
    _conversations[conversation.id] = conversation;
    messages[conversation.id] = [];
    _emitConversationUpdate(conversation, ConversationUpdateType.created);
    return conversation;
  }

  @override
  Future<bool> validateConversationCode(String code) async =>
      code.startsWith('SHARE-');

  @override
  Future<void> addParticipants(
    String conversationId,
    List<String> userIds,
  ) async {
    final conversation = _conversations[conversationId];
    if (conversation != null) {
      final participants = List<Participant>.from(conversation.participants);
      for (final id in userIds) {
        participants.add(
          Participant(
            id: 'part-$id',
            userId: id,
            displayName: 'User $id',
          ),
        );
      }
      final updated = conversation.copyWith(participants: participants);
      _conversations[conversationId] = updated;
      _emitConversationUpdate(updated, ConversationUpdateType.participantAdded);
    }
  }

  @override
  Future<void> removeParticipant(String conversationId, String userId) async {
    final conversation = _conversations[conversationId];
    if (conversation != null) {
      final participants =
          conversation.participants.where((p) => p.userId != userId).toList();
      final updated = conversation.copyWith(participants: participants);
      _conversations[conversationId] = updated;
      _emitConversationUpdate(
        updated,
        ConversationUpdateType.participantRemoved,
      );
    }
  }

  @override
  Future<void> updateParticipantStatus(
    String conversationId,
    String userId,
    ParticipantStatus status,
  ) async {
    final conversation = _conversations[conversationId];
    if (conversation != null) {
      final participants = conversation.participants.map((p) {
        return p.userId == userId
            ? Participant(
                id: p.id,
                userId: p.userId,
                displayName: p.displayName,
                avatarUrl: p.avatarUrl,
                role: p.role,
                status: status,
                isOnline: p.isOnline,
              )
            : p;
      }).toList();
      final updated = conversation.copyWith(participants: participants);
      _conversations[conversationId] = updated;
      _emitConversationUpdate(
        updated,
        ConversationUpdateType.participantUpdated,
      );
    }
  }

  @override
  Future<List<Participant>> getPendingRequests(String conversationId) async {
    final conversation = _conversations[conversationId];
    return conversation?.participants
            .where((p) => p.status == ParticipantStatus.pending)
            .toList() ??
        [];
  }

  @override
  Future<Message> sendMessage(SendMessageParams params) async {
    final message = Message(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      conversationId: params.conversationId,
      senderId: userId,
      content: MessageContent(plainText: params.content),
      type: params.type,
      clientTimestamp: DateTime.now(),
      serverTimestamp: DateTime.now(),
      serverId: 'srv-${DateTime.now().millisecondsSinceEpoch}',
      status: MessageStatus.sent,
    );
    messages.putIfAbsent(params.conversationId, () => []).add(message);
    // Deliberately no _emitMessage here — the server confirms receipt via a
    // separate socket echo in production. Tests that need an incoming event
    // should use simulateIncomingMessage instead.
    return message;
  }

  @override
  Future<void> deleteMessage(String conversationId, String messageId) async {
    final conversationMessages = messages[conversationId];
    if (conversationMessages != null) {
      conversationMessages.removeWhere((m) => m.id == messageId);
    }
  }

  @override
  Future<LoadMessagesResult> loadMessages(
    String conversationId, {
    String? before,
    int? limit,
  }) async {
    final conversationMessages = messages[conversationId] ?? [];
    return LoadMessagesResult(
      messages: conversationMessages.reversed.toList(),
    );
  }

  @override
  Future<String> starMessage(String conversationId, String messageId) async {
    final conversationMessages = messages[conversationId] ?? [];
    final index = conversationMessages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      messages[conversationId]![index] =
          conversationMessages[index].copyWith(isStarred: true);
    }
    // Return a mock star ID
    return 'star_$messageId';
  }

  @override
  Future<void> unstarMessage(String starId) async {
    // Extract message ID from star ID (mock implementation)
    final messageId = starId.replaceFirst('star_', '');
    for (final conversationId in messages.keys) {
      final conversationMessages = messages[conversationId]!;
      final index = conversationMessages.indexWhere((m) => m.id == messageId);
      if (index != -1) {
        messages[conversationId]![index] =
            conversationMessages[index].copyWith(isStarred: false);
        break;
      }
    }
  }

  @override
  Future<List<Message>> getStarredMessages() async {
    final allMessages = <Message>[];
    for (final msgList in messages.values) {
      allMessages.addAll(msgList.where((m) => m.isStarred));
    }
    return allMessages;
  }

  @override
  Future<List<Message>> getStarredMessagesByConversation(
    String conversationId,
  ) async {
    return (messages[conversationId] ?? []).where((m) => m.isStarred).toList();
  }

  @override
  Future<void> pinMessage(
    String conversationId,
    String messageId,
    Duration? duration,
  ) async {
    final conversationMessages = messages[conversationId];
    if (conversationMessages != null) {
      for (var i = 0; i < conversationMessages.length; i++) {
        messages[conversationId]![i] = conversationMessages[i].copyWith(
          isPinned: false,
        );
      }

      final index = conversationMessages.indexWhere((m) => m.id == messageId);
      if (index != -1) {
        messages[conversationId]![index] = conversationMessages[index].copyWith(
          isPinned: true,
          pinnedUntil: duration != null ? DateTime.now().add(duration) : null,
        );
      }
    }
  }

  @override
  Future<void> unpinMessage(String conversationId, String messageId) async {
    final conversationMessages = messages[conversationId];
    if (conversationMessages != null) {
      final index = conversationMessages.indexWhere((m) => m.id == messageId);
      if (index != -1) {
        messages[conversationId]![index] = conversationMessages[index].copyWith(
          isPinned: false,
        );
      }
    }
  }

  @override
  Future<List<Message>> getPinnedMessages(String conversationId) async {
    return (messages[conversationId] ?? []).where((m) => m.isPinned).toList();
  }

  @override
  Future<void> addReaction(String messageId, String emoji) async {
    // Implementation for adding reactions
  }

  @override
  Future<void> removeReaction(String messageId, String reactionId) async {
    // Implementation for removing reactions
  }

  @override
  Future<void> sendTyping(
    String conversationId, {
    required bool isTyping,
  }) async {
    _eventController.add(
      TypingEvent(
        eventId: 'evt-${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        conversationId: conversationId,
        userId: userId,
        isTyping: isTyping,
        userName: 'Test User',
      ),
    );
  }

  @override
  Future<void> markAsRead(String conversationId, String messageId) async {
    _eventController.add(
      ReceiptEvent(
        eventId: 'evt-${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        conversationId: conversationId,
        messageId: messageId,
        userId: userId,
        type: ReceiptType.read,
      ),
    );
  }

  @override
  Future<void> subscribePresence(String userId) async {}

  @override
  Future<void> unsubscribePresence(String userId) async {}

  @override
  Future<PresenceResult> getPresence(String userId) async {
    return PresenceResult(userId: userId, active: false);
  }

  @override
  Stream<FileUploadProgress> uploadFile(UploadFileParams params) async* {
    yield const FileUploadProgress(
      fileId: 'file-1',
      progress: 0,
      status: FileUploadStatus.uploading,
    );
    await Future<void>.delayed(const Duration(milliseconds: 100));
    yield FileUploadProgress(
      fileId: 'file-1',
      progress: 1,
      status: FileUploadStatus.completed,
      attachment: FileAttachment(
        id: 'file-1',
        url: 'https://example.com/file.png',
        name: params.fileName,
        extension: params.fileName.split('.').last,
        size: 1000,
        mimeType: params.mimeType,
      ),
    );
  }

  void _emitMessage(Message message) {
    _eventController.add(
      MessageEvent(
        eventId: 'evt-${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        message: message,
      ),
    );
  }

  void _emitConversationUpdate(
    Conversation conversation,
    ConversationUpdateType type,
  ) {
    _eventController.add(
      ConversationUpdateEvent(
        eventId: 'evt-${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        conversation: conversation,
        updateType: type,
      ),
    );
  }

  /// Simulate receiving a message from another user.
  void simulateIncomingMessage({
    required String roomId,
    required String senderId,
    required String content,
  }) {
    final message = Message(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      conversationId: roomId,
      senderId: senderId,
      content: MessageContent(plainText: content),
      clientTimestamp: DateTime.now(),
      serverTimestamp: DateTime.now(),
      status: MessageStatus.sent,
    );
    messages.putIfAbsent(roomId, () => []).add(message);
    _emitMessage(message);
  }

  /// Simulate connection state change.
  void simulateConnectionState(ChatConnectionState state) {
    _isConnected = state == ChatConnectionState.connected;
    _connectionStateController.add(state);
  }

  /// Simulate typing indicator from another user.
  void simulateTyping({
    required String roomId,
    required String userId,
    required bool isTyping,
  }) {
    _eventController.add(
      TypingEvent(
        eventId: 'evt-${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        conversationId: roomId,
        userId: userId,
        isTyping: isTyping,
        userName: 'User $userId',
      ),
    );
  }

  /// Simulate a pin/unpin event from the backend.
  void simulatePinEvent({
    required String conversationId,
    required String messageId,
    required bool isPinned,
    DateTime? pinnedUntil,
  }) {
    _eventController.add(
      PinEvent(
        eventId: 'evt-${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        conversationId: conversationId,
        messageId: messageId,
        isPinned: isPinned,
        pinnedUntil: pinnedUntil,
      ),
    );
  }
}
