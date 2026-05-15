/// Chat Package
///
/// A backend-agnostic chat SDK with offline-first support.
///
/// ## Quick Start
///
/// ```dart
/// // 1. Create configuration
/// final config = ChatConfig(
///   databasePath: 'chat.db',
/// );
///
/// // 2. Create registry with adapter
/// final registry = ChatRegistry.withAdapter(
///   config: config,
///   adapter: YourBackendAdapter(),
///   identityProvider: YourIdentityProvider(),
/// );
///
/// // 3. Create chat instance
/// final chat = Chat(registry);
///
/// // 4. Initialize
/// await chat.initialize();
///
/// // 5. Use it!
/// final conversations = chat.watchConversations();
/// await chat.sendMessage(conversationId: '123', content: 'Hello!');
/// ```
library;

export 'src/adapters/chat_adapter.dart';
export 'src/chat.dart' show Chat, ChatSessionState;
export 'src/config/chat_config.dart';
export 'src/config/chat_identity_provider.dart';
export 'src/config/chat_registry.dart';
export 'src/core/database/chat_database.dart';
export 'src/core/encryption/encryption_service.dart';
export 'src/core/event_bus/chat_event_bus.dart';
export 'src/core/media/attachment_type_strategy.dart';
export 'src/core/media/media_type_resolver.dart';
export 'src/core/queue/outbound_queue.dart';
export 'src/core/security/database_key_config.dart';
export 'src/core/sync/sync_engine.dart';
export 'src/domain/entities/chat_event.dart';
export 'src/domain/entities/conversation.dart';
export 'src/domain/entities/file_attachment.dart';
export 'src/domain/entities/message.dart';
export 'src/domain/entities/message_content.dart';
export 'src/domain/entities/participant.dart';
export 'src/domain/entities/pinned_event.dart';
export 'src/domain/entities/presence_result.dart';
export 'src/domain/entities/reaction.dart';
export 'src/domain/entities/sync_state.dart';
export 'src/domain/enums/connection_state.dart';
export 'src/domain/enums/conversation_mode.dart';
export 'src/domain/enums/conversation_status.dart';
export 'src/domain/enums/conversation_type.dart';
export 'src/domain/enums/message_status.dart';
export 'src/domain/enums/message_type.dart';
export 'src/domain/enums/participant_role.dart';
export 'src/domain/enums/participant_status.dart';
export 'src/domain/enums/sync_status.dart';
export 'src/domain/repositories/chat_repository.dart';
export 'src/exceptions/chat_exception.dart';
export 'src/extensions/context_extensions.dart';
export 'src/extensions/conversation_extensions.dart';
export 'src/extensions/message_extensions.dart';
export 'src/flutter/chat_provider.dart';
export 'src/flutter/widgets/connection_state_builder.dart';
export 'src/flutter/widgets/conversations_builder.dart';
export 'src/flutter/widgets/messages_builder.dart';
