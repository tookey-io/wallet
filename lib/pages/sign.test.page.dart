import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tookey/pages/wallet_connect/wallet_connect_sign.dialog.dart';
import 'package:tookey/state.dart';
import 'package:wallet_connect/wallet_connect.dart';

class SignTest extends StatefulWidget {
  const SignTest({super.key, required this.title});

  final String title;

  @override
  State<SignTest> createState() => _SignTestState();
}

class _SignTestState extends State<SignTest> {
  Future<void> _approveTransactionDialog(int id, WCEthereumTransaction tx) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WalletConnectSignDialog(
          title: 'Aave protocol',
          icon:
              'https://raw.githubusercontent.com/trustwallet/assets/master/blockchains/ethereum/info/logo.png',
          tx: tx,
          data: tx.data,
          onSign: ({result}) {
            Navigator.pop(context);
          },
          onReject: () {
            Navigator.pop(context);
          },
          chainId: 1,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
    return Consumer<AppState>(
      builder: (context, state, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: [
              TextButton(
                style: style,
                onPressed: () {},
                child: const Icon(Icons.more_horiz_outlined),
              ),
            ],
          ),
          body: Card(
            child: Column(
              children: [
                TextButton(
                  onPressed: () async {
                    await _approveTransactionDialog(
                      5,
                      WCEthereumTransaction.fromJson(
                        // ignore: leading_newlines_in_multiline_strings
                        jsonDecode('''{
                          "from": "0xdef13e0461bd92f2cd4ffacb947b50a5ab2cc998",
                          "to": "0x87870bca3f3fd6335c3f4ce8392d69350b4fa4e2",
                          "nonce": "0x1fa",
                          "gasPrice": "0x21d997647e",
                          "maxFeePerGas": "0x2beeb14e6e",
                          "maxPriorityFeePerGas": "0x758b5a469",
                          "gas": "0x493e0",
                          "value": "0x0",
                          "data": "0x617ba037000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb4800000000000000000000000000000000000000000000000000000001dcd65000000000000000000000000000def13e0461bd92f2cd4ffacb947b50a5ab2cc9980000000000000000000000000000000000000000000000000000000000000000"
                        }''') as Map<String, dynamic>,
                      ),
                    );
                  },
                  child: const Text('Sign Tx'),
                ),
                TextButton(
                  onPressed: () async {
                    await _approveTransactionDialog(
                      5,
                      WCEthereumTransaction.fromJson(
                        // ignore: leading_newlines_in_multiline_strings
                        jsonDecode('''{
                          "from": "0xdef13e0461bd92f2cd4ffacb947b50a5ab2cc998",
                          "to": "0x87870bca3f3fd6335c3f4ce8392d69350b4fa4e2",
                          "nonce": "0x1fa",
                          "gasPrice": "0x21d997647e",
                          "maxFeePerGas": "0x2beeb14e6e",
                          "maxPriorityFeePerGas": "0x758b5a469",
                          "gas": "0x493e0",
                          "value": "0x0",
                          "data": "0x617ba037000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb4800000000000000000000000000000000000000000000000000000001dcd65000000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000000000000000000000000000000000000000000000"
                        }''') as Map<String, dynamic>,
                      ),
                    );
                  },
                  child: const Text('Sign Behalf Token'),
                ),
                TextButton(
                  onPressed: () async {
                    await _approveTransactionDialog(
                      5,
                      WCEthereumTransaction.fromJson(
                        // ignore: leading_newlines_in_multiline_strings
                        jsonDecode('''{
                          "from": "0xdef13e0461bd92f2cd4ffacb947b50a5ab2cc998",
                          "to": "0x87870bca3f3fd6335c3f4ce8392d69350b4fa4e2",
                          "nonce": "0x1fa",
                          "gasPrice": "0x21d997647e",
                          "maxFeePerGas": "0x2beeb14e6e",
                          "maxPriorityFeePerGas": "0x758b5a469",
                          "gas": "0x493e0",
                          "value": "0x0",
                          "data": "0x617ba037000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb4800000000000000000000000000000000000000000000000000000001dcd65000000000000000000000000000c30141B657f4216252dc59Af2e7CdB9D8792e1B00000000000000000000000000000000000000000000000000000000000000000"
                        }''') as Map<String, dynamic>,
                      ),
                    );
                  },
                  child: const Text('Sign Behalf Contract'),
                ),
                const Text('hello world'),
              ],
            ),
          ),
        );
      },
    );
  }
}
