import 'package:flutter_chat_sdk/src/chat.dart';
import 'package:flutter_chat_sdk/src/flutter/chat_provider.dart';
import 'package:flutter/widgets.dart';

/// Extension methods on [BuildContext] for Chat access.
extension ChatBuildContextExtension on BuildContext {
  /// Get the [Chat] instance from the closest [ChatProvider] ancestor.
  ///
  /// ```dart
  /// final chat = context.chat;
  /// await chat.sendMessage(conversationId: '123', content: 'Hello!');
  /// ```
  Chat get chat => ChatProvider.of(this);
}
