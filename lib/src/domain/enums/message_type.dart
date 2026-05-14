/// Type of message content.
enum MessageType {
  /// Plain text message.
  text,

  /// Image attachment.
  image,

  /// Video attachment.
  video,

  /// Audio attachment.
  audio,

  /// Generic file attachment.
  file,

  /// System notification message (room events).
  system,

  /// Legacy system notification message (alias).
  notification,
}
