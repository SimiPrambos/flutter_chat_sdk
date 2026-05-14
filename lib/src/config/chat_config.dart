import 'package:meta/meta.dart';

/// Configuration for Chat SDK.
///
/// ## Example
/// ```dart
/// // At app startup
/// final config = ChatConfig(
///   databasePath: 'chat.db',
/// );
/// ```
@immutable
class ChatConfig {
  /// Create basic configuration.
  ///
  const ChatConfig({
    required this.databasePath,
    this.encryptionKey,
    this.enableLogging = false,
    this.maxRetryAttempts = 10,
    this.heartbeatInterval = const Duration(seconds: 30),
    this.syncInterval = const Duration(minutes: 5),
  });

  /// Create configuration with encryption enabled.
  factory ChatConfig.withEncryption({
    required String databasePath,
    required String encryptionKey,
    bool enableLogging = false,
    int maxRetryAttempts = 10,
    Duration heartbeatInterval = const Duration(seconds: 30),
    Duration syncInterval = const Duration(minutes: 5),
  }) {
    return ChatConfig(
      databasePath: databasePath,
      encryptionKey: encryptionKey,
      enableLogging: enableLogging,
      maxRetryAttempts: maxRetryAttempts,
      heartbeatInterval: heartbeatInterval,
      syncInterval: syncInterval,
    );
  }

  /// Path to database file.
  final String databasePath;

  /// Encryption key for messages (optional).
  final String? encryptionKey;

  /// Enable debug logging.
  final bool enableLogging;

  /// Maximum retry attempts for failed operations.
  final int maxRetryAttempts;

  /// Presence heartbeat interval.
  final Duration heartbeatInterval;

  /// Background sync interval.
  final Duration syncInterval;

  /// Creates a copy with updated fields.
  ChatConfig copyWith({
    String? databasePath,
    String? encryptionKey,
    bool? enableLogging,
    int? maxRetryAttempts,
    Duration? heartbeatInterval,
    Duration? syncInterval,
  }) {
    return ChatConfig(
      databasePath: databasePath ?? this.databasePath,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      enableLogging: enableLogging ?? this.enableLogging,
      maxRetryAttempts: maxRetryAttempts ?? this.maxRetryAttempts,
      heartbeatInterval: heartbeatInterval ?? this.heartbeatInterval,
      syncInterval: syncInterval ?? this.syncInterval,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatConfig &&
          runtimeType == other.runtimeType &&
          databasePath == other.databasePath &&
          encryptionKey == other.encryptionKey &&
          enableLogging == other.enableLogging &&
          maxRetryAttempts == other.maxRetryAttempts &&
          heartbeatInterval == other.heartbeatInterval &&
          syncInterval == other.syncInterval;

  @override
  int get hashCode => Object.hash(databasePath, encryptionKey, enableLogging,
      maxRetryAttempts, heartbeatInterval, syncInterval);
}
