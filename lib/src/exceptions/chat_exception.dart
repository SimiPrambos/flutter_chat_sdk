/// Base exception for all chat-related errors.
class ChatException implements Exception {
  /// Creates a chat exception.
  const ChatException(this.message, [this.cause]);

  /// Error message.
  final String message;

  /// Underlying cause.
  final Object? cause;

  @override
  String toString() => 'ChatException: $message';
}

/// Exception thrown when chat is not initialized.
class ChatNotInitializedException extends ChatException {
  /// Creates a not initialized exception.
  const ChatNotInitializedException()
      : super('Chat must be initialized before use. Call initialize() first.');
}

/// Exception thrown when a required operation fails.
class ChatOperationException extends ChatException {
  /// Creates an operation exception.
  const ChatOperationException(super.message, [super.cause]);
}

/// Exception thrown when sync fails.
class ChatSyncException extends ChatException {
  /// Creates a sync exception.
  const ChatSyncException(super.message, [super.cause]);
}

/// Exception thrown when database operations fail.
class ChatDatabaseException extends ChatException {
  /// Creates a database exception.
  const ChatDatabaseException(super.message, [super.cause]);
}

/// Exception thrown when encryption/decryption fails.
class ChatEncryptionException extends ChatException {
  /// Creates an encryption exception.
  const ChatEncryptionException(super.message, [super.cause]);
}

/// Exception thrown when adapter operations fail.
class ChatAdapterException extends ChatException {
  /// Creates an adapter exception.
  const ChatAdapterException(super.message, [super.cause]);
}

/// Exception thrown when validation fails.
class ChatValidationException extends ChatException {
  /// Creates a validation exception.
  const ChatValidationException(super.message);
}

/// Exception thrown when userId is required but not set.
class UserIdNotSetException extends ChatException {
  /// Creates a userId not set exception.
  const UserIdNotSetException()
      : super('userId must be available before this operation.');
}
