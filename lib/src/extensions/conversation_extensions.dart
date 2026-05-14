import 'package:flutter_chat_sdk/src/domain/entities/conversation.dart';
import 'package:flutter_chat_sdk/src/domain/entities/participant.dart';
import 'package:flutter_chat_sdk/src/domain/enums/conversation_mode.dart';
import 'package:flutter_chat_sdk/src/domain/enums/conversation_type.dart';
import 'package:intl/intl.dart';

/// Extension methods on [Conversation].
extension ConversationExtensions on Conversation {
  /// Display name: conversation name or participant names for direct chats.
  String get displayName {
    if (name != null && name!.isNotEmpty) return name!;
    if (type == ConversationType.direct && participants.isNotEmpty) {
      return participants
          .where((p) => p.userId != myUserId)
          .map((p) => p.displayName)
          .join(', ');
    }
    return 'Unknown';
  }

  /// Last activity label: "Active now", "2h ago", "Yesterday"
  String get lastActivityLabel {
    if (lastMessageAt == null) return 'No messages';

    final now = DateTime.now();
    final diff = now.difference(lastMessageAt!);

    if (diff.inMinutes < 5) return 'Active now';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';

    return DateFormat('MMM d').format(lastMessageAt!);
  }

  /// Whether this is a direct (1:1) chat.
  bool get isDirect => type == ConversationType.direct;

  /// Whether this is a group chat.
  bool get isGroup => type == ConversationType.group;

  /// Whether this conversation is ephemeral (temporary/expiring).
  bool get isEphemeral => mode == ConversationMode.ephemeral;

  /// Whether this conversation has expired.
  bool get isExpired => expiresAt?.isBefore(DateTime.now()) ?? false;

  /// Count of active (online) participants.
  int get activeParticipantCount =>
      participants.where((p) => p.isOnline).length;

  /// Other participant in direct chat (null for group).
  Participant? get otherParticipant {
    if (!isDirect || participants.length < 2) return null;
    return participants.firstWhere(
      (p) => p.userId != myUserId,
      orElse: () => participants.first,
    );
  }
}
