import 'package:equatable/equatable.dart';

/// Emoji reaction on a message.
class Reaction extends Equatable {
  /// Creates a reaction.
  const Reaction({
    required this.id,
    required this.emoji,
    required this.userId,
    this.userName,
    this.createdAt,
  });

  /// Unique identifier.
  final String id;

  /// Emoji character.
  final String emoji;

  /// User who added the reaction.
  final String userId;

  /// Name of user who reacted.
  final String? userName;

  /// When the reaction was added.
  final DateTime? createdAt;

  /// Creates a copy with updated fields.
  Reaction copyWith({
    String? id,
    String? emoji,
    String? userId,
    String? userName,
    DateTime? createdAt,
  }) {
    return Reaction(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, emoji, userId, userName, createdAt];
}
