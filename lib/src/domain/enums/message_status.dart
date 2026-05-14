/// Message delivery status.
///
/// Tracks the lifecycle of a message from creation to being read.
enum MessageStatus {
  /// Message created locally, not yet queued.
  draft,

  /// Message is in outbound queue, waiting to be sent.
  pending,

  /// Message is being sent to server.
  sending,

  /// Server acknowledged receipt of the message.
  sent,

  /// Message delivered to recipient's device.
  delivered,

  /// Message has been read by recipient.
  read,

  /// Message failed to send (will be retried).
  failed,
}
