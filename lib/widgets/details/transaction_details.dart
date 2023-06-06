// ignore_for_file: avoid_dynamic_calls, constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:tookey/services/details.dart';
import 'package:tookey/services/networks.dart';
import 'package:tookey/state.dart';
import 'package:tookey/widgets/details/method_call.dart';
import 'package:tookey/widgets/details/method_call_parameter.dart';
import 'package:tookey/widgets/details/method_signature.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

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
  Future<MethodCall?> _callFuture = Future.value();

  @override
  void initState() {
    _callFuture = _decodeCall();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MethodCall?>(
      builder: (context, snapshot) {
        final call = snapshot.data;
        if (call != null) {
          final widgets = <Widget>[
            MethodSignature(call: call),
          ];

          for (var index = 0; index < call.argsCount; index++) {
            widgets.add(
              MethodCallParameter<dynamic>(
                call: call,
                parameter: call.getArgument(index),
                data: call.getArgumentData(index),
              ),
            );
          }

          return Column(
            children: widgets,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      future: _callFuture,
    );
  }

  Future<MethodCall?> _decodeCall() async {
    if (network.explorerApi == null) {
      return null;
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
            'https://raw.githubusercontent.com/tookey-io/extended-abis/main/$chainId/$abiAddress.json',
          ),
        )
        .then((response) => response.ok ? response.body : null);

    final contract =
        response != null ? ContractAbi.fromJson(response, 'Contract') : null;

    final contractMethod = contract?.functions
        .firstWhere((element) => bytesToHex(element.selector) == callSignature);

    log(
      contractMethod?.parameters
              .map(
                (e) => [
                  e.name,
                  e.type.runtimeType.toString(),
                  e.meta?['description'],
                  e.meta?['kind'],
                ].join(' '),
              )
              .join('\n') ??
          'not found contract',
    );

    final decoded = contractMethod != null
        ? TupleType(contractMethod.parameters.map((e) => e.type).toList())
            .decode(
            hexToBytes(data!.substring(10)).buffer,
            0,
          )
        : null;
    // throw 'unimplemented';
    log(decoded?.data.join(', ') ?? 'not found');
    log(decoded?.data.map((e) => e.runtimeType).join(', ') ?? 'not found');

    return contractMethod != null && decoded != null
        ? MethodCall(
            method: contractMethod,
            data: decoded.data,
            chainId: chainId,
          )
        : null;
  }
}
