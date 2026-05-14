import 'package:flutter_chat_sdk/src/domain/enums/participant_role.dart';
import 'package:flutter_chat_sdk/src/domain/enums/participant_status.dart';
import 'package:equatable/equatable.dart';

/// Participant in a chat room.
class Participant extends Equatable {
  /// Creates a participant.
  const Participant({
    required this.id,
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    this.role = ParticipantRole.member,
    this.status = ParticipantStatus.approved,
    this.isOnline = false,
    this.lastSeenAt,
    this.joinedAt,
  });

  /// Unique participant ID.
  final String id;

  /// User ID.
  final String userId;

  /// Display name in this room.
  final String displayName;

  /// Avatar URL.
  final String? avatarUrl;

  /// Role in the room.
  final ParticipantRole role;

  /// Membership status.
  final ParticipantStatus status;

  /// Whether currently online.
  final bool isOnline;

  /// Last seen timestamp.
  final DateTime? lastSeenAt;

  /// When user joined the room.
  final DateTime? joinedAt;

  /// Whether participant is an admin.
  bool get isAdmin => role == ParticipantRole.admin;

  /// Whether participant is approved.
  bool get isApproved => status == ParticipantStatus.approved;

  /// Whether participant is pending.
  bool get isPending => status == ParticipantStatus.pending;

  /// Creates a copy with updated fields.
  Participant copyWith({
    String? id,
    String? userId,
    String? displayName,
    String? avatarUrl,
    ParticipantRole? role,
    ParticipantStatus? status,
    bool? isOnline,
    DateTime? lastSeenAt,
    DateTime? joinedAt,
  }) {
    return Participant(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      isOnline: isOnline ?? this.isOnline,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        displayName,
        avatarUrl,
        role,
        status,
        isOnline,
        lastSeenAt,
        joinedAt,
      ];
}
