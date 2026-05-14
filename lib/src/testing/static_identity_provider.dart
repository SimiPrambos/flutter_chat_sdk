// lib/src/testing/static_identity_provider.dart

import 'package:flutter_chat_sdk/src/config/chat_identity_provider.dart';

/// A [ChatIdentityProvider] that always returns the same user ID.
///
/// Useful for tests and example apps where a fixed identity is sufficient.
///
/// ```dart
/// final chat = await Chat.create(
///   databasePath: ':memory:',
///   adapter: MockChatAdapter(),
///   identityProvider: StaticIdentityProvider('user-1'),
/// );
/// ```
class StaticIdentityProvider implements ChatIdentityProvider {
  const StaticIdentityProvider(this._userId);
  final String _userId;

  @override
  Future<String?> getCurrentUserId() async => _userId;

  @override
  Stream<String?> get userIdChanges => Stream.value(_userId);
}
