import 'package:flutter_chat_sdk/src/domain/entities/conversation.dart';
import 'package:intl/intl.dart';

/// Extension methods on [Conversation].
extension ConversationExtensions on Conversation {
  /// Human-readable label for the last activity time.
  ///
  /// Returns "Active now", "2h ago", "Yesterday", or a formatted date.
  String get lastActivityLabel {
    if (lastMessageAt == null) return 'No messages';

    final now = DateTime.now();
    final diff = now.difference(lastMessageAt!);

    if (diff.inMinutes < 5) return 'Active now';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';

    return DateFormat('MMM d').format(lastMessageAt!);
  }
}
