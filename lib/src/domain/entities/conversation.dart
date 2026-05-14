// lib/src/domain/entities/conversation.dart

import 'package:flutter_chat_sdk/src/domain/entities/message.dart';
import 'package:flutter_chat_sdk/src/domain/entities/participant.dart';
import 'package:flutter_chat_sdk/src/domain/enums/conversation_mode.dart';
import 'package:flutter_chat_sdk/src/domain/enums/conversation_status.dart';
import 'package:flutter_chat_sdk/src/domain/enums/conversation_type.dart';
import 'package:flutter_chat_sdk/src/domain/enums/participant_role.dart';
import 'package:equatable/equatable.dart';

/// A chat conversation (direct message or group).
class Conversation extends Equatable {
  /// Creates a conversation.
  const Conversation({
    required this.id,
    required this.type,
    required this.mode,
    this.name,
    this.avatarUrl,
    this.status = ConversationStatus.active,
    this.participants = const [],
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
    this.shareCode,
    this.expiresAt,
    this.myRole = ParticipantRole.member,
    this.myUserId,
    this.metadata,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String? name;
  final String? avatarUrl;
  final ConversationType type;
  final ConversationMode mode;
  final ConversationStatus status;
  final List<Participant> participants;
  final Message? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final String? shareCode;
  final DateTime? expiresAt;
  final ParticipantRole myRole;
  final String? myUserId;
  final Map<String, dynamic>? metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isDirect => type == ConversationType.direct;
  bool get isGroup => type == ConversationType.group;
  bool get isEphemeral => mode == ConversationMode.ephemeral;
  bool get isStandard => mode == ConversationMode.standard;
  bool get isAdmin => myRole == ParticipantRole.admin;
  bool get isActive => status == ConversationStatus.active;
  bool get isArchived => status == ConversationStatus.archived;
  bool get hasUnread => unreadCount > 0;

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get hasDeletedParticipant {
    if (isEphemeral) return false;
    return myUserId != null && !participants.any((p) => p.userId != myUserId);
  }

  String get displayName {
    if (name != null && name!.isNotEmpty) return name!;
    if (isDirect && participants.isNotEmpty) {
      final other = participants.firstWhere(
        (p) => p.userId != myUserId,
        orElse: () => participants.first,
      );
      return other.displayName;
    }
    return 'Chat';
  }

  String? get displayAvatar {
    if (avatarUrl != null) return avatarUrl;
    if (isDirect && participants.isNotEmpty) {
      final other = participants.firstWhere(
        (p) => p.userId != myUserId,
        orElse: () => participants.first,
      );
      return other.avatarUrl;
    }
    return null;
  }

  Participant? get otherParticipant {
    if (!isDirect || participants.isEmpty) return null;
    return participants.firstWhere(
      (p) => p.userId != myUserId,
      orElse: () => participants.first,
    );
  }

  int get approvedParticipantsCount =>
      participants.where((p) => p.isApproved).length;

  int get onlineParticipantsCount =>
      participants.where((p) => p.isOnline).length;

  Conversation copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    ConversationType? type,
    ConversationMode? mode,
    ConversationStatus? status,
    List<Participant>? participants,
    Message? lastMessage,
    DateTime? lastMessageAt,
    int? unreadCount,
    String? shareCode,
    DateTime? expiresAt,
    ParticipantRole? myRole,
    String? myUserId,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      type: type ?? this.type,
      mode: mode ?? this.mode,
      status: status ?? this.status,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      shareCode: shareCode ?? this.shareCode,
      expiresAt: expiresAt ?? this.expiresAt,
      myRole: myRole ?? this.myRole,
      myUserId: myUserId ?? this.myUserId,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id, name, avatarUrl, type, mode, status, participants,
        lastMessage, lastMessageAt, unreadCount, shareCode, expiresAt,
        myRole, myUserId, metadata, createdAt, updatedAt,
      ];
}

/// Filter for querying conversations.
class ConversationFilter extends Equatable {
  const ConversationFilter({
    this.mode,
    this.status,
    this.type,
    this.searchQuery,
  });

  final ConversationMode? mode;
  final ConversationStatus? status;
  final ConversationType? type;
  final String? searchQuery;

  @override
  List<Object?> get props => [mode, status, type, searchQuery];
}
