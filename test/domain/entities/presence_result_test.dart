import 'package:flutter_chat_sdk/src/domain/entities/presence_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PresenceResult', () {
    test('stores userId, active, and lastSeen', () {
      final now = DateTime(2026, 4, 8, 12);
      final result = PresenceResult(
        userId: 'user-1',
        active: true,
        lastSeen: now,
      );

      expect(result.userId, 'user-1');
      expect(result.active, true);
      expect(result.lastSeen, now);
    });

    test('supports equality', () {
      final now = DateTime(2026, 4, 8, 12);
      final a = PresenceResult(userId: 'user-1', active: true, lastSeen: now);
      final b = PresenceResult(userId: 'user-1', active: true, lastSeen: now);

      expect(a, equals(b));
    });

    test('lastSeen can be null', () {
      const result =
          PresenceResult(userId: 'user-1', active: false);

      expect(result.lastSeen, isNull);
    });
  });
}
