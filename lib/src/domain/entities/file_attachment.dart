import 'package:equatable/equatable.dart';

/// Status of file upload.
enum FileUploadStatus {
  /// Not yet started.
  pending,

  /// Currently uploading.
  uploading,

  /// Upload completed.
  completed,

  /// Upload failed.
  failed,
}

/// File attachment in a message.
class FileAttachment extends Equatable {
  /// Creates a file attachment.
  const FileAttachment({
    required this.id,
    required this.url,
    required this.name,
    required this.extension,
    required this.size,
    this.mimeType,
    this.pageCount,
    this.thumbnailUrl,
    this.uploadStatus = FileUploadStatus.completed,
    this.uploadProgress,
    this.localPath,
    this.width,
    this.height,
    this.thumbhash,
    this.blurhash,
    this.duration,
    this.waveform,
  });

  /// Creates a [FileAttachment] from a JSON map (database storage format).
  factory FileAttachment.fromJson(Map<String, dynamic> json) {
    return FileAttachment(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
      name: json['name'] as String? ?? '',
      extension: json['ext'] as String? ?? '',
      size: json['size'] as int? ?? 0,
      mimeType: json['mimeType'] as String?,
      pageCount: json['pageCount'] as int?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      uploadStatus: FileUploadStatus.completed,
      localPath: json['localPath'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      thumbhash: json['thumbhash'] as String?,
      blurhash: json['blurhash'] as String?,
      duration: json['durationMs'] != null
          ? Duration(milliseconds: json['durationMs'] as int)
          : null,
      waveform: (json['waveform'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  /// Unique identifier.
  final String id;

  /// Remote URL of the file.
  final String url;

  /// Original file name.
  final String name;

  /// File extension (pdf, jpg, etc.).
  final String extension;

  /// File size in bytes.
  final int size;

  /// MIME type of the file.
  final String? mimeType;

  /// Number of pages (for PDFs).
  final int? pageCount;

  /// Thumbnail URL for preview.
  final String? thumbnailUrl;

  /// Current upload status.
  final FileUploadStatus uploadStatus;

  /// Upload progress (0.0 to 1.0).
  final double? uploadProgress;

  /// Local file path (if cached).
  final String? localPath;

  /// Width in pixels (for image/video).
  final int? width;

  /// Height in pixels (for image/video).
  final int? height;

  /// Thumbhash placeholder for image.
  final String? thumbhash;

  /// Blurhash placeholder for image.
  final String? blurhash;

  /// Duration (for audio/video).
  final Duration? duration;

  /// Waveform data for audio visualization.
  final List<double>? waveform;

  /// File name (alias for [name] for API compatibility).
  String get fileName => name;

  /// Whether this is an image file.
  bool get isImage {
    final ext = extension.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext);
  }

  /// Whether this is a video file.
  bool get isVideo {
    final ext = extension.toLowerCase();
    return ['mp4', 'mov', 'avi', 'mkv', 'webm'].contains(ext);
  }

  /// Whether this is an audio file.
  bool get isAudio {
    final ext = extension.toLowerCase();
    return ['mp3', 'wav', 'aac', 'm4a', 'ogg'].contains(ext);
  }

  /// Whether this is a PDF file.
  bool get isPdf => extension.toLowerCase() == 'pdf';

  /// Human-readable file size.
  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Converts this attachment to a JSON map for database storage.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'url': url,
      'name': name,
      'ext': extension,
      'size': size,
      if (mimeType != null) 'mimeType': mimeType,
      if (pageCount != null) 'pageCount': pageCount,
      if (thumbnailUrl != null) 'thumbnailUrl': thumbnailUrl,
      if (localPath != null) 'localPath': localPath,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (thumbhash != null) 'thumbhash': thumbhash,
      if (blurhash != null) 'blurhash': blurhash,
      if (duration != null) 'durationMs': duration!.inMilliseconds,
      if (waveform != null) 'waveform': waveform,
    };
  }

  /// Creates a copy with updated fields.
  FileAttachment copyWith({
    String? id,
    String? url,
    String? name,
    String? extension,
    int? size,
    String? mimeType,
    int? pageCount,
    String? thumbnailUrl,
    FileUploadStatus? uploadStatus,
    double? uploadProgress,
    String? localPath,
    int? width,
    int? height,
    String? thumbhash,
    String? blurhash,
    Duration? duration,
    List<double>? waveform,
  }) {
    return FileAttachment(
      id: id ?? this.id,
      url: url ?? this.url,
      name: name ?? this.name,
      extension: extension ?? this.extension,
      size: size ?? this.size,
      mimeType: mimeType ?? this.mimeType,
      pageCount: pageCount ?? this.pageCount,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      localPath: localPath ?? this.localPath,
      width: width ?? this.width,
      height: height ?? this.height,
      thumbhash: thumbhash ?? this.thumbhash,
      blurhash: blurhash ?? this.blurhash,
      duration: duration ?? this.duration,
      waveform: waveform ?? this.waveform,
    );
  }

  @override
  List<Object?> get props => [
        id,
        url,
        name,
        extension,
        size,
        mimeType,
        pageCount,
        thumbnailUrl,
        uploadStatus,
        uploadProgress,
        localPath,
        width,
        height,
        thumbhash,
        blurhash,
        duration,
        waveform,
      ];
}

/// Progress of file upload.
class FileUploadProgress extends Equatable {
  /// Creates file upload progress.
  const FileUploadProgress({
    required this.fileId,
    required this.progress,
    required this.status,
    this.error,
    this.attachment,
  });

  /// File identifier.
  final String fileId;

  /// Progress (0.0 to 1.0).
  final double progress;

  /// Current status.
  final FileUploadStatus status;

  /// Error message if failed.
  final String? error;

  /// Completed attachment (when status is completed).
  final FileAttachment? attachment;

  @override
  List<Object?> get props => [fileId, progress, status, error, attachment];
}
