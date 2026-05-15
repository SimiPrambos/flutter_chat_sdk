// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_database_impl.dart';

// ignore_for_file: type=lint
class $MessagesTable extends Messages
    with TableInfo<$MessagesTable, MessageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _serverIdMeta =
      const VerificationMeta('serverId');
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
      'server_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _conversationIdMeta =
      const VerificationMeta('conversationId');
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
      'conversation_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderIdMeta =
      const VerificationMeta('senderId');
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
      'sender_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _senderNameMeta =
      const VerificationMeta('senderName');
  @override
  late final GeneratedColumn<String> senderName = GeneratedColumn<String>(
      'sender_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _senderAvatarMeta =
      const VerificationMeta('senderAvatar');
  @override
  late final GeneratedColumn<String> senderAvatar = GeneratedColumn<String>(
      'sender_avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentNonceMeta =
      const VerificationMeta('contentNonce');
  @override
  late final GeneratedColumn<String> contentNonce = GeneratedColumn<String>(
      'content_nonce', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isEncryptedMeta =
      const VerificationMeta('isEncrypted');
  @override
  late final GeneratedColumn<bool> isEncrypted = GeneratedColumn<bool>(
      'is_encrypted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_encrypted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _clientTimestampMeta =
      const VerificationMeta('clientTimestamp');
  @override
  late final GeneratedColumn<DateTime> clientTimestamp =
      GeneratedColumn<DateTime>('client_timestamp', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _serverTimestampMeta =
      const VerificationMeta('serverTimestamp');
  @override
  late final GeneratedColumn<DateTime> serverTimestamp =
      GeneratedColumn<DateTime>('server_timestamp', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _replyToIdMeta =
      const VerificationMeta('replyToId');
  @override
  late final GeneratedColumn<String> replyToId = GeneratedColumn<String>(
      'reply_to_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isEditedMeta =
      const VerificationMeta('isEdited');
  @override
  late final GeneratedColumn<bool> isEdited = GeneratedColumn<bool>(
      'is_edited', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_edited" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isStarredMeta =
      const VerificationMeta('isStarred');
  @override
  late final GeneratedColumn<bool> isStarred = GeneratedColumn<bool>(
      'is_starred', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_starred" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isPinnedMeta =
      const VerificationMeta('isPinned');
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
      'is_pinned', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_pinned" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _pinnedUntilMeta =
      const VerificationMeta('pinnedUntil');
  @override
  late final GeneratedColumn<DateTime> pinnedUntil = GeneratedColumn<DateTime>(
      'pinned_until', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _localSequenceMeta =
      const VerificationMeta('localSequence');
  @override
  late final GeneratedColumn<int> localSequence = GeneratedColumn<int>(
      'local_sequence', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _attachmentsJsonMeta =
      const VerificationMeta('attachmentsJson');
  @override
  late final GeneratedColumn<String> attachmentsJson = GeneratedColumn<String>(
      'attachments_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        serverId,
        conversationId,
        senderId,
        senderName,
        senderAvatar,
        content,
        contentNonce,
        isEncrypted,
        type,
        status,
        clientTimestamp,
        serverTimestamp,
        replyToId,
        isDeleted,
        isEdited,
        isStarred,
        isPinned,
        pinnedUntil,
        localSequence,
        attachmentsJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(Insertable<MessageData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta,
          serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
          _conversationIdMeta,
          conversationId.isAcceptableOrUnknown(
              data['conversation_id']!, _conversationIdMeta));
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(_senderIdMeta,
          senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta));
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('sender_name')) {
      context.handle(
          _senderNameMeta,
          senderName.isAcceptableOrUnknown(
              data['sender_name']!, _senderNameMeta));
    }
    if (data.containsKey('sender_avatar')) {
      context.handle(
          _senderAvatarMeta,
          senderAvatar.isAcceptableOrUnknown(
              data['sender_avatar']!, _senderAvatarMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('content_nonce')) {
      context.handle(
          _contentNonceMeta,
          contentNonce.isAcceptableOrUnknown(
              data['content_nonce']!, _contentNonceMeta));
    }
    if (data.containsKey('is_encrypted')) {
      context.handle(
          _isEncryptedMeta,
          isEncrypted.isAcceptableOrUnknown(
              data['is_encrypted']!, _isEncryptedMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('client_timestamp')) {
      context.handle(
          _clientTimestampMeta,
          clientTimestamp.isAcceptableOrUnknown(
              data['client_timestamp']!, _clientTimestampMeta));
    } else if (isInserting) {
      context.missing(_clientTimestampMeta);
    }
    if (data.containsKey('server_timestamp')) {
      context.handle(
          _serverTimestampMeta,
          serverTimestamp.isAcceptableOrUnknown(
              data['server_timestamp']!, _serverTimestampMeta));
    }
    if (data.containsKey('reply_to_id')) {
      context.handle(
          _replyToIdMeta,
          replyToId.isAcceptableOrUnknown(
              data['reply_to_id']!, _replyToIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('is_edited')) {
      context.handle(_isEditedMeta,
          isEdited.isAcceptableOrUnknown(data['is_edited']!, _isEditedMeta));
    }
    if (data.containsKey('is_starred')) {
      context.handle(_isStarredMeta,
          isStarred.isAcceptableOrUnknown(data['is_starred']!, _isStarredMeta));
    }
    if (data.containsKey('is_pinned')) {
      context.handle(_isPinnedMeta,
          isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta));
    }
    if (data.containsKey('pinned_until')) {
      context.handle(
          _pinnedUntilMeta,
          pinnedUntil.isAcceptableOrUnknown(
              data['pinned_until']!, _pinnedUntilMeta));
    }
    if (data.containsKey('local_sequence')) {
      context.handle(
          _localSequenceMeta,
          localSequence.isAcceptableOrUnknown(
              data['local_sequence']!, _localSequenceMeta));
    }
    if (data.containsKey('attachments_json')) {
      context.handle(
          _attachmentsJsonMeta,
          attachmentsJson.isAcceptableOrUnknown(
              data['attachments_json']!, _attachmentsJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      serverId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_id']),
      conversationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conversation_id'])!,
      senderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_id'])!,
      senderName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_name']),
      senderAvatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sender_avatar']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      contentNonce: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_nonce']),
      isEncrypted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_encrypted'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      clientTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}client_timestamp'])!,
      serverTimestamp: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}server_timestamp']),
      replyToId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reply_to_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      isEdited: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_edited'])!,
      isStarred: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_starred'])!,
      isPinned: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_pinned'])!,
      pinnedUntil: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}pinned_until']),
      localSequence: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}local_sequence'])!,
      attachmentsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}attachments_json']),
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }
}

class MessageData extends DataClass implements Insertable<MessageData> {
  final String id;
  final String? serverId;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String? senderAvatar;
  final String content;
  final String? contentNonce;
  final bool isEncrypted;
  final String type;
  final String status;
  final DateTime clientTimestamp;
  final DateTime? serverTimestamp;
  final String? replyToId;
  final bool isDeleted;
  final bool isEdited;
  final bool isStarred;
  final bool isPinned;
  final DateTime? pinnedUntil;
  final int localSequence;
  final String? attachmentsJson;
  const MessageData(
      {required this.id,
      this.serverId,
      required this.conversationId,
      required this.senderId,
      this.senderName,
      this.senderAvatar,
      required this.content,
      this.contentNonce,
      required this.isEncrypted,
      required this.type,
      required this.status,
      required this.clientTimestamp,
      this.serverTimestamp,
      this.replyToId,
      required this.isDeleted,
      required this.isEdited,
      required this.isStarred,
      required this.isPinned,
      this.pinnedUntil,
      required this.localSequence,
      this.attachmentsJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    map['conversation_id'] = Variable<String>(conversationId);
    map['sender_id'] = Variable<String>(senderId);
    if (!nullToAbsent || senderName != null) {
      map['sender_name'] = Variable<String>(senderName);
    }
    if (!nullToAbsent || senderAvatar != null) {
      map['sender_avatar'] = Variable<String>(senderAvatar);
    }
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || contentNonce != null) {
      map['content_nonce'] = Variable<String>(contentNonce);
    }
    map['is_encrypted'] = Variable<bool>(isEncrypted);
    map['type'] = Variable<String>(type);
    map['status'] = Variable<String>(status);
    map['client_timestamp'] = Variable<DateTime>(clientTimestamp);
    if (!nullToAbsent || serverTimestamp != null) {
      map['server_timestamp'] = Variable<DateTime>(serverTimestamp);
    }
    if (!nullToAbsent || replyToId != null) {
      map['reply_to_id'] = Variable<String>(replyToId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['is_edited'] = Variable<bool>(isEdited);
    map['is_starred'] = Variable<bool>(isStarred);
    map['is_pinned'] = Variable<bool>(isPinned);
    if (!nullToAbsent || pinnedUntil != null) {
      map['pinned_until'] = Variable<DateTime>(pinnedUntil);
    }
    map['local_sequence'] = Variable<int>(localSequence);
    if (!nullToAbsent || attachmentsJson != null) {
      map['attachments_json'] = Variable<String>(attachmentsJson);
    }
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      conversationId: Value(conversationId),
      senderId: Value(senderId),
      senderName: senderName == null && nullToAbsent
          ? const Value.absent()
          : Value(senderName),
      senderAvatar: senderAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(senderAvatar),
      content: Value(content),
      contentNonce: contentNonce == null && nullToAbsent
          ? const Value.absent()
          : Value(contentNonce),
      isEncrypted: Value(isEncrypted),
      type: Value(type),
      status: Value(status),
      clientTimestamp: Value(clientTimestamp),
      serverTimestamp: serverTimestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(serverTimestamp),
      replyToId: replyToId == null && nullToAbsent
          ? const Value.absent()
          : Value(replyToId),
      isDeleted: Value(isDeleted),
      isEdited: Value(isEdited),
      isStarred: Value(isStarred),
      isPinned: Value(isPinned),
      pinnedUntil: pinnedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(pinnedUntil),
      localSequence: Value(localSequence),
      attachmentsJson: attachmentsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(attachmentsJson),
    );
  }

  factory MessageData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageData(
      id: serializer.fromJson<String>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      senderName: serializer.fromJson<String?>(json['senderName']),
      senderAvatar: serializer.fromJson<String?>(json['senderAvatar']),
      content: serializer.fromJson<String>(json['content']),
      contentNonce: serializer.fromJson<String?>(json['contentNonce']),
      isEncrypted: serializer.fromJson<bool>(json['isEncrypted']),
      type: serializer.fromJson<String>(json['type']),
      status: serializer.fromJson<String>(json['status']),
      clientTimestamp: serializer.fromJson<DateTime>(json['clientTimestamp']),
      serverTimestamp: serializer.fromJson<DateTime?>(json['serverTimestamp']),
      replyToId: serializer.fromJson<String?>(json['replyToId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      isEdited: serializer.fromJson<bool>(json['isEdited']),
      isStarred: serializer.fromJson<bool>(json['isStarred']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      pinnedUntil: serializer.fromJson<DateTime?>(json['pinnedUntil']),
      localSequence: serializer.fromJson<int>(json['localSequence']),
      attachmentsJson: serializer.fromJson<String?>(json['attachmentsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'conversationId': serializer.toJson<String>(conversationId),
      'senderId': serializer.toJson<String>(senderId),
      'senderName': serializer.toJson<String?>(senderName),
      'senderAvatar': serializer.toJson<String?>(senderAvatar),
      'content': serializer.toJson<String>(content),
      'contentNonce': serializer.toJson<String?>(contentNonce),
      'isEncrypted': serializer.toJson<bool>(isEncrypted),
      'type': serializer.toJson<String>(type),
      'status': serializer.toJson<String>(status),
      'clientTimestamp': serializer.toJson<DateTime>(clientTimestamp),
      'serverTimestamp': serializer.toJson<DateTime?>(serverTimestamp),
      'replyToId': serializer.toJson<String?>(replyToId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'isEdited': serializer.toJson<bool>(isEdited),
      'isStarred': serializer.toJson<bool>(isStarred),
      'isPinned': serializer.toJson<bool>(isPinned),
      'pinnedUntil': serializer.toJson<DateTime?>(pinnedUntil),
      'localSequence': serializer.toJson<int>(localSequence),
      'attachmentsJson': serializer.toJson<String?>(attachmentsJson),
    };
  }

  MessageData copyWith(
          {String? id,
          Value<String?> serverId = const Value.absent(),
          String? conversationId,
          String? senderId,
          Value<String?> senderName = const Value.absent(),
          Value<String?> senderAvatar = const Value.absent(),
          String? content,
          Value<String?> contentNonce = const Value.absent(),
          bool? isEncrypted,
          String? type,
          String? status,
          DateTime? clientTimestamp,
          Value<DateTime?> serverTimestamp = const Value.absent(),
          Value<String?> replyToId = const Value.absent(),
          bool? isDeleted,
          bool? isEdited,
          bool? isStarred,
          bool? isPinned,
          Value<DateTime?> pinnedUntil = const Value.absent(),
          int? localSequence,
          Value<String?> attachmentsJson = const Value.absent()}) =>
      MessageData(
        id: id ?? this.id,
        serverId: serverId.present ? serverId.value : this.serverId,
        conversationId: conversationId ?? this.conversationId,
        senderId: senderId ?? this.senderId,
        senderName: senderName.present ? senderName.value : this.senderName,
        senderAvatar:
            senderAvatar.present ? senderAvatar.value : this.senderAvatar,
        content: content ?? this.content,
        contentNonce:
            contentNonce.present ? contentNonce.value : this.contentNonce,
        isEncrypted: isEncrypted ?? this.isEncrypted,
        type: type ?? this.type,
        status: status ?? this.status,
        clientTimestamp: clientTimestamp ?? this.clientTimestamp,
        serverTimestamp: serverTimestamp.present
            ? serverTimestamp.value
            : this.serverTimestamp,
        replyToId: replyToId.present ? replyToId.value : this.replyToId,
        isDeleted: isDeleted ?? this.isDeleted,
        isEdited: isEdited ?? this.isEdited,
        isStarred: isStarred ?? this.isStarred,
        isPinned: isPinned ?? this.isPinned,
        pinnedUntil: pinnedUntil.present ? pinnedUntil.value : this.pinnedUntil,
        localSequence: localSequence ?? this.localSequence,
        attachmentsJson: attachmentsJson.present
            ? attachmentsJson.value
            : this.attachmentsJson,
      );
  MessageData copyWithCompanion(MessagesCompanion data) {
    return MessageData(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      senderName:
          data.senderName.present ? data.senderName.value : this.senderName,
      senderAvatar: data.senderAvatar.present
          ? data.senderAvatar.value
          : this.senderAvatar,
      content: data.content.present ? data.content.value : this.content,
      contentNonce: data.contentNonce.present
          ? data.contentNonce.value
          : this.contentNonce,
      isEncrypted:
          data.isEncrypted.present ? data.isEncrypted.value : this.isEncrypted,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      clientTimestamp: data.clientTimestamp.present
          ? data.clientTimestamp.value
          : this.clientTimestamp,
      serverTimestamp: data.serverTimestamp.present
          ? data.serverTimestamp.value
          : this.serverTimestamp,
      replyToId: data.replyToId.present ? data.replyToId.value : this.replyToId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      isEdited: data.isEdited.present ? data.isEdited.value : this.isEdited,
      isStarred: data.isStarred.present ? data.isStarred.value : this.isStarred,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      pinnedUntil:
          data.pinnedUntil.present ? data.pinnedUntil.value : this.pinnedUntil,
      localSequence: data.localSequence.present
          ? data.localSequence.value
          : this.localSequence,
      attachmentsJson: data.attachmentsJson.present
          ? data.attachmentsJson.value
          : this.attachmentsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MessageData(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('conversationId: $conversationId, ')
          ..write('senderId: $senderId, ')
          ..write('senderName: $senderName, ')
          ..write('senderAvatar: $senderAvatar, ')
          ..write('content: $content, ')
          ..write('contentNonce: $contentNonce, ')
          ..write('isEncrypted: $isEncrypted, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('clientTimestamp: $clientTimestamp, ')
          ..write('serverTimestamp: $serverTimestamp, ')
          ..write('replyToId: $replyToId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('isEdited: $isEdited, ')
          ..write('isStarred: $isStarred, ')
          ..write('isPinned: $isPinned, ')
          ..write('pinnedUntil: $pinnedUntil, ')
          ..write('localSequence: $localSequence, ')
          ..write('attachmentsJson: $attachmentsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        serverId,
        conversationId,
        senderId,
        senderName,
        senderAvatar,
        content,
        contentNonce,
        isEncrypted,
        type,
        status,
        clientTimestamp,
        serverTimestamp,
        replyToId,
        isDeleted,
        isEdited,
        isStarred,
        isPinned,
        pinnedUntil,
        localSequence,
        attachmentsJson
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageData &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.conversationId == this.conversationId &&
          other.senderId == this.senderId &&
          other.senderName == this.senderName &&
          other.senderAvatar == this.senderAvatar &&
          other.content == this.content &&
          other.contentNonce == this.contentNonce &&
          other.isEncrypted == this.isEncrypted &&
          other.type == this.type &&
          other.status == this.status &&
          other.clientTimestamp == this.clientTimestamp &&
          other.serverTimestamp == this.serverTimestamp &&
          other.replyToId == this.replyToId &&
          other.isDeleted == this.isDeleted &&
          other.isEdited == this.isEdited &&
          other.isStarred == this.isStarred &&
          other.isPinned == this.isPinned &&
          other.pinnedUntil == this.pinnedUntil &&
          other.localSequence == this.localSequence &&
          other.attachmentsJson == this.attachmentsJson);
}

class MessagesCompanion extends UpdateCompanion<MessageData> {
  final Value<String> id;
  final Value<String?> serverId;
  final Value<String> conversationId;
  final Value<String> senderId;
  final Value<String?> senderName;
  final Value<String?> senderAvatar;
  final Value<String> content;
  final Value<String?> contentNonce;
  final Value<bool> isEncrypted;
  final Value<String> type;
  final Value<String> status;
  final Value<DateTime> clientTimestamp;
  final Value<DateTime?> serverTimestamp;
  final Value<String?> replyToId;
  final Value<bool> isDeleted;
  final Value<bool> isEdited;
  final Value<bool> isStarred;
  final Value<bool> isPinned;
  final Value<DateTime?> pinnedUntil;
  final Value<int> localSequence;
  final Value<String?> attachmentsJson;
  final Value<int> rowid;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.senderName = const Value.absent(),
    this.senderAvatar = const Value.absent(),
    this.content = const Value.absent(),
    this.contentNonce = const Value.absent(),
    this.isEncrypted = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.clientTimestamp = const Value.absent(),
    this.serverTimestamp = const Value.absent(),
    this.replyToId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.isEdited = const Value.absent(),
    this.isStarred = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.pinnedUntil = const Value.absent(),
    this.localSequence = const Value.absent(),
    this.attachmentsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MessagesCompanion.insert({
    required String id,
    this.serverId = const Value.absent(),
    required String conversationId,
    required String senderId,
    this.senderName = const Value.absent(),
    this.senderAvatar = const Value.absent(),
    required String content,
    this.contentNonce = const Value.absent(),
    this.isEncrypted = const Value.absent(),
    required String type,
    required String status,
    required DateTime clientTimestamp,
    this.serverTimestamp = const Value.absent(),
    this.replyToId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.isEdited = const Value.absent(),
    this.isStarred = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.pinnedUntil = const Value.absent(),
    this.localSequence = const Value.absent(),
    this.attachmentsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        conversationId = Value(conversationId),
        senderId = Value(senderId),
        content = Value(content),
        type = Value(type),
        status = Value(status),
        clientTimestamp = Value(clientTimestamp);
  static Insertable<MessageData> custom({
    Expression<String>? id,
    Expression<String>? serverId,
    Expression<String>? conversationId,
    Expression<String>? senderId,
    Expression<String>? senderName,
    Expression<String>? senderAvatar,
    Expression<String>? content,
    Expression<String>? contentNonce,
    Expression<bool>? isEncrypted,
    Expression<String>? type,
    Expression<String>? status,
    Expression<DateTime>? clientTimestamp,
    Expression<DateTime>? serverTimestamp,
    Expression<String>? replyToId,
    Expression<bool>? isDeleted,
    Expression<bool>? isEdited,
    Expression<bool>? isStarred,
    Expression<bool>? isPinned,
    Expression<DateTime>? pinnedUntil,
    Expression<int>? localSequence,
    Expression<String>? attachmentsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (conversationId != null) 'conversation_id': conversationId,
      if (senderId != null) 'sender_id': senderId,
      if (senderName != null) 'sender_name': senderName,
      if (senderAvatar != null) 'sender_avatar': senderAvatar,
      if (content != null) 'content': content,
      if (contentNonce != null) 'content_nonce': contentNonce,
      if (isEncrypted != null) 'is_encrypted': isEncrypted,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (clientTimestamp != null) 'client_timestamp': clientTimestamp,
      if (serverTimestamp != null) 'server_timestamp': serverTimestamp,
      if (replyToId != null) 'reply_to_id': replyToId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (isEdited != null) 'is_edited': isEdited,
      if (isStarred != null) 'is_starred': isStarred,
      if (isPinned != null) 'is_pinned': isPinned,
      if (pinnedUntil != null) 'pinned_until': pinnedUntil,
      if (localSequence != null) 'local_sequence': localSequence,
      if (attachmentsJson != null) 'attachments_json': attachmentsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MessagesCompanion copyWith(
      {Value<String>? id,
      Value<String?>? serverId,
      Value<String>? conversationId,
      Value<String>? senderId,
      Value<String?>? senderName,
      Value<String?>? senderAvatar,
      Value<String>? content,
      Value<String?>? contentNonce,
      Value<bool>? isEncrypted,
      Value<String>? type,
      Value<String>? status,
      Value<DateTime>? clientTimestamp,
      Value<DateTime?>? serverTimestamp,
      Value<String?>? replyToId,
      Value<bool>? isDeleted,
      Value<bool>? isEdited,
      Value<bool>? isStarred,
      Value<bool>? isPinned,
      Value<DateTime?>? pinnedUntil,
      Value<int>? localSequence,
      Value<String?>? attachmentsJson,
      Value<int>? rowid}) {
    return MessagesCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      content: content ?? this.content,
      contentNonce: contentNonce ?? this.contentNonce,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      type: type ?? this.type,
      status: status ?? this.status,
      clientTimestamp: clientTimestamp ?? this.clientTimestamp,
      serverTimestamp: serverTimestamp ?? this.serverTimestamp,
      replyToId: replyToId ?? this.replyToId,
      isDeleted: isDeleted ?? this.isDeleted,
      isEdited: isEdited ?? this.isEdited,
      isStarred: isStarred ?? this.isStarred,
      isPinned: isPinned ?? this.isPinned,
      pinnedUntil: pinnedUntil ?? this.pinnedUntil,
      localSequence: localSequence ?? this.localSequence,
      attachmentsJson: attachmentsJson ?? this.attachmentsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (senderName.present) {
      map['sender_name'] = Variable<String>(senderName.value);
    }
    if (senderAvatar.present) {
      map['sender_avatar'] = Variable<String>(senderAvatar.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (contentNonce.present) {
      map['content_nonce'] = Variable<String>(contentNonce.value);
    }
    if (isEncrypted.present) {
      map['is_encrypted'] = Variable<bool>(isEncrypted.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (clientTimestamp.present) {
      map['client_timestamp'] = Variable<DateTime>(clientTimestamp.value);
    }
    if (serverTimestamp.present) {
      map['server_timestamp'] = Variable<DateTime>(serverTimestamp.value);
    }
    if (replyToId.present) {
      map['reply_to_id'] = Variable<String>(replyToId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (isEdited.present) {
      map['is_edited'] = Variable<bool>(isEdited.value);
    }
    if (isStarred.present) {
      map['is_starred'] = Variable<bool>(isStarred.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (pinnedUntil.present) {
      map['pinned_until'] = Variable<DateTime>(pinnedUntil.value);
    }
    if (localSequence.present) {
      map['local_sequence'] = Variable<int>(localSequence.value);
    }
    if (attachmentsJson.present) {
      map['attachments_json'] = Variable<String>(attachmentsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('conversationId: $conversationId, ')
          ..write('senderId: $senderId, ')
          ..write('senderName: $senderName, ')
          ..write('senderAvatar: $senderAvatar, ')
          ..write('content: $content, ')
          ..write('contentNonce: $contentNonce, ')
          ..write('isEncrypted: $isEncrypted, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('clientTimestamp: $clientTimestamp, ')
          ..write('serverTimestamp: $serverTimestamp, ')
          ..write('replyToId: $replyToId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('isEdited: $isEdited, ')
          ..write('isStarred: $isStarred, ')
          ..write('isPinned: $isPinned, ')
          ..write('pinnedUntil: $pinnedUntil, ')
          ..write('localSequence: $localSequence, ')
          ..write('attachmentsJson: $attachmentsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConversationsTable extends Conversations
    with TableInfo<$ConversationsTable, ConversationData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
      'mode', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unreadCountMeta =
      const VerificationMeta('unreadCount');
  @override
  late final GeneratedColumn<int> unreadCount = GeneratedColumn<int>(
      'unread_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _myRoleMeta = const VerificationMeta('myRole');
  @override
  late final GeneratedColumn<String> myRole = GeneratedColumn<String>(
      'my_role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastMessageIdMeta =
      const VerificationMeta('lastMessageId');
  @override
  late final GeneratedColumn<String> lastMessageId = GeneratedColumn<String>(
      'last_message_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastMessageAtMeta =
      const VerificationMeta('lastMessageAt');
  @override
  late final GeneratedColumn<DateTime> lastMessageAt =
      GeneratedColumn<DateTime>('last_message_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        avatarUrl,
        type,
        mode,
        status,
        unreadCount,
        myRole,
        lastMessageId,
        lastMessageAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversations';
  @override
  VerificationContext validateIntegrity(Insertable<ConversationData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
          _modeMeta, mode.isAcceptableOrUnknown(data['mode']!, _modeMeta));
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('unread_count')) {
      context.handle(
          _unreadCountMeta,
          unreadCount.isAcceptableOrUnknown(
              data['unread_count']!, _unreadCountMeta));
    }
    if (data.containsKey('my_role')) {
      context.handle(_myRoleMeta,
          myRole.isAcceptableOrUnknown(data['my_role']!, _myRoleMeta));
    } else if (isInserting) {
      context.missing(_myRoleMeta);
    }
    if (data.containsKey('last_message_id')) {
      context.handle(
          _lastMessageIdMeta,
          lastMessageId.isAcceptableOrUnknown(
              data['last_message_id']!, _lastMessageIdMeta));
    }
    if (data.containsKey('last_message_at')) {
      context.handle(
          _lastMessageAtMeta,
          lastMessageAt.isAcceptableOrUnknown(
              data['last_message_at']!, _lastMessageAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConversationData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversationData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      mode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mode'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      unreadCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unread_count'])!,
      myRole: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}my_role'])!,
      lastMessageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_message_id']),
      lastMessageAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_message_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ConversationsTable createAlias(String alias) {
    return $ConversationsTable(attachedDatabase, alias);
  }
}

class ConversationData extends DataClass
    implements Insertable<ConversationData> {
  final String id;
  final String? name;
  final String? avatarUrl;
  final String type;
  final String mode;
  final String status;
  final int unreadCount;
  final String myRole;
  final String? lastMessageId;
  final DateTime? lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ConversationData(
      {required this.id,
      this.name,
      this.avatarUrl,
      required this.type,
      required this.mode,
      required this.status,
      required this.unreadCount,
      required this.myRole,
      this.lastMessageId,
      this.lastMessageAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['type'] = Variable<String>(type);
    map['mode'] = Variable<String>(mode);
    map['status'] = Variable<String>(status);
    map['unread_count'] = Variable<int>(unreadCount);
    map['my_role'] = Variable<String>(myRole);
    if (!nullToAbsent || lastMessageId != null) {
      map['last_message_id'] = Variable<String>(lastMessageId);
    }
    if (!nullToAbsent || lastMessageAt != null) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ConversationsCompanion toCompanion(bool nullToAbsent) {
    return ConversationsCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      type: Value(type),
      mode: Value(mode),
      status: Value(status),
      unreadCount: Value(unreadCount),
      myRole: Value(myRole),
      lastMessageId: lastMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageId),
      lastMessageAt: lastMessageAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ConversationData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversationData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      type: serializer.fromJson<String>(json['type']),
      mode: serializer.fromJson<String>(json['mode']),
      status: serializer.fromJson<String>(json['status']),
      unreadCount: serializer.fromJson<int>(json['unreadCount']),
      myRole: serializer.fromJson<String>(json['myRole']),
      lastMessageId: serializer.fromJson<String?>(json['lastMessageId']),
      lastMessageAt: serializer.fromJson<DateTime?>(json['lastMessageAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String?>(name),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'type': serializer.toJson<String>(type),
      'mode': serializer.toJson<String>(mode),
      'status': serializer.toJson<String>(status),
      'unreadCount': serializer.toJson<int>(unreadCount),
      'myRole': serializer.toJson<String>(myRole),
      'lastMessageId': serializer.toJson<String?>(lastMessageId),
      'lastMessageAt': serializer.toJson<DateTime?>(lastMessageAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ConversationData copyWith(
          {String? id,
          Value<String?> name = const Value.absent(),
          Value<String?> avatarUrl = const Value.absent(),
          String? type,
          String? mode,
          String? status,
          int? unreadCount,
          String? myRole,
          Value<String?> lastMessageId = const Value.absent(),
          Value<DateTime?> lastMessageAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ConversationData(
        id: id ?? this.id,
        name: name.present ? name.value : this.name,
        avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
        type: type ?? this.type,
        mode: mode ?? this.mode,
        status: status ?? this.status,
        unreadCount: unreadCount ?? this.unreadCount,
        myRole: myRole ?? this.myRole,
        lastMessageId:
            lastMessageId.present ? lastMessageId.value : this.lastMessageId,
        lastMessageAt:
            lastMessageAt.present ? lastMessageAt.value : this.lastMessageAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ConversationData copyWithCompanion(ConversationsCompanion data) {
    return ConversationData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      type: data.type.present ? data.type.value : this.type,
      mode: data.mode.present ? data.mode.value : this.mode,
      status: data.status.present ? data.status.value : this.status,
      unreadCount:
          data.unreadCount.present ? data.unreadCount.value : this.unreadCount,
      myRole: data.myRole.present ? data.myRole.value : this.myRole,
      lastMessageId: data.lastMessageId.present
          ? data.lastMessageId.value
          : this.lastMessageId,
      lastMessageAt: data.lastMessageAt.present
          ? data.lastMessageAt.value
          : this.lastMessageAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversationData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('type: $type, ')
          ..write('mode: $mode, ')
          ..write('status: $status, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('myRole: $myRole, ')
          ..write('lastMessageId: $lastMessageId, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, avatarUrl, type, mode, status,
      unreadCount, myRole, lastMessageId, lastMessageAt, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversationData &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatarUrl == this.avatarUrl &&
          other.type == this.type &&
          other.mode == this.mode &&
          other.status == this.status &&
          other.unreadCount == this.unreadCount &&
          other.myRole == this.myRole &&
          other.lastMessageId == this.lastMessageId &&
          other.lastMessageAt == this.lastMessageAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ConversationsCompanion extends UpdateCompanion<ConversationData> {
  final Value<String> id;
  final Value<String?> name;
  final Value<String?> avatarUrl;
  final Value<String> type;
  final Value<String> mode;
  final Value<String> status;
  final Value<int> unreadCount;
  final Value<String> myRole;
  final Value<String?> lastMessageId;
  final Value<DateTime?> lastMessageAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ConversationsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.type = const Value.absent(),
    this.mode = const Value.absent(),
    this.status = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.myRole = const Value.absent(),
    this.lastMessageId = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationsCompanion.insert({
    required String id,
    this.name = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    required String type,
    required String mode,
    required String status,
    this.unreadCount = const Value.absent(),
    required String myRole,
    this.lastMessageId = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        mode = Value(mode),
        status = Value(status),
        myRole = Value(myRole),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ConversationData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? avatarUrl,
    Expression<String>? type,
    Expression<String>? mode,
    Expression<String>? status,
    Expression<int>? unreadCount,
    Expression<String>? myRole,
    Expression<String>? lastMessageId,
    Expression<DateTime>? lastMessageAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (type != null) 'type': type,
      if (mode != null) 'mode': mode,
      if (status != null) 'status': status,
      if (unreadCount != null) 'unread_count': unreadCount,
      if (myRole != null) 'my_role': myRole,
      if (lastMessageId != null) 'last_message_id': lastMessageId,
      if (lastMessageAt != null) 'last_message_at': lastMessageAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? name,
      Value<String?>? avatarUrl,
      Value<String>? type,
      Value<String>? mode,
      Value<String>? status,
      Value<int>? unreadCount,
      Value<String>? myRole,
      Value<String?>? lastMessageId,
      Value<DateTime?>? lastMessageAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ConversationsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      type: type ?? this.type,
      mode: mode ?? this.mode,
      status: status ?? this.status,
      unreadCount: unreadCount ?? this.unreadCount,
      myRole: myRole ?? this.myRole,
      lastMessageId: lastMessageId ?? this.lastMessageId,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (unreadCount.present) {
      map['unread_count'] = Variable<int>(unreadCount.value);
    }
    if (myRole.present) {
      map['my_role'] = Variable<String>(myRole.value);
    }
    if (lastMessageId.present) {
      map['last_message_id'] = Variable<String>(lastMessageId.value);
    }
    if (lastMessageAt.present) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('type: $type, ')
          ..write('mode: $mode, ')
          ..write('status: $status, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('myRole: $myRole, ')
          ..write('lastMessageId: $lastMessageId, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncStatesTable extends SyncStates
    with TableInfo<$SyncStatesTable, SyncStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _lastSyncTokenMeta =
      const VerificationMeta('lastSyncToken');
  @override
  late final GeneratedColumn<String> lastSyncToken = GeneratedColumn<String>(
      'last_sync_token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastSyncAtMeta =
      const VerificationMeta('lastSyncAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
      'last_sync_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isInitialSyncCompleteMeta =
      const VerificationMeta('isInitialSyncComplete');
  @override
  late final GeneratedColumn<bool> isInitialSyncComplete =
      GeneratedColumn<bool>('is_initial_sync_complete', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintIsAlways(
              'CHECK ("is_initial_sync_complete" IN (0, 1))'),
          defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, lastSyncToken, lastSyncAt, isInitialSyncComplete];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_states';
  @override
  VerificationContext validateIntegrity(Insertable<SyncStateData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_sync_token')) {
      context.handle(
          _lastSyncTokenMeta,
          lastSyncToken.isAcceptableOrUnknown(
              data['last_sync_token']!, _lastSyncTokenMeta));
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
          _lastSyncAtMeta,
          lastSyncAt.isAcceptableOrUnknown(
              data['last_sync_at']!, _lastSyncAtMeta));
    }
    if (data.containsKey('is_initial_sync_complete')) {
      context.handle(
          _isInitialSyncCompleteMeta,
          isInitialSyncComplete.isAcceptableOrUnknown(
              data['is_initial_sync_complete']!, _isInitialSyncCompleteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      lastSyncToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_sync_token']),
      lastSyncAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_sync_at']),
      isInitialSyncComplete: attachedDatabase.typeMapping.read(
          DriftSqlType.bool,
          data['${effectivePrefix}is_initial_sync_complete'])!,
    );
  }

  @override
  $SyncStatesTable createAlias(String alias) {
    return $SyncStatesTable(attachedDatabase, alias);
  }
}

class SyncStateData extends DataClass implements Insertable<SyncStateData> {
  final int id;
  final String? lastSyncToken;
  final DateTime? lastSyncAt;
  final bool isInitialSyncComplete;
  const SyncStateData(
      {required this.id,
      this.lastSyncToken,
      this.lastSyncAt,
      required this.isInitialSyncComplete});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || lastSyncToken != null) {
      map['last_sync_token'] = Variable<String>(lastSyncToken);
    }
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    map['is_initial_sync_complete'] = Variable<bool>(isInitialSyncComplete);
    return map;
  }

  SyncStatesCompanion toCompanion(bool nullToAbsent) {
    return SyncStatesCompanion(
      id: Value(id),
      lastSyncToken: lastSyncToken == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncToken),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      isInitialSyncComplete: Value(isInitialSyncComplete),
    );
  }

  factory SyncStateData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateData(
      id: serializer.fromJson<int>(json['id']),
      lastSyncToken: serializer.fromJson<String?>(json['lastSyncToken']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
      isInitialSyncComplete:
          serializer.fromJson<bool>(json['isInitialSyncComplete']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastSyncToken': serializer.toJson<String?>(lastSyncToken),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
      'isInitialSyncComplete': serializer.toJson<bool>(isInitialSyncComplete),
    };
  }

  SyncStateData copyWith(
          {int? id,
          Value<String?> lastSyncToken = const Value.absent(),
          Value<DateTime?> lastSyncAt = const Value.absent(),
          bool? isInitialSyncComplete}) =>
      SyncStateData(
        id: id ?? this.id,
        lastSyncToken:
            lastSyncToken.present ? lastSyncToken.value : this.lastSyncToken,
        lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
        isInitialSyncComplete:
            isInitialSyncComplete ?? this.isInitialSyncComplete,
      );
  SyncStateData copyWithCompanion(SyncStatesCompanion data) {
    return SyncStateData(
      id: data.id.present ? data.id.value : this.id,
      lastSyncToken: data.lastSyncToken.present
          ? data.lastSyncToken.value
          : this.lastSyncToken,
      lastSyncAt:
          data.lastSyncAt.present ? data.lastSyncAt.value : this.lastSyncAt,
      isInitialSyncComplete: data.isInitialSyncComplete.present
          ? data.isInitialSyncComplete.value
          : this.isInitialSyncComplete,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateData(')
          ..write('id: $id, ')
          ..write('lastSyncToken: $lastSyncToken, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('isInitialSyncComplete: $isInitialSyncComplete')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, lastSyncToken, lastSyncAt, isInitialSyncComplete);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateData &&
          other.id == this.id &&
          other.lastSyncToken == this.lastSyncToken &&
          other.lastSyncAt == this.lastSyncAt &&
          other.isInitialSyncComplete == this.isInitialSyncComplete);
}

class SyncStatesCompanion extends UpdateCompanion<SyncStateData> {
  final Value<int> id;
  final Value<String?> lastSyncToken;
  final Value<DateTime?> lastSyncAt;
  final Value<bool> isInitialSyncComplete;
  const SyncStatesCompanion({
    this.id = const Value.absent(),
    this.lastSyncToken = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.isInitialSyncComplete = const Value.absent(),
  });
  SyncStatesCompanion.insert({
    this.id = const Value.absent(),
    this.lastSyncToken = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.isInitialSyncComplete = const Value.absent(),
  });
  static Insertable<SyncStateData> custom({
    Expression<int>? id,
    Expression<String>? lastSyncToken,
    Expression<DateTime>? lastSyncAt,
    Expression<bool>? isInitialSyncComplete,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastSyncToken != null) 'last_sync_token': lastSyncToken,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (isInitialSyncComplete != null)
        'is_initial_sync_complete': isInitialSyncComplete,
    });
  }

  SyncStatesCompanion copyWith(
      {Value<int>? id,
      Value<String?>? lastSyncToken,
      Value<DateTime?>? lastSyncAt,
      Value<bool>? isInitialSyncComplete}) {
    return SyncStatesCompanion(
      id: id ?? this.id,
      lastSyncToken: lastSyncToken ?? this.lastSyncToken,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      isInitialSyncComplete:
          isInitialSyncComplete ?? this.isInitialSyncComplete,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastSyncToken.present) {
      map['last_sync_token'] = Variable<String>(lastSyncToken.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (isInitialSyncComplete.present) {
      map['is_initial_sync_complete'] =
          Variable<bool>(isInitialSyncComplete.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStatesCompanion(')
          ..write('id: $id, ')
          ..write('lastSyncToken: $lastSyncToken, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('isInitialSyncComplete: $isInitialSyncComplete')
          ..write(')'))
        .toString();
  }
}

class $OutboundOperationsTable extends OutboundOperations
    with TableInfo<$OutboundOperationsTable, OutboundOperationData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutboundOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
      'data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _processedAtMeta =
      const VerificationMeta('processedAt');
  @override
  late final GeneratedColumn<DateTime> processedAt = GeneratedColumn<DateTime>(
      'processed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        type,
        data,
        retryCount,
        status,
        createdAt,
        processedAt,
        errorMessage
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outbound_operations';
  @override
  VerificationContext validateIntegrity(
      Insertable<OutboundOperationData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
          _dataMeta, this.data.isAcceptableOrUnknown(data['data']!, _dataMeta));
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('processed_at')) {
      context.handle(
          _processedAtMeta,
          processedAt.isAcceptableOrUnknown(
              data['processed_at']!, _processedAtMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutboundOperationData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboundOperationData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      data: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}data'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      processedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}processed_at']),
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
    );
  }

  @override
  $OutboundOperationsTable createAlias(String alias) {
    return $OutboundOperationsTable(attachedDatabase, alias);
  }
}

class OutboundOperationData extends DataClass
    implements Insertable<OutboundOperationData> {
  final String id;
  final String type;
  final String data;
  final int retryCount;
  final String status;
  final DateTime createdAt;
  final DateTime? processedAt;
  final String? errorMessage;
  const OutboundOperationData(
      {required this.id,
      required this.type,
      required this.data,
      required this.retryCount,
      required this.status,
      required this.createdAt,
      this.processedAt,
      this.errorMessage});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['data'] = Variable<String>(data);
    map['retry_count'] = Variable<int>(retryCount);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || processedAt != null) {
      map['processed_at'] = Variable<DateTime>(processedAt);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    return map;
  }

  OutboundOperationsCompanion toCompanion(bool nullToAbsent) {
    return OutboundOperationsCompanion(
      id: Value(id),
      type: Value(type),
      data: Value(data),
      retryCount: Value(retryCount),
      status: Value(status),
      createdAt: Value(createdAt),
      processedAt: processedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(processedAt),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
    );
  }

  factory OutboundOperationData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboundOperationData(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      data: serializer.fromJson<String>(json['data']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      processedAt: serializer.fromJson<DateTime?>(json['processedAt']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'data': serializer.toJson<String>(data),
      'retryCount': serializer.toJson<int>(retryCount),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'processedAt': serializer.toJson<DateTime?>(processedAt),
      'errorMessage': serializer.toJson<String?>(errorMessage),
    };
  }

  OutboundOperationData copyWith(
          {String? id,
          String? type,
          String? data,
          int? retryCount,
          String? status,
          DateTime? createdAt,
          Value<DateTime?> processedAt = const Value.absent(),
          Value<String?> errorMessage = const Value.absent()}) =>
      OutboundOperationData(
        id: id ?? this.id,
        type: type ?? this.type,
        data: data ?? this.data,
        retryCount: retryCount ?? this.retryCount,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        processedAt: processedAt.present ? processedAt.value : this.processedAt,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
      );
  OutboundOperationData copyWithCompanion(OutboundOperationsCompanion data) {
    return OutboundOperationData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      data: data.data.present ? data.data.value : this.data,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      processedAt:
          data.processedAt.present ? data.processedAt.value : this.processedAt,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboundOperationData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('data: $data, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('processedAt: $processedAt, ')
          ..write('errorMessage: $errorMessage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, type, data, retryCount, status, createdAt, processedAt, errorMessage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboundOperationData &&
          other.id == this.id &&
          other.type == this.type &&
          other.data == this.data &&
          other.retryCount == this.retryCount &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.processedAt == this.processedAt &&
          other.errorMessage == this.errorMessage);
}

class OutboundOperationsCompanion
    extends UpdateCompanion<OutboundOperationData> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> data;
  final Value<int> retryCount;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> processedAt;
  final Value<String?> errorMessage;
  final Value<int> rowid;
  const OutboundOperationsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.data = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutboundOperationsCompanion.insert({
    required String id,
    required String type,
    required String data,
    this.retryCount = const Value.absent(),
    required String status,
    required DateTime createdAt,
    this.processedAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        data = Value(data),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<OutboundOperationData> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? data,
    Expression<int>? retryCount,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? processedAt,
    Expression<String>? errorMessage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (data != null) 'data': data,
      if (retryCount != null) 'retry_count': retryCount,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (processedAt != null) 'processed_at': processedAt,
      if (errorMessage != null) 'error_message': errorMessage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutboundOperationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? type,
      Value<String>? data,
      Value<int>? retryCount,
      Value<String>? status,
      Value<DateTime>? createdAt,
      Value<DateTime?>? processedAt,
      Value<String?>? errorMessage,
      Value<int>? rowid}) {
    return OutboundOperationsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      data: data ?? this.data,
      retryCount: retryCount ?? this.retryCount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      processedAt: processedAt ?? this.processedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (processedAt.present) {
      map['processed_at'] = Variable<DateTime>(processedAt.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutboundOperationsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('data: $data, ')
          ..write('retryCount: $retryCount, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('processedAt: $processedAt, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReactionsTable extends Reactions
    with TableInfo<$ReactionsTable, ReactionData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageIdMeta =
      const VerificationMeta('messageId');
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
      'message_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
      'emoji', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userNameMeta =
      const VerificationMeta('userName');
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
      'user_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, messageId, emoji, userId, userName, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reactions';
  @override
  VerificationContext validateIntegrity(Insertable<ReactionData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
          _emojiMeta, emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta));
    } else if (isInserting) {
      context.missing(_emojiMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('user_name')) {
      context.handle(_userNameMeta,
          userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReactionData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReactionData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      messageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_id'])!,
      emoji: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}emoji'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      userName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_name']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
    );
  }

  @override
  $ReactionsTable createAlias(String alias) {
    return $ReactionsTable(attachedDatabase, alias);
  }
}

class ReactionData extends DataClass implements Insertable<ReactionData> {
  final String id;
  final String messageId;
  final String emoji;
  final String userId;
  final String? userName;
  final DateTime? createdAt;
  const ReactionData(
      {required this.id,
      required this.messageId,
      required this.emoji,
      required this.userId,
      this.userName,
      this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['message_id'] = Variable<String>(messageId);
    map['emoji'] = Variable<String>(emoji);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || userName != null) {
      map['user_name'] = Variable<String>(userName);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  ReactionsCompanion toCompanion(bool nullToAbsent) {
    return ReactionsCompanion(
      id: Value(id),
      messageId: Value(messageId),
      emoji: Value(emoji),
      userId: Value(userId),
      userName: userName == null && nullToAbsent
          ? const Value.absent()
          : Value(userName),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory ReactionData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReactionData(
      id: serializer.fromJson<String>(json['id']),
      messageId: serializer.fromJson<String>(json['messageId']),
      emoji: serializer.fromJson<String>(json['emoji']),
      userId: serializer.fromJson<String>(json['userId']),
      userName: serializer.fromJson<String?>(json['userName']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageId': serializer.toJson<String>(messageId),
      'emoji': serializer.toJson<String>(emoji),
      'userId': serializer.toJson<String>(userId),
      'userName': serializer.toJson<String?>(userName),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  ReactionData copyWith(
          {String? id,
          String? messageId,
          String? emoji,
          String? userId,
          Value<String?> userName = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent()}) =>
      ReactionData(
        id: id ?? this.id,
        messageId: messageId ?? this.messageId,
        emoji: emoji ?? this.emoji,
        userId: userId ?? this.userId,
        userName: userName.present ? userName.value : this.userName,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
      );
  ReactionData copyWithCompanion(ReactionsCompanion data) {
    return ReactionData(
      id: data.id.present ? data.id.value : this.id,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      userId: data.userId.present ? data.userId.value : this.userId,
      userName: data.userName.present ? data.userName.value : this.userName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReactionData(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('emoji: $emoji, ')
          ..write('userId: $userId, ')
          ..write('userName: $userName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, messageId, emoji, userId, userName, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReactionData &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.emoji == this.emoji &&
          other.userId == this.userId &&
          other.userName == this.userName &&
          other.createdAt == this.createdAt);
}

class ReactionsCompanion extends UpdateCompanion<ReactionData> {
  final Value<String> id;
  final Value<String> messageId;
  final Value<String> emoji;
  final Value<String> userId;
  final Value<String?> userName;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const ReactionsCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.emoji = const Value.absent(),
    this.userId = const Value.absent(),
    this.userName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReactionsCompanion.insert({
    required String id,
    required String messageId,
    required String emoji,
    required String userId,
    this.userName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        messageId = Value(messageId),
        emoji = Value(emoji),
        userId = Value(userId);
  static Insertable<ReactionData> custom({
    Expression<String>? id,
    Expression<String>? messageId,
    Expression<String>? emoji,
    Expression<String>? userId,
    Expression<String>? userName,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (emoji != null) 'emoji': emoji,
      if (userId != null) 'user_id': userId,
      if (userName != null) 'user_name': userName,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? messageId,
      Value<String>? emoji,
      Value<String>? userId,
      Value<String?>? userName,
      Value<DateTime?>? createdAt,
      Value<int>? rowid}) {
    return ReactionsCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      emoji: emoji ?? this.emoji,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReactionsCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('emoji: $emoji, ')
          ..write('userId: $userId, ')
          ..write('userName: $userName, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ParticipantsTable extends Participants
    with TableInfo<$ParticipantsTable, ParticipantData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParticipantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _conversationIdMeta =
      const VerificationMeta('conversationId');
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
      'conversation_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES conversations (id)'));
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayNameMeta =
      const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
      'display_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarUrlMeta =
      const VerificationMeta('avatarUrl');
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
      'avatar_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isOnlineMeta =
      const VerificationMeta('isOnline');
  @override
  late final GeneratedColumn<bool> isOnline = GeneratedColumn<bool>(
      'is_online', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_online" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastSeenAtMeta =
      const VerificationMeta('lastSeenAt');
  @override
  late final GeneratedColumn<DateTime> lastSeenAt = GeneratedColumn<DateTime>(
      'last_seen_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _joinedAtMeta =
      const VerificationMeta('joinedAt');
  @override
  late final GeneratedColumn<DateTime> joinedAt = GeneratedColumn<DateTime>(
      'joined_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        conversationId,
        userId,
        displayName,
        avatarUrl,
        role,
        status,
        isOnline,
        lastSeenAt,
        joinedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'participants';
  @override
  VerificationContext validateIntegrity(Insertable<ParticipantData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
          _conversationIdMeta,
          conversationId.isAcceptableOrUnknown(
              data['conversation_id']!, _conversationIdMeta));
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
          _displayNameMeta,
          displayName.isAcceptableOrUnknown(
              data['display_name']!, _displayNameMeta));
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(_avatarUrlMeta,
          avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta));
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('is_online')) {
      context.handle(_isOnlineMeta,
          isOnline.isAcceptableOrUnknown(data['is_online']!, _isOnlineMeta));
    }
    if (data.containsKey('last_seen_at')) {
      context.handle(
          _lastSeenAtMeta,
          lastSeenAt.isAcceptableOrUnknown(
              data['last_seen_at']!, _lastSeenAtMeta));
    }
    if (data.containsKey('joined_at')) {
      context.handle(_joinedAtMeta,
          joinedAt.isAcceptableOrUnknown(data['joined_at']!, _joinedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ParticipantData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParticipantData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      conversationId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}conversation_id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      displayName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}display_name'])!,
      avatarUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_url']),
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      isOnline: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_online'])!,
      lastSeenAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_seen_at']),
      joinedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}joined_at']),
    );
  }

  @override
  $ParticipantsTable createAlias(String alias) {
    return $ParticipantsTable(attachedDatabase, alias);
  }
}

class ParticipantData extends DataClass implements Insertable<ParticipantData> {
  final String id;
  final String conversationId;
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final String role;
  final String status;
  final bool isOnline;
  final DateTime? lastSeenAt;
  final DateTime? joinedAt;
  const ParticipantData(
      {required this.id,
      required this.conversationId,
      required this.userId,
      required this.displayName,
      this.avatarUrl,
      required this.role,
      required this.status,
      required this.isOnline,
      this.lastSeenAt,
      this.joinedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['conversation_id'] = Variable<String>(conversationId);
    map['user_id'] = Variable<String>(userId);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['role'] = Variable<String>(role);
    map['status'] = Variable<String>(status);
    map['is_online'] = Variable<bool>(isOnline);
    if (!nullToAbsent || lastSeenAt != null) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt);
    }
    if (!nullToAbsent || joinedAt != null) {
      map['joined_at'] = Variable<DateTime>(joinedAt);
    }
    return map;
  }

  ParticipantsCompanion toCompanion(bool nullToAbsent) {
    return ParticipantsCompanion(
      id: Value(id),
      conversationId: Value(conversationId),
      userId: Value(userId),
      displayName: Value(displayName),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      role: Value(role),
      status: Value(status),
      isOnline: Value(isOnline),
      lastSeenAt: lastSeenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeenAt),
      joinedAt: joinedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(joinedAt),
    );
  }

  factory ParticipantData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParticipantData(
      id: serializer.fromJson<String>(json['id']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      userId: serializer.fromJson<String>(json['userId']),
      displayName: serializer.fromJson<String>(json['displayName']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      role: serializer.fromJson<String>(json['role']),
      status: serializer.fromJson<String>(json['status']),
      isOnline: serializer.fromJson<bool>(json['isOnline']),
      lastSeenAt: serializer.fromJson<DateTime?>(json['lastSeenAt']),
      joinedAt: serializer.fromJson<DateTime?>(json['joinedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'conversationId': serializer.toJson<String>(conversationId),
      'userId': serializer.toJson<String>(userId),
      'displayName': serializer.toJson<String>(displayName),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'role': serializer.toJson<String>(role),
      'status': serializer.toJson<String>(status),
      'isOnline': serializer.toJson<bool>(isOnline),
      'lastSeenAt': serializer.toJson<DateTime?>(lastSeenAt),
      'joinedAt': serializer.toJson<DateTime?>(joinedAt),
    };
  }

  ParticipantData copyWith(
          {String? id,
          String? conversationId,
          String? userId,
          String? displayName,
          Value<String?> avatarUrl = const Value.absent(),
          String? role,
          String? status,
          bool? isOnline,
          Value<DateTime?> lastSeenAt = const Value.absent(),
          Value<DateTime?> joinedAt = const Value.absent()}) =>
      ParticipantData(
        id: id ?? this.id,
        conversationId: conversationId ?? this.conversationId,
        userId: userId ?? this.userId,
        displayName: displayName ?? this.displayName,
        avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
        role: role ?? this.role,
        status: status ?? this.status,
        isOnline: isOnline ?? this.isOnline,
        lastSeenAt: lastSeenAt.present ? lastSeenAt.value : this.lastSeenAt,
        joinedAt: joinedAt.present ? joinedAt.value : this.joinedAt,
      );
  ParticipantData copyWithCompanion(ParticipantsCompanion data) {
    return ParticipantData(
      id: data.id.present ? data.id.value : this.id,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      userId: data.userId.present ? data.userId.value : this.userId,
      displayName:
          data.displayName.present ? data.displayName.value : this.displayName,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      role: data.role.present ? data.role.value : this.role,
      status: data.status.present ? data.status.value : this.status,
      isOnline: data.isOnline.present ? data.isOnline.value : this.isOnline,
      lastSeenAt:
          data.lastSeenAt.present ? data.lastSeenAt.value : this.lastSeenAt,
      joinedAt: data.joinedAt.present ? data.joinedAt.value : this.joinedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParticipantData(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('userId: $userId, ')
          ..write('displayName: $displayName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('role: $role, ')
          ..write('status: $status, ')
          ..write('isOnline: $isOnline, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('joinedAt: $joinedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, conversationId, userId, displayName,
      avatarUrl, role, status, isOnline, lastSeenAt, joinedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParticipantData &&
          other.id == this.id &&
          other.conversationId == this.conversationId &&
          other.userId == this.userId &&
          other.displayName == this.displayName &&
          other.avatarUrl == this.avatarUrl &&
          other.role == this.role &&
          other.status == this.status &&
          other.isOnline == this.isOnline &&
          other.lastSeenAt == this.lastSeenAt &&
          other.joinedAt == this.joinedAt);
}

class ParticipantsCompanion extends UpdateCompanion<ParticipantData> {
  final Value<String> id;
  final Value<String> conversationId;
  final Value<String> userId;
  final Value<String> displayName;
  final Value<String?> avatarUrl;
  final Value<String> role;
  final Value<String> status;
  final Value<bool> isOnline;
  final Value<DateTime?> lastSeenAt;
  final Value<DateTime?> joinedAt;
  final Value<int> rowid;
  const ParticipantsCompanion({
    this.id = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.userId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.role = const Value.absent(),
    this.status = const Value.absent(),
    this.isOnline = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ParticipantsCompanion.insert({
    required String id,
    required String conversationId,
    required String userId,
    required String displayName,
    this.avatarUrl = const Value.absent(),
    required String role,
    required String status,
    this.isOnline = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.joinedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        conversationId = Value(conversationId),
        userId = Value(userId),
        displayName = Value(displayName),
        role = Value(role),
        status = Value(status);
  static Insertable<ParticipantData> custom({
    Expression<String>? id,
    Expression<String>? conversationId,
    Expression<String>? userId,
    Expression<String>? displayName,
    Expression<String>? avatarUrl,
    Expression<String>? role,
    Expression<String>? status,
    Expression<bool>? isOnline,
    Expression<DateTime>? lastSeenAt,
    Expression<DateTime>? joinedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conversationId != null) 'conversation_id': conversationId,
      if (userId != null) 'user_id': userId,
      if (displayName != null) 'display_name': displayName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (role != null) 'role': role,
      if (status != null) 'status': status,
      if (isOnline != null) 'is_online': isOnline,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (joinedAt != null) 'joined_at': joinedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ParticipantsCompanion copyWith(
      {Value<String>? id,
      Value<String>? conversationId,
      Value<String>? userId,
      Value<String>? displayName,
      Value<String?>? avatarUrl,
      Value<String>? role,
      Value<String>? status,
      Value<bool>? isOnline,
      Value<DateTime?>? lastSeenAt,
      Value<DateTime?>? joinedAt,
      Value<int>? rowid}) {
    return ParticipantsCompanion(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      isOnline: isOnline ?? this.isOnline,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      joinedAt: joinedAt ?? this.joinedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isOnline.present) {
      map['is_online'] = Variable<bool>(isOnline.value);
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt.value);
    }
    if (joinedAt.present) {
      map['joined_at'] = Variable<DateTime>(joinedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParticipantsCompanion(')
          ..write('id: $id, ')
          ..write('conversationId: $conversationId, ')
          ..write('userId: $userId, ')
          ..write('displayName: $displayName, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('role: $role, ')
          ..write('status: $status, ')
          ..write('isOnline: $isOnline, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('joinedAt: $joinedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PinnedEventsTable extends PinnedEvents
    with TableInfo<$PinnedEventsTable, PinnedEventData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PinnedEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageIdMeta =
      const VerificationMeta('messageId');
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
      'message_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roomIdMeta = const VerificationMeta('roomId');
  @override
  late final GeneratedColumn<String> roomId = GeneratedColumn<String>(
      'room_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pinnedByMeta =
      const VerificationMeta('pinnedBy');
  @override
  late final GeneratedColumn<String> pinnedBy = GeneratedColumn<String>(
      'pinned_by', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pinnedAtMeta =
      const VerificationMeta('pinnedAt');
  @override
  late final GeneratedColumn<DateTime> pinnedAt = GeneratedColumn<DateTime>(
      'pinned_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _unpinnedAtMeta =
      const VerificationMeta('unpinnedAt');
  @override
  late final GeneratedColumn<DateTime> unpinnedAt = GeneratedColumn<DateTime>(
      'unpinned_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, messageId, roomId, pinnedBy, pinnedAt, unpinnedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pinned_events';
  @override
  VerificationContext validateIntegrity(Insertable<PinnedEventData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(_messageIdMeta,
          messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta));
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('room_id')) {
      context.handle(_roomIdMeta,
          roomId.isAcceptableOrUnknown(data['room_id']!, _roomIdMeta));
    } else if (isInserting) {
      context.missing(_roomIdMeta);
    }
    if (data.containsKey('pinned_by')) {
      context.handle(_pinnedByMeta,
          pinnedBy.isAcceptableOrUnknown(data['pinned_by']!, _pinnedByMeta));
    } else if (isInserting) {
      context.missing(_pinnedByMeta);
    }
    if (data.containsKey('pinned_at')) {
      context.handle(_pinnedAtMeta,
          pinnedAt.isAcceptableOrUnknown(data['pinned_at']!, _pinnedAtMeta));
    } else if (isInserting) {
      context.missing(_pinnedAtMeta);
    }
    if (data.containsKey('unpinned_at')) {
      context.handle(
          _unpinnedAtMeta,
          unpinnedAt.isAcceptableOrUnknown(
              data['unpinned_at']!, _unpinnedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PinnedEventData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PinnedEventData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      messageId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_id'])!,
      roomId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}room_id'])!,
      pinnedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pinned_by'])!,
      pinnedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}pinned_at'])!,
      unpinnedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}unpinned_at']),
    );
  }

  @override
  $PinnedEventsTable createAlias(String alias) {
    return $PinnedEventsTable(attachedDatabase, alias);
  }
}

class PinnedEventData extends DataClass implements Insertable<PinnedEventData> {
  final String id;
  final String messageId;
  final String roomId;
  final String pinnedBy;
  final DateTime pinnedAt;
  final DateTime? unpinnedAt;
  const PinnedEventData(
      {required this.id,
      required this.messageId,
      required this.roomId,
      required this.pinnedBy,
      required this.pinnedAt,
      this.unpinnedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['message_id'] = Variable<String>(messageId);
    map['room_id'] = Variable<String>(roomId);
    map['pinned_by'] = Variable<String>(pinnedBy);
    map['pinned_at'] = Variable<DateTime>(pinnedAt);
    if (!nullToAbsent || unpinnedAt != null) {
      map['unpinned_at'] = Variable<DateTime>(unpinnedAt);
    }
    return map;
  }

  PinnedEventsCompanion toCompanion(bool nullToAbsent) {
    return PinnedEventsCompanion(
      id: Value(id),
      messageId: Value(messageId),
      roomId: Value(roomId),
      pinnedBy: Value(pinnedBy),
      pinnedAt: Value(pinnedAt),
      unpinnedAt: unpinnedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(unpinnedAt),
    );
  }

  factory PinnedEventData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PinnedEventData(
      id: serializer.fromJson<String>(json['id']),
      messageId: serializer.fromJson<String>(json['messageId']),
      roomId: serializer.fromJson<String>(json['roomId']),
      pinnedBy: serializer.fromJson<String>(json['pinnedBy']),
      pinnedAt: serializer.fromJson<DateTime>(json['pinnedAt']),
      unpinnedAt: serializer.fromJson<DateTime?>(json['unpinnedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'messageId': serializer.toJson<String>(messageId),
      'roomId': serializer.toJson<String>(roomId),
      'pinnedBy': serializer.toJson<String>(pinnedBy),
      'pinnedAt': serializer.toJson<DateTime>(pinnedAt),
      'unpinnedAt': serializer.toJson<DateTime?>(unpinnedAt),
    };
  }

  PinnedEventData copyWith(
          {String? id,
          String? messageId,
          String? roomId,
          String? pinnedBy,
          DateTime? pinnedAt,
          Value<DateTime?> unpinnedAt = const Value.absent()}) =>
      PinnedEventData(
        id: id ?? this.id,
        messageId: messageId ?? this.messageId,
        roomId: roomId ?? this.roomId,
        pinnedBy: pinnedBy ?? this.pinnedBy,
        pinnedAt: pinnedAt ?? this.pinnedAt,
        unpinnedAt: unpinnedAt.present ? unpinnedAt.value : this.unpinnedAt,
      );
  PinnedEventData copyWithCompanion(PinnedEventsCompanion data) {
    return PinnedEventData(
      id: data.id.present ? data.id.value : this.id,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      roomId: data.roomId.present ? data.roomId.value : this.roomId,
      pinnedBy: data.pinnedBy.present ? data.pinnedBy.value : this.pinnedBy,
      pinnedAt: data.pinnedAt.present ? data.pinnedAt.value : this.pinnedAt,
      unpinnedAt:
          data.unpinnedAt.present ? data.unpinnedAt.value : this.unpinnedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PinnedEventData(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('roomId: $roomId, ')
          ..write('pinnedBy: $pinnedBy, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('unpinnedAt: $unpinnedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, messageId, roomId, pinnedBy, pinnedAt, unpinnedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PinnedEventData &&
          other.id == this.id &&
          other.messageId == this.messageId &&
          other.roomId == this.roomId &&
          other.pinnedBy == this.pinnedBy &&
          other.pinnedAt == this.pinnedAt &&
          other.unpinnedAt == this.unpinnedAt);
}

class PinnedEventsCompanion extends UpdateCompanion<PinnedEventData> {
  final Value<String> id;
  final Value<String> messageId;
  final Value<String> roomId;
  final Value<String> pinnedBy;
  final Value<DateTime> pinnedAt;
  final Value<DateTime?> unpinnedAt;
  final Value<int> rowid;
  const PinnedEventsCompanion({
    this.id = const Value.absent(),
    this.messageId = const Value.absent(),
    this.roomId = const Value.absent(),
    this.pinnedBy = const Value.absent(),
    this.pinnedAt = const Value.absent(),
    this.unpinnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PinnedEventsCompanion.insert({
    required String id,
    required String messageId,
    required String roomId,
    required String pinnedBy,
    required DateTime pinnedAt,
    this.unpinnedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        messageId = Value(messageId),
        roomId = Value(roomId),
        pinnedBy = Value(pinnedBy),
        pinnedAt = Value(pinnedAt);
  static Insertable<PinnedEventData> custom({
    Expression<String>? id,
    Expression<String>? messageId,
    Expression<String>? roomId,
    Expression<String>? pinnedBy,
    Expression<DateTime>? pinnedAt,
    Expression<DateTime>? unpinnedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (messageId != null) 'message_id': messageId,
      if (roomId != null) 'room_id': roomId,
      if (pinnedBy != null) 'pinned_by': pinnedBy,
      if (pinnedAt != null) 'pinned_at': pinnedAt,
      if (unpinnedAt != null) 'unpinned_at': unpinnedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PinnedEventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? messageId,
      Value<String>? roomId,
      Value<String>? pinnedBy,
      Value<DateTime>? pinnedAt,
      Value<DateTime?>? unpinnedAt,
      Value<int>? rowid}) {
    return PinnedEventsCompanion(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      roomId: roomId ?? this.roomId,
      pinnedBy: pinnedBy ?? this.pinnedBy,
      pinnedAt: pinnedAt ?? this.pinnedAt,
      unpinnedAt: unpinnedAt ?? this.unpinnedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (roomId.present) {
      map['room_id'] = Variable<String>(roomId.value);
    }
    if (pinnedBy.present) {
      map['pinned_by'] = Variable<String>(pinnedBy.value);
    }
    if (pinnedAt.present) {
      map['pinned_at'] = Variable<DateTime>(pinnedAt.value);
    }
    if (unpinnedAt.present) {
      map['unpinned_at'] = Variable<DateTime>(unpinnedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PinnedEventsCompanion(')
          ..write('id: $id, ')
          ..write('messageId: $messageId, ')
          ..write('roomId: $roomId, ')
          ..write('pinnedBy: $pinnedBy, ')
          ..write('pinnedAt: $pinnedAt, ')
          ..write('unpinnedAt: $unpinnedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ChatDatabaseImpl extends GeneratedDatabase {
  _$ChatDatabaseImpl(QueryExecutor e) : super(e);
  $ChatDatabaseImplManager get managers => $ChatDatabaseImplManager(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $ConversationsTable conversations = $ConversationsTable(this);
  late final $SyncStatesTable syncStates = $SyncStatesTable(this);
  late final $OutboundOperationsTable outboundOperations =
      $OutboundOperationsTable(this);
  late final $ReactionsTable reactions = $ReactionsTable(this);
  late final $ParticipantsTable participants = $ParticipantsTable(this);
  late final $PinnedEventsTable pinnedEvents = $PinnedEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        messages,
        conversations,
        syncStates,
        outboundOperations,
        reactions,
        participants,
        pinnedEvents
      ];
}

typedef $$MessagesTableCreateCompanionBuilder = MessagesCompanion Function({
  required String id,
  Value<String?> serverId,
  required String conversationId,
  required String senderId,
  Value<String?> senderName,
  Value<String?> senderAvatar,
  required String content,
  Value<String?> contentNonce,
  Value<bool> isEncrypted,
  required String type,
  required String status,
  required DateTime clientTimestamp,
  Value<DateTime?> serverTimestamp,
  Value<String?> replyToId,
  Value<bool> isDeleted,
  Value<bool> isEdited,
  Value<bool> isStarred,
  Value<bool> isPinned,
  Value<DateTime?> pinnedUntil,
  Value<int> localSequence,
  Value<String?> attachmentsJson,
  Value<int> rowid,
});
typedef $$MessagesTableUpdateCompanionBuilder = MessagesCompanion Function({
  Value<String> id,
  Value<String?> serverId,
  Value<String> conversationId,
  Value<String> senderId,
  Value<String?> senderName,
  Value<String?> senderAvatar,
  Value<String> content,
  Value<String?> contentNonce,
  Value<bool> isEncrypted,
  Value<String> type,
  Value<String> status,
  Value<DateTime> clientTimestamp,
  Value<DateTime?> serverTimestamp,
  Value<String?> replyToId,
  Value<bool> isDeleted,
  Value<bool> isEdited,
  Value<bool> isStarred,
  Value<bool> isPinned,
  Value<DateTime?> pinnedUntil,
  Value<int> localSequence,
  Value<String?> attachmentsJson,
  Value<int> rowid,
});

class $$MessagesTableFilterComposer
    extends Composer<_$ChatDatabaseImpl, $MessagesTable> {
  $$MessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get conversationId => $composableBuilder(
      column: $table.conversationId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senderId => $composableBuilder(
      column: $table.senderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senderName => $composableBuilder(
      column: $table.senderName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get senderAvatar => $composableBuilder(
      column: $table.senderAvatar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contentNonce => $composableBuilder(
      column: $table.contentNonce, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get clientTimestamp => $composableBuilder(
      column: $table.clientTimestamp,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get serverTimestamp => $composableBuilder(
      column: $table.serverTimestamp,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get replyToId => $composableBuilder(
      column: $table.replyToId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEdited => $composableBuilder(
      column: $table.isEdited, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isStarred => $composableBuilder(
      column: $table.isStarred, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get pinnedUntil => $composableBuilder(
      column: $table.pinnedUntil, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get localSequence => $composableBuilder(
      column: $table.localSequence, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get attachmentsJson => $composableBuilder(
      column: $table.attachmentsJson,
      builder: (column) => ColumnFilters(column));
}

class $$MessagesTableOrderingComposer
    extends Composer<_$ChatDatabaseImpl, $MessagesTable> {
  $$MessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serverId => $composableBuilder(
      column: $table.serverId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get conversationId => $composableBuilder(
      column: $table.conversationId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senderId => $composableBuilder(
      column: $table.senderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senderName => $composableBuilder(
      column: $table.senderName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get senderAvatar => $composableBuilder(
      column: $table.senderAvatar,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contentNonce => $composableBuilder(
      column: $table.contentNonce,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get clientTimestamp => $composableBuilder(
      column: $table.clientTimestamp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get serverTimestamp => $composableBuilder(
      column: $table.serverTimestamp,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get replyToId => $composableBuilder(
      column: $table.replyToId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEdited => $composableBuilder(
      column: $table.isEdited, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isStarred => $composableBuilder(
      column: $table.isStarred, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPinned => $composableBuilder(
      column: $table.isPinned, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get pinnedUntil => $composableBuilder(
      column: $table.pinnedUntil, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get localSequence => $composableBuilder(
      column: $table.localSequence,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attachmentsJson => $composableBuilder(
      column: $table.attachmentsJson,
      builder: (column) => ColumnOrderings(column));
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$ChatDatabaseImpl, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
      column: $table.conversationId, builder: (column) => column);

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get senderName => $composableBuilder(
      column: $table.senderName, builder: (column) => column);

  GeneratedColumn<String> get senderAvatar => $composableBuilder(
      column: $table.senderAvatar, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get contentNonce => $composableBuilder(
      column: $table.contentNonce, builder: (column) => column);

  GeneratedColumn<bool> get isEncrypted => $composableBuilder(
      column: $table.isEncrypted, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get clientTimestamp => $composableBuilder(
      column: $table.clientTimestamp, builder: (column) => column);

  GeneratedColumn<DateTime> get serverTimestamp => $composableBuilder(
      column: $table.serverTimestamp, builder: (column) => column);

  GeneratedColumn<String> get replyToId =>
      $composableBuilder(column: $table.replyToId, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<bool> get isEdited =>
      $composableBuilder(column: $table.isEdited, builder: (column) => column);

  GeneratedColumn<bool> get isStarred =>
      $composableBuilder(column: $table.isStarred, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<DateTime> get pinnedUntil => $composableBuilder(
      column: $table.pinnedUntil, builder: (column) => column);

  GeneratedColumn<int> get localSequence => $composableBuilder(
      column: $table.localSequence, builder: (column) => column);

  GeneratedColumn<String> get attachmentsJson => $composableBuilder(
      column: $table.attachmentsJson, builder: (column) => column);
}

class $$MessagesTableTableManager extends RootTableManager<
    _$ChatDatabaseImpl,
    $MessagesTable,
    MessageData,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (
      MessageData,
      BaseReferences<_$ChatDatabaseImpl, $MessagesTable, MessageData>
    ),
    MessageData,
    PrefetchHooks Function()> {
  $$MessagesTableTableManager(_$ChatDatabaseImpl db, $MessagesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> serverId = const Value.absent(),
            Value<String> conversationId = const Value.absent(),
            Value<String> senderId = const Value.absent(),
            Value<String?> senderName = const Value.absent(),
            Value<String?> senderAvatar = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String?> contentNonce = const Value.absent(),
            Value<bool> isEncrypted = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> clientTimestamp = const Value.absent(),
            Value<DateTime?> serverTimestamp = const Value.absent(),
            Value<String?> replyToId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<bool> isEdited = const Value.absent(),
            Value<bool> isStarred = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            Value<DateTime?> pinnedUntil = const Value.absent(),
            Value<int> localSequence = const Value.absent(),
            Value<String?> attachmentsJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesCompanion(
            id: id,
            serverId: serverId,
            conversationId: conversationId,
            senderId: senderId,
            senderName: senderName,
            senderAvatar: senderAvatar,
            content: content,
            contentNonce: contentNonce,
            isEncrypted: isEncrypted,
            type: type,
            status: status,
            clientTimestamp: clientTimestamp,
            serverTimestamp: serverTimestamp,
            replyToId: replyToId,
            isDeleted: isDeleted,
            isEdited: isEdited,
            isStarred: isStarred,
            isPinned: isPinned,
            pinnedUntil: pinnedUntil,
            localSequence: localSequence,
            attachmentsJson: attachmentsJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> serverId = const Value.absent(),
            required String conversationId,
            required String senderId,
            Value<String?> senderName = const Value.absent(),
            Value<String?> senderAvatar = const Value.absent(),
            required String content,
            Value<String?> contentNonce = const Value.absent(),
            Value<bool> isEncrypted = const Value.absent(),
            required String type,
            required String status,
            required DateTime clientTimestamp,
            Value<DateTime?> serverTimestamp = const Value.absent(),
            Value<String?> replyToId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<bool> isEdited = const Value.absent(),
            Value<bool> isStarred = const Value.absent(),
            Value<bool> isPinned = const Value.absent(),
            Value<DateTime?> pinnedUntil = const Value.absent(),
            Value<int> localSequence = const Value.absent(),
            Value<String?> attachmentsJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MessagesCompanion.insert(
            id: id,
            serverId: serverId,
            conversationId: conversationId,
            senderId: senderId,
            senderName: senderName,
            senderAvatar: senderAvatar,
            content: content,
            contentNonce: contentNonce,
            isEncrypted: isEncrypted,
            type: type,
            status: status,
            clientTimestamp: clientTimestamp,
            serverTimestamp: serverTimestamp,
            replyToId: replyToId,
            isDeleted: isDeleted,
            isEdited: isEdited,
            isStarred: isStarred,
            isPinned: isPinned,
            pinnedUntil: pinnedUntil,
            localSequence: localSequence,
            attachmentsJson: attachmentsJson,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MessagesTableProcessedTableManager = ProcessedTableManager<
    _$ChatDatabaseImpl,
    $MessagesTable,
    MessageData,
    $$MessagesTableFilterComposer,
    $$MessagesTableOrderingComposer,
    $$MessagesTableAnnotationComposer,
    $$MessagesTableCreateCompanionBuilder,
    $$MessagesTableUpdateCompanionBuilder,
    (
      MessageData,
      BaseReferences<_$ChatDatabaseImpl, $MessagesTable, MessageData>
    ),
    MessageData,
    PrefetchHooks Function()>;
typedef $$ConversationsTableCreateCompanionBuilder = ConversationsCompanion
    Function({
  required String id,
  Value<String?> name,
  Value<String?> avatarUrl,
  required String type,
  required String mode,
  required String status,
  Value<int> unreadCount,
  required String myRole,
  Value<String?> lastMessageId,
  Value<DateTime?> lastMessageAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ConversationsTableUpdateCompanionBuilder = ConversationsCompanion
    Function({
  Value<String> id,
  Value<String?> name,
  Value<String?> avatarUrl,
  Value<String> type,
  Value<String> mode,
  Value<String> status,
  Value<int> unreadCount,
  Value<String> myRole,
  Value<String?> lastMessageId,
  Value<DateTime?> lastMessageAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ConversationsTableReferences extends BaseReferences<
    _$ChatDatabaseImpl, $ConversationsTable, ConversationData> {
  $$ConversationsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ParticipantsTable, List<ParticipantData>>
      _participantsRefsTable(_$ChatDatabaseImpl db) =>
          MultiTypedResultKey.fromTable(db.participants,
              aliasName: $_aliasNameGenerator(
                  db.conversations.id, db.participants.conversationId));

  $$ParticipantsTableProcessedTableManager get participantsRefs {
    final manager = $$ParticipantsTableTableManager($_db, $_db.participants)
        .filter(
            (f) => f.conversationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_participantsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ConversationsTableFilterComposer
    extends Composer<_$ChatDatabaseImpl, $ConversationsTable> {
  $$ConversationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unreadCount => $composableBuilder(
      column: $table.unreadCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get myRole => $composableBuilder(
      column: $table.myRole, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastMessageId => $composableBuilder(
      column: $table.lastMessageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastMessageAt => $composableBuilder(
      column: $table.lastMessageAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> participantsRefs(
      Expression<bool> Function($$ParticipantsTableFilterComposer f) f) {
    final $$ParticipantsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.participants,
        getReferencedColumn: (t) => t.conversationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ParticipantsTableFilterComposer(
              $db: $db,
              $table: $db.participants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ConversationsTableOrderingComposer
    extends Composer<_$ChatDatabaseImpl, $ConversationsTable> {
  $$ConversationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mode => $composableBuilder(
      column: $table.mode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unreadCount => $composableBuilder(
      column: $table.unreadCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get myRole => $composableBuilder(
      column: $table.myRole, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastMessageId => $composableBuilder(
      column: $table.lastMessageId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastMessageAt => $composableBuilder(
      column: $table.lastMessageAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ConversationsTableAnnotationComposer
    extends Composer<_$ChatDatabaseImpl, $ConversationsTable> {
  $$ConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get unreadCount => $composableBuilder(
      column: $table.unreadCount, builder: (column) => column);

  GeneratedColumn<String> get myRole =>
      $composableBuilder(column: $table.myRole, builder: (column) => column);

  GeneratedColumn<String> get lastMessageId => $composableBuilder(
      column: $table.lastMessageId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastMessageAt => $composableBuilder(
      column: $table.lastMessageAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> participantsRefs<T extends Object>(
      Expression<T> Function($$ParticipantsTableAnnotationComposer a) f) {
    final $$ParticipantsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.participants,
        getReferencedColumn: (t) => t.conversationId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ParticipantsTableAnnotationComposer(
              $db: $db,
              $table: $db.participants,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ConversationsTableTableManager extends RootTableManager<
    _$ChatDatabaseImpl,
    $ConversationsTable,
    ConversationData,
    $$ConversationsTableFilterComposer,
    $$ConversationsTableOrderingComposer,
    $$ConversationsTableAnnotationComposer,
    $$ConversationsTableCreateCompanionBuilder,
    $$ConversationsTableUpdateCompanionBuilder,
    (ConversationData, $$ConversationsTableReferences),
    ConversationData,
    PrefetchHooks Function({bool participantsRefs})> {
  $$ConversationsTableTableManager(
      _$ChatDatabaseImpl db, $ConversationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> mode = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> unreadCount = const Value.absent(),
            Value<String> myRole = const Value.absent(),
            Value<String?> lastMessageId = const Value.absent(),
            Value<DateTime?> lastMessageAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ConversationsCompanion(
            id: id,
            name: name,
            avatarUrl: avatarUrl,
            type: type,
            mode: mode,
            status: status,
            unreadCount: unreadCount,
            myRole: myRole,
            lastMessageId: lastMessageId,
            lastMessageAt: lastMessageAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> name = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            required String type,
            required String mode,
            required String status,
            Value<int> unreadCount = const Value.absent(),
            required String myRole,
            Value<String?> lastMessageId = const Value.absent(),
            Value<DateTime?> lastMessageAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ConversationsCompanion.insert(
            id: id,
            name: name,
            avatarUrl: avatarUrl,
            type: type,
            mode: mode,
            status: status,
            unreadCount: unreadCount,
            myRole: myRole,
            lastMessageId: lastMessageId,
            lastMessageAt: lastMessageAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ConversationsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({participantsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (participantsRefs) db.participants],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (participantsRefs)
                    await $_getPrefetchedData<ConversationData,
                            $ConversationsTable, ParticipantData>(
                        currentTable: table,
                        referencedTable: $$ConversationsTableReferences
                            ._participantsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ConversationsTableReferences(db, table, p0)
                                .participantsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.conversationId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ConversationsTableProcessedTableManager = ProcessedTableManager<
    _$ChatDatabaseImpl,
    $ConversationsTable,
    ConversationData,
    $$ConversationsTableFilterComposer,
    $$ConversationsTableOrderingComposer,
    $$ConversationsTableAnnotationComposer,
    $$ConversationsTableCreateCompanionBuilder,
    $$ConversationsTableUpdateCompanionBuilder,
    (ConversationData, $$ConversationsTableReferences),
    ConversationData,
    PrefetchHooks Function({bool participantsRefs})>;
typedef $$SyncStatesTableCreateCompanionBuilder = SyncStatesCompanion Function({
  Value<int> id,
  Value<String?> lastSyncToken,
  Value<DateTime?> lastSyncAt,
  Value<bool> isInitialSyncComplete,
});
typedef $$SyncStatesTableUpdateCompanionBuilder = SyncStatesCompanion Function({
  Value<int> id,
  Value<String?> lastSyncToken,
  Value<DateTime?> lastSyncAt,
  Value<bool> isInitialSyncComplete,
});

class $$SyncStatesTableFilterComposer
    extends Composer<_$ChatDatabaseImpl, $SyncStatesTable> {
  $$SyncStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastSyncToken => $composableBuilder(
      column: $table.lastSyncToken, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isInitialSyncComplete => $composableBuilder(
      column: $table.isInitialSyncComplete,
      builder: (column) => ColumnFilters(column));
}

class $$SyncStatesTableOrderingComposer
    extends Composer<_$ChatDatabaseImpl, $SyncStatesTable> {
  $$SyncStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastSyncToken => $composableBuilder(
      column: $table.lastSyncToken,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isInitialSyncComplete => $composableBuilder(
      column: $table.isInitialSyncComplete,
      builder: (column) => ColumnOrderings(column));
}

class $$SyncStatesTableAnnotationComposer
    extends Composer<_$ChatDatabaseImpl, $SyncStatesTable> {
  $$SyncStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lastSyncToken => $composableBuilder(
      column: $table.lastSyncToken, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
      column: $table.lastSyncAt, builder: (column) => column);

  GeneratedColumn<bool> get isInitialSyncComplete => $composableBuilder(
      column: $table.isInitialSyncComplete, builder: (column) => column);
}

class $$SyncStatesTableTableManager extends RootTableManager<
    _$ChatDatabaseImpl,
    $SyncStatesTable,
    SyncStateData,
    $$SyncStatesTableFilterComposer,
    $$SyncStatesTableOrderingComposer,
    $$SyncStatesTableAnnotationComposer,
    $$SyncStatesTableCreateCompanionBuilder,
    $$SyncStatesTableUpdateCompanionBuilder,
    (
      SyncStateData,
      BaseReferences<_$ChatDatabaseImpl, $SyncStatesTable, SyncStateData>
    ),
    SyncStateData,
    PrefetchHooks Function()> {
  $$SyncStatesTableTableManager(_$ChatDatabaseImpl db, $SyncStatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> lastSyncToken = const Value.absent(),
            Value<DateTime?> lastSyncAt = const Value.absent(),
            Value<bool> isInitialSyncComplete = const Value.absent(),
          }) =>
              SyncStatesCompanion(
            id: id,
            lastSyncToken: lastSyncToken,
            lastSyncAt: lastSyncAt,
            isInitialSyncComplete: isInitialSyncComplete,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> lastSyncToken = const Value.absent(),
            Value<DateTime?> lastSyncAt = const Value.absent(),
            Value<bool> isInitialSyncComplete = const Value.absent(),
          }) =>
              SyncStatesCompanion.insert(
            id: id,
            lastSyncToken: lastSyncToken,
            lastSyncAt: lastSyncAt,
            isInitialSyncComplete: isInitialSyncComplete,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncStatesTableProcessedTableManager = ProcessedTableManager<
    _$ChatDatabaseImpl,
    $SyncStatesTable,
    SyncStateData,
    $$SyncStatesTableFilterComposer,
    $$SyncStatesTableOrderingComposer,
    $$SyncStatesTableAnnotationComposer,
    $$SyncStatesTableCreateCompanionBuilder,
    $$SyncStatesTableUpdateCompanionBuilder,
    (
      SyncStateData,
      BaseReferences<_$ChatDatabaseImpl, $SyncStatesTable, SyncStateData>
    ),
    SyncStateData,
    PrefetchHooks Function()>;
typedef $$OutboundOperationsTableCreateCompanionBuilder
    = OutboundOperationsCompanion Function({
  required String id,
  required String type,
  required String data,
  Value<int> retryCount,
  required String status,
  required DateTime createdAt,
  Value<DateTime?> processedAt,
  Value<String?> errorMessage,
  Value<int> rowid,
});
typedef $$OutboundOperationsTableUpdateCompanionBuilder
    = OutboundOperationsCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<String> data,
  Value<int> retryCount,
  Value<String> status,
  Value<DateTime> createdAt,
  Value<DateTime?> processedAt,
  Value<String?> errorMessage,
  Value<int> rowid,
});

class $$OutboundOperationsTableFilterComposer
    extends Composer<_$ChatDatabaseImpl, $OutboundOperationsTable> {
  $$OutboundOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get processedAt => $composableBuilder(
      column: $table.processedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => ColumnFilters(column));
}

class $$OutboundOperationsTableOrderingComposer
    extends Composer<_$ChatDatabaseImpl, $OutboundOperationsTable> {
  $$OutboundOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get data => $composableBuilder(
      column: $table.data, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get processedAt => $composableBuilder(
      column: $table.processedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage,
      builder: (column) => ColumnOrderings(column));
}

class $$OutboundOperationsTableAnnotationComposer
    extends Composer<_$ChatDatabaseImpl, $OutboundOperationsTable> {
  $$OutboundOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get processedAt => $composableBuilder(
      column: $table.processedAt, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => column);
}

class $$OutboundOperationsTableTableManager extends RootTableManager<
    _$ChatDatabaseImpl,
    $OutboundOperationsTable,
    OutboundOperationData,
    $$OutboundOperationsTableFilterComposer,
    $$OutboundOperationsTableOrderingComposer,
    $$OutboundOperationsTableAnnotationComposer,
    $$OutboundOperationsTableCreateCompanionBuilder,
    $$OutboundOperationsTableUpdateCompanionBuilder,
    (
      OutboundOperationData,
      BaseReferences<_$ChatDatabaseImpl, $OutboundOperationsTable,
          OutboundOperationData>
    ),
    OutboundOperationData,
    PrefetchHooks Function()> {
  $$OutboundOperationsTableTableManager(
      _$ChatDatabaseImpl db, $OutboundOperationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutboundOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutboundOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutboundOperationsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> data = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> processedAt = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OutboundOperationsCompanion(
            id: id,
            type: type,
            data: data,
            retryCount: retryCount,
            status: status,
            createdAt: createdAt,
            processedAt: processedAt,
            errorMessage: errorMessage,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String type,
            required String data,
            Value<int> retryCount = const Value.absent(),
            required String status,
            required DateTime createdAt,
            Value<DateTime?> processedAt = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OutboundOperationsCompanion.insert(
            id: id,
            type: type,
            data: data,
            retryCount: retryCount,
            status: status,
            createdAt: createdAt,
            processedAt: processedAt,
            errorMessage: errorMessage,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OutboundOperationsTableProcessedTableManager = ProcessedTableManager<
    _$ChatDatabaseImpl,
    $OutboundOperationsTable,
    OutboundOperationData,
    $$OutboundOperationsTableFilterComposer,
    $$OutboundOperationsTableOrderingComposer,
    $$OutboundOperationsTableAnnotationComposer,
    $$OutboundOperationsTableCreateCompanionBuilder,
    $$OutboundOperationsTableUpdateCompanionBuilder,
    (
      OutboundOperationData,
      BaseReferences<_$ChatDatabaseImpl, $OutboundOperationsTable,
          OutboundOperationData>
    ),
    OutboundOperationData,
    PrefetchHooks Function()>;
typedef $$ReactionsTableCreateCompanionBuilder = ReactionsCompanion Function({
  required String id,
  required String messageId,
  required String emoji,
  required String userId,
  Value<String?> userName,
  Value<DateTime?> createdAt,
  Value<int> rowid,
});
typedef $$ReactionsTableUpdateCompanionBuilder = ReactionsCompanion Function({
  Value<String> id,
  Value<String> messageId,
  Value<String> emoji,
  Value<String> userId,
  Value<String?> userName,
  Value<DateTime?> createdAt,
  Value<int> rowid,
});

class $$ReactionsTableFilterComposer
    extends Composer<_$ChatDatabaseImpl, $ReactionsTable> {
  $$ReactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get messageId => $composableBuilder(
      column: $table.messageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userName => $composableBuilder(
      column: $table.userName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ReactionsTableOrderingComposer
    extends Composer<_$ChatDatabaseImpl, $ReactionsTable> {
  $$ReactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get messageId => $composableBuilder(
      column: $table.messageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get emoji => $composableBuilder(
      column: $table.emoji, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userName => $composableBuilder(
      column: $table.userName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ReactionsTableAnnotationComposer
    extends Composer<_$ChatDatabaseImpl, $ReactionsTable> {
  $$ReactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ReactionsTableTableManager extends RootTableManager<
    _$ChatDatabaseImpl,
    $ReactionsTable,
    ReactionData,
    $$ReactionsTableFilterComposer,
    $$ReactionsTableOrderingComposer,
    $$ReactionsTableAnnotationComposer,
    $$ReactionsTableCreateCompanionBuilder,
    $$ReactionsTableUpdateCompanionBuilder,
    (
      ReactionData,
      BaseReferences<_$ChatDatabaseImpl, $ReactionsTable, ReactionData>
    ),
    ReactionData,
    PrefetchHooks Function()> {
  $$ReactionsTableTableManager(_$ChatDatabaseImpl db, $ReactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> messageId = const Value.absent(),
            Value<String> emoji = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String?> userName = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReactionsCompanion(
            id: id,
            messageId: messageId,
            emoji: emoji,
            userId: userId,
            userName: userName,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String messageId,
            required String emoji,
            required String userId,
            Value<String?> userName = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReactionsCompanion.insert(
            id: id,
            messageId: messageId,
            emoji: emoji,
            userId: userId,
            userName: userName,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReactionsTableProcessedTableManager = ProcessedTableManager<
    _$ChatDatabaseImpl,
    $ReactionsTable,
    ReactionData,
    $$ReactionsTableFilterComposer,
    $$ReactionsTableOrderingComposer,
    $$ReactionsTableAnnotationComposer,
    $$ReactionsTableCreateCompanionBuilder,
    $$ReactionsTableUpdateCompanionBuilder,
    (
      ReactionData,
      BaseReferences<_$ChatDatabaseImpl, $ReactionsTable, ReactionData>
    ),
    ReactionData,
    PrefetchHooks Function()>;
typedef $$ParticipantsTableCreateCompanionBuilder = ParticipantsCompanion
    Function({
  required String id,
  required String conversationId,
  required String userId,
  required String displayName,
  Value<String?> avatarUrl,
  required String role,
  required String status,
  Value<bool> isOnline,
  Value<DateTime?> lastSeenAt,
  Value<DateTime?> joinedAt,
  Value<int> rowid,
});
typedef $$ParticipantsTableUpdateCompanionBuilder = ParticipantsCompanion
    Function({
  Value<String> id,
  Value<String> conversationId,
  Value<String> userId,
  Value<String> displayName,
  Value<String?> avatarUrl,
  Value<String> role,
  Value<String> status,
  Value<bool> isOnline,
  Value<DateTime?> lastSeenAt,
  Value<DateTime?> joinedAt,
  Value<int> rowid,
});

final class $$ParticipantsTableReferences extends BaseReferences<
    _$ChatDatabaseImpl, $ParticipantsTable, ParticipantData> {
  $$ParticipantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ConversationsTable _conversationIdTable(_$ChatDatabaseImpl db) =>
      db.conversations.createAlias($_aliasNameGenerator(
          db.participants.conversationId, db.conversations.id));

  $$ConversationsTableProcessedTableManager get conversationId {
    final $_column = $_itemColumn<String>('conversation_id')!;

    final manager = $$ConversationsTableTableManager($_db, $_db.conversations)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_conversationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ParticipantsTableFilterComposer
    extends Composer<_$ChatDatabaseImpl, $ParticipantsTable> {
  $$ParticipantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isOnline => $composableBuilder(
      column: $table.isOnline, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSeenAt => $composableBuilder(
      column: $table.lastSeenAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get joinedAt => $composableBuilder(
      column: $table.joinedAt, builder: (column) => ColumnFilters(column));

  $$ConversationsTableFilterComposer get conversationId {
    final $$ConversationsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.conversationId,
        referencedTable: $db.conversations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConversationsTableFilterComposer(
              $db: $db,
              $table: $db.conversations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ParticipantsTableOrderingComposer
    extends Composer<_$ChatDatabaseImpl, $ParticipantsTable> {
  $$ParticipantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
      column: $table.avatarUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isOnline => $composableBuilder(
      column: $table.isOnline, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSeenAt => $composableBuilder(
      column: $table.lastSeenAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get joinedAt => $composableBuilder(
      column: $table.joinedAt, builder: (column) => ColumnOrderings(column));

  $$ConversationsTableOrderingComposer get conversationId {
    final $$ConversationsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.conversationId,
        referencedTable: $db.conversations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConversationsTableOrderingComposer(
              $db: $db,
              $table: $db.conversations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ParticipantsTableAnnotationComposer
    extends Composer<_$ChatDatabaseImpl, $ParticipantsTable> {
  $$ParticipantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
      column: $table.displayName, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isOnline =>
      $composableBuilder(column: $table.isOnline, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeenAt => $composableBuilder(
      column: $table.lastSeenAt, builder: (column) => column);

  GeneratedColumn<DateTime> get joinedAt =>
      $composableBuilder(column: $table.joinedAt, builder: (column) => column);

  $$ConversationsTableAnnotationComposer get conversationId {
    final $$ConversationsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.conversationId,
        referencedTable: $db.conversations,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ConversationsTableAnnotationComposer(
              $db: $db,
              $table: $db.conversations,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ParticipantsTableTableManager extends RootTableManager<
    _$ChatDatabaseImpl,
    $ParticipantsTable,
    ParticipantData,
    $$ParticipantsTableFilterComposer,
    $$ParticipantsTableOrderingComposer,
    $$ParticipantsTableAnnotationComposer,
    $$ParticipantsTableCreateCompanionBuilder,
    $$ParticipantsTableUpdateCompanionBuilder,
    (ParticipantData, $$ParticipantsTableReferences),
    ParticipantData,
    PrefetchHooks Function({bool conversationId})> {
  $$ParticipantsTableTableManager(
      _$ChatDatabaseImpl db, $ParticipantsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParticipantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParticipantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParticipantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> conversationId = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> displayName = const Value.absent(),
            Value<String?> avatarUrl = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> isOnline = const Value.absent(),
            Value<DateTime?> lastSeenAt = const Value.absent(),
            Value<DateTime?> joinedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ParticipantsCompanion(
            id: id,
            conversationId: conversationId,
            userId: userId,
            displayName: displayName,
            avatarUrl: avatarUrl,
            role: role,
            status: status,
            isOnline: isOnline,
            lastSeenAt: lastSeenAt,
            joinedAt: joinedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String conversationId,
            required String userId,
            required String displayName,
            Value<String?> avatarUrl = const Value.absent(),
            required String role,
            required String status,
            Value<bool> isOnline = const Value.absent(),
            Value<DateTime?> lastSeenAt = const Value.absent(),
            Value<DateTime?> joinedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ParticipantsCompanion.insert(
            id: id,
            conversationId: conversationId,
            userId: userId,
            displayName: displayName,
            avatarUrl: avatarUrl,
            role: role,
            status: status,
            isOnline: isOnline,
            lastSeenAt: lastSeenAt,
            joinedAt: joinedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ParticipantsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({conversationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (conversationId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.conversationId,
                    referencedTable:
                        $$ParticipantsTableReferences._conversationIdTable(db),
                    referencedColumn: $$ParticipantsTableReferences
                        ._conversationIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ParticipantsTableProcessedTableManager = ProcessedTableManager<
    _$ChatDatabaseImpl,
    $ParticipantsTable,
    ParticipantData,
    $$ParticipantsTableFilterComposer,
    $$ParticipantsTableOrderingComposer,
    $$ParticipantsTableAnnotationComposer,
    $$ParticipantsTableCreateCompanionBuilder,
    $$ParticipantsTableUpdateCompanionBuilder,
    (ParticipantData, $$ParticipantsTableReferences),
    ParticipantData,
    PrefetchHooks Function({bool conversationId})>;
typedef $$PinnedEventsTableCreateCompanionBuilder = PinnedEventsCompanion
    Function({
  required String id,
  required String messageId,
  required String roomId,
  required String pinnedBy,
  required DateTime pinnedAt,
  Value<DateTime?> unpinnedAt,
  Value<int> rowid,
});
typedef $$PinnedEventsTableUpdateCompanionBuilder = PinnedEventsCompanion
    Function({
  Value<String> id,
  Value<String> messageId,
  Value<String> roomId,
  Value<String> pinnedBy,
  Value<DateTime> pinnedAt,
  Value<DateTime?> unpinnedAt,
  Value<int> rowid,
});

class $$PinnedEventsTableFilterComposer
    extends Composer<_$ChatDatabaseImpl, $PinnedEventsTable> {
  $$PinnedEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get messageId => $composableBuilder(
      column: $table.messageId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get roomId => $composableBuilder(
      column: $table.roomId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinnedBy => $composableBuilder(
      column: $table.pinnedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get pinnedAt => $composableBuilder(
      column: $table.pinnedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get unpinnedAt => $composableBuilder(
      column: $table.unpinnedAt, builder: (column) => ColumnFilters(column));
}

class $$PinnedEventsTableOrderingComposer
    extends Composer<_$ChatDatabaseImpl, $PinnedEventsTable> {
  $$PinnedEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get messageId => $composableBuilder(
      column: $table.messageId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get roomId => $composableBuilder(
      column: $table.roomId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinnedBy => $composableBuilder(
      column: $table.pinnedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get pinnedAt => $composableBuilder(
      column: $table.pinnedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get unpinnedAt => $composableBuilder(
      column: $table.unpinnedAt, builder: (column) => ColumnOrderings(column));
}

class $$PinnedEventsTableAnnotationComposer
    extends Composer<_$ChatDatabaseImpl, $PinnedEventsTable> {
  $$PinnedEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get roomId =>
      $composableBuilder(column: $table.roomId, builder: (column) => column);

  GeneratedColumn<String> get pinnedBy =>
      $composableBuilder(column: $table.pinnedBy, builder: (column) => column);

  GeneratedColumn<DateTime> get pinnedAt =>
      $composableBuilder(column: $table.pinnedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get unpinnedAt => $composableBuilder(
      column: $table.unpinnedAt, builder: (column) => column);
}

class $$PinnedEventsTableTableManager extends RootTableManager<
    _$ChatDatabaseImpl,
    $PinnedEventsTable,
    PinnedEventData,
    $$PinnedEventsTableFilterComposer,
    $$PinnedEventsTableOrderingComposer,
    $$PinnedEventsTableAnnotationComposer,
    $$PinnedEventsTableCreateCompanionBuilder,
    $$PinnedEventsTableUpdateCompanionBuilder,
    (
      PinnedEventData,
      BaseReferences<_$ChatDatabaseImpl, $PinnedEventsTable, PinnedEventData>
    ),
    PinnedEventData,
    PrefetchHooks Function()> {
  $$PinnedEventsTableTableManager(
      _$ChatDatabaseImpl db, $PinnedEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PinnedEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PinnedEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PinnedEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> messageId = const Value.absent(),
            Value<String> roomId = const Value.absent(),
            Value<String> pinnedBy = const Value.absent(),
            Value<DateTime> pinnedAt = const Value.absent(),
            Value<DateTime?> unpinnedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PinnedEventsCompanion(
            id: id,
            messageId: messageId,
            roomId: roomId,
            pinnedBy: pinnedBy,
            pinnedAt: pinnedAt,
            unpinnedAt: unpinnedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String messageId,
            required String roomId,
            required String pinnedBy,
            required DateTime pinnedAt,
            Value<DateTime?> unpinnedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PinnedEventsCompanion.insert(
            id: id,
            messageId: messageId,
            roomId: roomId,
            pinnedBy: pinnedBy,
            pinnedAt: pinnedAt,
            unpinnedAt: unpinnedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PinnedEventsTableProcessedTableManager = ProcessedTableManager<
    _$ChatDatabaseImpl,
    $PinnedEventsTable,
    PinnedEventData,
    $$PinnedEventsTableFilterComposer,
    $$PinnedEventsTableOrderingComposer,
    $$PinnedEventsTableAnnotationComposer,
    $$PinnedEventsTableCreateCompanionBuilder,
    $$PinnedEventsTableUpdateCompanionBuilder,
    (
      PinnedEventData,
      BaseReferences<_$ChatDatabaseImpl, $PinnedEventsTable, PinnedEventData>
    ),
    PinnedEventData,
    PrefetchHooks Function()>;

class $ChatDatabaseImplManager {
  final _$ChatDatabaseImpl _db;
  $ChatDatabaseImplManager(this._db);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$ConversationsTableTableManager get conversations =>
      $$ConversationsTableTableManager(_db, _db.conversations);
  $$SyncStatesTableTableManager get syncStates =>
      $$SyncStatesTableTableManager(_db, _db.syncStates);
  $$OutboundOperationsTableTableManager get outboundOperations =>
      $$OutboundOperationsTableTableManager(_db, _db.outboundOperations);
  $$ReactionsTableTableManager get reactions =>
      $$ReactionsTableTableManager(_db, _db.reactions);
  $$ParticipantsTableTableManager get participants =>
      $$ParticipantsTableTableManager(_db, _db.participants);
  $$PinnedEventsTableTableManager get pinnedEvents =>
      $$PinnedEventsTableTableManager(_db, _db.pinnedEvents);
}
