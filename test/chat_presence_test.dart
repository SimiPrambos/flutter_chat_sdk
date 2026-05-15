import 'package:flutter_chat_sdk/flutter_chat_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_helpers.dart';

void main() {
  late Chat chat;

  setUp(() async {
    final registry = createTestRegistry();
    chat = Chat(registry);
    await chat.initialize();
  });

  tearDown(() async {
    await chat.dispose();
  });

  group('presence', () {
    test('subscribePresence completes without error', () async {
      await chat.subscribePresence('user-other');
    });

    test('unsubscribePresence completes without error', () async {
      await chat.unsubscribePresence('user-other');
    });

    test('getPresence returns a PresenceResult', () async {
      final result = await chat.getPresence('user-other');

      expect(result, isA<PresenceResult>());
      expect(result.userId, 'user-other');
      expect(result.active, isFalse);
      expect(result.lastSeen, isNull);
    });

    test('startHeartbeat does not throw', () {
      // FakeChatAdapter is not CompositeAdapter, so heartbeat is a no-op.
      // This test verifies no exception is thrown.
      chat.startHeartbeat();
    });

    test('stopHeartbeat does not throw after start', () {
      chat.startHeartbeat();
      chat.stopHeartbeat();
    });

    test('stopHeartbeat is safe without start', () {
      chat.stopHeartbeat();
    });
  });
}
