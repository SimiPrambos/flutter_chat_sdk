import 'package:flutter_chat_sdk/src/core/queue/outbound_queue.dart';
import 'package:flutter_chat_sdk/src/domain/entities/conversation.dart';
import 'package:flutter_chat_sdk/src/domain/entities/message.dart';
import 'package:flutter_chat_sdk/src/domain/entities/participant.dart';
import 'package:flutter_chat_sdk/src/domain/entities/pinned_event.dart';
import 'package:flutter_chat_sdk/src/domain/entities/reaction.dart';
import 'package:flutter_chat_sdk/src/domain/entities/sync_state.dart';
import 'package:flutter_chat_sdk/src/domain/enums/message_status.dart';

/// Interface for chat database operations.
///
/// Implementations can use SQLite, Drift, or custom databases.
abstract class ChatDatabase implements OutboundQueueDatabase {
  /// Initializes the database.
  Future<void> initialize();

  /// Closes the database connection.
  Future<void> close();

  // ═══════════════════════════════════════════════════════════════════════════
  // CONVERSATION OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Watches all conversations.
  Stream<List<Conversation>> watchConversations({ConversationFilter? filter});

  /// Gets all conversations (one-shot, not a stream).
  ///
  /// For reactive updates, use [watchConversations] instead.
  Future<List<Conversation>> getAllConversations({ConversationFilter? filter});

  /// Gets a conversation by ID.
  Future<Conversation?> getConversation(String conversationId);

  /// Inserts a conversation.
  Future<void> insertConversation(Conversation conversation);

  /// Updates a conversation.
  Future<void> updateConversation(Conversation conversation);

  /// Deletes a conversation.
  Future<void> deleteConversation(String conversationId);

  /// Updates the last message info for a conversation and optionally
  /// increments the unread count.
  Future<void> updateConversationLastMessage(
    String conversationId, {
    required String messageId,
    required DateTime messageAt,
    bool incrementUnread = true,
  });

  /// Resets a conversation's unread count to zero.
  ///
  /// Called by `Chat.markAsRead` for optimistic local update so the
  /// unread badge clears immediately, before the server confirms.
  Future<void> resetConversationUnreadCount(String conversationId);

  /// Marks sent/delivered messages in a conversation as read.
  ///
  /// Called when a conversation-level read receipt arrives (the other user
  /// opened the chat), indicating they have seen the messages you sent.
  ///
  /// [senderIdFilter] — when provided, only messages with that sender_id are
  /// updated.  Pass the current user's ID so that only your own sent messages
  /// are promoted to 'read'; received messages are left unchanged.
  Future<void> markConversationMessagesAsRead(String conversationId,
      {String? senderIdFilter,});

  /// Marks sent messages in a conversation as delivered.
  ///
  /// Called when a conversation-level delivery receipt arrives, indicating the
  /// recipient's device has received the messages you sent.
  ///
  /// [senderIdFilter] — when provided, only messages with that sender_id are
  /// updated.  Pass the current user's ID so that only your own sent messages
  /// are marked as delivered; received messages are left unchanged.
  Future<void> markConversationMessagesAsDelivered(String conversationId,
      {String? senderIdFilter,});

  // ═══════════════════════════════════════════════════════════════════════════
  // MESSAGE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Watches messages for a conversation.
  Stream<List<Message>> watchMessages(String conversationId);

  /// Gets messages for a conversation (one-shot, not a stream).
  ///
  /// For reactive updates, use [watchMessages] instead.
  Future<List<Message>> getMessagesByConversation(String conversationId,
      {int limit = 50,});

  /// Gets a message by ID.
  Future<Message?> getMessage(String messageId);

  /// Inserts a message (with deduplication).
  /// Returns the actual primary key of the row — either the existing local
  /// message's PK (if dedup matched) or `message.id` for new inserts.
  Future<String> insertMessage(Message message);

  /// Updates a message.
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
  });

  /// Replaces the currently pinned message in a conversation with [messageId].
  ///
  /// After this call, at most one non-deleted message in the conversation
  /// should have `isPinned == true`.
  Future<void> replacePinnedMessage(
    String conversationId,
    String messageId, {
    DateTime? pinnedUntil,
  });

  /// Deletes messages for a conversation.
  Future<void> deleteMessages(String conversationId);

  // ═══════════════════════════════════════════════════════════════════════════
  // MESSAGE FEATURES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Watches starred messages.
  Stream<List<Message>> watchStarredMessages();

  /// Watches pinned messages for a conversation.
  Stream<List<Message>> watchPinnedMessages(String conversationId);

  // ═══════════════════════════════════════════════════════════════════════════
  // SYNC STATE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Gets the current sync state.
  Future<SyncState?> getSyncState();

  /// Updates the sync state.
  Future<void> updateSyncState(SyncState state);

  /// Clears the sync state (called on logout).
  ///
  /// This ensures that after logout, the next sync will be an initial sync
  /// rather than an incremental sync.
  Future<void> clearSyncState();

  // ═══════════════════════════════════════════════════════════════════════════
  // REACTION OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Gets reactions for a message.
  Future<List<Reaction>> getReactionsForMessage(String messageId);

  /// Adds a reaction to a message.
  Future<void> addReaction(String messageId, Reaction reaction);

  /// Removes a reaction from a message.
  Future<void> removeReaction(String messageId, String reactionId);

  // ═══════════════════════════════════════════════════════════════════════════
  // PARTICIPANT OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Gets participants for a conversation.
  Future<List<Participant>> getParticipantsForConversation(
      String conversationId,);

  /// Replaces all participants for a conversation.
  Future<void> upsertParticipants(
      String conversationId, List<Participant> participants,);

  /// Deletes all participants for a conversation.
  Future<void> deleteParticipants(String conversationId);

  // ═══════════════════════════════════════════════════════════════════════════
  // PINNED EVENT OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Watches active pinned events for a conversation.
  Stream<List<PinnedEvent>> watchPinnedEvents(String conversationId);

  /// Gets all pinned events for a conversation (one-shot, not a stream).
  Future<List<PinnedEvent>> getPinnedEvents(String conversationId);

  /// Inserts a pinned event.
  Future<void> insertPinnedEvent(PinnedEvent event);

  /// Updates a pinned event (typically to set unpinnedAt).
  Future<void> updatePinnedEvent(
    String eventId, {
    DateTime? unpinnedAt,
  });

  /// Deletes pinned events for a specific message.
  Future<void> deletePinnedEventsForMessage(String messageId);

  /// Deletes all pinned events for a conversation.
  Future<void> deletePinnedEvents(String conversationId);

  // ═══════════════════════════════════════════════════════════════════════════
  // TRANSACTION SUPPORT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Executes the given function within a database transaction.
  Future<T> runInTransaction<T>(Future<T> Function() action);
}
