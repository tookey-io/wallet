// ignore_for_file: avoid_dynamic_calls, constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:tookey/services/networks.dart';
import 'package:tookey/state.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

class MethodCall {
  MethodCall({
    required this.method,
    required this.data,
  });

  final ContractFunction method;
  final List<dynamic> data;
}

class TransactionDetails extends StatefulWidget {
  const TransactionDetails({
    super.key,
    required this.tx,
    required this.chainId,
    required this.network,
  });

  final WCEthereumTransaction tx;
  final int chainId;
  final Network network;

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  bool get isContractCreation =>
      widget.tx.to == null ||
      widget.tx.to == '0x0' ||
      widget.tx.to == '0x0000000000000000000000000000000000000000';

  EthereumAddress get to => EthereumAddress.fromHex(
        widget.tx.to ?? '0x0000000000000000000000000000000000000000',
      );
  int get chainId => widget.chainId;
  Network get network => widget.network;
  String? get data => widget.tx.data;
  String? get callSignature => data?.substring(2, 10);
  MethodCall? _call;

  @override
  void initState() {
    // asynchronous call
    () async {
      final abi = isContractCreation ? '{}' : await _requestAbi();
      log(abi);
    }();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(jsonEncode(network.toJson()));
  }

  Future<String> _requestAbi() async {
    if (network.explorerApi == null) {
      return '{}';
    }

    final client = Client();
    final ethClient = Web3Client(network.rpc, client);
    final proxy = await ethClient
        .getStorage(
          to,
          BigInt.parse(
            // _IMPLEMENTATION_SLOT
            '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc',
          ),
        )
        .then((bytes) => EthereumAddress(bytes.sublist(12)));

    final isProxy = proxy.addressBytes.any((element) => element != 0);

    log('Implementation: ${proxy.hex}, $isProxy');

    final abiAddress = isProxy ? proxy.hexEip55 : to.hexEip55; 

    final uri = Uri.parse(
      '${network.explorerApi!}/api?module=contract&action=getabi&address=$abiAddress',
    );
    // final response = await http.get(uri).then((response) => response.body);
    final response = await http
        .get(
          Uri.parse(
            'https://raw.githubusercontent.com/tookey-io/extended-abis/main/137/$abiAddress.json',
          ),
        )
        .then((response) => response.body);

    final contract = ContractAbi.fromJson(response, 'Contract');

    final contractMethod = contract.functions
        .firstWhere((element) => bytesToHex(element.selector) == callSignature);
    final buffer = hexToBytes(data!).sublist(4);
    final decoded =
        TupleType(contractMethod.parameters.map((e) => e.type).toList()).decode(
      buffer.buffer,
      0,
    );

    log(
      contractMethod.parameters
          .map((e) =>
              [e.type.runtimeType.toString(), e.type is AddressType].join(' '))
          .join('\n'),
    );
    log(decoded.data.join(', '));
    log(decoded.data.map((e) => e.runtimeType).join(', '));

    return '{}';
  }
}
