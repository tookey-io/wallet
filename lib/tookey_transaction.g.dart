// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tookey_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TookeyTransaction _$TookeyTransactionFromJson(Map<String, dynamic> json) =>
    TookeyTransaction(
      from: json['from'] as String,
      chainId: json['chainId'] as String?,
      to: json['to'] as String? ?? '0x0000000000000000000000000000000000000000',
      nonce: json['nonce'] as String?,
      maxFeePerGas: json['maxFeePerGas'] as String?,
      maxPriorityFeePerGas: json['maxPriorityFeePerGas'] as String?,
      gas: json['gas'] as String?,
      value: json['value'] as String?,
      data: json['data'] as String?,
      type: json['type'] as String? ?? '0x0',
      gasPrice: json['gasPrice'] as String?,
    );

Map<String, dynamic> _$TookeyTransactionToJson(TookeyTransaction instance) =>
    <String, dynamic>{
      'from': instance.from,
      'type': instance.type,
      'to': instance.to,
      'chainId': instance.chainId,
      'nonce': instance.nonce,
      'gas': instance.gas,
      'gasPrice': instance.gasPrice,
      'maxPriorityFeePerGas': instance.maxPriorityFeePerGas,
      'maxFeePerGas': instance.maxFeePerGas,
      'value': instance.value,
      'data': instance.data,
    };
