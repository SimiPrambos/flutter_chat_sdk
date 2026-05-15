import 'package:flutter_chat_sdk/src/chat.dart';
import 'package:flutter_chat_sdk/src/config/chat_config.dart';
import 'package:flutter_chat_sdk/src/config/chat_registry.dart';
import 'package:flutter_chat_sdk/src/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/mock_adapters.dart';
import 'helpers/test_helpers.dart';

void main() {
  group('Chat Package: Pin Message', () {
    late Chat chat;
    late FakeChatAdapter adapter;
    late FakeChatDatabase database;

    setUp(() async {
      adapter = FakeChatAdapter(userId: 'user-123');
      database = FakeChatDatabase();

      final registry = ChatRegistry.custom(
        config: const ChatConfig(
          databasePath: ':memory:',
        ),
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

    test('pinMessage replaces the previous pinned message in the same room',
        () async {
      const roomId = 'room-123';

      await database.insertMessage(
        Message(
          id: 'msg-1',
          conversationId: roomId,
          senderId: 'other-user',
          content: const MessageContent(plainText: 'First'),
          status: MessageStatus.sent,
          clientTimestamp: DateTime(2026, 1, 1, 10),
          isPinned: true,
          pinnedUntil: DateTime(2026, 1, 2),
        ),
      );
      await database.insertMessage(
        Message(
          id: 'msg-2',
          conversationId: roomId,
          senderId: 'other-user',
          content: const MessageContent(plainText: 'Second'),
          status: MessageStatus.sent,
          clientTimestamp: DateTime(2026, 1, 1, 9),
        ),
      );

      await chat.pinMessage(
        roomId,
        'msg-2',
        duration: const Duration(hours: 24),
      );

      final roomMessages = database.getMessages(roomId);
      final pinnedIds = roomMessages.where((m) => m.isPinned).map((m) => m.id);

      expect(pinnedIds, ['msg-2']);
      expect(
        roomMessages.firstWhere((m) => m.id == 'msg-1').isPinned,
        isFalse,
      );
    });

    test('incoming PinEvent replaces the old pinned message', () async {
      const roomId = 'room-123';

      await database.insertMessage(
        Message(
          id: 'msg-1',
          conversationId: roomId,
          senderId: 'other-user',
          content: const MessageContent(plainText: 'First'),
          status: MessageStatus.sent,
          clientTimestamp: DateTime(2026, 1, 1, 10),
          isPinned: true,
        ),
      );
      await database.insertMessage(
        Message(
          id: 'msg-2',
          conversationId: roomId,
          senderId: 'other-user',
          content: const MessageContent(plainText: 'Second'),
          status: MessageStatus.sent,
          clientTimestamp: DateTime(2026, 1, 1, 9),
        ),
      );

      adapter.simulatePinEvent(
        conversationId: roomId,
        messageId: 'msg-2',
        isPinned: true,
        pinnedUntil: DateTime(2026, 1, 2),
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));

      final roomMessages = database.getMessages(roomId);
      final pinnedIds = roomMessages.where((m) => m.isPinned).map((m) => m.id);

      expect(pinnedIds, ['msg-2']);
      expect(
        roomMessages.firstWhere((m) => m.id == 'msg-1').isPinned,
        isFalse,
      );
    });
  });
}
