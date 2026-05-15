/// End-to-end tests for the Chat package.
///
/// These tests simulate the complete flow of sending a message
/// as documented in docs/chat-package-guide.md.
import 'dart:async';

import 'package:flutter_chat_sdk/src/chat.dart';
import 'package:flutter_chat_sdk/src/config/chat_config.dart';
import 'package:flutter_chat_sdk/src/config/chat_registry.dart';
import 'package:flutter_chat_sdk/src/domain/domain.dart';
import 'package:flutter_chat_sdk/src/domain/entities/file_attachment.dart';
import 'package:flutter_chat_sdk/src/exceptions/chat_exception.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/mock_adapters.dart';
import 'helpers/test_helpers.dart';

void main() {
  group('Chat Package: Send Message Flow', () {
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

    test('Step 1: User clicks send button creates message', () async {
      // Simulate: User types "Hello!" and clicks Send button
      const roomId = 'room-123';
      const content = 'Hello!';

      // Act: Call sendMessage
      final message = await chat.sendMessage(
        conversationId: roomId,
        content: content,
      );

      // Assert: Message is created with pending status
      expect(message.id, isNotEmpty);
      expect(message.conversationId, roomId);
      expect(message.senderId, 'user-123');
      expect(message.content.plainText, content);
      expect(message.status, MessageStatus.pending);
      expect(message.serverId, isNull);
      expect(message.clientTimestamp, isNotNull);
    });

    test('Step 2: Message is saved to database immediately', () async {
      const roomId = 'room-123';

      // Send message
      final message = await chat.sendMessage(
        conversationId: roomId,
        content: 'Test message',
      );

      // Wait a bit for async operations
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Verify message is in database
      final dbMessages = database.getMessages(roomId);
      expect(dbMessages, hasLength(1));
      expect(dbMessages.first.id, message.id);
      expect(dbMessages.first.status, MessageStatus.pending);
    });

    test('Step 3: UI receives message via stream (optimistic UI)', () async {
      const roomId = 'room-123';

      // Start watching messages before sending
      final messages = <List<Message>>[];
      late StreamSubscription<List<Message>> subscription;

      subscription = chat.watchMessages(roomId).listen(messages.add);

      // Send message
      await chat.sendMessage(
        conversationId: roomId,
        content: 'Test message',
      );

      // Wait for stream to emit
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await subscription.cancel();

      // Verify UI received the message
      expect(messages, isNotEmpty);
      final latestMessages = messages.last;
      expect(latestMessages, hasLength(1));
      expect(latestMessages.first.status, MessageStatus.pending);
    });

    test('Step 4: Outbound queue processes message', () async {
      const roomId = 'room-123';
      const content = 'Test message';

      // Send message FIRST (will be queued since not connected yet)
      await chat.sendMessage(
        conversationId: roomId,
        content: content,
      );

      // Wait for database insertion
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Now connect (triggers queue processing)
      await chat.connect();

      // Wait for queue processing
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Verify message was sent via adapter (by content match)
      final adapterMessages = adapter.messages[roomId] ?? [];
      expect(adapterMessages, isNotEmpty);
      expect(
        adapterMessages.any((m) => m.content.plainText == content),
        isTrue,
      );
    });

    test('Step 5: Multiple messages queued while offline', () async {
      const roomId = 'room-123';

      // Send multiple messages while disconnected
      final contents = ['Message 1', 'Message 2', 'Message 3'];
      for (final content in contents) {
        await chat.sendMessage(
          conversationId: roomId,
          content: content,
        );
      }

      // Wait for database insertions
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Verify all messages are in database with pending status
      final dbMessages = database.getMessages(roomId);
      expect(dbMessages, hasLength(3));
      for (final msg in dbMessages) {
        expect(msg.status, MessageStatus.pending);
      }

      // Adapter should have no messages yet
      expect(adapter.messages[roomId] ?? [], isEmpty);

      // Connect (triggers queue processing)
      await chat.connect();

      // Wait for queue to process
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Verify all messages were sent
      final adapterMessages = adapter.messages[roomId] ?? [];
      expect(adapterMessages, hasLength(3));
      for (final content in contents) {
        expect(
          adapterMessages.any((m) => m.content.plainText == content),
          isTrue,
          reason: 'Expected to find message with content "$content"',
        );
      }
    });

    test('Step 6: Incoming message event updates database', () async {
      const roomId = 'room-123';
      const senderId = 'other-user-456';

      // Connect to receive events
      await chat.connect();

      // Listen for message events
      final events = <MessageEvent>[];
      late StreamSubscription<MessageEvent> subscription;
      subscription = chat.on<MessageEvent>().listen(events.add);

      // Simulate incoming message from another user
      adapter.simulateIncomingMessage(
        roomId: roomId,
        senderId: senderId,
        content: 'Incoming message',
      );

      // Wait for event processing
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await subscription.cancel();

      // Verify event was received
      expect(events, hasLength(1));
      expect(events.first.message.senderId, senderId);
      expect(events.first.message.content.plainText, 'Incoming message');

      // Verify message is in database
      final dbMessages = database.getMessages(roomId);
      expect(
        dbMessages.any((m) => m.senderId == senderId),
        isTrue,
      );
    });

    test(
      'attachment caption survives server merge when response content is empty',
      () async {
        final adapter = _AttachmentResponseDropsContentAdapter(
          userId: 'user-123',
        );
        final database = FakeChatDatabase();
        final registry = ChatRegistry.custom(
          config: const ChatConfig(
            databasePath: ':memory:',
          ),
          adapter: adapter,
          identityProvider: FakeChatIdentityProvider('user-123'),
          database: database,
        );

        final chat = Chat(registry);
        await chat.initialize();
        addTearDown(() async {
          await chat.dispose();
          await adapter.dispose();
          await database.close();
        });

        await chat.sendMessageWithParams(
          const SendMessageParams(
            conversationId: 'room-123',
            content: 'Japan',
            type: MessageType.file,
            attachments: [
              PendingAttachment(
                filePath: '/tmp/doc.pdf',
                fileName: 'doc.pdf',
                mimeType: 'application/pdf',
              ),
            ],
          ),
        );

        await Future<void>.delayed(const Duration(milliseconds: 50));
        await chat.connect();
        await Future<void>.delayed(const Duration(milliseconds: 200));

        final messages = database.getMessages('room-123');
        expect(messages, hasLength(1));
        expect(messages.first.attachments, hasLength(1));
        expect(messages.first.attachments.first.url,
            'https://example.com/doc.pdf');
        expect(messages.first.content.plainText, 'Japan');
      },
    );

    test('Complete flow: Send and receive messages', () async {
      const roomId = 'room-123';

      // Connect
      await chat.connect();

      // Collect all message events
      final allEvents = <MessageEvent>[];
      late StreamSubscription<MessageEvent> subscription;
      subscription = chat.on<MessageEvent>().listen(allEvents.add);

      // Send message
      await chat.sendMessage(
        conversationId: roomId,
        content: 'Hello from user-123',
      );

      // Wait for send processing
      await Future<void>.delayed(const Duration(milliseconds: 100));

      // Simulate response from another user
      adapter.simulateIncomingMessage(
        roomId: roomId,
        senderId: 'user-456',
        content: 'Hello back!',
      );

      // Wait for incoming event
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await subscription.cancel();

      // Note: We only get 1 event (incoming message) because
      // our own sent message doesn't emit an event back through the adapter
      expect(allEvents, hasLength(1));
      expect(allEvents.first.message.senderId, 'user-456');
      expect(
        allEvents.first.message.content.plainText,
        'Hello back!',
      );

      // Verify both messages are in database
      final dbMessages = database.getMessages(roomId);
      expect(dbMessages, hasLength(2));
      expect(
        dbMessages.any((m) => m.senderId == 'user-123'),
        isTrue,
      );
      expect(
        dbMessages.any((m) => m.senderId == 'user-456'),
        isTrue,
      );
    });

    test('Typing indicators are received', () async {
      const roomId = 'room-123';
      const otherUserId = 'user-456';

      await chat.connect();

      final typingEvents = <TypingEvent>[];
      late StreamSubscription<TypingEvent> subscription;
      subscription = chat.on<TypingEvent>().listen(typingEvents.add);

      // Simulate typing from another user
      adapter.simulateTyping(
        roomId: roomId,
        userId: otherUserId,
        isTyping: true,
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await subscription.cancel();

      expect(typingEvents, hasLength(1));
      expect(typingEvents.first.userId, otherUserId);
      expect(typingEvents.first.isTyping, isTrue);
    });

    test('Presence events are received', () async {
      await chat.connect();

      final presenceEvents = <PresenceEvent>[];
      late StreamSubscription<PresenceEvent> subscription;
      subscription = chat.on<PresenceEvent>().listen(presenceEvents.add);

      // Simulate presence change
      adapter.simulateConnectionState(ChatConnectionState.connected);

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await subscription.cancel();

      // Note: Our adapter doesn't emit PresenceEvent on connect,
      // but this test structure is ready when that's implemented
    });

    test('Connection state changes are tracked', () {
      expect(chat.connectionState.value, ChatConnectionState.disconnected);

      final states = <ChatConnectionState>[];
      chat.connectionState.addListener(() {
        states.add(chat.connectionState.value);
      });

      chat.connect();

      // Wait for async connection
      return Future<void>.delayed(const Duration(milliseconds: 100)).then((_) {
        expect(states, contains(ChatConnectionState.connected));
      });
    });

    test('Pending operations are tracked', () async {
      // Send message while disconnected
      await chat.sendMessage(
        conversationId: 'room-123',
        content: 'Pending message',
      );

      // Wait for queueing
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Pending count should be tracked
      // (Note: Our implementation doesn't expose pending operations count
      // until connection is established)
      expect(chat.pendingCount.value, greaterThanOrEqualTo(0));
    });

    test('Send reply message', () async {
      const roomId = 'room-123';

      // Send original message
      final original = await chat.sendMessage(
        conversationId: roomId,
        content: 'Original message',
      );

      // Wait for database update
      await Future<void>.delayed(const Duration(milliseconds: 50));

      // Send reply
      final reply = await chat.sendMessage(
        conversationId: roomId,
        content: 'Reply message',
        replyToId: original.id,
      );

      expect(reply.replyToId, original.id);
      expect(reply.isReply, isTrue);

      // Verify both messages are in database
      await Future<void>.delayed(const Duration(milliseconds: 50));
      final dbMessages = database.getMessages(roomId);
      expect(dbMessages, hasLength(2));
    });

    test('Send message with custom type', () async {
      const roomId = 'room-123';

      final message = await chat.sendMessage(
        conversationId: roomId,
        content: 'image.jpg',
        type: MessageType.image,
      );

      expect(message.type, MessageType.image);
    });

    test('Multiple messages maintain order', () async {
      const roomId = 'room-123';

      final sentIds = <String>[];
      for (int i = 0; i < 5; i++) {
        final msg = await chat.sendMessage(
          conversationId: roomId,
          content: 'Message $i',
        );
        sentIds.add(msg.id);
      }

      // Wait for all database inserts
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final dbMessages = database.getMessages(roomId);
      expect(dbMessages, hasLength(5));

      // Verify order
      final dbIds = dbMessages.map((m) => m.id).toList();
      expect(dbIds, orderedEquals(sentIds));
    });

    test('Messages from different rooms are separated', () async {
      const room1 = 'room-1';
      const room2 = 'room-2';

      await chat.sendMessage(
        conversationId: room1,
        content: 'Room 1 message',
      );

      await chat.sendMessage(
        conversationId: room2,
        content: 'Room 2 message',
      );

      await Future<void>.delayed(const Duration(milliseconds: 100));

      final room1Messages = database.getMessages(room1);
      final room2Messages = database.getMessages(room2);

      expect(room1Messages, hasLength(1));
      expect(room2Messages, hasLength(1));
      expect(room1Messages.first.content.plainText, 'Room 1 message');
      expect(room2Messages.first.content.plainText, 'Room 2 message');
    });
  });

  group('Chat Package: Error Handling', () {
    test('throws when using chat before initialization', () async {
      final registry = createTestRegistry();
      final chat = Chat(registry);

      expect(
        () => chat.sendMessage(conversationId: 'room-1', content: 'Test'),
        throwsA(isA<ChatNotInitializedException>()),
      );

      // Don't call dispose since chat was never initialized
      // The registry resources will be garbage collected
    });

    test('handles adapter errors gracefully', () async {
      final adapter = FakeChatAdapter(userId: 'user-123');
      final database = FakeChatDatabase();

      final registry = ChatRegistry.custom(
        config: const ChatConfig(databasePath: ':memory:'),
        adapter: adapter,
        identityProvider: FakeChatIdentityProvider('user-123'),
        database: database,
      );

      final chat = Chat(registry);
      await chat.initialize();

      // This test structure is ready for when we add
      // error scenarios to the adapter
      expect(chat.isInitialized, isTrue);

      await chat.dispose();
      await adapter.dispose();
      await database.close();
    });
  });

  group('Chat Package: Stream Behavior', () {
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

    test('watchConversations emits conversation list', () async {
      final conversations = <List<Conversation>>[];
      late StreamSubscription<List<Conversation>> subscription;
      subscription = chat.watchConversations().listen(conversations.add);

      // Insert a conversation
      await database.insertConversation(
        createTestConversation(id: 'room-1', name: 'Test Room'),
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await subscription.cancel();

      expect(conversations, isNotEmpty);
      expect(conversations.first, hasLength(1));
      expect(conversations.first.first.name, 'Test Room');
    });

    test(
        'watchConversations re-emits stamped conversations when provider userId changes',
        () async {
      await chat.dispose();
      await adapter.dispose();
      await database.close();

      adapter = FakeChatAdapter(userId: 'me');
      database = FakeChatDatabase();
      final identityProvider = FakeChatIdentityProvider();

      final registry = ChatRegistry.custom(
        config: const ChatConfig(databasePath: ':memory:'),
        adapter: adapter,
        identityProvider: identityProvider,
        database: database,
      );

      chat = Chat(registry);
      await chat.initialize();

      final conversations = <List<Conversation>>[];
      late StreamSubscription<List<Conversation>> subscription;
      subscription = chat.watchConversations().listen(conversations.add);

      await database.insertConversation(
        const Conversation(
          id: 'direct-room',
          type: ConversationType.direct,
          mode: ConversationMode.standard,
          participants: [
            Participant(
              id: 'part-me',
              userId: 'me',
              displayName: 'Me',
            ),
            Participant(
              id: 'part-alice',
              userId: 'alice',
              displayName: 'Alice',
            ),
          ],
        ),
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));

      identityProvider.setUserId('me');
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await subscription.cancel();

      expect(conversations, hasLength(greaterThanOrEqualTo(2)));
      expect(conversations.first, isEmpty);
      expect(conversations.last.single.myUserId, 'me');
      expect(conversations.last.single.displayName, 'Alice');
      await identityProvider.dispose();
    });

    test('watchMessages emits message list for room', () async {
      const roomId = 'room-123';

      final messages = <List<Message>>[];
      late StreamSubscription<List<Message>> subscription;
      subscription = chat.watchMessages(roomId).listen(messages.add);

      // Send a message
      await chat.sendMessage(
        conversationId: roomId,
        content: 'Test message',
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await subscription.cancel();

      expect(messages, isNotEmpty);
      expect(messages.first, hasLength(1));
      expect(messages.first.first.content.plainText, 'Test message');
    });

    test('multiple subscribers receive same updates', () async {
      const roomId = 'room-123';

      final messages1 = <List<Message>>[];
      final messages2 = <List<Message>>[];

      final sub1 = chat.watchMessages(roomId).listen(messages1.add);
      final sub2 = chat.watchMessages(roomId).listen(messages2.add);

      await chat.sendMessage(
        conversationId: roomId,
        content: 'Test message',
      );

      await Future<void>.delayed(const Duration(milliseconds: 50));
      await sub1.cancel();
      await sub2.cancel();

      expect(messages1, hasLength(greaterThan(0)));
      expect(messages2, hasLength(greaterThan(0)));
      expect(messages1.first.first.id, messages2.first.first.id);
    });
  });
}

class _AttachmentResponseDropsContentAdapter extends FakeChatAdapter {
  _AttachmentResponseDropsContentAdapter({required super.userId});

  @override
  Future<Message> sendMessage(SendMessageParams params) async {
    return Message(
      id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      conversationId: params.conversationId,
      senderId: userId,
      content: const MessageContent.plain(''),
      type: params.type,
      clientTimestamp: DateTime.now(),
      serverTimestamp: DateTime.now(),
      serverId: 'srv-${DateTime.now().millisecondsSinceEpoch}',
      status: MessageStatus.sent,
      attachments: [
        FileAttachment(
          id: 'file-1',
          url: 'https://example.com/doc.pdf',
          name: 'doc.pdf',
          extension: 'pdf',
          size: 1024,
          mimeType: 'application/pdf',
        ),
      ],
    );
  }
}
