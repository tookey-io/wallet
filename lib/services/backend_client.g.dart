// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthToken _$AuthTokenFromJson(Map<String, dynamic> json) => AuthToken(
      json['token'] as String,
      json['validUntil'] as String,
    );

Map<String, dynamic> _$AuthTokenToJson(AuthToken instance) => <String, dynamic>{
      'token': instance.token,
      'validUntil': instance.validUntil,
    };

AuthTokens _$AuthTokensFromJson(Map<String, dynamic> json) => AuthTokens(
      AuthToken.fromJson(json['access'] as Map<String, dynamic>),
      AuthToken.fromJson(json['refresh'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthTokensToJson(AuthTokens instance) =>
    <String, dynamic>{
      'access': instance.access,
      'refresh': instance.refresh,
    };

KeyRecord _$KeyRecordFromJson(Map<String, dynamic> json) => KeyRecord(
      json['id'] as int,
      json['roomId'] as String,
      json['participantsThreshold'] as int,
      json['timeoutSeconds'] as int,
      json['name'] as String,
      json['description'] as String,
      (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      (json['participants'] as List<dynamic>).map((e) => e as int).toList(),
      json['publicKey'] as String,
    );

Map<String, dynamic> _$KeyRecordToJson(KeyRecord instance) => <String, dynamic>{
      'id': instance.id,
      'roomId': instance.roomId,
      'participantsThreshold': instance.participantsThreshold,
      'timeoutSeconds': instance.timeoutSeconds,
      'name': instance.name,
      'description': instance.description,
      'tags': instance.tags,
      'participants': instance.participants,
      'publicKey': instance.publicKey,
    };

KeysList _$KeysListFromJson(Map<String, dynamic> json) => KeysList(
      (json['items'] as List<dynamic>)
          .map((e) => KeyRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$KeysListToJson(KeysList instance) => <String, dynamic>{
      'items': instance.items,
    };

SignRecord _$SignRecordFromJson(Map<String, dynamic> json) => SignRecord(
      json['id'] as int,
      json['roomId'] as String,
      (json['participantsConfirmations'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      json['data'] as String,
      json['metadata'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$SignRecordToJson(SignRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'roomId': instance.roomId,
      'participantsConfirmations': instance.participantsConfirmations,
      'data': instance.data,
      'metadata': instance.metadata,
    };
