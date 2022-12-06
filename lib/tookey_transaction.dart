import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'tookey_transaction.g.dart';

@JsonSerializable()
class TookeyTransaction {
  TookeyTransaction({
    required this.from,
    this.chainId,
    this.to,
    this.nonce,
    this.maxFeePerGas,
    this.maxPriorityFeePerGas,
    this.gas,
    this.value,
    this.data,
    this.type = '0x2',
    this.gasPrice = '0x0',
  });

  factory TookeyTransaction.fromJson(Map<String, dynamic> json) =>
      _$TookeyTransactionFromJson(json);

  String from;
  int? chainId;
  String? nonce;
  String? maxPriorityFeePerGas;
  String? maxFeePerGas;
  String? to;
  String? gas;
  String? value;
  String? data;
  String type;
  String gasPrice;

  Map<String, dynamic> toJson() => _$TookeyTransactionToJson(this);

  @override
  String toString() {
    final json = toJson();
    return 'TookeyTransaction($json)';
  }
}
