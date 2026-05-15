import 'package:flutter_chat_sdk/src/core/security/database_key_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DatabaseEncryptionConfig.isValid()', () {
    test('returns true for valid 256-bit hex key', () {
      final config = DatabaseEncryptionConfig(
        encryptionKey:
            '627ac90f35ac1a785afa41c586ea84e7e1c9205ec17264d2e2f77c00308a9318',
      );
      expect(config.isValid(), isTrue);
    });

    test('returns false for key with invalid characters', () {
      final config = DatabaseEncryptionConfig(
        encryptionKey:
            '627ac90f35ac1a785afa41c586ea84e7e1c9205ec17264d2e2f77c00308a931g', // 'g' is not valid hex
      );
      expect(config.isValid(), isFalse);
    });

    test('returns false for key that is too short', () {
      final config = DatabaseEncryptionConfig(
        encryptionKey:
            '627ac90f35ac1a785afa41c586ea84e7e1c9205ec17264d2e2f77c00308a931', // 63 characters
      );
      expect(config.isValid(), isFalse);
    });

    test('returns false for key that is too long', () {
      final config = DatabaseEncryptionConfig(
        encryptionKey:
            '627ac90f35ac1a785afa41c586ea84e7e1c9205ec17264d2e2f77c00308a9318a', // 65 characters
      );
      expect(config.isValid(), isFalse);
    });

    test('returns true for valid key with uppercase hex', () {
      final config = DatabaseEncryptionConfig(
        encryptionKey:
            '627AC90F35AC1A785AFA41C586EA84E7E1C9205EC17264D2E2F77C00308A9318',
      );
      expect(config.isValid(), isTrue);
    });

    test('returns true for valid key with mixed case hex', () {
      final config = DatabaseEncryptionConfig(
        encryptionKey:
            '627ac90F35ac1a785AFA41C586ea84e7e1c9205Ec17264d2e2f77c00308a9318',
      );
      expect(config.isValid(), isTrue);
    });

    test('returns false for key with special characters', () {
      final config = DatabaseEncryptionConfig(
        encryptionKey:
            '627ac90f35ac1a785afa41c586ea84e7e1c9205ec17264d2e2f77c00308a931@',
      );
      expect(config.isValid(), isFalse);
    });
  });
}
