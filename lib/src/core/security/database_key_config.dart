/// Configuration for database encryption.
///
/// The chat package accepts an encryption key but does NOT manage it.
/// Key generation, storage, and lifecycle management should be handled
/// at the app level.
class DatabaseEncryptionConfig {
  /// Creates database encryption configuration.
  const DatabaseEncryptionConfig({
    required this.encryptionKey,
    this.cipherPageSize = 4096,
    this.kdfIterations = 64000,
  });

  /// The encryption key (hex-encoded, 64 characters for 256-bit key).
  ///
  /// **IMPORTANT**: This key should be:
  /// 1. Derived from user password using PBKDF2/Argon2
  /// 2. Stored securely using flutter_secure_storage
  /// 3. Never hardcoded or stored in plaintext
  ///
  /// Example key generation at app level:
  /// ```dart
  /// // Generate random 256-bit key
  /// final random = Random.secure();
  /// final keyBytes = List<int>.generate(32, (_) => random.nextInt(256));
  /// final keyHex = hex.encode(keyBytes);
  /// ```
  final String encryptionKey;

  /// SQLCipher page size (default: 4096).
  final int cipherPageSize;

  /// KDF iterations (default: 64000).
  ///
  /// Higher = more secure but slower.
  /// OWASP recommends minimum 100,000 for PBKDF2.
  final int kdfIterations;

  /// Validates the encryption key format.
  bool isValid() {
    // Must be 64 hex characters (256 bits)
    if (encryptionKey.length != 64) return false;

    // Must be valid hex (characters 0-9, a-f, A-F)
    // Using regex to avoid integer parsing limitations for 256-bit numbers
    final hexRegex = RegExp(r'^[0-9a-fA-F]{64}$');
    return hexRegex.hasMatch(encryptionKey);
  }
}
