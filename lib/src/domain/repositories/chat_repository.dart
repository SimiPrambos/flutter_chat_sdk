// lib/src/domain/repositories/chat_repository.dart

import 'package:flutter_chat_sdk/src/domain/domain.dart';
import 'package:flutter_chat_sdk/src/domain/entities/file_attachment.dart';
import 'package:flutter_chat_sdk/src/domain/entities/presence_result.dart';

/// Parameters for creating a conversation.
class CreateConversationParams {
  /// Creates conversation parameters.
  const CreateConversationParams({
    required this.type,
    required this.mode,
    this.name,
    this.participantIds,
    this.extra,
  });

  /// Whether this is a direct (1:1) or group conversation.
  final ConversationType type;

  /// Whether this conversation retains messages (standard) or auto-expires
  /// (ephemeral).
  final ConversationMode mode;

  /// Display name for group conversations.
  final String? name;

  /// User IDs to add as initial participants.
  final List<String>? participantIds;

  /// Arbitrary backend-specific metadata.
  final Map<String, dynamic>? extra;
}

/// Parameters for updating a conversation.
class UpdateConversationParams {
  /// Creates update parameters.
  const UpdateConversationParams({
    this.name,
    this.avatarUrl,
  });

  /// New display name.
  final String? name;

  /// New avatar URL.
  final String? avatarUrl;
}

/// Parameters for sending a message.
class SendMessageParams {
  /// Creates send message parameters.
  const SendMessageParams({
    required this.conversationId,
    required this.content,
    this.type = MessageType.text,
    this.replyToId,
    this.attachments,
    this.nonce,
    this.extra,
  });

  /// Target conversation ID.
  final String conversationId;

  /// Plain text content of the message.
  final String content;

  /// Message type (text, image, etc.).
  final MessageType type;

  /// ID of the message being replied to, if any.
  final String? replyToId;

  /// Files to attach to this message.
  final List<PendingAttachment>? attachments;

  /// Encryption nonce for E2E-encrypted messages.
  final String? nonce;

  /// Arbitrary backend-specific metadata.
  final Map<String, dynamic>? extra;
}

/// A file to be attached to an outgoing message.
class PendingAttachment {
  /// Creates a pending attachment.
  const PendingAttachment({
    required this.filePath,
    required this.fileName,
    required this.mimeType,
  });

  /// Absolute path to the local file.
  final String filePath;

  /// Original filename (used as display name and for extension detection).
  final String fileName;

  /// MIME type, e.g. `image/jpeg`.
  final String mimeType;
}

/// Parameters for uploading a file.
class UploadFileParams {
  /// Creates upload parameters.
  const UploadFileParams({
    required this.filePath,
    required this.fileName,
    required this.mimeType,
  });

  /// Absolute path to the local file.
  final String filePath;

  /// Original filename.
  final String fileName;

  /// MIME type, e.g. `application/pdf`.
  final String mimeType;
}

/// Main repository interface for chat operations.
abstract class ChatRepository {
  // SYNC
  Future<SyncResult> initialSync();
  Future<SyncResult> incrementalSync(String sinceToken);
  Future<SyncResult> syncConversation(String conversationId);

  // CONVERSATION OPERATIONS
  Future<Conversation> createConversation(CreateConversationParams params);
  Future<Conversation?> getConversation(String conversationId);
  Future<Conversation> updateConversation(
    String conversationId,
    UpdateConversationParams params,
  );
  Future<void> deleteConversation(String conversationId);
  Future<void> archiveConversation(String conversationId);
  Future<void> unarchiveConversation(String conversationId);

  // PARTICIPANT OPERATIONS
  Future<void> addParticipants(String conversationId, List<String> userIds);
  Future<void> removeParticipant(String conversationId, String userId);
  Future<void> updateParticipantStatus(
    String conversationId,
    String userId,
    ParticipantStatus status,
  );
  Future<List<Participant>> getPendingRequests(String conversationId);

  // MESSAGE OPERATIONS
  Future<Message> sendMessage(SendMessageParams params);
  Future<void> deleteMessage(String conversationId, String messageId);
  Future<LoadMessagesResult> loadMessages(
    String conversationId, {
    String? before,
    int? limit,
  });

  // MESSAGE FEATURES
  Future<String> starMessage(String conversationId, String messageId);
  Future<void> unstarMessage(String messageId);
  Future<List<Message>> getStarredMessages();
  Future<List<Message>> getStarredMessagesByConversation(
    String conversationId,
  );
  Future<void> pinMessage(
    String conversationId,
    String messageId,
    Duration? duration,
  );
  Future<void> unpinMessage(String conversationId, String messageId);
  Future<List<Message>> getPinnedMessages(String conversationId);
  Future<void> addReaction(String messageId, String emoji);
  Future<void> removeReaction(String messageId, String reactionId);

  // REAL-TIME
  Future<void> sendTyping(String conversationId, {required bool isTyping});
  Future<void> markAsRead(String conversationId, String messageId);
  Future<void> subscribePresence(String userId);
  Future<void> unsubscribePresence(String userId);
  Future<PresenceResult> getPresence(String userId);

  // FILE OPERATIONS
  Stream<FileUploadProgress> uploadFile(UploadFileParams params);

  // CONNECTION
  Future<void> connect();
  Future<void> disconnect();
  Stream<ChatConnectionState> get connectionState;
  Stream<ChatEvent> get eventStream;
}
