import 'package:flutter/widgets.dart';
import 'package:flutter_chat_sdk/src/domain/enums/connection_state.dart';
import 'package:flutter_chat_sdk/src/extensions/context_extensions.dart';

/// Builder widget that watches connection state.
///
/// ```dart
/// ConnectionStateBuilder(
///   builder: (context, state) {
///     switch (state) {
///       case ChatConnectionState.connected:
///         return Icon(Icons.cloud_done, color: Colors.green);
///       case ChatConnectionState.connecting:
///         return Icon(Icons.cloud_sync, color: Colors.orange);
///       default:
///         return Icon(Icons.cloud_off, color: Colors.grey);
///     }
///   },
/// )
/// ```
class ConnectionStateBuilder extends StatelessWidget {
  const ConnectionStateBuilder({
    required this.builder,
    super.key,
  });

  final Widget Function(BuildContext context, ChatConnectionState state)
      builder;

  @override
  Widget build(BuildContext context) {
    final chat = context.chat;

    return ValueListenableBuilder<ChatConnectionState>(
      valueListenable: chat.connectionState,
      builder: (context, state, _) => builder(context, state),
    );
  }
}
