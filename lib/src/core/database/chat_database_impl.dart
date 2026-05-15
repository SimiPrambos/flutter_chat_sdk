// ignore_for_file: public_member_api_docs, document_ignores
// Database implementation with table definitions.

import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_sdk/src/core/database/chat_database.dart';
import 'package:flutter_chat_sdk/src/core/queue/outbound_queue.dart';
import 'package:flutter_chat_sdk/src/core/security/database_key_config.dart';
import 'package:flutter_chat_sdk/src/domain/domain.dart';
import 'package:flutter_chat_sdk/src/domain/entities/file_attachment.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'chat_database_impl.g.dart';

/// Messages table.
@DataClassName('MessageData')
class Messages extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text()();
  TextColumn get serverId => text().nullable()();
  TextColumn get conversationId => text()();
  TextColumn get senderId => text()();
  TextColumn get senderName => text().nullable()();
  TextColumn get senderAvatar => text().nullable()();
  TextColumn get content => text()();
  TextColumn get contentNonce => text().nullable()();
  BoolColumn get isEncrypted => boolean().withDefault(const Constant(false))();
  TextColumn get type => text()();
  TextColumn get status => text()();
  DateTimeColumn get clientTimestamp => dateTime()();
  DateTimeColumn get serverTimestamp => dateTime().nullable()();
  TextColumn get replyToId => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isEdited => boolean().withDefault(const Constant(false))();
  BoolColumn get isStarred => boolean().withDefault(const Constant(false))();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  DateTimeColumn get pinnedUntil => dateTime().nullable()();
  IntColumn get localSequence => integer().withDefault(const Constant(0))();
  TextColumn get attachmentsJson => text().nullable()();
}

/// Conversations table.
@DataClassName('ConversationData')
class Conversations extends Table {
  @override
  String get tableName => 'conversations';

  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get type => text()();
  TextColumn get mode => text()();
  TextColumn get status => text()();
  IntColumn get unreadCount => integer().withDefault(const Constant(0))();
  TextColumn get myRole => text()();
  TextColumn get lastMessageId => text().nullable()();
  DateTimeColumn get lastMessageAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

/// Sync state table.
@DataClassName('SyncStateData')
class SyncStates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get lastSyncToken => text().nullable()();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  BoolColumn get isInitialSyncComplete =>
      boolean().withDefault(const Constant(false))();
}

/// Outbound operations table for queue persistence.
@DataClassName('OutboundOperationData')
class OutboundOperations extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get data => text()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get status => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get processedAt => dateTime().nullable()();
  TextColumn get errorMessage => text().nullable()();
}

/// Reactions table for message reactions.
@DataClassName('ReactionData')
class Reactions extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text()();
  TextColumn get messageId => text()();
  TextColumn get emoji => text()();
  TextColumn get userId => text()();
  TextColumn get userName => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

/// Participants table for room members.
@DataClassName('ParticipantData')
class Participants extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text()();
  TextColumn get conversationId => text().references(Conversations, #id)();
  TextColumn get userId => text()();
  TextColumn get displayName => text()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get role => text()();
  TextColumn get status => text()();
  BoolColumn get isOnline => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSeenAt => dateTime().nullable()();
  DateTimeColumn get joinedAt => dateTime().nullable()();
}

/// Pinned events table for tracking message pin/unpin history.
@DataClassName('PinnedEventData')
class PinnedEvents extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text()();
  TextColumn get messageId => text()();
  TextColumn get roomId => text()();
  TextColumn get pinnedBy => text()();
  DateTimeColumn get pinnedAt => dateTime()();
  DateTimeColumn get unpinnedAt => dateTime().nullable()();
}

/// Drift database implementation.
@DriftDatabase(
  tables: [
    Messages,
    Conversations,
    SyncStates,
    OutboundOperations,
    Reactions,
    Participants,
    PinnedEvents,
  ],
)
class ChatDatabaseImpl extends _$ChatDatabaseImpl implements ChatDatabase {
  /// Creates a new database instance.
  ///
  /// [databasePath] - Path to the database file (relative to app documents).
  /// [encryptionConfig] - Optional encryption configuration for SQLCipher.
  ///
  /// **Database Encryption:**
  /// When [encryptionConfig] is provided, the database will be encrypted
  /// using SQLCipher. The encryption key must be managed at the app level.
  ///
  /// See `docs/chat-database-encryption.md` for implementation guide.
  ChatDatabaseImpl({
    required String databasePath,
    DatabaseEncryptionConfig? encryptionConfig,
  }) : super(_openConnection(databasePath, encryptionConfig));

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _createIndexes();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Migration from v1 to v2: add encryption columns to messages
          if (from < 2) {
            await customStatement(
              'ALTER TABLE messages ADD COLUMN content_nonce TEXT',
            );
            await customStatement(
              'ALTER TABLE messages ADD COLUMN is_encrypted INTEGER '
              'NOT NULL DEFAULT 0',
            );
          }
          // Migration from v2 to v3: add performance indexes
          if (from < 3) {
            await _createIndexes();
          }
          // Migration from v3 to v4: add participants table + remove
          // my_user_id from rooms
          if (from < 4) {
            // Add participants table (using old room_id column name)
            await customStatement('''
              CREATE TABLE IF NOT EXISTS participants (
                id TEXT NOT NULL PRIMARY KEY,
                room_id TEXT NOT NULL REFERENCES rooms(id),
                user_id TEXT NOT NULL,
                display_name TEXT NOT NULL,
                avatar_url TEXT,
                role TEXT NOT NULL,
                status TEXT NOT NULL,
                is_online INTEGER NOT NULL DEFAULT 0,
                last_seen_at INTEGER,
                joined_at INTEGER
              )
            ''');
            await customStatement('''
              CREATE INDEX IF NOT EXISTS idx_participants_room_id
              ON participants(room_id)
            ''');
            await customStatement('''
              CREATE UNIQUE INDEX IF NOT EXISTS idx_participants_room_user
              ON participants(room_id, user_id)
            ''');

            // Rebuild rooms table to drop my_user_id column
            // (myUserId is now stamped by Chat layer, not stored in DB)
            await customStatement('''
              CREATE TABLE rooms_new (
                id TEXT NOT NULL PRIMARY KEY,
                name TEXT,
                avatar_url TEXT,
                type TEXT NOT NULL,
                mode TEXT NOT NULL,
                status TEXT NOT NULL,
                unread_count INTEGER NOT NULL DEFAULT 0,
                share_code TEXT,
                expires_at INTEGER,
                my_role TEXT NOT NULL,
                last_message_id TEXT,
                last_message_at INTEGER,
                created_at INTEGER NOT NULL,
                updated_at INTEGER NOT NULL
              )
            ''');
            await customStatement('''
              INSERT INTO rooms_new
                (id, name, avatar_url, type, mode, status, unread_count,
                 share_code, expires_at, my_role, last_message_id,
                 last_message_at, created_at, updated_at)
              SELECT id, name, avatar_url, type, mode, status, unread_count,
                     share_code, expires_at, my_role, last_message_id,
                     last_message_at, created_at, updated_at
              FROM rooms
            ''');
            await customStatement('DROP TABLE rooms');
            await customStatement('ALTER TABLE rooms_new RENAME TO rooms');
          }
          // Migration from v4 to v5: add attachments_json column to messages
          if (from < 5) {
            await customStatement(
              'ALTER TABLE messages ADD COLUMN attachments_json TEXT',
            );
          }
          // Migration from v5 to v6: add expires_at column to rooms
          if (from < 6) {
            await customStatement(
              'ALTER TABLE rooms ADD COLUMN expires_at INTEGER',
            );
          }
          // Migration from v6 to v7: rename rooms→conversations,
          // room_id→conversation_id
          // v0.1 — no existing users; clear and recreate for clean schema.
          if (from < 7) {
            // Drop old tables (cascade-safe order)
            await customStatement('DROP TABLE IF EXISTS participants');
            await customStatement('DROP TABLE IF EXISTS messages');
            await customStatement('DROP TABLE IF EXISTS rooms');
            // Recreate with the new schema via Drift's createAll
            await m.createAll();
            await _createIndexes();
          }
          // Migration from v7 to v8: drop share_code and expires_at columns
          // from conversations — these were backend-specific fields.
          if (from < 8) {
            await customStatement(
              'ALTER TABLE conversations DROP COLUMN share_code',
            );
            await customStatement(
              'ALTER TABLE conversations DROP COLUMN expires_at',
            );
          }
        },
      );

  /// Creates database indexes for performance optimization.
  Future<void> _createIndexes() async {
    // Messages indexes
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_messages_conversation_id
      ON messages(conversation_id)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_messages_conversation_timestamp
      ON messages(conversation_id, client_timestamp)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_messages_starred
      ON messages(is_starred) WHERE is_starred = 1
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_messages_pinned_conversation
      ON messages(conversation_id, is_pinned) WHERE is_pinned = 1
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_messages_server_id
      ON messages(server_id) WHERE server_id IS NOT NULL
    ''');

    // Conversations indexes
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_conversations_last_message_at
      ON conversations(last_message_at DESC)
    ''');

    // Reactions indexes
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_reactions_message_id
      ON reactions(message_id)
    ''');

    // Outbound operations indexes
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_outbound_operations_status
      ON outbound_operations(status, created_at)
    ''');

    // Message dedup: insertMessage() scans pending messages by conversation
    // + sender + status
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_messages_conversation_sender_status
      ON messages(conversation_id, sender_id, status)
    ''');

    // Reactions ordering: getReactionsForMessage() filters by message_id,
    // orders by created_at
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_reactions_message_created
      ON reactions(message_id, created_at)
    ''');

    // Pinned events indexes
    await _createPinnedEventIndexes();

    // Conversation filtering: watchConversations()/getAllConversations()
    // filter by status
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_conversations_status
      ON conversations(status)
    ''');

    // Conversation filtering: watchConversations()/getAllConversations()
    // filter by mode
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_conversations_mode
      ON conversations(mode)
    ''');

    // Participants indexes
    await _createParticipantIndexes();
  }

  /// Creates indexes for the participants table.
  Future<void> _createParticipantIndexes() async {
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_participants_conversation_id
      ON participants(conversation_id)
    ''');
    await customStatement('''
      CREATE UNIQUE INDEX IF NOT EXISTS idx_participants_conversation_user
      ON participants(conversation_id, user_id)
    ''');
  }

  /// Creates indexes for the pinned_events table.
  Future<void> _createPinnedEventIndexes() async {
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_pinned_events_room_id
      ON pinned_events(room_id)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_pinned_events_message_id
      ON pinned_events(message_id)
    ''');
    await customStatement('''
      CREATE INDEX IF NOT EXISTS idx_pinned_events_active
      ON pinned_events(room_id, pinned_at) WHERE unpinned_at IS NULL
    ''');
    // Note: pinned_events.room_id retained as-is (PinnedEvent entity still
    // uses roomId)
  }

  // ==========================================================================
  // Lifecycle
  // ==========================================================================

  @override
  Future<void> initialize() async {
    await customSelect('SELECT 1').get();
  }

  // ==========================================================================
  // Conversations
  // ==========================================================================

  @override
  Stream<List<Conversation>> watchConversations({ConversationFilter? filter,}) {
    final query = select(conversations).join([
      leftOuterJoin(
          messages, messages.id.equalsExp(conversations.lastMessageId),),
    ]);

    if (filter != null) {
      final conditions = <Expression<bool>>[];

      if (filter.type != null) {
        conditions.add(conversations.type.equals(filter.type!.name));
      }
      if (filter.mode != null) {
        conditions.add(conversations.mode.equals(filter.mode!.name));
      }
      if (filter.status != null) {
        conditions.add(conversations.status.equals(filter.status!.name));
      }
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        conditions.add(conversations.name.contains(filter.searchQuery!));
      }

      if (conditions.isNotEmpty) {
        query.where(conditions.reduce((a, b) => a & b));
      }
    }

    query.orderBy([OrderingTerm.desc(conversations.lastMessageAt)]);

    return query.watch().asyncMap((rows) async {
      final conversationIds =
          rows.map((r) => r.readTable(conversations).id).toList();
      final participantMap =
          await _getParticipantsByConversationIds(conversationIds);

      return rows.map((row) {
        final conversationData = row.readTable(conversations);
        final messageData = row.readTableOrNull(messages);
        final lastMessage =
            messageData != null ? _messageFromData(messageData) : null;
        return _conversationFromData(
          conversationData,
          lastMessage: lastMessage,
          participants: participantMap[conversationData.id] ?? const [],
        );
      }).toList();
    });
  }

  @override
  Future<List<Conversation>> getAllConversations(
      {ConversationFilter? filter,}) async {
    final query = select(conversations).join([
      leftOuterJoin(
          messages, messages.id.equalsExp(conversations.lastMessageId),),
    ]);

    if (filter != null) {
      final conditions = <Expression<bool>>[];

      if (filter.type != null) {
        conditions.add(conversations.type.equals(filter.type!.name));
      }
      if (filter.mode != null) {
        conditions.add(conversations.mode.equals(filter.mode!.name));
      }
      if (filter.status != null) {
        conditions.add(conversations.status.equals(filter.status!.name));
      }
      if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
        conditions.add(conversations.name.contains(filter.searchQuery!));
      }

      if (conditions.isNotEmpty) {
        query.where(conditions.reduce((a, b) => a & b));
      }
    }

    query.orderBy([OrderingTerm.desc(conversations.lastMessageAt)]);

    final results = await query.get();
    final conversationIds =
        results.map((r) => r.readTable(conversations).id).toList();
    final participantMap =
        await _getParticipantsByConversationIds(conversationIds);

    return results.map((row) {
      final conversationData = row.readTable(conversations);
      final messageData = row.readTableOrNull(messages);
      final lastMessage =
          messageData != null ? _messageFromData(messageData) : null;
      return _conversationFromData(
        conversationData,
        lastMessage: lastMessage,
        participants: participantMap[conversationData.id] ?? const [],
      );
    }).toList();
  }

  @override
  Future<Conversation?> getConversation(String conversationId) async {
    final query = select(conversations).join([
      leftOuterJoin(
          messages, messages.id.equalsExp(conversations.lastMessageId),),
    ])
      ..where(conversations.id.equals(conversationId));
    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final conversationData = row.readTable(conversations);
    final messageData = row.readTableOrNull(messages);
    final lastMessage =
        messageData != null ? _messageFromData(messageData) : null;
    final participantMap =
        await _getParticipantsByConversationIds([conversationId]);
    return _conversationFromData(
      conversationData,
      lastMessage: lastMessage,
      participants: participantMap[conversationId] ?? const [],
    );
  }

  @override
  Future<void> insertConversation(Conversation conversation) async {
    await transaction(() async {
      // Check if conversation already exists with a newer lastMessageAt.
      // During initialSync the API often returns stale timestamps, so we
      // preserve the local value when it is more recent.
      final existing = await (select(conversations)
            ..where((r) => r.id.equals(conversation.id)))
          .getSingleOrNull();

      var data = _conversationToData(conversation);

      if (existing != null) {
        // Keep the newer-or-equal local lastMessageAt/lastMessageId/unreadCount.
        // Use !isBefore (≥) instead of isAfter (>) so that when a join event
        // arrives after the message event already stamped lastMessageAt (equal
        // timestamps), the existing lastMessageId is NOT overwritten with null.
        if (existing.lastMessageAt != null &&
            (conversation.lastMessageAt == null ||
                !existing.lastMessageAt!
                    .isBefore(conversation.lastMessageAt!))) {
          data = data.copyWith(
            lastMessageAt: Value(existing.lastMessageAt),
            lastMessageId: Value(existing.lastMessageId),
            unreadCount: Value(existing.unreadCount),
          );
        }

        // Incremental sync only returns timeline events — it does not include
        // full conversation state (name, type, mode, participants). When
        // participants are empty the incoming data has no reliable metadata, so
        // preserve whatever the existing row already has to avoid corruption.
        if (conversation.participants.isEmpty) {
          data = data.copyWith(
            name: Value(existing.name),
            type: Value(existing.type),
            mode: Value(existing.mode),
            createdAt: Value(existing.createdAt),
          );
        }
      } else {
        // New conversation: don't carry over the server's totalUnreadMessage
        // when there is no lastMessage reference. The server's count may
        // already include the message that is about to arrive via the message
        // socket event, which calls
        // updateConversationLastMessage(incrementUnread: true).
        // Starting at 0 prevents the +1 from creating a count of 2 not 1.
        //
        // When a conversation arrives from sync (initialSync / incrementalSync)
        // it always has lastMessage populated, so the branch below is never
        // taken for sync-sourced conversations — their authoritative server
        // count is preserved.
        if (conversation.lastMessage == null) {
          data = data.copyWith(unreadCount: const Value(0));
        }
      }

      await into(conversations).insertOnConflictUpdate(data);
      await _upsertParticipants(conversation.id, conversation.participants);
    });
  }

  @override
  Future<void> updateConversation(Conversation conversation) async {
    await transaction(() async {
      await (update(conversations)..where((r) => r.id.equals(conversation.id)))
          .write(_conversationToData(conversation));
      await _upsertParticipants(conversation.id, conversation.participants);
    });
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    await transaction(() async {
      await (delete(participants)
            ..where((p) => p.conversationId.equals(conversationId)))
          .go();
      await (delete(conversations)..where((r) => r.id.equals(conversationId)))
          .go();
      await deleteMessages(conversationId);
    });
  }

  @override
  Future<void> updateConversationLastMessage(
    String conversationId, {
    required String messageId,
    required DateTime messageAt,
    bool incrementUnread = true,
  }) async {
    final epochSeconds = messageAt.millisecondsSinceEpoch ~/ 1000;

    // Only update if the new message is newer or equal to the current
    // last_message_at (or if last_message_at is NULL). Using <= instead of <
    // so that equal-timestamp updates can correct lastMessageId to the proper
    // deduped primary key (Bug L fix). This still prevents pagination (older
    // messages) from overwriting the conversation's last message.
    if (incrementUnread) {
      // Use IS (SQLite null-safe equality) so that when the conversation was
      // already inserted with this exact last_message_id, the unread count is
      // not incremented a second time.
      await customStatement(
        'UPDATE conversations SET last_message_id = ?, last_message_at = ?, '
        'unread_count = CASE WHEN last_message_id IS ? '
        'THEN unread_count ELSE unread_count + 1 END '
        'WHERE id = ? AND (last_message_at IS NULL OR last_message_at <= ?)',
        [messageId, epochSeconds, messageId, conversationId, epochSeconds],
      );
    } else {
      await customStatement(
        'UPDATE conversations SET last_message_id = ?, last_message_at = ? '
        'WHERE id = ? AND (last_message_at IS NULL OR last_message_at <= ?)',
        [messageId, epochSeconds, conversationId, epochSeconds],
      );
    }
    // Notify drift watchers that the conversations table changed
    markTablesUpdated({conversations});
  }

  @override
  Future<void> resetConversationUnreadCount(String conversationId) async {
    await customStatement(
      'UPDATE conversations SET unread_count = 0 WHERE id = ?',
      [conversationId],
    );
    markTablesUpdated({conversations});
  }

  @override
  Future<void> markConversationMessagesAsRead(String conversationId,
      {String? senderIdFilter,}) async {
    if (senderIdFilter != null && senderIdFilter.isNotEmpty) {
      await customStatement(
        "UPDATE messages SET status = 'read' "
        'WHERE conversation_id = ? AND sender_id = ? '
            "AND status IN ('sent', 'delivered')",
        [conversationId, senderIdFilter],
      );
    } else {
      await customStatement(
        "UPDATE messages SET status = 'read' "
        "WHERE conversation_id = ? AND status IN ('sent', 'delivered')",
        [conversationId],
      );
    }
    markTablesUpdated({messages});
  }

  @override
  Future<void> markConversationMessagesAsDelivered(String conversationId,
      {String? senderIdFilter,}) async {
    if (senderIdFilter != null && senderIdFilter.isNotEmpty) {
      await customStatement(
        "UPDATE messages SET status = 'delivered' "
        "WHERE conversation_id = ? AND sender_id = ? AND status = 'sent'",
        [conversationId, senderIdFilter],
      );
    } else {
      await customStatement(
        "UPDATE messages SET status = 'delivered' "
        "WHERE conversation_id = ? AND status = 'sent'",
        [conversationId],
      );
    }
    markTablesUpdated({messages});
  }

  /// Replaces all participants for a conversation with the given list.
  Future<void> _upsertParticipants(
    String conversationId,
    List<Participant> conversationParticipants,
  ) async {
    if (conversationParticipants.isEmpty) return;

    final existingRows = await (select(participants)
          ..where((p) => p.conversationId.equals(conversationId)))
        .get();
    final existingByUserId = <String, Participant>{
      for (final r in existingRows) r.userId: _participantFromData(r),
    };

    final merged = <Participant>[];
    for (final p in conversationParticipants) {
      final prev = existingByUserId[p.userId];
      final isSyncSynthesizedId =
          p.userId.isNotEmpty && p.id == '${conversationId}_${p.userId}';

      if (prev != null &&
          prev.status == ParticipantStatus.pending &&
          p.status == ParticipantStatus.approved &&
          isSyncSynthesizedId) {
        merged.add(
          p.copyWith(
            status: ParticipantStatus.pending,
            id: prev.id,
            displayName:
                prev.displayName.isNotEmpty ? prev.displayName : p.displayName,
            avatarUrl: prev.avatarUrl ?? p.avatarUrl,
            joinedAt: prev.joinedAt ?? p.joinedAt,
          ),
        );
      } else {
        merged.add(p);
      }
    }

    await (delete(participants)
          ..where((p) => p.conversationId.equals(conversationId)))
        .go();
    for (final participant in merged) {
      await into(participants)
          .insert(_participantToData(conversationId, participant));
    }
  }

  // ==========================================================================
  // Messages
  // ==========================================================================

  @override
  Stream<List<Message>> watchMessages(String conversationId) {
    final query = select(messages)
      ..where((m) =>
          m.conversationId.equals(conversationId) & m.isDeleted.equals(false),)
      ..orderBy([
        (m) => OrderingTerm(
              expression: coalesce([m.serverTimestamp, m.clientTimestamp]),
            ),
        (m) => OrderingTerm(expression: m.clientTimestamp),
        (m) => OrderingTerm(expression: m.id),
      ]);

    // Join messages with their reactions
    return query.watch().asyncMap((rows) async {
      final messageList = <Message>[];
      for (final row in rows) {
        final message = _messageFromData(row);
        final messageReactions = await getReactionsForMessage(message.id);
        messageList.add(message.copyWith(reactions: messageReactions));
      }
      return messageList;
    });
  }

  @override
  Future<List<Message>> getMessagesByConversation(String conversationId,
      {int limit = 50,}) async {
    final query = select(messages)
      ..where((m) =>
          m.conversationId.equals(conversationId) & m.isDeleted.equals(false),)
      ..orderBy([
        (m) => OrderingTerm(
              expression: coalesce([m.serverTimestamp, m.clientTimestamp]),
            ),
        (m) => OrderingTerm(expression: m.clientTimestamp),
        (m) => OrderingTerm(expression: m.id),
      ])
      ..limit(limit);

    final results = await query.get();

    // Load reactions for each message
    final messageList = <Message>[];
    for (final row in results) {
      final message = _messageFromData(row);
      final messageReactions = await getReactionsForMessage(message.id);
      messageList.add(message.copyWith(reactions: messageReactions));
    }

    return messageList;
  }

  @override
  Future<Message?> getMessage(String messageId) async {
    final query = select(messages)..where((m) => m.id.equals(messageId));
    final result = await query.getSingleOrNull();
    if (result == null) return null;

    final message = _messageFromData(result);
    final messageReactions = await getReactionsForMessage(messageId);
    return message.copyWith(reactions: messageReactions);
  }

  @override
  Future<String> insertMessage(Message message) async {
    await _insertEmbeddedReplyMessage(message);

    // Dedup check #1: exact serverId match (fastest, most reliable).
    // After Step 1 fix, the outbound queue writes the serverId back to the
    // local message, so this check catches most socket echoes.
    if (message.serverId != null) {
      final existingByServerId = await _getCanonicalMessageByServerId(
        message.serverId!,
        preferredRoomId: message.conversationId,
      );

      if (existingByServerId != null) {
        final mergedMessage =
            _preserveExistingAttachmentCaption(message, existingByServerId);
        // Preserve existing status if it's more advanced than incoming status.
        // This prevents sync from overwriting delivered/read status with sent.
        final shouldPreserveStatus = _shouldPreserveStatus(
          existingByServerId.status,
          mergedMessage.status.name,
        );
        await (update(messages)
              ..where((m) => m.id.equals(existingByServerId.id)))
            .write(
          _messageToUpdateCompanion(
            mergedMessage,
            preserveStatus: shouldPreserveStatus,
          ),
        );
        await _syncReactions(existingByServerId.id, mergedMessage.reactions);
        return existingByServerId.id;
      }

      // Dedup check #2: match by content + sender for local messages whose
      // serverId hasn't been saved yet (race: socket echo arrives before
      // outbound queue completes).
      // Only match messages with no serverId (truly pending) and within a
      // tight 5-second window to avoid false-matching legitimate duplicate
      // messages (e.g., user sends "OK" twice).
      final localMessages = await (select(messages)
            ..where(
              (m) =>
                  m.conversationId.equals(message.conversationId) &
                  m.senderId.equals(message.senderId) &
                  m.serverId.isNull() &
                  m.status.isIn([
                    MessageStatus.pending.name,
                    MessageStatus.sending.name,
                  ]),
            ))
          .get();

      final incomingContent = message.content.isEncrypted
          ? message.content.cipherText
          : message.content.plainText;

      for (final local in localMessages) {
        if (local.content == incomingContent) {
          final timeDiff =
              message.clientTimestamp.difference(local.clientTimestamp).abs();
          if (timeDiff.inSeconds < 5) {
            final mergedMessage =
                _preserveExistingAttachmentCaption(message, local);
            // Preserve existing status if it's more advanced than incoming.
            final shouldPreserveStatus = _shouldPreserveStatus(
              local.status,
              mergedMessage.status.name,
            );
            await (update(messages)..where((m) => m.id.equals(local.id))).write(
              _messageToUpdateCompanion(
                mergedMessage,
                preserveStatus: shouldPreserveStatus,
              ),
            );
            await _syncReactions(local.id, mergedMessage.reactions);
            return local.id;
          }
        }
      }
    }

    // Default: insert or update by primary key
    // Check if message exists to preserve its status if needed
    final existingMessage = await (select(messages)
          ..where((m) => m.id.equals(message.id)))
        .getSingleOrNull();
    final mergedMessage = existingMessage == null
        ? message
        : _preserveExistingAttachmentCaption(message, existingMessage);
    final preservedStatus = existingMessage?.status;

    final shouldPreserveStatus = preservedStatus != null &&
        _shouldPreserveStatus(preservedStatus, mergedMessage.status.name);

    if (preservedStatus != null && shouldPreserveStatus) {
      // Insert with preserved status - use custom update to preserve status
      await into(messages).insertOnConflictUpdate(
        _messageToDataWithPreservedStatus(
          mergedMessage,
          preservedStatus,
        ),
      );
    } else {
      await into(messages)
          .insertOnConflictUpdate(_messageToData(mergedMessage));
    }
    await _syncReactions(mergedMessage.id, mergedMessage.reactions);
    return mergedMessage.id;
  }

  Future<void> _insertEmbeddedReplyMessage(Message message) async {
    final reply = message.replyTo;
    if (reply == null || reply.id.trim().isEmpty || reply.id == message.id) {
      return;
    }

    final replyConversationId = reply.conversationId.trim().isEmpty
        ? message.conversationId
        : reply.conversationId;
    final embeddedReply = Message(
      id: reply.id,
      serverId: reply.serverId ?? reply.id,
      conversationId: replyConversationId,
      senderId: reply.senderId,
      senderName: reply.senderName,
      senderAvatar: reply.senderAvatar,
      content: reply.content,
      type: reply.type,
      status: reply.status,
      clientTimestamp: reply.clientTimestamp,
      serverTimestamp: reply.serverTimestamp,
      replyToId: reply.replyToId,
      attachments: reply.attachments,
      reactions: reply.reactions,
      readBy: reply.readBy,
      isDeleted: reply.isDeleted,
      isEdited: reply.isEdited,
      isStarred: reply.isStarred,
      isPinned: reply.isPinned,
      pinnedUntil: reply.pinnedUntil,
      localSequence: reply.localSequence,
      metadata: reply.metadata,
    );

    final existing = await (select(messages)
          ..where((m) {
            final byId = m.id.equals(reply.id);
            final serverId = reply.serverId;
            if (serverId != null && serverId.trim().isNotEmpty) {
              return byId | m.serverId.equals(serverId);
            }
            return byId | m.serverId.equals(reply.id);
          }))
        .get();
    final existingMessage = existing.isEmpty ? null : existing.first;

    if (existingMessage != null) {
      final existingSenderId = existingMessage.senderId.trim();
      final existingSenderName = (existingMessage.senderName ?? '').trim();
      final nextSenderId = reply.senderId.trim();
      final nextSenderName = (reply.senderName ?? '').trim();
      final canFillSender = existingSenderId.isEmpty && nextSenderId.isNotEmpty;
      final canFillName =
          existingSenderName.isEmpty && nextSenderName.isNotEmpty;

      if (canFillSender || canFillName) {
        await (update(messages)..where((m) => m.id.equals(existingMessage.id)))
            .write(
          _messageToUpdateCompanion(embeddedReply),
        );
      }
      return;
    }

    await insertMessage(embeddedReply);
  }

  /// Returns true if [existingStatus] should be preserved over
  /// [incomingStatus].
  ///
  /// Status hierarchy: sent < delivered < read
  /// Preserve existing status if it's more advanced than incoming.
  bool _shouldPreserveStatus(String existingStatus, String incomingStatus) {
    final statusOrder = {
      MessageStatus.sent.name: 0,
      MessageStatus.delivered.name: 1,
      MessageStatus.read.name: 2,
      // For any other status (pending, sending, failed, draft), don't preserve
    };

    final existingOrder = statusOrder[existingStatus];
    final incomingOrder = statusOrder[incomingStatus];

    // Preserve if existing exists and is more advanced than incoming
    return existingOrder != null &&
        incomingOrder != null &&
        existingOrder > incomingOrder;
  }

  Future<MessageData?> _getCanonicalMessageByServerId(
    String serverId, {
    String? preferredRoomId,
  }) async {
    final rows = await (select(messages)
          ..where((m) => m.serverId.equals(serverId)))
        .get();
    if (rows.isEmpty) return null;
    if (rows.length == 1) return rows.single;

    rows.sort((a, b) {
      final roomCompare = _boolScore(b.conversationId == preferredRoomId) -
          _boolScore(a.conversationId == preferredRoomId);
      if (roomCompare != 0) return roomCompare;

      final serverIdCompare =
          _boolScore(b.id == serverId) - _boolScore(a.id == serverId);
      if (serverIdCompare != 0) return serverIdCompare;

      return b.clientTimestamp.compareTo(a.clientTimestamp);
    });

    final canonical = rows.first;
    for (final duplicate in rows.skip(1)) {
      await (update(conversations)
            ..where((r) => r.lastMessageId.equals(duplicate.id)))
          .write(ConversationsCompanion(lastMessageId: Value(canonical.id)));
      await (delete(reactions)..where((r) => r.messageId.equals(duplicate.id)))
          .go();
      await (delete(messages)..where((m) => m.id.equals(duplicate.id))).go();
    }
    markTablesUpdated({conversations, messages, reactions});

    return canonical;
  }

  int _boolScore(bool value) => value ? 1 : 0;

  Message _preserveExistingAttachmentCaption(
    Message incoming,
    MessageData existing,
  ) {
    if (incoming.attachments.isEmpty) return incoming;
    if (_messageText(incoming).isNotEmpty) return incoming;

    final existingMessage = _messageFromData(existing);
    if (_messageText(existingMessage).isEmpty) return incoming;

    return incoming.copyWith(content: existingMessage.content);
  }

  String _messageText(Message message) {
    final plain = message.content.plainText?.trim() ?? '';
    if (plain.isNotEmpty) return plain;
    return message.content.cipherText?.trim() ?? '';
  }

  /// Converts a [Message] to data companion while preserving the specified
  /// status.
  MessagesCompanion _messageToDataWithPreservedStatus(
    Message message,
    String preservedStatus,
  ) {
    final companion = _messageToData(message);
    // Override status with the preserved value
    return companion.copyWith(status: Value(preservedStatus));
  }

  /// Syncs reactions from an API message into the reactions table.
  Future<void> _syncReactions(
      String messageId, List<Reaction> messageReactions,) async {
    if (messageReactions.isEmpty) return;
    for (final reaction in messageReactions) {
      await into(reactions).insertOnConflictUpdate(
        _reactionToData(messageId, reaction),
      );
    }
  }

  @override
  Future<void> updateMessage(
    String messageId, {
    String? serverId,
    String? content,
    MessageStatus? status,
    DateTime? serverTimestamp,
    bool? isDeleted,
    bool? isEdited,
    bool? isStarred,
    bool? isPinned,
    DateTime? pinnedUntil,
  }) async {
    // Build the update companion once
    final companion = MessagesCompanion(
      serverId: serverId != null ? Value(serverId) : const Value.absent(),
      content: content != null ? Value(content) : const Value.absent(),
      status: status != null ? Value(status.name) : const Value.absent(),
      serverTimestamp: serverTimestamp != null
          ? Value(serverTimestamp)
          : const Value.absent(),
      isDeleted: isDeleted != null ? Value(isDeleted) : const Value.absent(),
      isEdited: isEdited != null ? Value(isEdited) : const Value.absent(),
      isStarred: isStarred != null ? Value(isStarred) : const Value.absent(),
      isPinned: isPinned != null ? Value(isPinned) : const Value.absent(),
      pinnedUntil:
          pinnedUntil != null ? Value(pinnedUntil) : const Value.absent(),
    );

    // First try to find by primary key (id)
    final existingById = await (select(messages)
          ..where((m) => m.id.equals(messageId)))
        .getSingleOrNull();

    if (existingById != null) {
      await (update(messages)..where((m) => m.id.equals(messageId)))
          .write(companion);
      return;
    }

    // If not found by id, try to find by serverId
    // This handles cases where socket events (e.g., pin, star) send the
    // server ID but the local message was created with a client UUID as id
    final existingByServerId = await _getCanonicalMessageByServerId(messageId);

    if (existingByServerId != null) {
      await (update(messages)..where((m) => m.id.equals(existingByServerId.id)))
          .write(companion);
      return;
    }

    // Message not found - this is fine, it might have been deleted
    // or the event might be for a message we haven't received yet
  }

  @override
  Future<void> replacePinnedMessage(
    String conversationId,
    String messageId, {
    DateTime? pinnedUntil,
  }) async {
    await transaction(() async {
      await (update(messages)
            ..where((m) => m.conversationId.equals(conversationId)))
          .write(
        const MessagesCompanion(
          isPinned: Value(false),
          pinnedUntil: Value(null),
        ),
      );

      final existingById = await (select(messages)
            ..where((m) => m.id.equals(messageId)))
          .getSingleOrNull();

      if (existingById != null) {
        await (update(messages)..where((m) => m.id.equals(messageId))).write(
          MessagesCompanion(
            isPinned: const Value(true),
            pinnedUntil: Value(pinnedUntil),
          ),
        );
        return;
      }

      final existingByServerId = await _getCanonicalMessageByServerId(
        messageId,
        preferredRoomId: conversationId,
      );

      if (existingByServerId != null) {
        await (update(messages)
              ..where((m) => m.id.equals(existingByServerId.id)))
            .write(
          MessagesCompanion(
            isPinned: const Value(true),
            pinnedUntil: Value(pinnedUntil),
          ),
        );
      }
    });
  }

  @override
  Future<void> deleteMessages(String conversationId) async {
    await (delete(messages)
          ..where((m) => m.conversationId.equals(conversationId)))
        .go();
  }

  @override
  Stream<List<Message>> watchStarredMessages() {
    final query = select(messages)
      ..where((m) => m.isStarred.equals(true) & m.isDeleted.equals(false))
      ..orderBy([
        (m) => OrderingTerm(
              expression: m.clientTimestamp,
              mode: OrderingMode.desc,
            ),
      ]);

    return query.watch().asyncMap((rows) async {
      final messageList = <Message>[];
      for (final row in rows) {
        final message = _messageFromData(row);
        final messageReactions = await getReactionsForMessage(message.id);
        messageList.add(message.copyWith(reactions: messageReactions));
      }
      return messageList;
    });
  }

  @override
  Stream<List<Message>> watchPinnedMessages(String conversationId) {
    final query = select(messages)
      ..where(
        (m) =>
            m.conversationId.equals(conversationId) &
            m.isPinned.equals(true) &
            m.isDeleted.equals(false),
      )
      ..orderBy([
        (m) => OrderingTerm(
              expression: m.clientTimestamp,
              mode: OrderingMode.desc,
            ),
      ]);

    return query.watch().asyncMap((rows) async {
      final messageList = <Message>[];
      for (final row in rows) {
        final message = _messageFromData(row);
        final messageReactions = await getReactionsForMessage(message.id);
        messageList.add(message.copyWith(reactions: messageReactions));
      }
      return messageList;
    });
  }

  // ==========================================================================
  // Sync State
  // ==========================================================================

  @override
  Future<SyncState?> getSyncState() async {
    final query = select(syncStates)..limit(1);
    final result = await query.getSingleOrNull();
    return result != null ? _syncStateFromData(result) : null;
  }

  @override
  Future<void> updateSyncState(SyncState state) async {
    final existing = await getSyncState();
    if (existing == null) {
      await into(syncStates).insert(_syncStateToData(state));
    } else {
      await (update(syncStates)..where((s) => s.id.equals(1)))
          .write(_syncStateToData(state));
    }
  }

  @override
  Future<void> clearSyncState() async {
    await delete(syncStates).go();
  }

  // ==========================================================================
  // Mappers
  // ==========================================================================

  Conversation _conversationFromData(
    ConversationData data, {
    Message? lastMessage,
    List<Participant> participants = const [],
  }) {
    return Conversation(
      id: data.id,
      name: data.name,
      avatarUrl: data.avatarUrl,
      type: ConversationType.values.byName(data.type),
      mode: ConversationMode.fromString(data.mode),
      status: ConversationStatus.values.byName(data.status),
      unreadCount: data.unreadCount,
      myRole: ParticipantRole.values.byName(data.myRole),
      participants: participants,
      lastMessage: lastMessage,
      lastMessageAt: data.lastMessageAt,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }

  ConversationsCompanion _conversationToData(Conversation conversation) {
    return ConversationsCompanion.insert(
      id: conversation.id,
      name: Value(conversation.name),
      avatarUrl: Value(conversation.avatarUrl),
      type: conversation.type.name,
      mode: conversation.mode.name,
      status: conversation.status.name,
      unreadCount: Value(conversation.unreadCount),
      myRole: conversation.myRole.name,
      lastMessageId: Value(conversation.lastMessage?.id),
      lastMessageAt: Value(conversation.lastMessageAt),
      createdAt: conversation.createdAt ?? DateTime.now(),
      updatedAt: conversation.updatedAt ?? DateTime.now(),
    );
  }

  Message _messageFromData(MessageData data) {
    // Reconstruct MessageContent based on encryption state.
    // Currently the API returns readable text in "ciphertext", so we always
    // set plainText for display. When real E2E encryption is added, encrypted
    // messages without a decrypted plainText should use
    // MessageContent.encrypted().
    final content = data.isEncrypted && data.contentNonce != null
        ? MessageContent(
            plainText: data.content,
            cipherText: data.content,
            nonce: data.contentNonce,
          )
        : MessageContent(plainText: data.content);

    // Deserialize attachments from JSON string.
    var attachments = const <FileAttachment>[];
    if (data.attachmentsJson != null && data.attachmentsJson!.isNotEmpty) {
      try {
        final decoded = jsonDecode(data.attachmentsJson!) as List<dynamic>;
        attachments = decoded
            .map((e) => FileAttachment.fromJson(e as Map<String, dynamic>))
            .toList();
      } on Object catch (_) {
        // Gracefully handle corrupted JSON — treat as no attachments.
      }
    }

    return Message(
      id: data.id,
      serverId: data.serverId,
      conversationId: data.conversationId,
      senderId: data.senderId,
      senderName: data.senderName,
      senderAvatar: data.senderAvatar,
      content: content,
      type: MessageType.values.byName(data.type),
      status: MessageStatus.values.byName(data.status),
      clientTimestamp: data.clientTimestamp,
      serverTimestamp: data.serverTimestamp,
      replyToId: data.replyToId,
      attachments: attachments,
      isDeleted: data.isDeleted,
      isEdited: data.isEdited,
      isStarred: data.isStarred,
      isPinned: data.isPinned,
      pinnedUntil: data.pinnedUntil,
    );
  }

  MessagesCompanion _messageToData(Message message) {
    // Store content based on encryption state:
    // - If encrypted: store cipherText in content column
    // - If plain: store plainText in content column
    final contentText = message.content.isEncrypted
        ? message.content.cipherText!
        : message.content.plainText ?? '';

    final attachmentsJsonValue = message.attachments.isNotEmpty
        ? jsonEncode(message.attachments.map((a) => a.toJson()).toList())
        : null;

    return MessagesCompanion.insert(
      id: message.id,
      serverId: Value(message.serverId),
      conversationId: message.conversationId,
      senderId: message.senderId,
      senderName: Value(message.senderName),
      senderAvatar: Value(message.senderAvatar),
      content: contentText,
      contentNonce: Value(message.content.nonce),
      isEncrypted: Value(message.content.isEncrypted),
      type: message.type.name,
      status: message.status.name,
      clientTimestamp: message.clientTimestamp,
      serverTimestamp: Value(message.serverTimestamp),
      replyToId: Value(message.replyToId),
      isDeleted: Value(message.isDeleted),
      isEdited: Value(message.isEdited),
      isStarred: Value(message.isStarred),
      isPinned: Value(message.isPinned),
      pinnedUntil: Value(message.pinnedUntil),
      attachmentsJson: Value(attachmentsJsonValue),
    );
  }

  /// Converts a [Message] to a companion for UPDATE during dedup.
  /// Unlike [_messageToData], this omits the `id` column so the existing
  /// primary key is preserved (client UUID stays, server data merges in).
  MessagesCompanion _messageToUpdateCompanion(
    Message message, {
    bool preserveStatus = false,
  }) {
    final contentText = message.content.isEncrypted
        ? message.content.cipherText!
        : message.content.plainText ?? '';

    final attachmentsJsonValue = message.attachments.isNotEmpty
        ? jsonEncode(message.attachments.map((a) => a.toJson()).toList())
        : null;

    return MessagesCompanion(
      serverId: Value(message.serverId),
      conversationId: Value(message.conversationId),
      senderId: Value(message.senderId),
      senderName: Value(message.senderName),
      senderAvatar: Value(message.senderAvatar),
      content: Value(contentText),
      contentNonce: Value(message.content.nonce),
      isEncrypted: Value(message.content.isEncrypted),
      type: Value(message.type.name),
      // Only update status if not preserving
      status:
          preserveStatus ? const Value.absent() : Value(message.status.name),
      clientTimestamp: Value(message.clientTimestamp),
      serverTimestamp: Value(message.serverTimestamp),
      replyToId: Value(message.replyToId),
      isDeleted: Value(message.isDeleted),
      isEdited: Value(message.isEdited),
      isStarred: Value(message.isStarred),
      isPinned: Value(message.isPinned),
      pinnedUntil: Value(message.pinnedUntil),
      attachmentsJson: Value(attachmentsJsonValue),
    );
  }

  Participant _participantFromData(ParticipantData data) {
    return Participant(
      id: data.id,
      userId: data.userId,
      displayName: data.displayName,
      avatarUrl: data.avatarUrl,
      role: ParticipantRole.values.byName(data.role),
      status: ParticipantStatus.values.byName(data.status),
      isOnline: data.isOnline,
      lastSeenAt: data.lastSeenAt,
      joinedAt: data.joinedAt,
    );
  }

  ParticipantsCompanion _participantToData(
    String conversationId,
    Participant participant,
  ) {
    return ParticipantsCompanion.insert(
      id: participant.id,
      conversationId: conversationId,
      userId: participant.userId,
      displayName: participant.displayName,
      avatarUrl: Value(participant.avatarUrl),
      role: participant.role.name,
      status: participant.status.name,
      isOnline: Value(participant.isOnline),
      lastSeenAt: Value(participant.lastSeenAt),
      joinedAt: Value(participant.joinedAt),
    );
  }

  /// Batch-fetches participants for a list of conversation IDs, grouped by
  /// conversationId.
  Future<Map<String, List<Participant>>> _getParticipantsByConversationIds(
    List<String> conversationIds,
  ) async {
    if (conversationIds.isEmpty) return {};

    final query = select(participants)
      ..where((p) => p.conversationId.isIn(conversationIds));
    final results = await query.get();

    final map = <String, List<Participant>>{};
    for (final row in results) {
      map
          .putIfAbsent(row.conversationId, () => [])
          .add(_participantFromData(row));
    }
    return map;
  }

  SyncState _syncStateFromData(SyncStateData data) {
    return SyncState(
      lastSyncToken: data.lastSyncToken,
      lastSyncAt: data.lastSyncAt,
      isInitialSyncComplete: data.isInitialSyncComplete,
    );
  }

  SyncStatesCompanion _syncStateToData(SyncState state) {
    return SyncStatesCompanion.insert(
      lastSyncToken: Value(state.lastSyncToken),
      lastSyncAt: Value(state.lastSyncAt),
      isInitialSyncComplete: Value(state.isInitialSyncComplete),
    );
  }

  // ==========================================================================
  // Participant Operations
  // ==========================================================================

  @override
  Future<List<Participant>> getParticipantsForConversation(
      String conversationId,) async {
    final query = select(participants)
      ..where((p) => p.conversationId.equals(conversationId));
    final results = await query.get();
    return results.map(_participantFromData).toList();
  }

  @override
  Future<void> upsertParticipants(
    String conversationId,
    List<Participant> conversationParticipants,
  ) async {
    await _upsertParticipants(conversationId, conversationParticipants);
  }

  @override
  Future<void> deleteParticipants(String conversationId) async {
    await (delete(participants)
          ..where((p) => p.conversationId.equals(conversationId)))
        .go();
  }

  // ==========================================================================
  // Reaction Operations
  // ==========================================================================

  @override
  Future<List<Reaction>> getReactionsForMessage(String messageId) async {
    final query = select(reactions)
      ..where((r) => r.messageId.equals(messageId))
      ..orderBy([(r) => OrderingTerm(expression: r.createdAt)]);

    final results = await query.get();
    return results.map(_reactionFromData).toList();
  }

  @override
  Future<void> addReaction(String messageId, Reaction reaction) async {
    await into(reactions).insertOnConflictUpdate(
      _reactionToData(messageId, reaction),
    );
  }

  @override
  Future<void> removeReaction(String messageId, String reactionId) async {
    await (delete(reactions)
          ..where(
            (r) => r.messageId.equals(messageId) & r.id.equals(reactionId),
          ))
        .go();
  }

  // ==========================================================================
  // Outbound Queue Operations
  // ==========================================================================

  @override
  Future<List<OutboundOperation>> getPendingOperations() async {
    final query = select(outboundOperations)
      ..where(
        (o) =>
            o.status.equals(OutboundOperationStatus.pending.name) |
            o.status.equals(OutboundOperationStatus.failed.name),
      )
      ..orderBy([(o) => OrderingTerm(expression: o.createdAt)]);

    final results = await query.get();
    return results.map(_operationFromData).toList();
  }

  @override
  Future<void> insertOperation(OutboundOperation operation) async {
    await into(outboundOperations)
        .insertOnConflictUpdate(_operationToData(operation));
  }

  @override
  Future<void> updateOperation(OutboundOperation operation) async {
    await (update(outboundOperations)..where((o) => o.id.equals(operation.id)))
        .write(_operationToData(operation));
  }

  @override
  Future<void> deleteOperation(String operationId) async {
    await (delete(outboundOperations)..where((o) => o.id.equals(operationId)))
        .go();
  }

  @override
  Future<void> deleteCompletedOperations() async {
    await (delete(outboundOperations)
          ..where(
            (o) => o.status.equals(OutboundOperationStatus.completed.name),
          ))
        .go();
  }

  // ==========================================================================
  // Pinned Event Operations
  // ==========================================================================

  @override
  Stream<List<PinnedEvent>> watchPinnedEvents(String conversationId) {
    final query = select(pinnedEvents)
      ..where((pe) => pe.roomId.equals(conversationId))
      ..where((pe) => pe.unpinnedAt.isNull())
      ..orderBy([(pe) => OrderingTerm(expression: pe.pinnedAt)]);

    return query.watch().map((rows) => rows.map(_pinnedEventFromData).toList());
  }

  @override
  Future<List<PinnedEvent>> getPinnedEvents(String conversationId) async {
    final query = select(pinnedEvents)
      ..where((pe) => pe.roomId.equals(conversationId))
      ..where((pe) => pe.unpinnedAt.isNull())
      ..orderBy([(pe) => OrderingTerm(expression: pe.pinnedAt)]);

    final results = await query.get();
    return results.map(_pinnedEventFromData).toList();
  }

  @override
  Future<void> insertPinnedEvent(PinnedEvent event) {
    return into(pinnedEvents).insertOnConflictUpdate(
      _pinnedEventToData(event),
    );
  }

  @override
  Future<void> updatePinnedEvent(
    String eventId, {
    DateTime? unpinnedAt,
  }) async {
    await (update(pinnedEvents)..where((pe) => pe.id.equals(eventId)))
        .write(PinnedEventsCompanion(unpinnedAt: Value(unpinnedAt)));
  }

  @override
  Future<void> deletePinnedEventsForMessage(String messageId) async {
    await (delete(pinnedEvents)..where((pe) => pe.messageId.equals(messageId)))
        .go();
  }

  @override
  Future<void> deletePinnedEvents(String conversationId) async {
    await (delete(pinnedEvents)
          ..where((pe) => pe.roomId.equals(conversationId)))
        .go();
  }

  PinnedEvent _pinnedEventFromData(PinnedEventData data) {
    return PinnedEvent(
      id: data.id,
      messageId: data.messageId,
      roomId: data.roomId,
      pinnedBy: data.pinnedBy,
      pinnedAt: data.pinnedAt,
      unpinnedAt: data.unpinnedAt,
    );
  }

  PinnedEventsCompanion _pinnedEventToData(PinnedEvent event) {
    return PinnedEventsCompanion.insert(
      id: event.id,
      messageId: event.messageId,
      roomId: event.roomId,
      pinnedBy: event.pinnedBy,
      pinnedAt: event.pinnedAt,
      unpinnedAt: Value(event.unpinnedAt),
    );
  }

  @override
  Future<T> runInTransaction<T>(Future<T> Function() action) {
    return transaction(action);
  }

  OutboundOperation _operationFromData(OutboundOperationData data) {
    return OutboundOperation(
      id: data.id,
      type: OutboundOperationType.values.byName(data.type),
      data: data.data,
      retryCount: data.retryCount,
      status: OutboundOperationStatus.values.byName(data.status),
      createdAt: data.createdAt,
      processedAt: data.processedAt,
      errorMessage: data.errorMessage,
    );
  }

  OutboundOperationsCompanion _operationToData(OutboundOperation operation) {
    return OutboundOperationsCompanion.insert(
      id: operation.id,
      type: operation.type.name,
      data: operation.data,
      retryCount: Value(operation.retryCount),
      status: operation.status.name,
      createdAt: operation.createdAt,
      processedAt: Value(operation.processedAt),
      errorMessage: Value(operation.errorMessage),
    );
  }

  Reaction _reactionFromData(ReactionData data) {
    return Reaction(
      id: data.id,
      emoji: data.emoji,
      userId: data.userId,
      userName: data.userName,
      createdAt: data.createdAt,
    );
  }

  ReactionsCompanion _reactionToData(String messageId, Reaction reaction) {
    return ReactionsCompanion.insert(
      id: reaction.id,
      messageId: messageId,
      emoji: reaction.emoji,
      userId: reaction.userId,
      userName: Value(reaction.userName),
      createdAt: Value(reaction.createdAt),
    );
  }
}

LazyDatabase _openConnection(
  String databasePath,
  DatabaseEncryptionConfig? encryptionConfig,
) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, databasePath));
    final token = RootIsolateToken.instance!;

    return NativeDatabase.createInBackground(
      file,
      isolateSetup: () async {
        BackgroundIsolateBinaryMessenger.ensureInitialized(token);
      },
      setup: (rawDb) {
        if (encryptionConfig == null) return;
        if (encryptionConfig.isValid() == false) return;

        // SQLite3MultipleCiphers (sqlite3mc) — SQLCipher-compatible
        // encryption. The `hooks.user_defines.sqlite3.source: sqlite3mc`
        // in pubspec.yaml bundles the SQLite3MultipleCiphers binary via
        // build hooks (sqlite3 v3+). These pragmas make it byte-compatible
        // with existing SQLCipher v4 databases.
        rawDb
          ..execute("PRAGMA cipher = 'sqlcipher'")
          ..execute('PRAGMA legacy = 4')
          ..execute("PRAGMA key = '${encryptionConfig.encryptionKey}'")
          ..execute(
            'PRAGMA cipher_page_size = ${encryptionConfig.cipherPageSize}',
          )
          ..execute('PRAGMA kdf_iter = ${encryptionConfig.kdfIterations}')
          ..execute('PRAGMA kdf_algorithm = 2') // PBKDF2_HMAC_SHA512
          ..execute('PRAGMA hmac_algorithm = 2'); // HMAC_SHA512

        rawDb.config.doubleQuotedStringLiterals = false;
      },
    );
  }, openImmediately: true,);
}
