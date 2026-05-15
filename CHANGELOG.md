# Changelog

## [2.0.0](https://github.com/SimiPrambos/flutter_chat_sdk/compare/v1.0.0...v2.0.0) (2026-05-15)


### ⚠ BREAKING CHANGES

* remove backend-specific fields and methods from public API

### Features

* initial commit ([4f6d250](https://github.com/SimiPrambos/flutter_chat_sdk/commit/4f6d250e37988d5213de8179446d3aa84f03b1f0))
* remove backend-specific fields and methods from public API ([e21fa2a](https://github.com/SimiPrambos/flutter_chat_sdk/commit/e21fa2a04e5a9bf69e77ac8251b389de830b7b85))


### Bug Fixes

* **chat:** show conversations when participant metadata is not yet loaded ([9853c04](https://github.com/SimiPrambos/flutter_chat_sdk/commit/9853c04ac83539f2de840aa779b3c607f3d706c4))
* enforce named parameters for boolean arguments in public API ([106ffe5](https://github.com/SimiPrambos/flutter_chat_sdk/commit/106ffe5b0ff0dfbdf7e0fd45c51841de383d1791))
* remove ConversationExtensions methods shadowing Conversation class members ([c445899](https://github.com/SimiPrambos/flutter_chat_sdk/commit/c445899f451d8e2693b320323857cd9f9edd7895))
* **sync:** incoming pin event replaces the previously pinned message ([a66cce8](https://github.com/SimiPrambos/flutter_chat_sdk/commit/a66cce8d325e9d77b0c897f0ebe279a873bcd39a))

## [1.0.0](https://github.com/SimiPrambos/flutter_chat_sdk/compare/flutter_chat_sdkv0.1.1...flutter_chat_sdkv1.0.0) (2026-05-15)


### ⚠ BREAKING CHANGES

* remove backend-specific fields and methods from public API

### Features

* initial commit ([4f6d250](https://github.com/SimiPrambos/flutter_chat_sdk/commit/4f6d250e37988d5213de8179446d3aa84f03b1f0))
* remove backend-specific fields and methods from public API ([e21fa2a](https://github.com/SimiPrambos/flutter_chat_sdk/commit/e21fa2a04e5a9bf69e77ac8251b389de830b7b85))


### Bug Fixes

* **chat:** show conversations when participant metadata is not yet loaded ([9853c04](https://github.com/SimiPrambos/flutter_chat_sdk/commit/9853c04ac83539f2de840aa779b3c607f3d706c4))
* enforce named parameters for boolean arguments in public API ([106ffe5](https://github.com/SimiPrambos/flutter_chat_sdk/commit/106ffe5b0ff0dfbdf7e0fd45c51841de383d1791))
* remove ConversationExtensions methods shadowing Conversation class members ([c445899](https://github.com/SimiPrambos/flutter_chat_sdk/commit/c445899f451d8e2693b320323857cd9f9edd7895))
* **sync:** incoming pin event replaces the previously pinned message ([a66cce8](https://github.com/SimiPrambos/flutter_chat_sdk/commit/a66cce8d325e9d77b0c897f0ebe279a873bcd39a))

## 0.1.2

### Breaking Changes

- Removed `Conversation.shareCode` and `Conversation.expiresAt` fields — these were specific to a particular backend and do not belong in a backend-agnostic SDK
- Removed `CreateConversationParams.expiresIn` parameter
- Removed `JoinConversationParams` class
- Removed `getShareCode()`, `joinConversation()`, and `validateConversationCode()` from `ChatRepository`, `ChatAdapter`, and `Chat` — join-by-code is a backend-specific feature that should be implemented in the adapter layer
- Removed `Chat.joinConversation()` and `Chat.getShareCode()` from the public API
- Database schema bumped to v8: `share_code` and `expires_at` columns are dropped from the `conversations` table (automatic migration runs on first launch)

### Bug Fixes

- `Chat.createConversation()` now throws a clear `StateError` instead of crashing with a null pointer if the adapter returns `null` for a newly created conversation

### Code Quality

- `ConversationMode.fromString()` now only accepts `'standard'` and `'ephemeral'` — removed undocumented legacy string aliases
- Removed an internal one-time data migration that was not applicable to new installations
- Cleaned up internal comments that referenced implementation details of a specific backend

## 0.1.1

### Bug Fixes

- Outbound queue now skips processing when the adapter is disconnected — optimistic messages correctly stay in `pending` state until a connection is established
- Incoming `PinEvent` now replaces the previously pinned message instead of accumulating multiple pinned messages
- `getConversations()` no longer hides conversations whose participant list has not yet been loaded

### Code Quality

- Renamed public entrypoint from `lib/chat.dart` to `lib/flutter_chat_sdk.dart` (import: `package:flutter_chat_sdk/flutter_chat_sdk.dart`)
- All boolean parameters in the public API are now named (`{required bool isTyping}`, `{required bool isLoading}`)
- Removed `ConversationExtensions` methods that were dead code shadowing `Conversation` class members
- `OutboundOperation` factory methods converted to named constructors

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
