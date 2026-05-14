import 'dart:convert';

/// Encryption service for chat messages.
///
/// Provides encryption and decryption capabilities for message content.
/// Implementations can use no-op encryption, AES, Sodium, or custom algorithms.
abstract class EncryptionService {
  /// Encrypts the given [data].
  ///
  /// Returns encrypted bytes.
  Future<List<int>> encrypt(List<int> data);

  /// Decrypts the given [encryptedData].
  ///
  /// Returns original data.
  Future<List<int>> decrypt(List<int> encryptedData);

  /// Encrypts a string.
  ///
  /// Convenience method for string encryption.
  /// Uses UTF-8 encoding for the input text and Base64 for the output.
  Future<String> encryptString(String text) async {
    // Use UTF-8 encoding (not codeUnits which uses UTF-16)
    final bytes = utf8.encode(text);
    final encrypted = await encrypt(bytes);
    // Return as Base64 for safe storage/transmission of binary data
    return base64Encode(encrypted);
  }

  /// Decrypts a string.
  ///
  /// Convenience method for string decryption.
  /// Expects Base64-encoded input and returns UTF-8 decoded text.
  Future<String> decryptString(String encryptedText) async {
    // Decode from Base64 to get the encrypted bytes
    final encryptedBytes = base64Decode(encryptedText);
    final decrypted = await decrypt(encryptedBytes);
    // Decode UTF-8 to get original text
    return utf8.decode(decrypted);
  }

  /// Disposes the encryption service.
  ///
  /// Called when the service is no longer needed.
  Future<void> dispose();
}
