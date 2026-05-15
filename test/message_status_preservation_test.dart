/// Test for message status preservation during sync.
///
/// This test verifies that when messages are synced from the server,
/// existing message statuses (delivered, read) are not overwritten
/// with the default 'sent' status from the sync API.
library;
import 'package:flutter_chat_sdk/flutter_chat_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/mock_adapters.dart';
import 'helpers/test_helpers.dart';

void main() {
  group('Message Status Preservation', () {
    late Chat chat;
    late FakeChatDatabase database;

    setUp(() async {
      database = FakeChatDatabase();

      final registry = ChatRegistry.custom(
        config: const ChatConfig(
          databasePath: ':memory:',
        ),
        adapter: FakeChatAdapter(userId: 'user-123'),
        identityProvider: FakeChatIdentityProvider('user-123'),
        database: database,
      );

      chat = Chat(registry);
      await chat.initialize();
    });

    tearDown(() async {
      await chat.dispose();
      await database.close();
    });

    test('Preserves delivered status when sync returns sent', () async {
      const roomId = 'room-123';

      // Step 1: Create a message with delivered status (simulating socket event)
      final originalMessage = Message(
        id: 'msg-1',
        serverId: 'server-msg-1',
        conversationId: roomId,
        senderId: 'user-123',
        content: const MessageContent.plain('Hello'),
        status: MessageStatus.delivered, // Higher status
        clientTimestamp: DateTime(2025, 1, 1, 10),
        serverTimestamp: DateTime(2025, 1, 1, 10),
      );

      // Insert the message with delivered status
      await database.insertMessage(originalMessage);

      // Verify it's stored as delivered
      final rooms = await chat.getConversations();
      expect(rooms, hasLength(1));
      final room = await chat.getConversation(roomId);
      expect(room?.lastMessage?.status, MessageStatus.delivered);

      // Step 2: Simulate sync API returning the same message with 'sent' status
      // (This is what happens in production - sync API hardcodes status to 'sent')
      final syncMessage = Message(
        id: 'msg-1',
        serverId: 'server-msg-1',
        conversationId: roomId,
        senderId: 'user-123',
        content: const MessageContent.plain('Hello'),
        status: MessageStatus.sent, // Lower status from sync API
        clientTimestamp: DateTime(2025, 1, 1, 10),
        serverTimestamp: DateTime(2025, 1, 1, 10),
      );

      // Insert the sync message (should preserve delivered status)
      await database.insertMessage(syncMessage);

      // Step 3: Verify status is still delivered (not downgraded to sent)
      final updatedRoom = await chat.getConversation(roomId);
      expect(
        updatedRoom?.lastMessage?.status,
        MessageStatus.delivered,
        reason:
            'Status should be preserved when existing status is more advanced',
      );
    });

    test('Preserves read status when sync returns sent', () async {
      const roomId = 'room-123';

      // Create a message with read status
      final originalMessage = Message(
        id: 'msg-2',
        serverId: 'server-msg-2',
        conversationId: roomId,
        senderId: 'user-123',
        content: const MessageContent.plain('World'),
        status: MessageStatus.read, // Highest status
        clientTimestamp: DateTime(2025, 1, 1, 10),
        serverTimestamp: DateTime(2025, 1, 1, 10),
      );

      await database.insertMessage(originalMessage);

      // Verify it's stored as read
      final room = await chat.getConversation(roomId);
      expect(room?.lastMessage?.status, MessageStatus.read);

      // Simulate sync API returning the same message with 'sent' status
      final syncMessage = Message(
        id: 'msg-2',
        serverId: 'server-msg-2',
        conversationId: roomId,
        senderId: 'user-123',
        content: const MessageContent.plain('World'),
        status: MessageStatus.sent, // Lower status from sync API
        clientTimestamp: DateTime(2025, 1, 1, 10),
        serverTimestamp: DateTime(2025, 1, 1, 10),
      );

      await database.insertMessage(syncMessage);

      // Verify status is still read
      final updatedRoom = await chat.getConversation(roomId);
      expect(
        updatedRoom?.lastMessage?.status,
        MessageStatus.read,
        reason: 'Read status should be preserved',
      );
    });

    test('Updates status when incoming status is more advanced', () async {
      const roomId = 'room-123';

      // Create a message with sent status
      final originalMessage = Message(
        id: 'msg-3',
        serverId: 'server-msg-3',
        conversationId: roomId,
        senderId: 'other-user',
        content: const MessageContent.plain('Hi'),
        status: MessageStatus.sent, // Lower status
        clientTimestamp: DateTime(2025, 1, 1, 10),
        serverTimestamp: DateTime(2025, 1, 1, 10),
      );

      await database.insertMessage(originalMessage);

      // Verify it's stored as sent
      final room = await chat.getConversation(roomId);
      expect(room?.lastMessage?.status, MessageStatus.sent);

      // Simulate socket event updating status to delivered
      final updatedMessage = Message(
        id: 'msg-3',
        serverId: 'server-msg-3',
        conversationId: roomId,
        senderId: 'other-user',
        content: const MessageContent.plain('Hi'),
        status: MessageStatus.delivered, // Higher status from socket
        clientTimestamp: DateTime(2025, 1, 1, 10),
        serverTimestamp: DateTime(2025, 1, 1, 10),
      );

      await database.insertMessage(updatedMessage);

      // Verify status is updated to delivered
      final finalRoom = await chat.getConversation(roomId);
      expect(
        finalRoom?.lastMessage?.status,
        MessageStatus.delivered,
        reason:
            'Status should be updated when incoming status is more advanced',
      );
    });
  });
}
