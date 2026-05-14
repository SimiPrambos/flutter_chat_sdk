/// Status of a participant's membership.
enum ParticipantStatus {
  /// Waiting for approval to join.
  pending,

  /// Approved and active member.
  approved,

  /// Join request was rejected.
  rejected,
}
