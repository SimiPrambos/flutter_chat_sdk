/// Connection state to the chat backend.
enum ChatConnectionState {
  /// Not connected to backend.
  disconnected,

  /// Attempting to connect.
  connecting,

  /// Successfully connected.
  connected,

  /// Reconnecting after disconnect.
  reconnecting,

  /// Connection error occurred.
  error,
}
