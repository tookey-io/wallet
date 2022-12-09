import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:wallet_connect/models/ethereum/wc_ethereum_transaction.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

part 'tookey_transaction.g.dart';

@JsonSerializable()
class TookeyTransaction {
  TookeyTransaction({
    required this.from,
    this.chainId,
    this.to = '0x0000000000000000000000000000000000000000',
    this.nonce,
    this.maxFeePerGas,
    this.maxPriorityFeePerGas,
    this.gas,
    this.value,
    this.data,
    this.type = '0x0',
    this.gasPrice,
  });

  factory TookeyTransaction.fromJson(Map<String, dynamic> json) =>
      _$TookeyTransactionFromJson(json);

  String from;
  String type;
  String to;
  String? chainId;
  String? nonce;
  String? gas;
  String? gasPrice;
  String? maxPriorityFeePerGas;
  String? maxFeePerGas;
  String? value;
  String? data;

  Map<String, dynamic> toJson() => _$TookeyTransactionToJson(this);

  @override
  String toString() {
    final json = toJson();
    return 'TookeyTransaction($json)';
  }

  static Future<TookeyTransaction> parseTransaction(
    WCEthereumTransaction wcTx,
  ) async {
    final json = wcTx.toJson();
    final tx = TookeyTransaction.fromJson(json);

    log("Node is ${dotenv.env['NODE_URL']!}");
    final ethClient = Web3Client(dotenv.env['NODE_URL']!, Client());

    log('Balance is ${await ethClient.getBalance(
      EthereumAddress.fromHex(tx.from),
    )}');

    tx.value ??= bytesToHex(intToBytes(BigInt.zero), include0x: true);
    tx.data ??= bytesToHex(intToBytes(BigInt.zero), include0x: true);

    if (tx.chainId == null) {
      final chainId = await ethClient.getChainId();
      log('Chain is ${tx.chainId}');
      tx.chainId = bytesToHex(intToBytes(chainId), include0x: true);
    }

    if (tx.gas == null) {
      final gas = await ethClient.estimateGas(
        sender: EthereumAddress.fromHex(tx.from),
        to: EthereumAddress.fromHex(
          tx.to,
        ),
        value: EtherAmount.fromUnitAndValue(EtherUnit.wei, tx.value),
        data: tx.data != null ? hexToBytes(tx.data!) : null,
      );
      log('Gas is $gas');
      tx.gas = bytesToHex(intToBytes(gas), include0x: true);
    }

    if (tx.nonce == null) {
      final nonce =
          await ethClient.getTransactionCount(EthereumAddress.fromHex(tx.from));
      log('Nonce is $nonce');
      tx.nonce = bytesToHex(intToBytes(BigInt.from(nonce)), include0x: true);
    }

    final gasPrice = (await ethClient.getGasPrice()).getInWei;
    log('GasPrice is $gasPrice');

    tx.gasPrice ??= bytesToHex(intToBytes(gasPrice), include0x: true);
    tx.maxFeePerGas ??= bytesToHex(intToBytes(gasPrice), include0x: true);
    tx.maxPriorityFeePerGas ??= bytesToHex(
      intToBytes(gasPrice + BigInt.from(1000000000)),
      include0x: true,
    );

    log('json encoded ${jsonEncode(tx)}');

    return tx;
  }
}
