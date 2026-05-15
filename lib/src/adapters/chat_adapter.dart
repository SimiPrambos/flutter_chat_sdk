// lib/src/adapters/chat_adapter.dart

import 'package:flutter_chat_sdk/src/domain/domain.dart';
import 'package:flutter_chat_sdk/src/domain/entities/file_attachment.dart';
import 'package:flutter_chat_sdk/src/domain/entities/presence_result.dart';
import 'package:flutter_chat_sdk/src/domain/repositories/chat_repository.dart';

/// Base interface for chat backend adapters.
///
/// Implement this to connect the chat package to your backend.
/// Use [HttpChatAdapter] or [SocketChatAdapter] as a starting point
/// if your backend is transport-specific.
abstract class ChatAdapter implements ChatRepository {
  /// Adapter name for logging.
  String get name;

  /// Whether the adapter is currently connected.
  bool get isConnected;

  /// Initialize the adapter (called once at startup).
  Future<void> initialize();

  /// Dispose adapter resources.
  Future<void> dispose();

  /// Start presence heartbeat. Override in socket-based adapters.
  ///
  /// Called automatically when the connection is established.
  /// Also available for manual control on app lifecycle changes.
  void startHeartbeat(String userId, Duration interval) {}

  /// Stop presence heartbeat. Override in socket-based adapters.
  ///
  /// Called automatically on disconnect.
  void stopHeartbeat() {}
}

/// Base class for HTTP-only adapters.
///
/// Provides no-op implementations for real-time operations.
/// Override the methods your backend supports.
abstract class HttpChatAdapter implements ChatAdapter {
  @override
  bool get isConnected => true;

  @override
  Future<void> connect() async {}

  @override
  Future<void> disconnect() async {}

  @override
  Stream<ChatConnectionState> get connectionState =>
      Stream.value(ChatConnectionState.connected);

  @override
  Stream<ChatEvent> get eventStream => const Stream.empty();

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
}

/// Base class for WebSocket-only adapters.
///
/// Provides [UnimplementedError] for non-real-time operations (sync, CRUD).
/// Override the methods your backend supports.
abstract class SocketChatAdapter implements ChatAdapter {
  @override
  Future<SyncResult> initialSync() => throw UnimplementedError();

  @override
  Future<SyncResult> incrementalSync(String sinceToken) =>
      throw UnimplementedError();

  @override
  Future<SyncResult> syncConversation(String conversationId) =>
      throw UnimplementedError();

  @override
  Future<Conversation> createConversation(CreateConversationParams params) =>
      throw UnimplementedError();

  @override
  Future<Conversation?> getConversation(String conversationId) =>
      throw UnimplementedError();

  @override
  Future<Conversation> updateConversation(
    String conversationId,
    UpdateConversationParams params,
  ) =>
      throw UnimplementedError();

  @override
  Future<void> deleteConversation(String conversationId) =>
      throw UnimplementedError();

  @override
  Future<void> archiveConversation(String conversationId) =>
      throw UnimplementedError();

  @override
  Future<void> unarchiveConversation(String conversationId) =>
      throw UnimplementedError();

  @override
  Future<String> getShareCode(String conversationId) =>
      throw UnimplementedError();

  @override
  Future<Conversation> joinConversation(JoinConversationParams params) =>
      throw UnimplementedError();

  @override
  Future<bool> validateConversationCode(String code) =>
      throw UnimplementedError();

  @override
  Future<void> addParticipants(
    String conversationId,
    List<String> userIds,
  ) =>
      throw UnimplementedError();

  @override
  Future<void> removeParticipant(
    String conversationId,
    String userId,
  ) =>
      throw UnimplementedError();

  @override
  Future<void> updateParticipantStatus(
    String conversationId,
    String userId,
    ParticipantStatus status,
  ) =>
      throw UnimplementedError();

  @override
  Future<List<Participant>> getPendingRequests(String conversationId) =>
      throw UnimplementedError();

  @override
  Future<Message> sendMessage(SendMessageParams params) =>
      throw UnimplementedError();

  @override
  Future<void> deleteMessage(String conversationId, String messageId) =>
      throw UnimplementedError();

  @override
  Future<LoadMessagesResult> loadMessages(
    String conversationId, {
    String? before,
    int? limit,
  }) =>
      throw UnimplementedError();

  @override
  Future<String> starMessage(String conversationId, String messageId) =>
      throw UnimplementedError();

  @override
  Future<void> unstarMessage(String messageId) => throw UnimplementedError();

  @override
  Future<List<Message>> getStarredMessages() => throw UnimplementedError();

  @override
  Future<List<Message>> getStarredMessagesByConversation(
    String conversationId,
  ) =>
      throw UnimplementedError();

  @override
  Future<void> pinMessage(
    String conversationId,
    String messageId,
    Duration? duration,
  ) =>
      throw UnimplementedError();

  @override
  Future<void> unpinMessage(String conversationId, String messageId) =>
      throw UnimplementedError();

  @override
  Future<List<Message>> getPinnedMessages(String conversationId) =>
      throw UnimplementedError();

  @override
  Future<void> addReaction(String messageId, String emoji) =>
      throw UnimplementedError();

  @override
  Future<void> removeReaction(String messageId, String reactionId) =>
      throw UnimplementedError();

  @override
  Future<void> sendTyping(
    String conversationId, {
    required bool isTyping,
  }) =>
      throw UnimplementedError();

  @override
  Stream<FileUploadProgress> uploadFile(UploadFileParams params) =>
      throw UnimplementedError();
}
