// packages/chat/lib/src/core/media/attachment_type_strategy.dart

/// Strategy for customizing which file extensions are treated as each media
/// type and for overriding MIME type lookups.
///
/// Extend [DefaultAttachmentTypeStrategy] for small customizations, or
/// implement this interface to replace the defaults entirely.
abstract class AttachmentTypeStrategy {
  const AttachmentTypeStrategy();

  /// Extensions that are treated as images (without leading dot, lowercase).
  List<String> get imageExtensions;

  /// Extensions that are treated as video (without leading dot, lowercase).
  List<String> get videoExtensions;

  /// Extensions that are treated as audio (without leading dot, lowercase).
  List<String> get audioExtensions;

  /// Return a non-null MIME type to override the default lookup for
  /// [extension]. [extension] is already normalized (no dot, lowercase).
  String? mimeTypeOverride(String extension);
}

/// Default extension sets used by `MediaTypeResolver`.
class DefaultAttachmentTypeStrategy extends AttachmentTypeStrategy {
  const DefaultAttachmentTypeStrategy();

  @override
  List<String> get imageExtensions => const [
        'jpg',
        'jpeg',
        'png',
        'gif',
        'webp',
        'bmp',
        'svg',
        'heic',
        'heif',
      ];

  @override
  List<String> get videoExtensions => const [
        'mp4',
        'mov',
        'avi',
        'mkv',
        'webm',
      ];

  @override
  List<String> get audioExtensions => const [
        'mp3',
        'wav',
        'aac',
        'm4a',
        'ogg',
      ];

  @override
  String? mimeTypeOverride(String extension) => null;
}
