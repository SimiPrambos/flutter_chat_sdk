import 'package:flutter_chat_sdk/src/adapters/chat_adapter.dart';
import 'package:flutter_chat_sdk/src/config/chat_config.dart';
import 'package:flutter_chat_sdk/src/config/chat_identity_provider.dart';
import 'package:flutter_chat_sdk/src/core/database/chat_database.dart';
import 'package:flutter_chat_sdk/src/core/database/chat_database_impl.dart';
import 'package:flutter_chat_sdk/src/core/encryption/encryption_service.dart';
import 'package:flutter_chat_sdk/src/core/encryption/no_op_encryption_impl.dart';
import 'package:flutter_chat_sdk/src/core/security/database_key_config.dart';

/// Registry for Chat dependencies.
///
/// Follows the same pattern as dependency injection in other packages.
///
/// ## Example
/// ```dart
/// // With custom adapter
/// final registry = ChatRegistry.withAdapter(
///   config: config,
///   adapter: MyBackendAdapter(),
/// );
/// ```
class ChatRegistry {
  ChatRegistry._({
    required this.config,
    required this.adapter,
    required this.identityProvider,
    this.databaseEncryptionConfig,
    EncryptionService? encryption,
    ChatDatabase? database,
  })  : _customEncryption = encryption,
        _customDatabase = database;

  /// Creates a registry with a single adapter.
  ///
  /// [databaseEncryptionConfig] - Optional database encryption.
  /// If provided, requires SQLite3MultipleCiphers (set
  /// `hooks.user_defines.sqlite3.source: sqlite3mc` in pubspec.yaml).
  factory ChatRegistry.withAdapter({
    required ChatConfig config,
    required ChatAdapter adapter,
    required ChatIdentityProvider identityProvider,
    DatabaseEncryptionConfig? databaseEncryptionConfig,
  }) {
    return ChatRegistry._(
      config: config,
      adapter: adapter,
      identityProvider: identityProvider,
      databaseEncryptionConfig: databaseEncryptionConfig,
    );
  }

  /// Creates a registry with custom services.
  ///
  /// [databaseEncryptionConfig] - Optional database encryption.
  /// Ignored if custom [database] is provided.
  factory ChatRegistry.custom({
    required ChatConfig config,
    required ChatAdapter adapter,
    required ChatIdentityProvider identityProvider,
    DatabaseEncryptionConfig? databaseEncryptionConfig,
    EncryptionService? encryption,
    ChatDatabase? database,
  }) {
    return ChatRegistry._(
      config: config,
      adapter: adapter,
      identityProvider: identityProvider,
      databaseEncryptionConfig: databaseEncryptionConfig,
      encryption: encryption,
      database: database,
    );
  }

  final ChatConfig config;
  final ChatAdapter adapter;
  final ChatIdentityProvider identityProvider;

  /// Optional database encryption configuration.
  ///
  /// When provided, the database will be encrypted using SQLCipher.
  /// The encryption key must be generated and managed at the app level.
  ///
  /// See `docs/chat-database-encryption.md` for implementation guide.
  final DatabaseEncryptionConfig? databaseEncryptionConfig;

  final EncryptionService? _customEncryption;
  final ChatDatabase? _customDatabase;

  /// Creates a database instance.
  ///
  /// If [databaseEncryptionConfig] is provided, creates an encrypted database.
  Future<ChatDatabase> createDatabase() async {
    if (_customDatabase != null) return _customDatabase;

    final database = ChatDatabaseImpl(
      databasePath: config.databasePath,
      encryptionConfig: databaseEncryptionConfig,
    );
    await database.initialize();
    return database;
  }

  /// Creates an encryption service.
  ///
  /// Returns [NoOpEncryptionService] by default.
  /// For encryption at app level, pass a custom [EncryptionService] to
  /// [ChatRegistry.custom].
  EncryptionService createEncryption() {
    if (_customEncryption != null) return _customEncryption;

    // Always use NoOpEncryptionService at package level
    // Encryption should be implemented at app level if needed
    return NoOpEncryptionService();
  }
}
