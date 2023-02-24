// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'key_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeySession _$KeySessionFromJson(Map<String, dynamic> json) => KeySession(
      store: WCSessionStore.fromJson(json['store'] as Map<String, dynamic>),
      publicKey: json['publicKey'] as String,
    );

Map<String, dynamic> _$KeySessionToJson(KeySession instance) =>
    <String, dynamic>{
      'store': instance.store,
      'publicKey': instance.publicKey,
    };
