# `flutter_chat_sdk`

[![pub.dev](https://img.shields.io/pub/v/flutter_chat_sdk.svg)](https://pub.dev/packages/flutter_chat_sdk)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?logo=Flutter&logoColor=white)](https://flutter.dev)

A backend-agnostic Flutter chat SDK with offline-first support. Bring your own backend — implement one interface and everything else works.

---

## Why this package?

Most Flutter chat packages are either tied to a specific vendor (Firebase, Stream, Sendbird) or provide only UI with no offline logic.

This package gives you:

- **Bring your own backend** — implement `ChatAdapter` to connect any REST API, WebSocket server, GraphQL subscription, or MQTT broker
- **Offline-first message queue** — messages are stored locally and sent when online; the queue survives app restarts and retries with exponential backoff
- **Zero vendor lock-in** — the domain model has no dependency on any backend service

---

## Features

- `ChatAdapter` interface — one contract, any backend
- `OutboundQueue` — SQLite-persisted queue with exponential backoff retry and crash recovery
- `SyncEngine` — initial, incremental, and per-conversation sync
- `ChatDatabase` — Drift/SQLite with optional SQLCipher encryption
- `ChatIdentityProvider` — initialize before user login for instant startup
- Flutter widgets — `ChatProvider`, `ConversationsBuilder`, `MessagesBuilder`, `ConnectionStateBuilder`
- Testing utilities — `MockChatAdapter` and `StaticIdentityProvider` in `package:flutter_chat_sdk/testing.dart`

---

## Quick Start

No backend needed. This example runs entirely in memory using `MockChatAdapter`.

```dart
// pubspec.yaml
dependencies:
  flutter_chat_sdk: ^0.1.0
```

```dart
// main.dart
import 'package:flutter_chat_sdk/flutter_chat_sdk.dart';
import 'package:flutter_chat_sdk/testing.dart';

Future<void> main() async {
  final chat = await Chat.create(
    databasePath: 'chat.db',
    adapter: MockChatAdapter(),
    identityProvider: const StaticIdentityProvider('user-1'),
  );

  await chat.connect();

  chat.watchConversations().listen(print);

  final conversation = await chat.createConversation(
    mode: ConversationMode.standard,
    name: 'General',
  );

  await chat.sendMessage(
    conversationId: conversation.id,
    content: 'Hello!',
  );

  await chat.dispose();
}
```

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_chat_sdk: ^0.1.0
```

For database encryption (optional):

```yaml
dependencies:
  sqlcipher_flutter_libs: ^0.6.8
```

Run:

```
flutter pub get
```

---

## Usage

### Implementing a ChatAdapter

`ChatAdapter` is the single interface between the SDK and your backend. Implementing it is the only thing needed to connect any backend.

```dart
import 'package:flutter_chat_sdk/flutter_chat_sdk.dart';

class MyBackendAdapter implements ChatAdapter {
  @override
  String get name => 'MyBackend';

  @override
  bool get isConnected => _connected;

  @override
  Stream<ChatConnectionState> get connectionState => _connectionStateController.stream;

  @override
  Stream<ChatEvent> get eventStream => _eventController.stream;

  @override
  Future<void> initialize() async {
    // Connect to your backend, set up auth headers, etc.
  }

  @override
  Future<void> connect() async {
    // Establish WebSocket connection or start polling.
  }

  @override
  Future<SyncResult> initialSync() async {
    // Fetch rooms + messages from your API.
    return SyncResult(conversations: [...], messages: [...]);
  }

  @override
  Future<Message> sendMessage(SendMessageParams params) async {
    // POST to your API.
  }

  // ...implement remaining ChatRepository methods
}
```

`HttpChatAdapter` and `SocketChatAdapter` are optional base classes that provide sensible no-ops for the transport they don't handle. Extend `HttpChatAdapter` for REST-only backends or `SocketChatAdapter` for WebSocket-only backends:

```dart
class MyHttpAdapter extends HttpChatAdapter {
  MyHttpAdapter(this._api);
  final MyApiClient _api;

  @override
  String get name => 'MyHttpAdapter';

  @override
  Future<void> initialize() async {
    // Set up auth headers, base URLs, etc.
  }

  @override
  Future<SyncResult> initialSync() async {
    final response = await _api.getInitialSync();
    return SyncResult(
      conversations: response.conversations.map(Conversation.fromJson).toList(),
      messages: response.messages.map(Message.fromJson).toList(),
      nextSyncToken: response.syncToken,
    );
  }

  @override
  Future<SyncResult> incrementalSync(String sinceToken) async {
    final response = await _api.getIncrementalSync(sinceToken);
    return SyncResult(
      conversations: response.conversations.map(Conversation.fromJson).toList(),
      messages: response.messages.map(Message.fromJson).toList(),
      nextSyncToken: response.syncToken,
    );
  }

  @override
  Future<Message> sendMessage(SendMessageParams params) async {
    return await _api.sendMessage(
      conversationId: params.conversationId,
      content: params.content,
      type: params.type,
    );
  }
}
```

For backends with both REST and WebSocket, use `ChatRegistry.withHttpAndSocket`:

```dart
final registry = ChatRegistry.withHttpAndSocket(
  config: config,
  httpAdapter: MyHttpAdapter(api),
  socketAdapter: MySocketAdapter(socket),
  identityProvider: identityProvider,
);
```

The SDK automatically routes sync and CRUD operations to HTTP, and real-time events to the socket.

### Initializing the SDK

The recommended approach initializes the SDK at app startup — before the user logs in — so local data is available immediately:

```dart
// At app startup (before login).
final chat = await Chat.create(
  databasePath: 'chat.db',
  adapter: MyHttpAdapter(api),
  identityProvider: MyIdentityProvider(storage),
  autoConnect: false, // Connect after login.
);

// After login: update the identity provider so it emits the user ID,
// then connect.
await storage.write('user_id', 'user-123');
await chat.connect();

// On logout: clear the user ID and disconnect.
await storage.delete('user_id');
await chat.disconnect();
await chat.clearSyncState(); // Ensures the next login does a full sync.
```

**`ChatIdentityProvider`** bridges your auth layer and the SDK:

```dart
class MyIdentityProvider implements ChatIdentityProvider {
  MyIdentityProvider(this._storage);
  final StorageService _storage;

  @override
  Future<String?> getCurrentUserId() => _storage.read('user_id');

  @override
  Stream<String?> get userIdChanges => _storage.events
      .where((e) => e.key == 'user_id')
      .map((e) => e.value as String?);
}
```

For manual control, use `ChatRegistry` directly:

```dart
final registry = ChatRegistry.withAdapter(
  config: ChatConfig(databasePath: 'chat.db', enableLogging: kDebugMode),
  adapter: MyHttpAdapter(api),
  identityProvider: identityProvider,
);
final chat = Chat(registry);
await chat.initialize();
await chat.connect();
```

Wrap your app with `ChatProvider` to make the `Chat` instance available throughout the widget tree:

```dart
ChatProvider(
  chat: chat,
  child: MyApp(),
)
```

Access the instance anywhere with `context.chat` (from the `package:flutter_chat_sdk/flutter_chat_sdk.dart` extension).

### Watching conversations

```dart
// Reactive stream — rebuilds whenever conversations change.
chat.watchConversations().listen((conversations) {
  for (final c in conversations) {
    print('${c.displayName}: ${c.unreadCount} unread');
  }
});

// With a filter.
chat.watchConversations(
  filter: ConversationFilter(
    mode: ConversationMode.ephemeral,
    status: ConversationStatus.active,
  ),
).listen((conversations) { ... });

// As a Flutter widget.
ConversationsBuilder(
  builder: (context, conversations, isLoading) {
    if (isLoading) return const CircularProgressIndicator();
    return ListView.builder(
      itemCount: conversations.length,
      itemBuilder: (context, i) => ListTile(
        title: Text(conversations[i].displayName),
        trailing: conversations[i].hasUnread
            ? Badge(label: Text('${conversations[i].unreadCount}'))
            : null,
      ),
    );
  },
)
```

### Sending messages

Messages are written to the local database first and returned immediately. The SDK sends them to the backend in the background, retrying with exponential backoff if offline.

```dart
// Simple text message.
await chat.sendMessage(
  conversationId: conversation.id,
  content: 'Hello!',
);

// Reply.
await chat.sendMessage(
  conversationId: conversation.id,
  content: 'Agreed.',
  replyToId: originalMessage.id,
);

// Image message.
await chat.sendMessage(
  conversationId: conversation.id,
  content: '[Image]',
  type: MessageType.image,
);
```

Watch messages in a conversation:

```dart
// Reactive stream.
chat.watchMessages(conversationId).listen((messages) {
  for (final m in messages) {
    print('${m.senderId}: ${m.content.displayText}');
  }
});

// As a Flutter widget.
MessagesBuilder(
  conversationId: conversationId,
  builder: (context, messages, isLoading) {
    if (isLoading) return const CircularProgressIndicator();
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, i) => Text(messages[i].content.displayText),
    );
  },
)
```

Load older messages (pagination):

```dart
final result = await chat.loadMoreMessages(conversationId);
if (result.hasMore) {
  // More history available — call loadMoreMessages again to go further back.
}
```

### Message features

```dart
// Star / unstar.
final starId = await chat.starMessage(conversationId, messageId);
await chat.unstarMessage(starId);

// Pin / unpin.
await chat.pinMessage(conversationId, messageId);
await chat.pinMessage(conversationId, messageId, duration: Duration(hours: 1));
await chat.unpinMessage(conversationId, messageId);

// Reactions.
await chat.addReaction(messageId, '👍');
await chat.removeReaction(messageId, '👍'); // pass emoji or reaction ID

// Watch starred / pinned.
chat.watchStarredMessages().listen((messages) { ... });
chat.watchPinnedMessages(conversationId).listen((messages) { ... });

// Real-time events.
chat.onEvent.listen((event) {
  print('Event: ${event.runtimeType}');
});

// Typed events.
chat.on<TypingEvent>().listen((event) {
  if (event.isTyping) {
    print('${event.userName} is typing...');
  }
});

chat.on<PresenceEvent>().listen((event) {
  print('${event.userId} is ${event.isOnline ? 'online' : 'offline'}');
});

// Send typing indicator.
await chat.sendTyping(conversationId, isTyping: true);

// Mark as read (clears unread badge immediately).
await chat.markAsRead(conversationId, lastMessageId);
```

Connection state as a Flutter widget:

```dart
ConnectionStateBuilder(
  builder: (context, state) {
    return switch (state) {
      ChatConnectionState.connected =>
        const Icon(Icons.cloud_done, color: Colors.green),
      ChatConnectionState.connecting =>
        const Icon(Icons.cloud_sync, color: Colors.orange),
      _ => const Icon(Icons.cloud_off, color: Colors.grey),
    };
  },
)
```

### Testing with MockChatAdapter

Import `package:flutter_chat_sdk/testing.dart` in tests and example apps — it never hits the network.

```dart
import 'package:flutter_chat_sdk/flutter_chat_sdk.dart';
import 'package:flutter_chat_sdk/testing.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late MockChatAdapter adapter;
  late Chat chat;

  setUp(() async {
    adapter = MockChatAdapter();
    chat = await Chat.create(
      databasePath: ':memory:',
      adapter: adapter,
      identityProvider: StaticIdentityProvider('user-1'),
      autoConnect: true,
    );
  });

  tearDown(() => chat.dispose());

  test('sendMessage enqueues optimistic message', () async {
    final conversation = await chat.createConversation(
      mode: ConversationMode.standard,
    );

    final message = await chat.sendMessage(
      conversationId: conversation.id,
      content: 'Test message',
    );

    expect(message.content.displayText, 'Test message');
    expect(message.conversationId, conversation.id);
  });

  test('simulateIncomingMessage triggers watchMessages', () async {
    final conversation = await chat.createConversation(
      mode: ConversationMode.standard,
    );

    final messages = <List<Message>>[];
    chat.watchMessages(conversation.id).listen(messages.add);

    adapter.simulateIncomingMessage(
      conversationId: conversation.id,
      senderId: 'user-2',
      content: 'Hello!',
    );

    await Future<void>.delayed(Duration.zero);
    expect(messages.last.last.content.displayText, 'Hello!');
  });
}
```

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                              APP LAYER                              │
│  ┌──────────────────┐    ┌──────────────────┐    ┌────────────────┐ │
│  │   ChatService    │    │     Adapter      │    │      UI        │ │
│  │  (Integration)   │───▶│  Implementation  │◀───│  (Pages/Wgt)   │ │
│  └──────────────────┘    └──────────────────┘    └────────────────┘ │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                           CHAT PACKAGE                              │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │                        Chat (Facade)                       │    │
│  │  - Conversation Operations  - Message Operations           │    │
│  │  - State Notifiers          - Event Streams                │    │
│  └────────────────────────────────────────────────────────────┘    │
│                              │                                     │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐  ┌──────────────┐    │
│  │ Database  │  │SyncEngine │  │  Queue    │  │  EventBus    │    │
│  │ (Drift)   │  │           │  │           │  │              │    │
│  └───────────┘  └───────────┘  └───────────┘  └──────────────┘    │
│                              │                                     │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │                   ChatAdapter Interface                    │    │
│  │           (Contract for Backend Communication)            │    │
│  └────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────┘
```

### Core components

| Component | Responsibility |
|-----------|----------------|
| `Chat` | Public facade. All operations go through here. |
| `ChatAdapter` | Backend contract. Implement this for your backend. |
| `SyncEngine` | Runs initial sync on first launch, incremental sync on reconnect, per-conversation sync on demand. |
| `OutboundQueue` | Persists pending operations to SQLite; retries with exponential backoff; crash-safe. |
| `ChatDatabase` | Drift/SQLite abstraction. Reactive queries via streams. Optional SQLCipher encryption. |
| `ChatEventBus` | Internal pub/sub. Adapter events → sync engine → event bus → public `onEvent` stream. |
| `ChatIdentityProvider` | Decouples user identity from SDK initialization. |

### Package structure

```
lib/
├── chat.dart           # Public API
├── testing.dart        # Testing utilities
└── src/
    ├── chat.dart                   # Chat facade
    ├── adapters/
    │   └── chat_adapter.dart       # ChatAdapter, HttpChatAdapter, SocketChatAdapter
    ├── config/
    │   ├── chat_config.dart
    │   ├── chat_identity_provider.dart
    │   └── chat_registry.dart
    ├── core/
    │   ├── database/               # Drift/SQLite
    │   ├── queue/                  # OutboundQueue
    │   ├── sync/                   # SyncEngine
    │   ├── event_bus/              # ChatEventBus
    │   ├── encryption/             # EncryptionService
    │   └── security/               # DatabaseEncryptionConfig
    ├── domain/
    │   ├── entities/               # Conversation, Message, Participant, ...
    │   ├── enums/                  # ConversationMode, ConversationType, MessageStatus, ...
    │   └── repositories/           # ChatRepository interface
    ├── flutter/
    │   ├── chat_provider.dart
    │   └── widgets/                # ConversationsBuilder, MessagesBuilder, ...
    ├── extensions/                 # context.chat, conversation helpers
    ├── exceptions/                 # Typed exceptions
    └── testing/                    # MockChatAdapter, StaticIdentityProvider
```

---

## Configuration

### ChatConfig

```dart
final config = ChatConfig(
  databasePath: 'chat.db',                       // Required. Use ':memory:' for tests.
  enableLogging: kDebugMode,                     // Default: false
  maxRetryAttempts: 10,                          // Default: 10
  syncInterval: Duration(minutes: 5),            // Default: 5 minutes
  heartbeatInterval: Duration(seconds: 30),      // Default: 30 seconds
);
```

### ChatRegistry

```dart
// Single adapter (HTTP or Socket).
final registry = ChatRegistry.withAdapter(
  config: config,
  adapter: MyAdapter(),
  identityProvider: identityProvider,
);

// HTTP + Socket (composite).
final registry = ChatRegistry.withHttpAndSocket(
  config: config,
  httpAdapter: MyHttpAdapter(),
  socketAdapter: MySocketAdapter(),
  identityProvider: identityProvider,
);

// Custom services (bring your own database or encryption).
final registry = ChatRegistry.custom(
  config: config,
  adapter: MyAdapter(),
  identityProvider: identityProvider,
  encryption: MyEncryptionService(),
  database: MyCustomDatabase(),
);
```

### Exception handling

```dart
try {
  await chat.sendMessage(conversationId: conversationId, content: 'Hello!');
} on UserIdNotSetException {
  // User not logged in yet.
} on ChatNotInitializedException {
  // initialize() not called.
} on ChatOperationException catch (e) {
  print('Operation failed: ${e.message}');
} on ChatException catch (e) {
  print('Chat error: ${e.message}');
}
```

| Exception | When thrown |
|-----------|-------------|
| `ChatNotInitializedException` | Methods called before `initialize()` |
| `UserIdNotSetException` | User-scoped operation called before identity is available |
| `ChatOperationException` | General operation failure |
| `ChatSyncException` | Synchronization failure |
| `ChatDatabaseException` | Database operation failure |
| `ChatAdapterException` | Adapter operation failure |
| `ChatValidationException` | Input validation failure |

### OutboundQueue retry config

```dart
final queue = OutboundQueueImpl(
  adapter: adapter,
  database: database,
  retryConfig: QueueRetryConfig(
    maxRetries: 5,           // Default: 3
    initialDelayMs: 2000,    // Default: 1000 ms
    maxDelayMs: 60000,       // Default: 30 000 ms
    backoffMultiplier: 2.0,  // Default: 2.0
  ),
  maxQueueSize: 500,         // Default: 1000
);
```

---

## Database Encryption

The SDK uses [sqlite3mc](https://github.com/utelle/SQLite3MultipleCiphers) via the `sqlite3` package hook for transparent SQLite encryption, with no additional dependencies required for basic use.

For full SQLCipher compatibility:

1. Add the optional dependency:

   ```yaml
   dependencies:
     sqlcipher_flutter_libs: ^0.6.8
   ```

2. Pass an encryption config:

   ```dart
   final registry = ChatRegistry.withAdapter(
     config: config,
     adapter: adapter,
     identityProvider: identityProvider,
     databaseEncryptionConfig: DatabaseEncryptionConfig(
       encryptionKey: 'your-64-character-hex-key', // 256-bit key
       cipherPageSize: 4096,    // Default: 4096
       kdfIterations: 64000,    // Default: 64000 (OWASP recommends 100000+)
     ),
   );
   ```

**Key management** is outside the SDK's scope. Generate and store keys at the app level:

```dart
import 'dart:math';
import 'package:convert/convert.dart';

final random = Random.secure();
final keyBytes = List<int>.generate(32, (_) => random.nextInt(256));
final keyHex = hex.encode(keyBytes); // 64 hex characters
```

Store the key with `flutter_secure_storage`, iOS Keychain, or Android Keystore.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

---

## License

[MIT](LICENSE)
