import 'package:flutter_chat_sdk/src/domain/domain.dart';
import 'package:flutter_chat_sdk/src/domain/entities/file_attachment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Message', () {
    test('creates a message with required fields', () {
      final message = Message(
        id: 'msg-123',
        conversationId: 'room-123',
        senderId: 'user-123',
        content: const MessageContent(plainText: 'Hello'),
        clientTimestamp: DateTime(2024, 1, 1),
      );

      expect(message.id, 'msg-123');
      expect(message.conversationId, 'room-123');
      expect(message.senderId, 'user-123');
      expect(message.content.plainText, 'Hello');
      expect(message.type, MessageType.text);
      expect(message.status, MessageStatus.pending);
    });

    test('isPending returns true for pending and sending status', () {
      final pending = Message(
        id: 'msg-1',
        conversationId: 'room-1',
        senderId: 'user-1',
        content: const MessageContent(plainText: 'Test'),
        clientTimestamp: DateTime.now(),
        status: MessageStatus.pending,
      );

      final sending = Message(
        id: 'msg-2',
        conversationId: 'room-1',
        senderId: 'user-1',
        content: const MessageContent(plainText: 'Test'),
        clientTimestamp: DateTime.now(),
        status: MessageStatus.sending,
      );

      expect(pending.isPending, isTrue);
      expect(sending.isPending, isTrue);
    });

    test('isSent returns true for sent, delivered, and read status', () {
      final statuses = [
        MessageStatus.sent,
        MessageStatus.delivered,
        MessageStatus.read,
      ];

      for (final status in statuses) {
        final message = Message(
          id: 'msg-$status',
          conversationId: 'room-1',
          senderId: 'user-1',
          content: const MessageContent(plainText: 'Test'),
          clientTimestamp: DateTime.now(),
          status: status,
        );

        expect(message.isSent, isTrue, reason: 'Failed for $status');
      }
    });

    test('isFailed returns true for failed status', () {
      final message = Message(
        id: 'msg-1',
        conversationId: 'room-1',
        senderId: 'user-1',
        content: const MessageContent(plainText: 'Test'),
        clientTimestamp: DateTime.now(),
        status: MessageStatus.failed,
      );

      expect(message.isFailed, isTrue);
    });

    test('isReply returns true when replyToId is set', () {
      final reply = Message(
        id: 'msg-1',
        conversationId: 'room-1',
        senderId: 'user-1',
        content: const MessageContent(plainText: 'Test'),
        clientTimestamp: DateTime.now(),
        replyToId: 'original-msg',
      );

      expect(reply.isReply, isTrue);
    });

    test('hasAttachments returns true when attachments exist', () {
      final message = Message(
        id: 'msg-1',
        conversationId: 'room-1',
        senderId: 'user-1',
        content: const MessageContent(plainText: 'Test'),
        clientTimestamp: DateTime.now(),
        attachments: const [
          FileAttachment(
            id: 'file-1',
            url: 'https://example.com/file.pdf',
            name: 'document.pdf',
            extension: 'pdf',
            size: 1024,
          ),
        ],
      );

      expect(message.hasAttachments, isTrue);
    });

    test('hasReactions returns true when reactions exist', () {
      final message = Message(
        id: 'msg-1',
        conversationId: 'room-1',
        senderId: 'user-1',
        content: const MessageContent(plainText: 'Test'),
        clientTimestamp: DateTime.now(),
        reactions: const [
          Reaction(
            id: 'react-1',
            userId: 'user-2',
            emoji: '👍',
          ),
        ],
      );

      expect(message.hasReactions, isTrue);
    });

    test('timestamp returns serverTimestamp when available', () {
      final clientTime = DateTime(2024, 1, 1, 10, 0);
      final serverTime = DateTime(2024, 1, 1, 10, 1);

      final message = Message(
        id: 'msg-1',
        conversationId: 'room-1',
        senderId: 'user-1',
        content: const MessageContent(plainText: 'Test'),
        clientTimestamp: clientTime,
        serverTimestamp: serverTime,
      );

      expect(message.timestamp, serverTime);
    });

    test('timestamp returns clientTimestamp when serverTimestamp is null', () {
      final clientTime = DateTime(2024, 1, 1, 10, 0);

      final message = Message(
        id: 'msg-1',
        conversationId: 'room-1',
        senderId: 'user-1',
        content: const MessageContent(plainText: 'Test'),
        clientTimestamp: clientTime,
      );

      expect(message.timestamp, clientTime);
    });

    test('copyWith creates a new message with updated fields', () {
      final original = Message(
        id: 'msg-1',
        conversationId: 'room-1',
        senderId: 'user-1',
        content: const MessageContent(plainText: 'Test'),
        clientTimestamp: DateTime(2024, 1, 1),
      );

      final updated = original.copyWith(
        status: MessageStatus.sent,
        serverId: 'srv-123',
      );

      expect(original.id, updated.id);
      expect(original.status, MessageStatus.pending);
      expect(updated.status, MessageStatus.sent);
      expect(updated.serverId, 'srv-123');
    });

    test('props includes all fields for equality', () {
      final message1 = Message(
        id: 'msg-1',
        conversationId: 'room-1',
        senderId: 'user-1',
        content: const MessageContent(plainText: 'Test'),
        clientTimestamp: DateTime(2024, 1, 1),
      );

      final message2 = Message(
        id: 'msg-1',
        conversationId: 'room-1',
        senderId: 'user-1',
        content: const MessageContent(plainText: 'Test'),
        clientTimestamp: DateTime(2024, 1, 1),
      );

      expect(message1, equals(message2));
    });
  });

  group('MessageContent', () {
    test('displayText returns plainText for text messages', () {
      final content = MessageContent(plainText: 'Hello World');
      expect(content.displayText, 'Hello World');
    });
  });

  group('Reaction', () {
    test('creates a reaction with required fields', () {
      final reaction = const Reaction(
        id: 'react-1',
        userId: 'user-1',
        emoji: '👍',
      );

      expect(reaction.id, 'react-1');
      expect(reaction.userId, 'user-1');
      expect(reaction.emoji, '👍');
    });
  });

  group('FileAttachment', () {
    test('identifies image files correctly', () {
      const png = FileAttachment(
        id: 'file-1',
        url: 'https://example.com/image.png',
        name: 'image.png',
        extension: 'png',
        size: 1024,
      );

      const jpg = FileAttachment(
        id: 'file-2',
        url: 'https://example.com/image.jpg',
        name: 'image.jpg',
        extension: 'jpg',
        size: 2048,
      );

      expect(png.isImage, isTrue);
      expect(jpg.isImage, isTrue);
    });

    test('identifies video files correctly', () {
      const video = FileAttachment(
        id: 'file-1',
        url: 'https://example.com/video.mp4',
        name: 'video.mp4',
        extension: 'mp4',
        size: 1024000,
      );

      expect(video.isVideo, isTrue);
    });

    test('identifies PDF files correctly', () {
      const pdf = FileAttachment(
        id: 'file-1',
        url: 'https://example.com/doc.pdf',
        name: 'doc.pdf',
        extension: 'pdf',
        size: 5000,
      );

      expect(pdf.isPdf, isTrue);
    });

    test('toJson() serializes all fields', () {
      const attachment = FileAttachment(
        id: 'file-1',
        url: 'https://example.com/file.pdf',
        name: 'document.pdf',
        extension: 'pdf',
        size: 1024,
        mimeType: 'application/pdf',
        pageCount: 5,
        thumbnailUrl: 'https://example.com/thumb.jpg',
        localPath: '/tmp/file.pdf',
        width: 800,
        height: 600,
        thumbhash: 'abc123',
        blurhash: 'LKO2',
        duration: Duration(seconds: 30),
        waveform: [0.1, 0.5, 0.9],
      );

      final json = attachment.toJson();
      expect(json['id'], 'file-1');
      expect(json['url'], 'https://example.com/file.pdf');
      expect(json['name'], 'document.pdf');
      expect(json['ext'], 'pdf');
      expect(json['size'], 1024);
      expect(json['mimeType'], 'application/pdf');
      expect(json['pageCount'], 5);
      expect(json['thumbnailUrl'], 'https://example.com/thumb.jpg');
      expect(json['localPath'], '/tmp/file.pdf');
      expect(json['width'], 800);
      expect(json['height'], 600);
      expect(json['durationMs'], 30000);
      expect(json['waveform'], [0.1, 0.5, 0.9]);
    });

    test('fromJson() round-trips correctly', () {
      const original = FileAttachment(
        id: 'file-1',
        url: 'https://example.com/file.pdf',
        name: 'document.pdf',
        extension: 'pdf',
        size: 1024,
        mimeType: 'application/pdf',
        width: 800,
        height: 600,
        duration: Duration(milliseconds: 1500),
        waveform: [0.1, 0.5, 0.9],
      );

      final json = original.toJson();
      final restored = FileAttachment.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.url, original.url);
      expect(restored.name, original.name);
      expect(restored.extension, original.extension);
      expect(restored.size, original.size);
      expect(restored.mimeType, original.mimeType);
      expect(restored.width, original.width);
      expect(restored.height, original.height);
      expect(restored.duration, original.duration);
      expect(restored.waveform, original.waveform);
      expect(restored.uploadStatus, FileUploadStatus.completed);
      expect(restored.uploadProgress, isNull);
    });

    test('toJson() omits null fields for compact storage', () {
      const minimal = FileAttachment(
        id: 'file-1',
        url: 'https://example.com/file.txt',
        name: 'file.txt',
        extension: 'txt',
        size: 100,
      );

      final json = minimal.toJson();
      expect(json.containsKey('mimeType'), isFalse);
      expect(json.containsKey('pageCount'), isFalse);
      expect(json.containsKey('thumbnailUrl'), isFalse);
      expect(json.containsKey('localPath'), isFalse);
      expect(json.containsKey('width'), isFalse);
      expect(json.containsKey('height'), isFalse);
      expect(json.containsKey('durationMs'), isFalse);
      expect(json.containsKey('waveform'), isFalse);
    });

    test('fromJson() handles missing optional fields gracefully', () {
      final json = <String, dynamic>{
        'id': 'file-1',
        'url': 'https://example.com/file.txt',
        'name': 'file.txt',
        'ext': 'txt',
        'size': 100,
      };

      final attachment = FileAttachment.fromJson(json);
      expect(attachment.id, 'file-1');
      expect(attachment.name, 'file.txt');
      expect(attachment.mimeType, isNull);
      expect(attachment.pageCount, isNull);
      expect(attachment.duration, isNull);
      expect(attachment.waveform, isNull);
      expect(attachment.uploadStatus, FileUploadStatus.completed);
    });

    test('formats file size correctly', () {
      expect(
        const FileAttachment(
          id: 'file-1',
          url: 'https://example.com/file.txt',
          name: 'file.txt',
          extension: 'txt',
          size: 500,
        ).formattedSize,
        '500 B',
      );

      expect(
        const FileAttachment(
          id: 'file-2',
          url: 'https://example.com/file.txt',
          name: 'file.txt',
          extension: 'txt',
          size: 2048,
        ).formattedSize,
        '2.0 KB',
      );

      expect(
        const FileAttachment(
          id: 'file-3',
          url: 'https://example.com/file.txt',
          name: 'file.txt',
          extension: 'txt',
          size: 5242880,
        ).formattedSize,
        '5.0 MB',
      );
    });
  });
}
