import 'package:flutter/foundation.dart';

/// Logger for Chat SDK.
///
/// Provides simple logging capabilities with configurable levels.
@internal
class ChatLogger {
  /// Whether debug logging is enabled.
  static bool _enabled = kDebugMode;

  /// Sets whether debug logging is enabled.
  // ignore: avoid_setters_without_getters
  static set enabled(bool value) => _enabled = value;

  /// Logs a debug message.
  static void debug(String message) {
    _log('DEBUG', message);
  }

  /// Logs an info message.
  static void info(String message) {
    _log('INFO', message);
  }

  /// Logs a warning message.
  static void warning(String message) {
    _log('WARNING', message);
  }

  /// Logs an error message.
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log('ERROR', message);
    if (error != null) {
      _log('ERROR', error.toString());
    }
    if (stackTrace != null) {
      _log('ERROR', stackTrace.toString());
    }
  }

  static void _log(String level, String message) {
    if (!_enabled) return;
    final timestamp = DateTime.now().toIso8601String();
    // Intentional console output for SDK debug logging — not production code.
    // ignore: avoid_print
    print('[$timestamp] [Chat] [$level] $message');
  }
}
