import 'package:flutter_chat_sdk/src/domain/entities/conversation.dart';
import 'package:flutter_chat_sdk/src/extensions/context_extensions.dart';
import 'package:flutter/widgets.dart';

/// Builder widget that watches conversations from the Chat SDK.
///
/// ```dart
/// ConversationsBuilder(
///   filter: ConversationFilter(mode: ConversationMode.ephemeral),
///   builder: (context, conversations, isLoading) {
///     if (isLoading) return CircularProgressIndicator();
///     return ListView.builder(
///       itemCount: conversations.length,
///       itemBuilder: (context, index) => ConversationTile(conversations[index]),
///     );
///   },
/// )
/// ```
class ConversationsBuilder extends StatelessWidget {
  const ConversationsBuilder({
    required this.builder,
    super.key,
    this.filter,
  });

  final ConversationFilter? filter;
  final Widget Function(
    BuildContext context,
    List<Conversation> conversations,
    bool isLoading,
  ) builder;

  @override
  Widget build(BuildContext context) {
    final chat = context.chat;

    return StreamBuilder<List<Conversation>>(
      stream: chat.watchConversations(filter: filter),
      builder: (context, snapshot) {
        final isLoading = !snapshot.hasData;
        final conversations = snapshot.data ?? [];

        return builder(context, conversations, isLoading);
      },
    );
  }
}
