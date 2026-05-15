import 'package:equatable/equatable.dart';
import 'package:flutter_chat_sdk/src/domain/entities/file_attachment.dart';
import 'package:flutter_chat_sdk/src/domain/entities/message_content.dart';
import 'package:flutter_chat_sdk/src/domain/entities/reaction.dart';
import 'package:flutter_chat_sdk/src/domain/enums/message_status.dart';
import 'package:flutter_chat_sdk/src/domain/enums/message_type.dart';

/// A chat message.
class Message extends Equatable {
  /// Creates a message.
  const Message({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.clientTimestamp,
    this.serverId,
    this.senderName,
    this.senderAvatar,
    this.anonymousName,
    this.anonymousAvatar,
    this.type = MessageType.text,
    this.status = MessageStatus.pending,
    this.serverTimestamp,
    this.replyToId,
    this.replyTo,
    this.attachments = const [],
    this.reactions = const [],
    this.readBy = const [],
    this.isDeleted = false,
    this.isEdited = false,
    this.isStarred = false,
    this.isPinned = false,
    this.pinnedUntil,
    this.localSequence = 0,
    this.metadata,
  });

  /// Client-generated unique ID (UUID).
  final String id;

  /// Server-assigned ID (null until synced).
  final String? serverId;

  /// Conversation this message belongs to.
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String? senderAvatar;
  final String? anonymousName;
  final String? anonymousAvatar;

  /// Message content.
  final MessageContent content;

  /// Type of message.
  final MessageType type;

  /// Delivery status.
  final MessageStatus status;

  /// Client-side creation timestamp.
  final DateTime clientTimestamp;

  /// Server-side timestamp (when received by server).
  final DateTime? serverTimestamp;

  /// ID of message being replied to.
  final String? replyToId;

  /// Cached reply message (for display).
  final Message? replyTo;

  /// File attachments.
  final List<FileAttachment> attachments;

  /// Emoji reactions.
  final List<Reaction> reactions;

  /// User IDs who have read this message.
  final List<String> readBy;

  /// Whether message is deleted.
  final bool isDeleted;

  /// Whether message was edited.
  final bool isEdited;

  /// Whether message is starred.
  final bool isStarred;

  /// Whether message is pinned.
  final bool isPinned;

  /// When pin expires.
  final DateTime? pinnedUntil;

  /// Local sequence number for ordering.
  final int localSequence;

  /// Extended metadata (waveform, dimensions, custom data).
  final Map<String, dynamic>? metadata;

  /// Whether message is still pending.
  bool get isPending =>
      status == MessageStatus.pending || status == MessageStatus.sending;

  /// Whether message was sent successfully.
  bool get isSent =>
      status == MessageStatus.sent ||
      status == MessageStatus.delivered ||
      status == MessageStatus.read;

  /// Whether message failed to send.
  bool get isFailed => status == MessageStatus.failed;

  /// Whether this is a reply.
  bool get isReply => replyToId != null;

  /// Whether message has attachments.
  bool get hasAttachments => attachments.isNotEmpty;

  /// Whether message has reactions.
  bool get hasReactions => reactions.isNotEmpty;

  /// Display text for the message.
  String get displayText => content.displayText;

  /// Effective timestamp for display.
  DateTime get timestamp => serverTimestamp ?? clientTimestamp;

  /// Creates a copy with updated fields.
  Message copyWith({
    String? id,
    String? serverId,
    String? conversationId,
    String? senderId,
    String? senderName,
    String? senderAvatar,
    String? anonymousName,
    String? anonymousAvatar,
    MessageContent? content,
    MessageType? type,
    MessageStatus? status,
    DateTime? clientTimestamp,
    DateTime? serverTimestamp,
    String? replyToId,
    Message? replyTo,
    List<FileAttachment>? attachments,
    List<Reaction>? reactions,
    List<String>? readBy,
    bool? isDeleted,
    bool? isEdited,
    bool? isStarred,
    bool? isPinned,
    DateTime? pinnedUntil,
    int? localSequence,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      anonymousName: anonymousName ?? this.anonymousName,
      anonymousAvatar: anonymousAvatar ?? this.anonymousAvatar,
      content: content ?? this.content,
      type: type ?? this.type,
      status: status ?? this.status,
      clientTimestamp: clientTimestamp ?? this.clientTimestamp,
      serverTimestamp: serverTimestamp ?? this.serverTimestamp,
      replyToId: replyToId ?? this.replyToId,
      replyTo: replyTo ?? this.replyTo,
      attachments: attachments ?? this.attachments,
      reactions: reactions ?? this.reactions,
      readBy: readBy ?? this.readBy,
      isDeleted: isDeleted ?? this.isDeleted,
      isEdited: isEdited ?? this.isEdited,
      isStarred: isStarred ?? this.isStarred,
      isPinned: isPinned ?? this.isPinned,
      pinnedUntil: pinnedUntil ?? this.pinnedUntil,
      localSequence: localSequence ?? this.localSequence,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [
        id,
        serverId,
        conversationId,
        senderId,
        senderName,
        senderAvatar,
        anonymousName,
        anonymousAvatar,
        content,
        type,
        status,
        clientTimestamp,
        serverTimestamp,
        replyToId,
        attachments,
        reactions,
        readBy,
        isDeleted,
        isEdited,
        isStarred,
        isPinned,
        pinnedUntil,
        localSequence,
        metadata,
      ];
}
