import 'package:flutter_chat_sdk/src/chat.dart';
import 'package:flutter_chat_sdk/src/config/chat_config.dart';
import 'package:flutter_chat_sdk/src/config/chat_registry.dart';
import 'package:flutter_chat_sdk/src/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/mock_adapters.dart';
import 'helpers/test_helpers.dart';

void main() {
  group('Chat.createConversation', () {
    late Chat chat;
    late FakeChatAdapter adapter;
    late FakeChatDatabase database;

    setUp(() async {
      adapter = FakeChatAdapter(userId: 'user-123');
      database = FakeChatDatabase();
      final registry = ChatRegistry.custom(
        config: const ChatConfig(databasePath: ':memory:'),
        adapter: adapter,
        identityProvider: FakeChatIdentityProvider('user-123'),
        database: database,
      );
      chat = Chat(registry);
      await chat.initialize();
    });

    tearDown(() async {
      await chat.dispose();
      await adapter.dispose();
      await database.close();
    });

    test(
        'creates ephemeral conversation and returns Conversation with ephemeral mode',
        () async {
      final conversation = await chat.createConversation(
        mode: ConversationMode.ephemeral,
        name: 'Secret Squad',
        expiresIn: const Duration(hours: 24),
      );

      expect(conversation.id, isNotEmpty);
      expect(conversation.mode, ConversationMode.ephemeral);
      expect(conversation.name, 'Secret Squad');
    });

    test(
        'creates standard conversation with ConversationType.direct by default when type omitted',
        () async {
      final conversation = await chat.createConversation(
        mode: ConversationMode.standard,
      );

      expect(conversation.id, isNotEmpty);
      expect(conversation.mode, ConversationMode.standard);
    });
  });
}
