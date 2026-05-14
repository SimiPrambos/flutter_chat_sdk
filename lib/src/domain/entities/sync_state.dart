import 'package:flutter_chat_sdk/src/domain/entities/chat_event.dart';
import 'package:flutter_chat_sdk/src/domain/entities/conversation.dart';
import 'package:flutter_chat_sdk/src/domain/entities/message.dart';
import 'package:equatable/equatable.dart';

/// State of synchronization.
class SyncState extends Equatable {
  /// Creates sync state.
  const SyncState({
    this.lastSyncToken,
    this.lastSyncAt,
    this.isInitialSyncComplete = false,
  });

  /// Initial state before any sync.
  const SyncState.initial()
      : lastSyncToken = null,
        lastSyncAt = null,
        isInitialSyncComplete = false;

  /// Token for incremental sync.
  final String? lastSyncToken;

  /// When last sync occurred.
  final DateTime? lastSyncAt;

  /// Whether initial sync has completed.
  final bool isInitialSyncComplete;

  /// Creates a copy with updated fields.
  SyncState copyWith({
    String? lastSyncToken,
    DateTime? lastSyncAt,
    bool? isInitialSyncComplete,
  }) {
    return SyncState(
      lastSyncToken: lastSyncToken ?? this.lastSyncToken,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      isInitialSyncComplete:
          isInitialSyncComplete ?? this.isInitialSyncComplete,
    );
  }

  @override
  List<Object?> get props => [lastSyncToken, lastSyncAt, isInitialSyncComplete];
}

/// Result of a sync operation.
class SyncResult extends Equatable {
  const SyncResult({
    this.conversations = const [],
    this.messages = const [],
    this.events = const [],
    this.nextSyncToken,
    this.hasMore = false,
  });

  const SyncResult.empty()
      : conversations = const [],
        messages = const [],
        events = const [],
        nextSyncToken = null,
        hasMore = false;

  final List<Conversation> conversations;
  final List<Message> messages;
  final List<ChatEvent> events;
  final String? nextSyncToken;
  final bool hasMore;

  @override
  List<Object?> get props =>
      [conversations, messages, events, nextSyncToken, hasMore];
}

/// Result of loading paginated messages.
class LoadMessagesResult {
  const LoadMessagesResult({
    this.messages = const [],
    this.prevBatch,
    this.hasMore = false,
  });

  /// Loaded messages.
  final List<Message> messages;

  /// Cursor for loading the next (older) page.
  final String? prevBatch;

  /// Whether there are more messages to load.
  final bool hasMore;
}
