import 'package:flutter_chat_sdk/chat.dart' show ChatRegistry;
import 'package:flutter_chat_sdk/src/config/chat_registry.dart' show ChatRegistry;
import 'package:flutter_chat_sdk/src/core/encryption/encryption_service.dart';

/// No-op encryption service.
///
/// Returns data as-is without encryption.
/// This is the default implementation for the chat package.
///
/// For production use with encryption, implement a custom [EncryptionService]
/// at the app level using your preferred encryption library (e.g., sodium_libs,
/// encrypt package, etc.) and pass it to [ChatRegistry.custom].
class NoOpEncryptionService extends EncryptionService {
  @override
  Future<List<int>> encrypt(List<int> data) async {
    return data;
  }

  @override
  Future<List<int>> decrypt(List<int> encryptedData) async {
    return encryptedData;
  }

  @override
  Future<void> dispose() async {}
}
