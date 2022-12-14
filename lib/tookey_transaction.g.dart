// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tookey_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TookeyTransaction _$TookeyTransactionFromJson(Map<String, dynamic> json) =>
    TookeyTransaction(
      from: json['from'] as String,
      chainId: json['chainId'] as int?,
      to: json['to'] as String?,
      nonce: json['nonce'] as String?,
      maxFeePerGas: json['maxFeePerGas'] as String?,
      maxPriorityFeePerGas: json['maxPriorityFeePerGas'] as String?,
      gas: json['gas'] as String?,
      value: json['value'] as String?,
      data: json['data'] as String?,
      type: json['type'] as String? ?? '0x0',
      gasPrice: json['gasPrice'] as String? ?? '0x0',
    );

Map<String, dynamic> _$TookeyTransactionToJson(TookeyTransaction instance) =>
    <String, dynamic>{
      'from': instance.from,
      'chainId': instance.chainId,
      'nonce': instance.nonce,
      'maxPriorityFeePerGas': instance.maxPriorityFeePerGas,
      'maxFeePerGas': instance.maxFeePerGas,
      'to': instance.to,
      'gas': instance.gas,
      'value': instance.value,
      'data': instance.data,
      'type': instance.type,
      'gasPrice': instance.gasPrice,
    };
