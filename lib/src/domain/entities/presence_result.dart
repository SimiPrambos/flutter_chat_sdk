import 'package:equatable/equatable.dart';

/// Result of a presence query for a specific user.
class PresenceResult extends Equatable {
  /// Creates a presence result.
  const PresenceResult({
    required this.userId,
    required this.active,
    this.lastSeen,
  });

  /// The queried user's ID.
  final String userId;

  /// Whether the user is currently online.
  final bool active;

  /// Last time the user was seen online (null if currently active).
  final DateTime? lastSeen;

  @override
  List<Object?> get props => [userId, active, lastSeen];
}
