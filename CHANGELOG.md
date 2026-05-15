# Changelog

## 0.1.1

### Bug Fixes

* Outbound queue now skips processing when the adapter is disconnected — optimistic messages correctly stay in `pending` state until a connection is established
* Incoming `PinEvent` now replaces the previously pinned message instead of accumulating multiple pinned messages
* `getConversations()` no longer hides conversations whose participant list has not yet been loaded

### Code Quality

* Renamed public entrypoint from `lib/chat.dart` to `lib/flutter_chat_sdk.dart` (import: `package:flutter_chat_sdk/flutter_chat_sdk.dart`)
* All boolean parameters in the public API are now named (`{required bool isTyping}`, `{required bool isLoading}`)
* Removed `ConversationExtensions` methods that were dead code shadowing `Conversation` class members
* `OutboundOperation` factory methods converted to named constructors

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
