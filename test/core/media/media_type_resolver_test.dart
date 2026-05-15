// packages/chat/test/core/media/media_type_resolver_test.dart
import 'package:flutter_chat_sdk/src/core/media/media_type_resolver.dart';
import 'package:flutter_chat_sdk/src/domain/entities/file_attachment.dart';
import 'package:flutter_chat_sdk/src/domain/enums/message_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MediaTypeResolver resolver;

  setUp(() {
    resolver = const MediaTypeResolver();
  });

  group('normalizeExtension', () {
    test('strips leading dot', () {
      expect(resolver.normalizeExtension('.jpg'), 'jpg');
    });
    test('lowercases uppercase', () {
      expect(resolver.normalizeExtension('JPG'), 'jpg');
    });
    test('handles already normalized', () {
      expect(resolver.normalizeExtension('png'), 'png');
    });
    test('handles empty string', () {
      expect(resolver.normalizeExtension(''), '');
    });
    test('handles dot with uppercase', () {
      expect(resolver.normalizeExtension('.PNG'), 'png');
    });
  });

  group('mimeTypeFromExtension', () {
    test('jpg → image/jpeg', () {
      expect(resolver.mimeTypeFromExtension('jpg'), 'image/jpeg');
    });
    test('.JPEG → image/jpeg (dot + uppercase)', () {
      expect(resolver.mimeTypeFromExtension('.JPEG'), 'image/jpeg');
    });
    test('png → image/png', () {
      expect(resolver.mimeTypeFromExtension('png'), 'image/png');
    });
    test('heic → image/heic', () {
      expect(resolver.mimeTypeFromExtension('heic'), 'image/heic');
    });
    test('heif → image/heif', () {
      expect(resolver.mimeTypeFromExtension('heif'), 'image/heif');
    });
    test('pdf → application/pdf', () {
      expect(resolver.mimeTypeFromExtension('pdf'), 'application/pdf');
    });
    test('mp4 → video/mp4', () {
      expect(resolver.mimeTypeFromExtension('mp4'), 'video/mp4');
    });
    test('mp3 → audio/mpeg', () {
      expect(resolver.mimeTypeFromExtension('mp3'), 'audio/mpeg');
    });
    test('unknown → application/octet-stream', () {
      expect(resolver.mimeTypeFromExtension('xyz'), 'application/octet-stream');
    });
    test('empty → application/octet-stream', () {
      expect(resolver.mimeTypeFromExtension(''), 'application/octet-stream');
    });
  });

  group('isImage', () {
    test('jpg is image', () => expect(resolver.isImage('jpg'), isTrue));
    test('jpeg is image', () => expect(resolver.isImage('jpeg'), isTrue));
    test('png is image', () => expect(resolver.isImage('png'), isTrue));
    test('heic is image', () => expect(resolver.isImage('heic'), isTrue));
    test('heif is image', () => expect(resolver.isImage('heif'), isTrue));
    test('.PNG is image (dot prefix)',
        () => expect(resolver.isImage('.PNG'), isTrue),);
    test('pdf is not image', () => expect(resolver.isImage('pdf'), isFalse));
    test('mp4 is not image', () => expect(resolver.isImage('mp4'), isFalse));
    test('empty is not image', () => expect(resolver.isImage(''), isFalse));
  });

  group('inferMessageType', () {
    test('empty list → text', () {
      expect(resolver.inferMessageType([]), MessageType.text);
    });
    test('jpg attachment → image', () {
      expect(
        resolver.inferMessageType([_makeAttachment('photo.jpg', 'jpg')]),
        MessageType.image,
      );
    });
    test('heic attachment → image', () {
      expect(
        resolver.inferMessageType([_makeAttachment('photo.heic', 'heic')]),
        MessageType.image,
      );
    });
    test('pdf attachment → file', () {
      expect(
        resolver.inferMessageType([_makeAttachment('doc.pdf', 'pdf')]),
        MessageType.file,
      );
    });
    test('docx attachment → file', () {
      expect(
        resolver.inferMessageType([_makeAttachment('report.docx', 'docx')]),
        MessageType.file,
      );
    });
    test('image + file mixed → image (image takes precedence)', () {
      expect(
        resolver.inferMessageType([
          _makeAttachment('photo.jpg', 'jpg'),
          _makeAttachment('doc.pdf', 'pdf'),
        ]),
        MessageType.image,
      );
    });
  });

  group('resolveAttachment', () {
    test('normalizes uppercase extension from rawExtension', () {
      final a = resolver.resolveAttachment(
        id: '1',
        url: 'https://example.com/file.JPG',
        fileName: 'photo.JPG',
        rawExtension: '.JPG',
      );
      expect(a.extension, 'jpg');
      expect(a.mimeType, 'image/jpeg');
    });

    test('falls back to filename when rawExtension is empty', () {
      final a = resolver.resolveAttachment(
        id: '1',
        url: 'https://example.com/photo.png',
        fileName: 'photo.png',
        rawExtension: '',
      );
      expect(a.extension, 'png');
      expect(a.mimeType, 'image/png');
    });

    test('prefers rawMimeType when provided and specific', () {
      final a = resolver.resolveAttachment(
        id: '1',
        url: 'https://example.com/file',
        fileName: 'file.jpg',
        rawExtension: 'jpg',
        rawMimeType: 'image/jpeg',
      );
      expect(a.mimeType, 'image/jpeg');
    });

    test('ignores generic rawMimeType and derives from extension', () {
      final a = resolver.resolveAttachment(
        id: '1',
        url: 'https://example.com/photo.jpg',
        fileName: 'photo.jpg',
        rawExtension: 'jpg',
        rawMimeType: 'application/octet-stream',
      );
      expect(a.mimeType, 'image/jpeg');
    });

    test('never throws on empty input', () {
      expect(
        () => resolver.resolveAttachment(id: '', url: '', fileName: ''),
        returnsNormally,
      );
    });

    test('sets url, name, size correctly', () {
      final a = resolver.resolveAttachment(
        id: 'abc',
        url: 'https://cdn.example.com/f.pdf',
        fileName: 'report.pdf',
        rawExtension: 'pdf',
        size: 12345,
      );
      expect(a.id, 'abc');
      expect(a.url, 'https://cdn.example.com/f.pdf');
      expect(a.name, 'report.pdf');
      expect(a.size, 12345);
    });
  });

  group('AttachmentTypeStrategy customization', () {
    test('custom strategy can add extension', () {
      final customResolver = MediaTypeResolver(
        strategy: _CustomStrategy(),
      );
      expect(customResolver.isImage('raw'), isTrue);
    });

    test('custom strategy mimeTypeOverride takes effect', () {
      final customResolver = MediaTypeResolver(
        strategy: _CustomStrategy(),
      );
      expect(customResolver.mimeTypeFromExtension('raw'), 'image/x-raw');
    });
  });
}

FileAttachment _makeAttachment(String name, String ext) {
  return FileAttachment(id: name, url: '', name: name, extension: ext, size: 0);
}

class _CustomStrategy extends DefaultAttachmentTypeStrategy {
  @override
  List<String> get imageExtensions => [...super.imageExtensions, 'raw'];

  @override
  String? mimeTypeOverride(String extension) {
    if (extension == 'raw') return 'image/x-raw';
    return null;
  }
}
