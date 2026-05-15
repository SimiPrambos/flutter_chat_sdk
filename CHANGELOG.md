# Changelog

## 0.1.0

Initial open-source release.

- Backend-agnostic `ChatAdapter` interface — bring your own backend
- Offline-first `OutboundQueue` with persistent SQLite storage, exponential
  backoff retry, and crash recovery
- `SyncEngine` with initial sync, incremental sync, and per-conversation sync
- `ChatDatabase` interface backed by Drift (SQLite), with optional SQLCipher
  encryption via `DatabaseEncryptionConfig`
- `ChatIdentityProvider` for early SDK initialization before user login
- Reactive `watchConversations()` and `watchMessages()` streams
- Optimistic UI for send, react, pin, star, and archive operations
- Flutter widgets: `ConversationsBuilder`, `MessagesBuilder`,
  `ConnectionStateBuilder`
- `HttpChatAdapter` and `SocketChatAdapter` base classes for single-transport
  adapters
