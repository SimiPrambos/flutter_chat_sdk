/// Provides the current chat identity to the Chat SDK.
abstract class ChatIdentityProvider {
  /// Returns the current user id, or null when the app is unauthenticated.
  Future<String?> getCurrentUserId();

  /// Emits whenever the current user id changes.
  Stream<String?> get userIdChanges;
}
