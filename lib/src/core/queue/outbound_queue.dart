// Internal implementation details — public API docs live on the public facade.
// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';

import 'package:flutter_chat_sdk/src/adapters/chat_adapter.dart';
import 'package:flutter_chat_sdk/src/config/chat_logger.dart';
import 'package:flutter_chat_sdk/src/core/database/chat_database.dart';
import 'package:flutter_chat_sdk/src/domain/domain.dart';

/// Pending operations in the outbound queue.
enum OutboundOperationType {
  sendMessage,
  createRoom,
  deleteRoom,
  starMessage,
  unstarMessage,
  pinMessage,
  unpinMessage,
  addReaction,
  removeReaction,
  markRead,
  archiveRoom,
  unarchiveRoom,
  addParticipants,
  removeParticipant,
  updateParticipantStatus,
}

/// Status of an outbound operation.
enum OutboundOperationStatus {
  pending,
  processing,
  completed,
  failed,
}

/// An outbound operation to be sent to the server.
class OutboundOperation {
  /// Creates an outbound operation.
  OutboundOperation({
    required this.id,
    required this.type,
    required this.data,
    this.retryCount = 0,
    this.status = OutboundOperationStatus.pending,
    DateTime? createdAt,
    this.processedAt,
    this.errorMessage,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Helper to create a send message operation.
  factory OutboundOperation.sendMessage({
    required String messageId,
    required String conversationId,
    required String content,
    MessageType? type,
    String? replyToId,
    List<PendingAttachment>? attachments,
    String? nonce,
    Map<String, dynamic>? extra,
  }) {
    return OutboundOperation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: OutboundOperationType.sendMessage,
      data: jsonEncode({
        'messageId': messageId,
        'conversationId': conversationId,
        'content': content,
        'type': type?.name,
        'replyToId': replyToId,
        'attachments': attachments
            ?.map(
              (a) => {
                'filePath': a.filePath,
                'fileName': a.fileName,
                'mimeType': a.mimeType,
              },
            )
            .toList(),
        'nonce': nonce,
        'extra': extra,
      }),
    );
  }

  /// Helper to create a star message operation.
  factory OutboundOperation.starMessage(String roomId, String messageId) {
    return OutboundOperation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: OutboundOperationType.starMessage,
      data: jsonEncode({'roomId': roomId, 'messageId': messageId}),
    );
  }

  /// Helper to create an unstar message operation.
  factory OutboundOperation.unstarMessage(String messageId) {
    return OutboundOperation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: OutboundOperationType.unstarMessage,
      data: jsonEncode({'messageId': messageId}),
    );
  }

  /// Helper to create a pin message operation.
  factory OutboundOperation.pinMessage(
    String conversationId,
    String messageId,
    Duration? duration,
  ) {
    return OutboundOperation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: OutboundOperationType.pinMessage,
      data: jsonEncode({
        'conversationId': conversationId,
        'messageId': messageId,
        'duration': duration?.inSeconds,
      }),
    );
  }

  /// Helper to create an unpin message operation.
  factory OutboundOperation.unpinMessage(
    String conversationId,
    String messageId,
  ) {
    return OutboundOperation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: OutboundOperationType.unpinMessage,
      data: jsonEncode({
        'conversationId': conversationId,
        'messageId': messageId,
      }),
    );
  }

  /// Helper to create an add reaction operation.
  factory OutboundOperation.addReaction(
    String messageId,
    String emoji,
  ) {
    return OutboundOperation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: OutboundOperationType.addReaction,
      data: jsonEncode({
        'messageId': messageId,
        'emoji': emoji,
      }),
    );
  }

  /// Helper to create a remove reaction operation.
  factory OutboundOperation.removeReaction(
    String messageId,
    String reactionId,
  ) {
    return OutboundOperation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: OutboundOperationType.removeReaction,
      data: jsonEncode({
        'messageId': messageId,
        'reactionId': reactionId,
      }),
    );
  }

  /// Helper to create a mark read operation.
  factory OutboundOperation.markRead(
    String conversationId,
    String messageId,
  ) {
    return OutboundOperation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: OutboundOperationType.markRead,
      data: jsonEncode({
        'conversationId': conversationId,
        'messageId': messageId,
      }),
    );
  }

  /// Helper to create a delete conversation operation.
  factory OutboundOperation.deleteConversation(String conversationId) {
    return OutboundOperation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: OutboundOperationType.deleteRoom,
      data: jsonEncode({
        'conversationId': conversationId,
      }),
    );
  }

  /// Helper to create an archive conversation operation.
  factory OutboundOperation.archiveConversation(String conversationId) {
    return OutboundOperation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: OutboundOperationType.archiveRoom,
      data: jsonEncode({
        'conversationId': conversationId,
      }),
    );
  }

  /// Helper to create an unarchive conversation operation.
  factory OutboundOperation.unarchiveConversation(String conversationId) {
    return OutboundOperation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: OutboundOperationType.unarchiveRoom,
      data: jsonEncode({
        'conversationId': conversationId,
      }),
    );
  }

  /// Unique ID for this operation.
  final String id;

  /// Type of operation.
  final OutboundOperationType type;

  /// Operation data (JSON string).
  final String data;

  /// Number of retry attempts.
  final int retryCount;

  /// Current status.
  final OutboundOperationStatus status;

  /// When operation was created.
  final DateTime createdAt;

  /// When operation was processed.
  final DateTime? processedAt;

  /// Error message if failed.
  final String? errorMessage;

  /// Creates a copy with updated fields.
  OutboundOperation copyWith({
    String? id,
    OutboundOperationType? type,
    String? data,
    int? retryCount,
    OutboundOperationStatus? status,
    DateTime? createdAt,
    DateTime? processedAt,
    String? errorMessage,
  }) {
    return OutboundOperation(
      id: id ?? this.id,
      type: type ?? this.type,
      data: data ?? this.data,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      processedAt: processedAt ?? this.processedAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Interface for outbound queue operations.
///
/// Manages operations to be sent to the server.
/// Operations are queued and retried automatically.
abstract class OutboundQueue {
  /// Initializes the queue, loading any persisted operations.
  Future<void> initialize();

  /// Enqueues an operation.
  Future<void> enqueue(OutboundOperation operation);

  /// Processes the queue.
  Future<void> processQueue();

  /// Stream of pending operations count.
  Stream<int> get pendingCount;

  /// Disposes the queue.
  Future<void> dispose();
}

/// Interface for database operations needed by the queue.
abstract class OutboundQueueDatabase {
  /// Gets all pending outbound operations.
  Future<List<OutboundOperation>> getPendingOperations();

  /// Inserts an outbound operation.
  Future<void> insertOperation(OutboundOperation operation);

  /// Updates an outbound operation.
  Future<void> updateOperation(OutboundOperation operation);

  /// Deletes an outbound operation.
  Future<void> deleteOperation(String operationId);

  /// Deletes all completed operations.
  Future<void> deleteCompletedOperations();
}

/// Configuration for queue retry behavior.
class QueueRetryConfig {
  /// Creates retry configuration.
  const QueueRetryConfig({
    this.maxRetries = 3,
    this.initialDelayMs = 1000,
    this.maxDelayMs = 30000,
    this.backoffMultiplier = 2.0,
  });

  /// Maximum number of retry attempts.
  final int maxRetries;

  /// Initial delay in milliseconds before first retry.
  final int initialDelayMs;

  /// Maximum delay in milliseconds between retries.
  final int maxDelayMs;

  /// Multiplier for exponential backoff.
  final double backoffMultiplier;

  /// Calculates delay for given retry count.
  Duration getDelayForRetry(int retryCount) {
    if (retryCount <= 0) return Duration.zero;
    final delayMs =
        (initialDelayMs * _pow(backoffMultiplier, retryCount - 1)).round();
    return Duration(milliseconds: delayMs.clamp(0, maxDelayMs));
  }

  static double _pow(double base, int exponent) {
    var result = 1.0;
    for (var i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }
}

/// Maximum number of operations allowed in queue.
const int kDefaultMaxQueueSize = 1000;

/// Implementation of [OutboundQueue] with database persistence.
class OutboundQueueImpl implements OutboundQueue {
  /// Creates an outbound queue.
  OutboundQueueImpl({
    required ChatAdapter adapter,
    required ChatDatabase database,
    QueueRetryConfig retryConfig = const QueueRetryConfig(),
    int maxQueueSize = kDefaultMaxQueueSize,
  })  : _adapter = adapter,
        _database = database,
        _retryConfig = retryConfig,
        _maxQueueSize = maxQueueSize;

  final ChatAdapter _adapter;
  final ChatDatabase _database;
  final QueueRetryConfig _retryConfig;
  final int _maxQueueSize;

  final _operations = <OutboundOperation>[];
  final _pendingCountController = StreamController<int>.broadcast();

  /// Lock to prevent concurrent queue processing.
  bool _isProcessing = false;

  /// Whether the queue has been initialized.
  bool _isInitialized = false;

  /// Temporary storage for the last sendMessage result, used to pass
  /// the server-assigned IDs to [_updateMessageStatusAfterSuccess].
  Message? _lastSendResult;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Load persisted operations from database
    final persistedOps = await _database.getPendingOperations();
    _operations.addAll(persistedOps);
    _pendingCountController.add(_operations.length);
    _isInitialized = true;

    final pendingOps = _operations.length;
    ChatLogger.info('OutboundQueue initialized with $pendingOps pending ops');
  }

  @override
  Future<void> enqueue(OutboundOperation operation) async {
    if (!_isInitialized) {
      await initialize();
    }

    // Check for duplicate operations (same type and data)
    // This prevents issues like double-clicking causing duplicate sends
    final isDuplicate = _operations.any(
      (op) =>
          op.type == operation.type &&
          op.data == operation.data &&
          op.status != OutboundOperationStatus.completed,
    );
    if (isDuplicate) {
      ChatLogger.debug(
        'Duplicate operation detected, skipping: ${operation.type}',
      );
      return;
    }

    // Check for canceling opposite operations (e.g., star then unstar)
    final cancelledIndex = await _findAndCancelOpposite(operation);
    if (cancelledIndex >= 0) {
      ChatLogger.debug(
        'Cancelled opposite operation for: ${operation.type}',
      );
      return;
    }

    // Check queue size limit
    if (_operations.length >= _maxQueueSize) {
      ChatLogger.warning(
        'Queue size limit reached ($_maxQueueSize). '
        'Removing oldest failed operation.',
      );
      // Remove oldest failed operation to make room
      final oldestFailed = _operations.indexWhere(
        (op) => op.status == OutboundOperationStatus.failed,
      );
      if (oldestFailed >= 0) {
        final removed = _operations.removeAt(oldestFailed);
        await _database.deleteOperation(removed.id);
      } else {
        // If no failed operations, reject the new one
        throw StateError(
          'Queue is full and no failed operations to remove',
        );
      }
    }

    _operations.add(operation);
    await _database.insertOperation(operation);
    _pendingCountController.add(_operations.length);

    // Flush immediately if not already processing.
    unawaited(processQueue());
  }

  /// Finds and cancels an opposite operation in the queue.
  /// Returns the index of cancelled operation, or -1 if none found.
  Future<int> _findAndCancelOpposite(OutboundOperation operation) async {
    final oppositeType = _getOppositeType(operation.type);
    if (oppositeType == null) return -1;

    final data = jsonDecode(operation.data) as Map<String, dynamic>;

    for (var i = 0; i < _operations.length; i++) {
      final existing = _operations[i];

      // Skip if not the opposite type or already completed/processing
      if (existing.type != oppositeType) continue;
      if (existing.status == OutboundOperationStatus.completed) continue;
      if (existing.status == OutboundOperationStatus.processing) continue;

      final existingData = jsonDecode(existing.data) as Map<String, dynamic>;

      // Check if the operations target the same entity
      if (_targetsTheSameEntity(operation.type, data, existingData)) {
        // Remove the opposite operation
        _operations.removeAt(i);
        await _database.deleteOperation(existing.id);
        _pendingCountController.add(_operations.length);
        return i;
      }
    }

    return -1;
  }

  /// Returns the opposite operation type, or null if there is none.
  OutboundOperationType? _getOppositeType(OutboundOperationType type) {
    switch (type) {
      case OutboundOperationType.starMessage:
        return OutboundOperationType.unstarMessage;
      case OutboundOperationType.unstarMessage:
        return OutboundOperationType.starMessage;
      case OutboundOperationType.pinMessage:
        return OutboundOperationType.unpinMessage;
      case OutboundOperationType.unpinMessage:
        return OutboundOperationType.pinMessage;
      case OutboundOperationType.addReaction:
        return OutboundOperationType.removeReaction;
      case OutboundOperationType.removeReaction:
        return OutboundOperationType.addReaction;
      case OutboundOperationType.archiveRoom:
        return OutboundOperationType.unarchiveRoom;
      case OutboundOperationType.unarchiveRoom:
        return OutboundOperationType.archiveRoom;
      case OutboundOperationType.sendMessage:
      case OutboundOperationType.createRoom:
      case OutboundOperationType.deleteRoom:
      case OutboundOperationType.markRead:
      case OutboundOperationType.addParticipants:
      case OutboundOperationType.removeParticipant:
      case OutboundOperationType.updateParticipantStatus:
        return null;
    }
  }

  /// Checks if two operations target the same entity.
  bool _targetsTheSameEntity(
    OutboundOperationType type,
    Map<String, dynamic> data1,
    Map<String, dynamic> data2,
  ) {
    switch (type) {
      case OutboundOperationType.starMessage:
      case OutboundOperationType.unstarMessage:
        return data1['messageId'] == data2['messageId'];

      case OutboundOperationType.pinMessage:
      case OutboundOperationType.unpinMessage:
        return data1['conversationId'] == data2['conversationId'] &&
            data1['messageId'] == data2['messageId'];

      case OutboundOperationType.addReaction:
      case OutboundOperationType.removeReaction:
        // For reactions, match by messageId and emoji (for add/remove)
        return data1['messageId'] == data2['messageId'] &&
            data1['emoji'] == data2['emoji'];

      case OutboundOperationType.archiveRoom:
      case OutboundOperationType.unarchiveRoom:
        return data1['conversationId'] == data2['conversationId'];

      case OutboundOperationType.sendMessage:
      case OutboundOperationType.createRoom:
      case OutboundOperationType.deleteRoom:
      case OutboundOperationType.markRead:
      case OutboundOperationType.addParticipants:
      case OutboundOperationType.removeParticipant:
      case OutboundOperationType.updateParticipantStatus:
        return false;
    }
  }

  @override
  Future<void> processQueue() async {
    if (!_isInitialized) {
      await initialize();
    }

    // Only process when the adapter has an active connection.
    // Enqueuing while offline is fine — processQueue() is called again
    // when the connection is restored (see Chat._connectionState listener).
    if (!_adapter.isConnected) return;

    // Prevent concurrent processing
    if (_isProcessing) {
      ChatLogger.debug('Queue already processing, skipping');
      return;
    }

    _isProcessing = true;

    try {
      await _processQueueInternal();
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _processQueueInternal() async {
    while (_operations.isNotEmpty) {
      final operation = _operations.first;

      // Skip already completed operations
      if (operation.status == OutboundOperationStatus.completed) {
        _operations.removeAt(0);
        await _database.deleteOperation(operation.id);
        continue;
      }

      // Check if this is a retry and we should wait
      if (operation.status == OutboundOperationStatus.failed) {
        if (operation.retryCount >= _retryConfig.maxRetries) {
          ChatLogger.warning(
            'Operation ${operation.id} exceeded max retries, skipping',
          );
          _operations.removeAt(0);
          // Keep in database for potential manual retry
          continue;
        }

        // Wait for backoff delay
        final delay = _retryConfig.getDelayForRetry(operation.retryCount);
        if (delay > Duration.zero) {
          final retryNum = operation.retryCount + 1;
          ChatLogger.debug(
            'Waiting ${delay.inMilliseconds}ms before retry $retryNum',
          );
          await Future<void>.delayed(delay);
        }
      }

      // Update status to processing
      final processingOp = operation.copyWith(
        status: OutboundOperationStatus.processing,
      );
      _operations[0] = processingOp;
      await _database.updateOperation(processingOp);

      try {
        _lastSendResult = null;
        await _executeOperation(operation);

        // Update message status to sent after successful send.
        await _updateMessageStatusAfterSuccess(operation);

        // Mark as completed and remove
        _operations.removeAt(0);
        await _database.deleteOperation(operation.id);
        _pendingCountController.add(_operations.length);

        ChatLogger.debug('Operation ${operation.id} completed successfully');
      } on Exception catch (e, s) {
        ChatLogger.error('Operation ${operation.id} failed', e, s);

        // Update with failure status and increment retry count
        final failedOp = operation.copyWith(
          status: OutboundOperationStatus.failed,
          retryCount: operation.retryCount + 1,
          processedAt: DateTime.now(),
          errorMessage: e.toString(),
        );

        _operations[0] = failedOp;
        await _database.updateOperation(failedOp);

        // If we have retries left, continue to next operation but
        // move failed operation to end for retry later
        if (failedOp.retryCount < _retryConfig.maxRetries) {
          _operations
            ..removeAt(0)
            ..add(failedOp);
          final retryAttempt = failedOp.retryCount;
          final maxRetries = _retryConfig.maxRetries;
          ChatLogger.debug(
            'Operation ${operation.id} will retry '
            '(attempt $retryAttempt/$maxRetries)',
          );
        } else {
          // Max retries exceeded — update message to failed status.
          await _updateMessageStatusOnFailure(operation);
          _operations.removeAt(0);
          final maxRetries = _retryConfig.maxRetries;
          ChatLogger.warning(
            'Operation ${operation.id} failed permanently '
            'after $maxRetries retries',
          );
        }
      }
    }
  }

  Future<void> _executeOperation(OutboundOperation operation) async {
    try {
      final data = jsonDecode(operation.data) as Map<String, dynamic>;

      switch (operation.type) {
        case OutboundOperationType.sendMessage:
          final params = SendMessageParams(
            conversationId: data['conversationId'] as String,
            content: data['content'] as String,
            type: data['type'] != null
                ? MessageType.values.byName(data['type'] as String)
                : MessageType.text,
            replyToId: data['replyToId'] as String?,
            attachments: (data['attachments'] as List<dynamic>?)
                ?.cast<Map<String, dynamic>>()
                .map(
                  (a) => PendingAttachment(
                    filePath: a['filePath']! as String,
                    fileName: a['fileName']! as String,
                    mimeType: a['mimeType']! as String,
                  ),
                )
                .toList(),
            nonce: data['nonce'] as String?,
            extra: data['extra'] as Map<String, dynamic>?,
          );
          _lastSendResult = await _adapter.sendMessage(params);

        case OutboundOperationType.starMessage:
          await _adapter.starMessage(
            data['roomId'] as String,
            data['messageId'] as String,
          );

        case OutboundOperationType.unstarMessage:
          await _adapter.unstarMessage(data['messageId'] as String);

        case OutboundOperationType.pinMessage:
          final duration = data['duration'] as int?;
          await _adapter.pinMessage(
            data['conversationId'] as String,
            data['messageId'] as String,
            duration != null ? Duration(seconds: duration) : null,
          );

        case OutboundOperationType.unpinMessage:
          await _adapter.unpinMessage(
            data['conversationId'] as String,
            data['messageId'] as String,
          );

        case OutboundOperationType.addReaction:
          await _adapter.addReaction(
            data['messageId'] as String,
            data['emoji'] as String,
          );

        case OutboundOperationType.removeReaction:
          await _adapter.removeReaction(
            data['messageId'] as String,
            data['reactionId'] as String,
          );

        case OutboundOperationType.markRead:
          await _adapter.markAsRead(
            data['conversationId'] as String,
            data['messageId'] as String,
          );

        case OutboundOperationType.deleteRoom:
          await _adapter.deleteConversation(data['conversationId'] as String);

        case OutboundOperationType.archiveRoom:
          await _adapter.archiveConversation(data['conversationId'] as String);

        case OutboundOperationType.unarchiveRoom:
          await _adapter.unarchiveConversation(
            data['conversationId'] as String,
          );

        case OutboundOperationType.createRoom:
        case OutboundOperationType.addParticipants:
        case OutboundOperationType.removeParticipant:
        case OutboundOperationType.updateParticipantStatus:
          // These operations are not queued - they're called directly
          ChatLogger.warning('Unexpected queued operation: ${operation.type}');
      }
    } catch (e, s) {
      ChatLogger.error('Failed to execute operation: ${operation.type}', e, s);
      rethrow;
    }
  }

  /// Updates the local message status to [MessageStatus.sent] after the
  /// outbound queue successfully delivers a sendMessage operation.
  /// Also writes the server-assigned `serverId` and `serverTimestamp` so that
  /// subsequent socket echoes can be deduplicated via the serverId check.
  Future<void> _updateMessageStatusAfterSuccess(
    OutboundOperation operation,
  ) async {
    if (operation.type != OutboundOperationType.sendMessage) return;
    try {
      final data = jsonDecode(operation.data) as Map<String, dynamic>;
      final messageId = data['messageId'] as String?;
      if (messageId == null) return;

      final serverMessage = _lastSendResult;
      _lastSendResult = null;

      await _database.updateMessage(
        messageId,
        status: MessageStatus.sent,
        serverId: serverMessage?.serverId,
        serverTimestamp: serverMessage?.serverTimestamp,
      );

      // Merge the server-provided attachment URLs and message type back into
      // the local optimistic message.  insertMessage's dedup logic finds the
      // local row by serverId (set above) and overwrites attachmentsJson + type
      // so the UI shows the real CDN URL instead of the empty '' placeholder.
      // Guard: only merge when the server actually returned file metadata —
      // an empty list would wipe the optimistic attachmentsJson, turning the
      // message into a plain text bubble.
      if (serverMessage != null && serverMessage.attachments.isNotEmpty) {
        await _database.insertMessage(serverMessage);
      }
    } on Object catch (e) {
      ChatLogger.error('Failed to update message status after send', e);
    }
  }

  /// Updates the local message status to [MessageStatus.failed] when the
  /// outbound queue permanently gives up on a sendMessage operation.
  Future<void> _updateMessageStatusOnFailure(
    OutboundOperation operation,
  ) async {
    if (operation.type != OutboundOperationType.sendMessage) return;
    try {
      final data = jsonDecode(operation.data) as Map<String, dynamic>;
      final messageId = data['messageId'] as String?;
      if (messageId == null) return;
      await _database.updateMessage(
        messageId,
        status: MessageStatus.failed,
      );
    } on Object catch (e) {
      ChatLogger.error('Failed to update message status on failure', e);
    }
  }

  @override
  Stream<int> get pendingCount => _pendingCountController.stream;

  @override
  Future<void> dispose() async {
    // Clean up completed operations from database
    await _database.deleteCompletedOperations();
    await _pendingCountController.close();
  }
}
