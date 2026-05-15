import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_chat_sdk/src/core/database/chat_database_impl.dart';
import 'package:flutter_chat_sdk/src/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');

  late ChatDatabaseImpl database;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('chat-db-test-');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (call) async {
      if (call.method == 'getApplicationDocumentsDirectory') {
        return tempDir.path;
      }
      return null;
    });

    database = ChatDatabaseImpl(databasePath: 'chat.sqlite');
    await database.initialize();
  });

  tearDown(() async {
    await database.close();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, null);
    await tempDir.delete(recursive: true);
  });

  test('insertMessage repairs duplicate serverId rows instead of throwing',
      () async {
    const roomId = 'room-1';
    const serverId = 'server-msg-1';
    final createdAt = DateTime(2026, 1, 1, 10);
    final createdAtSeconds = createdAt.millisecondsSinceEpoch ~/ 1000;
    final nextSecond = createdAtSeconds + 1;

    await database.insertConversation(
      Conversation(
        id: roomId,
        type: ConversationType.direct,
        mode: ConversationMode.standard,
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    );

    await database.customStatement(
      '''
      INSERT INTO messages (
        id, server_id, conversation_id, sender_id, content, is_encrypted, type, status,
        client_timestamp, server_timestamp, is_deleted, is_edited, is_starred,
        is_pinned, local_sequence
      ) VALUES (?, ?, ?, ?, ?, 0, ?, ?, ?, ?, 0, 0, 0, 0, 0)
      ''',
      [
        'local-duplicate',
        serverId,
        roomId,
        'me',
        'old local copy',
        MessageType.text.name,
        MessageStatus.sent.name,
        createdAtSeconds,
        createdAtSeconds,
      ],
    );
    await database.customStatement(
      '''
      INSERT INTO messages (
        id, server_id, conversation_id, sender_id, content, is_encrypted, type, status,
        client_timestamp, server_timestamp, is_deleted, is_edited, is_starred,
        is_pinned, local_sequence
      ) VALUES (?, ?, ?, ?, ?, 0, ?, ?, ?, ?, 0, 0, 0, 0, 0)
      ''',
      [
        'server-duplicate',
        serverId,
        roomId,
        'me',
        'old server copy',
        MessageType.text.name,
        MessageStatus.sent.name,
        nextSecond,
        nextSecond,
      ],
    );

    final retainedId = await database.insertMessage(
      Message(
        id: 'incoming-sync-copy',
        serverId: serverId,
        conversationId: roomId,
        senderId: 'me',
        content: const MessageContent.plain('fresh sync copy'),
        status: MessageStatus.delivered,
        clientTimestamp: createdAt.add(const Duration(seconds: 2)),
        serverTimestamp: createdAt.add(const Duration(seconds: 2)),
      ),
    );

    final messages = await database.getMessagesByConversation(roomId);

    expect(retainedId, isNot('incoming-sync-copy'));
    expect(messages.where((message) => message.serverId == serverId),
        hasLength(1),);
    expect(messages.single.serverId, serverId);
    expect(messages.single.content.plainText, 'fresh sync copy');
    expect(messages.single.status, MessageStatus.delivered);
  });
}
