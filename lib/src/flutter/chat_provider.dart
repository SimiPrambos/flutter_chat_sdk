import 'package:flutter_chat_sdk/src/chat.dart';
import 'package:flutter/widgets.dart';

/// Provides a [Chat] instance to the widget tree.
///
/// Place this at the top of your widget tree to make Chat available
/// to all descendant widgets.
///
/// ```dart
/// ChatProvider(
///   chat: chat,
///   child: MyApp(),
/// )
/// ```
class ChatProvider extends InheritedWidget {
  const ChatProvider({
    required this.chat,
    required super.child,
    super.key,
  });

  final Chat chat;

  /// Get the Chat instance from context.
  ///
  /// Throws [FlutterError] if ChatProvider is not found.
  static Chat of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<ChatProvider>();
    assert(() {
      if (provider == null) {
        throw FlutterError(
          'ChatProvider.of() called with a context that does not contain a '
          'ChatProvider.\n'
          'No ChatProvider ancestor could be found.',
        );
      }
      return true;
    }());
    return provider!.chat;
  }

  @override
  bool updateShouldNotify(ChatProvider oldWidget) => chat != oldWidget.chat;
}
