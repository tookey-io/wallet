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
          chainId: 137,
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
                          "from": "0x97568d242ab0233c55d992aa46cd41e7311fcc14",
                          "to": "0x794a61358d6845594f94dc1db02a252b5b4814ad",
                          "nonce": "0x1fa",
                          "gasPrice": "0x21d997647e",
                          "maxFeePerGas": "0x2beeb14e6e",
                          "maxPriorityFeePerGas": "0x758b5a469",
                          "gas": "0x493e0",
                          "value": "0x0",
                          "data": "0x617ba0370000000000000000000000001bfd67037b42cf73acf2047067bd4f2c47d9bfd6000000000000000000000000000000000000000000000000000000000000113000000000000000000000000097568d242ab0233c55d992aa46cd41e7311fcc140000000000000000000000000000000000000000000000000000000000000000"
                        }''') as Map<String, dynamic>,
                      ),
                    );
                  },
                  child: const Text('Sign Tx'),
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
