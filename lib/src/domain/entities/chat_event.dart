import 'package:equatable/equatable.dart';
import 'package:flutter_chat_sdk/src/domain/entities/conversation.dart';
import 'package:flutter_chat_sdk/src/domain/entities/message.dart';
import 'package:flutter_chat_sdk/src/domain/entities/participant.dart';
import 'package:flutter_chat_sdk/src/domain/entities/reaction.dart';

/// Base class for all chat events.
abstract class ChatEvent extends Equatable {
  /// Creates a chat event.
  const ChatEvent({
    required this.eventId,
    required this.timestamp,
  });

  /// Unique event ID.
  final String eventId;

  /// When the event occurred.
  final DateTime timestamp;
}

/// Event for new or updated message.
class MessageEvent extends ChatEvent {
  /// Creates a message event.
  const MessageEvent({
    required super.eventId,
    required super.timestamp,
    required this.message,
  });

  /// The message.
  final Message message;

  @override
  List<Object?> get props => [eventId, timestamp, message];
}

/// Event for typing indicator.
class TypingEvent extends ChatEvent {
  /// Creates a typing event.
  const TypingEvent({
    required super.eventId,
    required super.timestamp,
    required this.conversationId,
    required this.userId,
    required this.isTyping,
    this.userName,
  });

  /// Conversation where typing occurs.
  final String conversationId;

  /// User who is typing.
  final String userId;

  /// Whether user is typing.
  final bool isTyping;

  /// Name of user typing.
  final String? userName;

  @override
  List<Object?> get props =>
      [eventId, timestamp, conversationId, userId, isTyping, userName];
}

/// Event for user presence (online/offline).
class PresenceEvent extends ChatEvent {
  /// Creates a presence event.
  const PresenceEvent({
    required super.eventId,
    required super.timestamp,
    required this.userId,
    required this.isOnline,
    this.lastSeenAt,
    this.conversationId,
  });

  /// User ID.
  final String userId;

  /// Whether user is online.
  final bool isOnline;

  /// Last seen timestamp.
  final DateTime? lastSeenAt;

  /// Conversation ID (if conversation-specific presence).
  final String? conversationId;

  @override
  List<Object?> get props =>
      [eventId, timestamp, userId, isOnline, lastSeenAt, conversationId];
}

/// Type of receipt.
enum ReceiptType {
  /// Message was delivered to device.
  delivered,

  /// Message was read by user.
  read,
}

/// Event for message receipt (delivered/read).
class ReceiptEvent extends ChatEvent {
  /// Creates a receipt event.
  const ReceiptEvent({
    required super.eventId,
    required super.timestamp,
    required this.conversationId,
    required this.messageId,
    required this.userId,
    required this.type,
  });

  /// Conversation ID.
  final String conversationId;

  /// Message ID.
  final String messageId;

  /// User who received/read.
  final String userId;

  /// Type of receipt.
  final ReceiptType type;

  @override
  List<Object?> get props =>
      [eventId, timestamp, conversationId, messageId, userId, type];
}

/// Event for reaction on message.
class ReactionEvent extends ChatEvent {
  /// Creates a reaction event.
  const ReactionEvent({
    required super.eventId,
    required super.timestamp,
    required this.conversationId,
    required this.messageId,
    required this.reaction,
    this.isRemoved = false,
  });

  /// Conversation ID.
  final String conversationId;

  /// Message ID.
  final String messageId;

  /// The reaction.
  final Reaction reaction;

  /// Whether reaction was removed.
  final bool isRemoved;

  @override
  List<Object?> get props =>
      [eventId, timestamp, conversationId, messageId, reaction, isRemoved];
}

/// Type of conversation update.
enum ConversationUpdateType {
  /// Conversation was created.
  created,

  /// Conversation was updated.
  updated,

  /// Conversation was deleted.
  deleted,

  /// Participant was added.
  participantAdded,

  /// Participant was removed.
  participantRemoved,

  /// Participant was updated.
  participantUpdated,
}

/// Event for conversation update.
class ConversationUpdateEvent extends ChatEvent {
  /// Creates a conversation update event.
  const ConversationUpdateEvent({
    required super.eventId,
    required super.timestamp,
    required this.conversation,
    required this.updateType,
    this.participant,
  });

  /// The conversation.
  final Conversation conversation;

  /// Type of update.
  final ConversationUpdateType updateType;

  /// Affected participant (for participant events).
  final Participant? participant;

  @override
  List<Object?> get props =>
      [eventId, timestamp, conversation, updateType, participant];
}

/// Event for pin/unpin message.
class PinEvent extends ChatEvent {
  /// Creates a pin event.
  const PinEvent({
    required super.eventId,
    required super.timestamp,
    required this.conversationId,
    required this.messageId,
    required this.isPinned,
    this.pinnedUntil,
    this.pinnedBy,
  });

  /// Conversation ID.
  final String conversationId;

  /// Message ID.
  final String messageId;

  /// Whether message is pinned.
  final bool isPinned;

  /// When pin expires.
  final DateTime? pinnedUntil;

  /// User ID who pinned/unpinned the message.
  final String? pinnedBy;

  @override
  List<Object?> get props => [
        eventId,
        timestamp,
        conversationId,
        messageId,
        isPinned,
        pinnedUntil,
        pinnedBy,
      ];
}

/// Event for connection state change.
class ConnectionEvent extends ChatEvent {
  /// Creates a connection event.
  const ConnectionEvent({
    required super.eventId,
    required super.timestamp,
    required this.isConnected,
    this.error,
  });

  /// Whether connected.
  final bool isConnected;

  /// Error if disconnected due to error.
  final String? error;

  @override
  List<Object?> get props => [eventId, timestamp, isConnected, error];
}
