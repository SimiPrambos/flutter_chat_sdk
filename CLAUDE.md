# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run all tests
flutter test

# Run a single test file
flutter test test/chat_send_message_test.dart

# Static analysis
dart analyze lib/

# Regenerate Drift database code (required after modifying database schema)
dart run build_runner build --delete-conflicting-outputs
```

## Architecture

The SDK is a backend-agnostic Flutter chat library with offline-first support. The core abstraction is `ChatAdapter` — implementors provide the backend integration; the SDK handles persistence, queuing, and UI.

### Layer overview

```text
Chat (facade)
  ├── SyncEngine       — initial + incremental sync via token, coalesces rapid requests
  ├── OutboundQueue    — SQLite-backed send queue with exponential backoff retry
  ├── ChatDatabase     — Drift/SQLite local store; exposes reactive streams
  ├── ChatEventBus     — internal pub/sub routing adapter events to listeners
  └── ChatAdapter      — single interface that backend implementations must satisfy
```

**Public entrypoints:**

- `lib/flutter_chat_sdk.dart` — all public types; import this in consuming apps
- `lib/testing.dart` — `MockChatAdapter` and `StaticIdentityProvider` for tests

**Facade:** `lib/src/chat.dart` — `Chat.create(...)` wires up all services via `ChatRegistry`. All user-facing operations live here.

**ChatAdapter** (`lib/src/adapters/chat_adapter.dart`) — the only interface backend developers implement. Covers `initialSync`, `incrementalSync`, `sendMessage`, `createConversation`, etc.

**Domain entities** (`lib/src/domain/entities/`) are immutable value objects (Equatable). Key types: `Conversation`, `Message`, `Participant`, `Reaction`, `FileAttachment`, `ChatEvent` subtypes.

**Flutter integration** (`lib/src/flutter/`) — `ChatProvider` (InheritedWidget) exposes `Chat` to the widget tree; `ConversationsBuilder` and `MessagesBuilder` are reactive stream-based builders; `context.chat` extension accesses the instance.

### Offline-first flow

1. `sendMessage` writes locally first and returns immediately (optimistic UI).
2. `OutboundQueue` persists the send operation and retries with exponential backoff on failure.
3. `SyncEngine` runs an initial full sync on first launch and incremental token-based sync on reconnect.
4. Drift streams (`watchConversations`, `watchMessages`) propagate database changes to UI automatically.

### Drift code generation

`lib/src/core/database/chat_database_impl.g.dart` is generated — never edit it directly. After modifying `chat_database_impl.dart` table definitions, run `build_runner build`.

### Testing utilities

- `MockChatAdapter` (`lib/src/testing/mock_chat_adapter.dart`) — in-memory adapter; use `simulateIncomingMessage()` / `simulateConversationCreated()` in tests.
- `FakeChatDatabase` (`test/helpers/test_helpers.dart`) — in-memory Drift substitute for unit tests.
- `StaticIdentityProvider` (`lib/src/testing/static_identity_provider.dart`) — fixed user ID for test initialization.
- Pass `databasePath: ':memory:'` in `ChatConfig` for isolated in-process test databases.
