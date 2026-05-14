// lib/src/domain/repositories/chat_repository.dart

import 'package:flutter_chat_sdk/src/domain/domain.dart';
import 'package:flutter_chat_sdk/src/domain/entities/file_attachment.dart';
import 'package:flutter_chat_sdk/src/domain/entities/presence_result.dart';

/// Parameters for creating a conversation.
class CreateConversationParams {
  const CreateConversationParams({
    required this.type,
    required this.mode,
    this.name,
    this.participantIds,
    this.expiresIn,
    this.extra,
  });

  final ConversationType type;
  final ConversationMode mode;
  final String? name;
  final List<String>? participantIds;
  final Duration? expiresIn;
  final Map<String, dynamic>? extra;
}

/// Parameters for updating a conversation.
class UpdateConversationParams {
  const UpdateConversationParams({
    this.name,
    this.avatarUrl,
  });

  final String? name;
  final String? avatarUrl;
}

/// Parameters for joining a conversation.
class JoinConversationParams {
  const JoinConversationParams({
    required this.code,
    required this.displayName,
    this.avatarUrl,
  });

  final String code;
  final String displayName;
  final String? avatarUrl;
}

/// Parameters for sending a message.
class SendMessageParams {
  const SendMessageParams({
    required this.conversationId,
    required this.content,
    this.type = MessageType.text,
    this.replyToId,
    this.attachments,
    this.nonce,
    this.extra,
  });

  final String conversationId;
  final String content;
  final MessageType type;
  final String? replyToId;
  final List<PendingAttachment>? attachments;
  final String? nonce;
  final Map<String, dynamic>? extra;
}

/// Pending file attachment for upload.
class PendingAttachment {
  const PendingAttachment({
    required this.filePath,
    required this.fileName,
    required this.mimeType,
  });

  final String filePath;
  final String fileName;
  final String mimeType;
}

/// Parameters for file upload.
class UploadFileParams {
  const UploadFileParams({
    required this.filePath,
    required this.fileName,
    required this.mimeType,
  });

  final String filePath;
  final String fileName;
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
  Future<Conversation> updateConversation(String conversationId, UpdateConversationParams params);
  Future<void> deleteConversation(String conversationId);
  Future<void> archiveConversation(String conversationId);
  Future<void> unarchiveConversation(String conversationId);
  Future<String> getShareCode(String conversationId);
  Future<Conversation> joinConversation(JoinConversationParams params);
  Future<bool> validateConversationCode(String code);

  // PARTICIPANT OPERATIONS
  Future<void> addParticipants(String conversationId, List<String> userIds);
  Future<void> removeParticipant(String conversationId, String userId);
  Future<void> updateParticipantStatus(String conversationId, String userId, ParticipantStatus status);
  Future<List<Participant>> getPendingRequests(String conversationId);

  // MESSAGE OPERATIONS
  Future<Message> sendMessage(SendMessageParams params);
  Future<void> deleteMessage(String conversationId, String messageId);
  Future<LoadMessagesResult> loadMessages(String conversationId, {String? before, int? limit});

  // MESSAGE FEATURES
  Future<String> starMessage(String conversationId, String messageId);
  Future<void> unstarMessage(String messageId);
  Future<List<Message>> getStarredMessages();
  Future<List<Message>> getStarredMessagesByConversation(String conversationId);
  Future<void> pinMessage(String conversationId, String messageId, Duration? duration);
  Future<void> unpinMessage(String conversationId, String messageId);
  Future<List<Message>> getPinnedMessages(String conversationId);
  Future<void> addReaction(String messageId, String emoji);
  Future<void> removeReaction(String messageId, String reactionId);

  // REAL-TIME
  Future<void> sendTyping(String conversationId, bool isTyping);
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
