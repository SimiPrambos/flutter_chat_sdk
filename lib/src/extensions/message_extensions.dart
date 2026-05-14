import 'package:flutter_chat_sdk/src/domain/entities/message.dart';
import 'package:flutter_chat_sdk/src/domain/enums/message_status.dart';
import 'package:intl/intl.dart';

/// Extension methods on [Message].
extension MessageExtensions on Message {
  /// Human-readable time label: "2m ago", "Yesterday", "Jan 15"
  String get timeLabel {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';

    return DateFormat('MMM d').format(timestamp);
  }

  /// Status emoji: "⏳", "✓", "✓✓", "✗"
  String get statusEmoji {
    switch (status) {
      case MessageStatus.draft:
      case MessageStatus.pending:
      case MessageStatus.sending:
        return '⏳';
      case MessageStatus.sent:
        return '✓';
      case MessageStatus.delivered:
        return '✓✓';
      case MessageStatus.read:
        return '✓✓';
      case MessageStatus.failed:
        return '✗';
    }
  }

  /// Whether this message was sent by the current user.
  bool isFromMe(String myUserId) => senderId == myUserId;

  /// Whether this message can be edited.
  bool get canEdit => !isDeleted && isSent && !isEdited;

  /// Whether this message can be deleted.
  bool get canDelete => !isDeleted;

  /// Whether this message can be replied to.
  bool get canReply => !isDeleted && isSent;

  /// Whether this message has attachments.
  bool get hasAttachments => attachments.isNotEmpty;

  /// Whether this message has reactions.
  bool get hasReactions => reactions.isNotEmpty;

  /// Time since message was sent.
  Duration get age => DateTime.now().difference(timestamp);
}
