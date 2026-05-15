// packages/chat/lib/src/core/media/media_type_resolver.dart

import 'package:flutter_chat_sdk/src/core/media/attachment_type_strategy.dart';
import 'package:flutter_chat_sdk/src/domain/entities/file_attachment.dart';
import 'package:flutter_chat_sdk/src/domain/enums/message_type.dart';

export 'attachment_type_strategy.dart';

/// Single source of truth for MIME type mapping, extension normalization,
/// media type detection, and [MessageType] inference from attachments.
///
/// Use [resolveAttachment] whenever building a [FileAttachment] from raw server
/// data to guarantee consistent extension normalization and MIME derivation.
///
/// Use [inferMessageType] after building attachments to determine the correct
/// [MessageType] — do not rely on the server's raw type string when attachments
/// are present.
class MediaTypeResolver {
  const MediaTypeResolver({
    this.strategy = const DefaultAttachmentTypeStrategy(),
  });

  final AttachmentTypeStrategy strategy;

  // ─── Normalization ───────────────────────────────────────────────────────

  /// Strips a leading dot and lowercases [raw].
  /// `'.JPG'` → `'jpg'`, `'PDF'` → `'pdf'`, `''` → `''`.
  String normalizeExtension(String raw) {
    final lower = raw.trim().toLowerCase();
    return lower.startsWith('.') ? lower.substring(1) : lower;
  }

  /// Extracts the extension from [fileName] (no leading dot, lowercase).
  /// Returns `''` if the name has no extension.
  String extensionFromFileName(String fileName) {
    final i = fileName.lastIndexOf('.');
    if (i > 0 && i < fileName.length - 1) {
      return fileName.substring(i + 1).toLowerCase();
    }
    return '';
  }

  /// Resolves the best extension from an explicit raw extension with a filename
  /// fallback.
  ///
  /// Resolution order:
  /// 1. [rawExtension] normalized
  /// 2. [fallbackFileName] via [extensionFromFileName]
  String resolveExtension(String rawExtension, {String? fallbackFileName}) {
    final normalized = normalizeExtension(rawExtension);
    if (normalized.isNotEmpty) return normalized;
    if (fallbackFileName != null) {
      return extensionFromFileName(fallbackFileName);
    }
    return '';
  }

  // ─── Type checks ─────────────────────────────────────────────────────────

  bool isImage(String extension) =>
      strategy.imageExtensions.contains(normalizeExtension(extension));

  bool isVideo(String extension) =>
      strategy.videoExtensions.contains(normalizeExtension(extension));

  bool isAudio(String extension) =>
      strategy.audioExtensions.contains(normalizeExtension(extension));

  // ─── MIME lookup ─────────────────────────────────────────────────────────

  /// Returns the canonical MIME type for [extension].
  /// Falls back to `'application/octet-stream'` for unknown extensions.
  String mimeTypeFromExtension(String extension) {
    final ext = normalizeExtension(extension);
    final override = strategy.mimeTypeOverride(ext);
    if (override != null) return override;
    return _defaultMime(ext);
  }

  /// Returns the canonical extension for [mimeType], or `''` if unrecognized.
  String extensionFromMimeType(String mimeType) {
    switch (mimeType.toLowerCase()) {
      case 'image/jpeg':
      case 'image/jpg':
        return 'jpg';
      case 'image/png':
        return 'png';
      case 'image/gif':
        return 'gif';
      case 'image/webp':
        return 'webp';
      case 'image/bmp':
        return 'bmp';
      case 'image/svg+xml':
        return 'svg';
      case 'image/heic':
        return 'heic';
      case 'image/heif':
        return 'heif';
      case 'video/mp4':
        return 'mp4';
      case 'video/quicktime':
        return 'mov';
      case 'audio/mpeg':
        return 'mp3';
      case 'audio/wav':
        return 'wav';
      case 'audio/aac':
        return 'aac';
      case 'audio/mp4':
        return 'm4a';
      case 'application/pdf':
        return 'pdf';
      case 'application/msword':
        return 'doc';
      case 'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
        return 'docx';
      case 'application/vnd.ms-excel':
        return 'xls';
      case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
        return 'xlsx';
      default:
        return '';
    }
  }

  // ─── MessageType inference ───────────────────────────────────────────────

  /// Infers [MessageType] from a list of [FileAttachment]s.
  ///
  /// - Empty → [MessageType.text]
  /// - Any image extension → [MessageType.image]
  /// - Any video extension → [MessageType.video]
  /// - Any audio extension → [MessageType.audio]
  /// - Otherwise → [MessageType.file]
  MessageType inferMessageType(List<FileAttachment> attachments) {
    if (attachments.isEmpty) return MessageType.text;
    if (attachments.any((a) => isImage(a.extension))) return MessageType.image;
    if (attachments.any((a) => isVideo(a.extension))) return MessageType.video;
    if (attachments.any((a) => isAudio(a.extension))) return MessageType.audio;
    return MessageType.file;
  }

  MessageType inferMessageTypeFromExtension(String extension) {
    if (isImage(extension)) return MessageType.image;
    if (isVideo(extension)) return MessageType.video;
    if (isAudio(extension)) return MessageType.audio;
    return MessageType.file;
  }

  /// Infers [MessageType] from a URL when attachment is uploading.
  ///
  /// For pending uploads, the URL is empty but the extension/mimeType
  /// still indicate the intended file type.
  MessageType inferMessageTypeFromUrl(String? url, String? mimeType) {
    if (url?.isEmpty ?? true) {
      // Infer from MIME type when URL is empty (uploading in progress)
      if (mimeType?.startsWith('image/') ?? false) return MessageType.image;
      if (mimeType?.startsWith('video/') ?? false) return MessageType.video;
      if (mimeType?.startsWith('audio/') ?? false) return MessageType.audio;
      return MessageType.file;
    }
    // When URL is available, use standard type checking
    return inferMessageTypeFromExtension(url!.split('.').lastOrNull ?? '');
  }

  // ─── Attachment builder ──────────────────────────────────────────────────

  /// Builds a `FileAttachment` from raw server data, normalizing `rawExtension`
  /// and deriving `mimeType` consistently.
  ///
  /// This is the single entry point for constructing `FileAttachment` from
  /// server responses or socket events.
  FileAttachment resolveAttachment({
    required String id,
    required String url,
    required String fileName,
    String? rawExtension,
    String? rawMimeType,
    int size = 0,
    int? pageCount,
    String? thumbnailUrl,
    int? width,
    int? height,
    String? thumbhash,
    String? blurhash,
    Duration? duration,
    List<double>? waveform,
  }) {
    var ext = (rawExtension != null && rawExtension.isNotEmpty)
        ? normalizeExtension(rawExtension)
        : extensionFromFileName(fileName);

    // Fallback 1: reverse-map a specific MIME type to extension so that
    // inferMessageType() classifies the attachment correctly (e.g. the sync
    // API sends mime but no extension field).
    if (ext.isEmpty &&
        rawMimeType != null &&
        rawMimeType.isNotEmpty &&
        rawMimeType != 'application/octet-stream') {
      ext = extensionFromMimeType(rawMimeType);
    }

    // Fallback 2: try the URL path segment (strip query params) — CDN URLs
    // commonly preserve the original file extension even when the metadata
    // fields (extension, file_name, mime_type) are absent or generic.
    if (ext.isEmpty && url.isNotEmpty) {
      final urlBasename = url.split('?').first.split('/').last;
      ext = extensionFromFileName(urlBasename);
    }

    final mime = (rawMimeType != null &&
            rawMimeType.isNotEmpty &&
            rawMimeType != 'application/octet-stream')
        ? rawMimeType
        : mimeTypeFromExtension(ext);

    return FileAttachment(
      id: id,
      url: url,
      name: fileName,
      extension: ext,
      size: size,
      mimeType: mime,
      pageCount: pageCount,
      thumbnailUrl: thumbnailUrl,
      width: width,
      height: height,
      thumbhash: thumbhash,
      blurhash: blurhash,
      duration: duration,
      waveform: waveform,
    );
  }

  // ─── Private ─────────────────────────────────────────────────────────────

  String _defaultMime(String ext) {
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'bmp':
        return 'image/bmp';
      case 'svg':
        return 'image/svg+xml';
      case 'heic':
        return 'image/heic';
      case 'heif':
        return 'image/heif';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'avi':
        return 'video/x-msvideo';
      case 'mkv':
        return 'video/x-matroska';
      case 'webm':
        return 'video/webm';
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'aac':
        return 'audio/aac';
      case 'm4a':
        return 'audio/mp4';
      case 'ogg':
        return 'audio/ogg';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'txt':
        return 'text/plain';
      case 'csv':
        return 'text/csv';
      case 'zip':
        return 'application/zip';
      default:
        return 'application/octet-stream';
    }
  }
}
