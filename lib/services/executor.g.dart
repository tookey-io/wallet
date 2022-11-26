// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'executor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExecutionMessage _$ExecutionMessageFromJson(Map<String, dynamic> json) =>
    ExecutionMessage(
      json['sender'] as int,
      json['receiver'] as int?,
      json['body'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$ExecutionMessageToJson(ExecutionMessage instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'receiver': instance.receiver,
      'body': instance.body,
    };
