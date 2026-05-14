import 'package:flutter_chat_sdk/src/domain/entities/message.dart';
import 'package:flutter_chat_sdk/src/extensions/context_extensions.dart';
import 'package:flutter/widgets.dart';

/// Builder widget that watches messages for a specific room.
///
/// ```dart
/// MessagesBuilder(
///   roomId: 'room-123',
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
    required this.roomId,
    required this.builder,
    super.key,
  });

  final String roomId;
  final Widget Function(
    BuildContext context,
    List<Message> messages,
    bool isLoading,
  ) builder;

  @override
  Widget build(BuildContext context) {
    final chat = context.chat;

    return StreamBuilder<List<Message>>(
      stream: chat.watchMessages(roomId),
      builder: (context, snapshot) {
        final isLoading = !snapshot.hasData;
        final messages = snapshot.data ?? [];

        return builder(context, messages, isLoading);
      },
    );
  }
}
