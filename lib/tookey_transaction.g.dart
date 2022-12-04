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
      gasPrice: json['gasPrice'] as String?,
      maxFeePerGas: json['maxFeePerGas'] as String?,
      maxPriorityFeePerGas: json['maxPriorityFeePerGas'] as String?,
      gas: json['gas'] as String?,
      gasLimit: json['gasLimit'] as String?,
      value: json['value'] as String?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$TookeyTransactionToJson(TookeyTransaction instance) =>
    <String, dynamic>{
      'chainId': instance.chainId,
      'nonce': instance.nonce,
      'maxPriorityFeePerGas': instance.maxPriorityFeePerGas,
      'from': instance.from,
      'to': instance.to,
      'gasPrice': instance.gasPrice,
      'maxFeePerGas': instance.maxFeePerGas,
      'gas': instance.gas,
      'gasLimit': instance.gasLimit,
      'value': instance.value,
      'data': instance.data,
    };
