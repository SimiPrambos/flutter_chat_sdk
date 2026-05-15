/// Domain layer exports.
library;

// Entities
export 'entities/chat_event.dart';
export 'entities/conversation.dart';
export 'entities/file_attachment.dart' show FileUploadStatus;
export 'entities/message.dart';
export 'entities/message_content.dart';
export 'entities/participant.dart';
export 'entities/pinned_event.dart';
export 'entities/reaction.dart';
export 'entities/sync_state.dart';

// Enums
export 'enums/connection_state.dart';
export 'enums/conversation_mode.dart';
export 'enums/conversation_status.dart';
export 'enums/conversation_type.dart';
export 'enums/message_status.dart';
export 'enums/message_type.dart';
export 'enums/participant_role.dart';
export 'enums/participant_status.dart';
export 'enums/sync_status.dart';

// Parameter classes and types from repository
export 'repositories/chat_repository.dart'
    show
        CreateConversationParams,
        JoinConversationParams,
        PendingAttachment,
        SendMessageParams,
        UpdateConversationParams,
        UploadFileParams;
