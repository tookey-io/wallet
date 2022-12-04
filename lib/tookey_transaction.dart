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
    this.gasPrice,
    this.maxFeePerGas,
    this.maxPriorityFeePerGas,
    this.gas,
    this.gasLimit,
    this.value,
    this.data,
  });

  factory TookeyTransaction.fromJson(Map<String, dynamic> json) =>
      _$TookeyTransactionFromJson(json);
  int? chainId;
  String? nonce;
  String? maxPriorityFeePerGas;

  final String from;
  final String? to;
  final String? gasPrice;
  final String? maxFeePerGas;
  final String? gas;
  final String? gasLimit;
  final String? value;
  final String? data;
  Map<String, dynamic> toJson() => _$TookeyTransactionToJson(this);

  @override
  String toString() {
    final json = toJson();
    return 'TookeyTransaction($json)';
  }
}
