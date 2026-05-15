// example/lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_chat_sdk/flutter_chat_sdk.dart';
import 'package:flutter_chat_sdk/testing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final chat = await Chat.create(
    databasePath: ':memory:',
    adapter: MockChatAdapter(),
    identityProvider: const StaticIdentityProvider('user-1'),
  );

  await chat.connect();

  // Seed a demo conversation
  (chat.registry.adapter as MockChatAdapter).simulateIncomingMessage(
    conversationId: 'demo',
    senderId: 'user-2',
    content: 'Hello from the example!',
  );

  runApp(ChatExampleApp(chat: chat));
}

class ChatExampleApp extends StatelessWidget {
  const ChatExampleApp({required this.chat, super.key});
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat SDK Example',
      home: ConversationListScreen(chat: chat),
    );
  }
}

class ConversationListScreen extends StatelessWidget {
  const ConversationListScreen({required this.chat, super.key});
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversations')),
      body: StreamBuilder<List<Conversation>>(
        stream: chat.watchConversations(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final conversations = snapshot.data!;
          if (conversations.isEmpty) {
            return const Center(child: Text('No conversations yet.'));
          }
          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return ListTile(
                title: Text(conversation.displayName),
                subtitle: Text(
                  conversation.lastMessage?.displayText ?? 'No messages',
                ),
                trailing: conversation.hasUnread
                    ? Badge(label: Text('${conversation.unreadCount}'))
                    : null,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => chat.sendMessage(
          conversationId: 'demo',
          content: 'Hello! ${DateTime.now()}',
        ),
        child: const Icon(Icons.send),
      ),
    );
  }
}
