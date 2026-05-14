import 'dart:async';

import 'package:flutter_chat_sdk/src/core/event_bus/chat_event_bus.dart';
import 'package:flutter_chat_sdk/src/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatEventBus', () {
    late ChatEventBus eventBus;

    setUp(() {
      eventBus = ChatEventBusImpl();
    });

    tearDown(() async {
      eventBus.dispose();
    });

    test('emits events to all listeners', () async {
      final event = MessageEvent(
        eventId: 'evt-1',
        timestamp: DateTime.now(),
        message: createTestMessage(),
      );

      final emissions = <ChatEvent>[];
      final subscription = eventBus.eventStream.listen(emissions.add);

      eventBus.emit(event);

      await Future<void>.delayed(const Duration(milliseconds: 10));
      await subscription.cancel();

      expect(emissions, contains(event));
    });

    test('on<T> filters by event type', () async {
      final messageEvent = MessageEvent(
        eventId: 'evt-1',
        timestamp: DateTime.now(),
        message: createTestMessage(id: 'msg-1'),
      );

      final typingEvent = TypingEvent(
        eventId: 'evt-2',
        timestamp: DateTime.now(),
        conversationId: 'room-1',
        userId: 'user-1',
        isTyping: true,
      );

      final messageEvents = <MessageEvent>[];
      final subscription =
          eventBus.on<MessageEvent>().listen(messageEvents.add);

      eventBus.emit(messageEvent);
      eventBus.emit(typingEvent);

      await Future<void>.delayed(const Duration(milliseconds: 10));
      await subscription.cancel();

      expect(messageEvents, hasLength(1));
      expect(messageEvents.first, messageEvent);
    });

    test('multiple listeners receive the same event', () async {
      final event = MessageEvent(
        eventId: 'evt-1',
        timestamp: DateTime.now(),
        message: createTestMessage(),
      );

      final listener1Events = <ChatEvent>[];
      final listener2Events = <ChatEvent>[];

      final sub1 = eventBus.eventStream.listen(listener1Events.add);
      final sub2 = eventBus.eventStream.listen(listener2Events.add);

      eventBus.emit(event);

      await Future<void>.delayed(const Duration(milliseconds: 10));
      await sub1.cancel();
      await sub2.cancel();

      expect(listener1Events, contains(event));
      expect(listener2Events, contains(event));
    });

    test('does not emit to cancelled listeners', () async {
      final event = MessageEvent(
        eventId: 'evt-1',
        timestamp: DateTime.now(),
        message: createTestMessage(),
      );

      final emissions = <ChatEvent>[];
      late StreamSubscription<ChatEvent> subscription;

      subscription = eventBus.eventStream.listen(
        emissions.add,
        onDone: () {},
      );

      await subscription.cancel();
      eventBus.emit(event);

      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(emissions, isEmpty);
    });
  });

  group('ChatEvent Types', () {
    test('MessageEvent contains message', () {
      final message = createTestMessage();
      final event = MessageEvent(
        eventId: 'evt-1',
        timestamp: DateTime.now(),
        message: message,
      );

      expect(event.message, message);
    });

    test('TypingEvent contains typing info', () {
      final event = TypingEvent(
        eventId: 'evt-1',
        timestamp: DateTime.now(),
        conversationId: 'room-1',
        userId: 'user-1',
        isTyping: true,
        userName: 'Test User',
      );

      expect(event.conversationId, 'room-1');
      expect(event.userId, 'user-1');
      expect(event.isTyping, isTrue);
      expect(event.userName, 'Test User');
    });

    test('PresenceEvent contains presence info', () {
      final event = PresenceEvent(
        eventId: 'evt-1',
        timestamp: DateTime.now(),
        userId: 'user-1',
        isOnline: true,
        lastSeenAt: DateTime(2024, 1, 1),
      );

      expect(event.userId, 'user-1');
      expect(event.isOnline, isTrue);
      expect(event.lastSeenAt, DateTime(2024, 1, 1));
    });

    test('ReceiptEvent contains receipt info', () {
      final event = ReceiptEvent(
        eventId: 'evt-1',
        timestamp: DateTime.now(),
        conversationId: 'room-1',
        messageId: 'msg-1',
        userId: 'user-1',
        type: ReceiptType.read,
      );

      expect(event.conversationId, 'room-1');
      expect(event.messageId, 'msg-1');
      expect(event.userId, 'user-1');
      expect(event.type, ReceiptType.read);
    });

    test('ReactionEvent contains reaction info', () {
      final reaction = const Reaction(
        id: 'react-1',
        userId: 'user-1',
        emoji: '👍',
      );

      final event = ReactionEvent(
        eventId: 'evt-1',
        timestamp: DateTime.now(),
        conversationId: 'room-1',
        messageId: 'msg-1',
        reaction: reaction,
      );

      expect(event.conversationId, 'room-1');
      expect(event.messageId, 'msg-1');
      expect(event.reaction, reaction);
      expect(event.isRemoved, isFalse);
    });

    test('ConversationUpdateEvent contains conversation update info', () {
      final conversation = createTestConversation();
      final event = ConversationUpdateEvent(
        eventId: 'evt-1',
        timestamp: DateTime.now(),
        conversation: conversation,
        updateType: ConversationUpdateType.updated,
      );

      expect(event.conversation, conversation);
      expect(event.updateType, ConversationUpdateType.updated);
    });

    test('PinEvent contains pin info', () {
      final event = PinEvent(
        eventId: 'evt-1',
        timestamp: DateTime.now(),
        conversationId: 'room-1',
        messageId: 'msg-1',
        isPinned: true,
        pinnedUntil: DateTime(2024, 12, 31),
      );

      expect(event.conversationId, 'room-1');
      expect(event.messageId, 'msg-1');
      expect(event.isPinned, isTrue);
      expect(event.pinnedUntil, DateTime(2024, 12, 31));
    });
  });
}

Message createTestMessage({String? id}) {
  return Message(
    id: id ?? 'msg-1',
    conversationId: 'room-1',
    senderId: 'user-1',
    content: const MessageContent(plainText: 'Test'),
    clientTimestamp: DateTime.now(),
  );
}

Conversation createTestConversation() {
  return Conversation(
    id: 'room-1',
    type: ConversationType.group,
    mode: ConversationMode.standard,
    myUserId: 'user-1',
    myRole: ParticipantRole.member,
  );
}
