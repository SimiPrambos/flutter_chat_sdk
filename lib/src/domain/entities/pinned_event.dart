import 'package:equatable/equatable.dart';

/// A pinned message event that tracks when a message was pinned/unpinned.
///
/// Unlike the `isPinned` flag on Message which only tracks current state,
/// PinnedEvent maintains a history of pin/unpin actions for displaying
/// notifications in the chat stream.
class PinnedEvent extends Equatable {
  /// Creates a pinned event.
  const PinnedEvent({
    required this.id,
    required this.messageId,
    required this.roomId,
    required this.pinnedBy,
    required this.pinnedAt,
    this.unpinnedAt,
  });

  /// Unique event ID.
  final String id;

  /// ID of the message that was pinned.
  final String messageId;

  /// Room ID where the message belongs.
  final String roomId;

  /// User ID who pinned the message.
  final String pinnedBy;

  /// When the pin action occurred (for positioning in chat stream).
  final DateTime pinnedAt;

  /// When the message was unpinned (null if still pinned).
  final DateTime? unpinnedAt;

  /// Whether this pin is currently active.
  bool get isActive => unpinnedAt == null;

  /// Creates a copy with updated fields.
  PinnedEvent copyWith({
    String? id,
    String? messageId,
    String? roomId,
    String? pinnedBy,
    DateTime? pinnedAt,
    DateTime? unpinnedAt,
  }) {
    return PinnedEvent(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      roomId: roomId ?? this.roomId,
      pinnedBy: pinnedBy ?? this.pinnedBy,
      pinnedAt: pinnedAt ?? this.pinnedAt,
      unpinnedAt: unpinnedAt ?? this.unpinnedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        messageId,
        roomId,
        pinnedBy,
        pinnedAt,
        unpinnedAt,
      ];
}
