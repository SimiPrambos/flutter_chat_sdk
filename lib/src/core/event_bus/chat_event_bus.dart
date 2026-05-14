import 'dart:async';

import 'package:flutter_chat_sdk/src/domain/entities/chat_event.dart';

/// Event bus for chat events.
///
/// Provides a publish-subscribe mechanism for chat events.
/// Allows multiple listeners to react to chat events.
abstract class ChatEventBus {
  /// Publishes an event to all subscribers.
  void emit(ChatEvent event);

  /// Subscribes to chat events.
  Stream<ChatEvent> get eventStream;

  /// Subscribes to a specific event type.
  Stream<T> on<T extends ChatEvent>();

  /// Disposes the event bus.
  void dispose();
}

/// Implementation of [ChatEventBus] using StreamController.
class ChatEventBusImpl implements ChatEventBus {
  final _controller = StreamController<ChatEvent>.broadcast();

  @override
  void emit(ChatEvent event) {
    _controller.add(event);
  }

  @override
  Stream<ChatEvent> get eventStream => _controller.stream;

  @override
  Stream<T> on<T extends ChatEvent>() {
    return _controller.stream.where((e) => e is T).cast<T>();
  }

  @override
  void dispose() {
    _controller.close();
  }
}
