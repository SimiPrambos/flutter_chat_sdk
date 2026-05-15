import 'package:flutter_chat_sdk/src/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Conversation', () {
    const userId = 'user-123';

    test('creates a conversation with required fields', () {
      const conversation = Conversation(
        id: 'room-123',
        type: ConversationType.group,
        mode: ConversationMode.standard,
        myUserId: userId,
        myRole: ParticipantRole.admin,
      );

      expect(conversation.id, 'room-123');
      expect(conversation.type, ConversationType.group);
      expect(conversation.mode, ConversationMode.standard);
      expect(conversation.myUserId, userId);
      expect(conversation.myRole, ParticipantRole.admin);
    });

    test('isDirect returns true for direct conversations', () {
      const conversation = Conversation(
        id: 'room-123',
        type: ConversationType.direct,
        mode: ConversationMode.standard,
        myUserId: userId,
      );

      expect(conversation.isDirect, isTrue);
      expect(conversation.isGroup, isFalse);
    });

    test('isGroup returns true for group conversations', () {
      const conversation = Conversation(
        id: 'room-123',
        type: ConversationType.group,
        mode: ConversationMode.standard,
        myUserId: userId,
      );

      expect(conversation.isGroup, isTrue);
      expect(conversation.isDirect, isFalse);
    });

    test('isEphemeral returns true for ephemeral mode conversations', () {
      const conversation = Conversation(
        id: 'room-123',
        type: ConversationType.group,
        mode: ConversationMode.ephemeral,
        myUserId: userId,
      );

      expect(conversation.isEphemeral, isTrue);
      expect(conversation.isStandard, isFalse);
    });

    test('isStandard returns true for standard mode conversations', () {
      const conversation = Conversation(
        id: 'room-123',
        type: ConversationType.group,
        mode: ConversationMode.standard,
        myUserId: userId,
      );

      expect(conversation.isStandard, isTrue);
      expect(conversation.isEphemeral, isFalse);
    });

    test('isAdmin returns true when user is admin', () {
      const conversation = Conversation(
        id: 'room-123',
        type: ConversationType.group,
        mode: ConversationMode.standard,
        myUserId: userId,
        myRole: ParticipantRole.admin,
      );

      expect(conversation.isAdmin, isTrue);
    });

    test('isActive returns true for active conversations', () {
      const conversation = Conversation(
        id: 'room-123',
        type: ConversationType.group,
        mode: ConversationMode.standard,
        myUserId: userId,
      );

      expect(conversation.isActive, isTrue);
      expect(conversation.isArchived, isFalse);
    });

    test('isArchived returns true for archived conversations', () {
      const conversation = Conversation(
        id: 'room-123',
        type: ConversationType.group,
        mode: ConversationMode.standard,
        status: ConversationStatus.archived,
        myUserId: userId,
      );

      expect(conversation.isArchived, isTrue);
      expect(conversation.isActive, isFalse);
    });

    test('hasUnread returns true when unreadCount > 0', () {
      const conversation = Conversation(
        id: 'room-123',
        type: ConversationType.group,
        mode: ConversationMode.standard,
        myUserId: userId,
        unreadCount: 5,
      );

      expect(conversation.hasUnread, isTrue);
    });

    test('displayName returns name when set', () {
      const conversation = Conversation(
        id: 'room-123',
        type: ConversationType.group,
        mode: ConversationMode.standard,
        name: 'My Room',
        myUserId: userId,
      );

      expect(conversation.displayName, 'My Room');
    });

    test('displayName returns other participant name for direct chats', () {
      const conversation = Conversation(
        id: 'room-123',
        type: ConversationType.direct,
        mode: ConversationMode.standard,
        myUserId: userId,
        participants: [
          Participant(
            id: 'part-1',
            userId: 'user-123',
            displayName: 'Me',
          ),
          Participant(
            id: 'part-2',
            userId: 'user-456',
            displayName: 'Alice',
          ),
        ],
      );

      expect(conversation.displayName, 'Alice');
    });

    test('displayName returns "Chat" as fallback', () {
      const conversation = Conversation(
        id: 'room-123',
        type: ConversationType.direct,
        mode: ConversationMode.standard,
        myUserId: userId,
      );

      expect(conversation.displayName, 'Chat');
    });

    test('displayAvatar returns avatarUrl when set', () {
      const avatarUrl = 'https://example.com/avatar.png';
      const conversation = Conversation(
        id: 'room-123',
        type: ConversationType.group,
        mode: ConversationMode.standard,
        avatarUrl: avatarUrl,
        myUserId: userId,
      );

      expect(conversation.displayAvatar, avatarUrl);
    });

    test('otherParticipant returns other user in direct chat', () {
      const conversation = Conversation(
        id: 'room-123',
        type: ConversationType.direct,
        mode: ConversationMode.standard,
        myUserId: userId,
        participants: [
          Participant(
            id: 'part-1',
            userId: 'user-123',
            displayName: 'Me',
          ),
          Participant(
            id: 'part-2',
            userId: 'user-456',
            displayName: 'Alice',
          ),
        ],
      );

      expect(conversation.otherParticipant?.userId, 'user-456');
    });

    test('otherParticipant returns null for group chats', () {
      const conversation = Conversation(
        id: 'room-123',
        type: ConversationType.group,
        mode: ConversationMode.standard,
        myUserId: userId,
      );

      expect(conversation.otherParticipant, isNull);
    });

    test('approvedParticipantsCount counts approved participants', () {
      const conversation = Conversation(
        id: 'room-123',
        type: ConversationType.group,
        mode: ConversationMode.standard,
        myUserId: userId,
        myRole: ParticipantRole.admin,
        participants: [
          Participant(
            id: 'part-1',
            userId: 'user-1',
            displayName: 'User 1',
          ),
          Participant(
            id: 'part-2',
            userId: 'user-2',
            displayName: 'User 2',
          ),
          Participant(
            id: 'part-3',
            userId: 'user-3',
            displayName: 'User 3',
            status: ParticipantStatus.pending,
          ),
        ],
      );

      expect(conversation.approvedParticipantsCount, 2);
    });

    test('onlineParticipantsCount counts online participants', () {
      const conversation = Conversation(
        id: 'room-123',
        type: ConversationType.group,
        mode: ConversationMode.standard,
        myUserId: userId,
        myRole: ParticipantRole.admin,
        participants: [
          Participant(
            id: 'part-1',
            userId: 'user-1',
            displayName: 'User 1',
            isOnline: true,
          ),
          Participant(
            id: 'part-2',
            userId: 'user-2',
            displayName: 'User 2',
            isOnline: true,
          ),
          Participant(
            id: 'part-3',
            userId: 'user-3',
            displayName: 'User 3',
          ),
        ],
      );

      expect(conversation.onlineParticipantsCount, 2);
    });

    test('copyWith creates a new conversation with updated fields', () {
      const original = Conversation(
        id: 'room-123',
        type: ConversationType.group,
        mode: ConversationMode.standard,
        name: 'Old Name',
        myUserId: userId,
      );

      final updated = original.copyWith(
        name: 'New Name',
        unreadCount: 5,
      );

      expect(original.name, 'Old Name');
      expect(original.unreadCount, 0);
      expect(updated.name, 'New Name');
      expect(updated.unreadCount, 5);
      expect(updated.id, original.id);
    });

    test('props includes all fields for equality', () {
      const conversation1 = Conversation(
        id: 'room-123',
        type: ConversationType.group,
        mode: ConversationMode.standard,
        name: 'Test Room',
        myUserId: userId,
      );

      const conversation2 = Conversation(
        id: 'room-123',
        type: ConversationType.group,
        mode: ConversationMode.standard,
        name: 'Test Room',
        myUserId: userId,
      );

      expect(conversation1, equals(conversation2));
    });

    group('hasDeletedParticipant', () {
      test('returns true for direct conversation with only self as participant',
          () {
        const conversation = Conversation(
          id: 'room-123',
          type: ConversationType.direct,
          mode: ConversationMode.standard,
          myUserId: userId,
          participants: [
            Participant(
              id: 'part-1',
              userId: 'user-123',
              displayName: 'Me',
            ),
          ],
        );

        expect(conversation.hasDeletedParticipant, isTrue);
      });

      test(
          'returns false for direct conversation with self '
          'and another participant', () {
        const conversation = Conversation(
          id: 'room-123',
          type: ConversationType.direct,
          mode: ConversationMode.standard,
          myUserId: userId,
          participants: [
            Participant(
              id: 'part-1',
              userId: 'user-123',
              displayName: 'Me',
            ),
            Participant(
              id: 'part-2',
              userId: 'user-456',
              displayName: 'Alice',
            ),
          ],
        );

        expect(conversation.hasDeletedParticipant, isFalse);
      });

      test(
          'returns false for group conversation even with only self '
          'as participant', () {
        const conversation = Conversation(
          id: 'room-123',
          type: ConversationType.group,
          mode: ConversationMode.standard,
          myUserId: userId,
          participants: [
            Participant(
              id: 'part-1',
              userId: 'user-123',
              displayName: 'Me',
            ),
          ],
        );

        expect(conversation.hasDeletedParticipant, isFalse);
      });

      test('returns false when myUserId is null', () {
        const conversation = Conversation(
          id: 'room-123',
          type: ConversationType.direct,
          mode: ConversationMode.standard,
          participants: [
            Participant(
              id: 'part-1',
              userId: 'user-123',
              displayName: 'Me',
            ),
          ],
        );

        expect(conversation.hasDeletedParticipant, isFalse);
      });
    });
  });

  group('ConversationFilter', () {
    test('creates filter with all fields null by default', () {
      const filter = ConversationFilter();
      expect(filter.mode, isNull);
      expect(filter.status, isNull);
      expect(filter.type, isNull);
      expect(filter.searchQuery, isNull);
    });

    test('creates filter with specified values', () {
      const filter = ConversationFilter(
        mode: ConversationMode.ephemeral,
        status: ConversationStatus.active,
        type: ConversationType.group,
        searchQuery: 'test',
      );

      expect(filter.mode, ConversationMode.ephemeral);
      expect(filter.status, ConversationStatus.active);
      expect(filter.type, ConversationType.group);
      expect(filter.searchQuery, 'test');
    });

    test('props includes all fields for equality', () {
      const filter1 = ConversationFilter(
        mode: ConversationMode.ephemeral,
        searchQuery: 'test',
      );

      const filter2 = ConversationFilter(
        mode: ConversationMode.ephemeral,
        searchQuery: 'test',
      );

      expect(filter1, equals(filter2));
    });
  });
}
