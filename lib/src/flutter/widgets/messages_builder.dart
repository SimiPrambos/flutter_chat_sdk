import 'package:flutter/widgets.dart';
import 'package:flutter_chat_sdk/src/domain/entities/message.dart';
import 'package:flutter_chat_sdk/src/extensions/context_extensions.dart';

/// Builder widget that watches messages for a specific conversation.
///
/// ```dart
/// MessagesBuilder(
///   conversationId: 'conv-123',
///   builder: (context, messages, isLoading) {
///     if (isLoading) return CircularProgressIndicator();
///     return ListView.builder(
///       itemCount: messages.length,
///       itemBuilder: (context, index) => MessageBubble(messages[index]),
///     );
///   },
/// )
/// ```
class MessagesBuilder extends StatelessWidget {
  const MessagesBuilder({
    required this.conversationId,
    required this.builder,
    super.key,
  });

  /// The ID of the conversation whose messages to watch.
  final String conversationId;
  final Widget Function(
    BuildContext context,
    List<Message> messages, {
    required bool isLoading,
  }) builder;

  @override
  Widget build(BuildContext context) {
    final chat = context.chat;

    return StreamBuilder<List<Message>>(
      stream: chat.watchMessages(conversationId),
      builder: (context, snapshot) {
        final isLoading = !snapshot.hasData;
        final messages = snapshot.data ?? [];

        return builder(context, messages, isLoading: isLoading);
      },
    );
  }
}
