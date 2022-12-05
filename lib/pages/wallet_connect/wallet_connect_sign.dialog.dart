import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tookey/ffi.dart';
import 'package:tookey/services/backend_client.dart';
import 'package:tookey/state.dart';
import 'package:tookey/widgets/dialog/dialog_button.dart';
import 'package:tookey/widgets/dialog/dialog_progress.dart';
import 'package:tookey/widgets/dialog/dialog_title.dart';
import 'package:tookey/widgets/toaster.dart';
import 'package:wallet_connect/utils/hex.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:web3dart/web3dart.dart';

class WalletConnectSignDialog extends StatefulWidget {
  const WalletConnectSignDialog({
    super.key,
    required this.onSign,
    required this.onReject,
    this.tx,
    this.message,
    this.data,
    required this.title,
    this.icon,
    this.metadata,
  });

  final void Function({String? result}) onSign;
  final void Function() onReject;
  final WCEthereumTransaction? tx;
  final WCEthereumSignMessage? message;
  final String? data;
  final String title;
  final String? icon;
  final Map<String, dynamic>? metadata;

  @override
  State<WalletConnectSignDialog> createState() =>
      _WalletConnectSignDialogState();
}

class _WalletConnectSignDialogState extends State<WalletConnectSignDialog> {
  Completer<String?> signJoinHandle = Completer<String?>();
  bool isExecuting = false;

  Future<void> _onCancel() async {
    signJoinHandle.complete();
    widget.onReject();
  }

  Future<void> _onSign(AppState state) async {
    if (signJoinHandle.isCompleted) signJoinHandle = Completer<String?>();
    if (isExecuting) return;

    setState(() {
      isExecuting = true;
    });

    try {
      var tx = widget.tx;
      if (tx != null) {
        final ethClient = Web3Client(dotenv.env['NODE_URL']!, Client());
        final gasLimit = await ethClient.estimateGas(
            sender: EthereumAddress.fromHex(tx.from),
            to: EthereumAddress.fromHex(tx.to ?? '0x0000000000000000000000000000000000000000'),
            value: EtherAmount.fromUnitAndValue(EtherUnit.wei, tx.value),
            data: tx.data != null ? hexToBytes(tx.data!) : null);
        final nonce = await ethClient.getTransactionCount(EthereumAddress.fromHex(tx.from));
        final encoded = await state.parseTransaction(WCEthereumTransaction(from: from) widget.tx!);
        final hash = await api.toMessageHash(txRequest: encoded);
        final signature =
            await state.signKey(widget.tx!.data!, hash, widget.metadata);
        final encodedTx = await api.encodeTransaction(
            txRequest: encoded, signature: signature);

        await Toaster.success('Transaction signed');
        await state
            .sendSignedTransaction(encodedTx)
            .then((value) => Toaster.success('Transaction successfully sent'))
            .catchError((error) => Toaster.error('Transaction send fail'));
        signJoinHandle.complete();
        widget.onSign(result: 'Success');
      }
      if (widget.message != null) {
        // TODO(temadev): implement
        // final hash = await api.messageToHash(message: widget.tx!.data!);
        // final signedTransaction =
        //     await state.signKey(widget.tx!.data!, hash, widget.metadata);
        //
        // await Toaster.success('Transaction signed');
        // await state
        //     .sendSignedTransaction(signedTransaction)
        //     .then((value) => Toaster.success('Transaction successfully sent'))
        //     .catchError((error) => Toaster.error('Transaction send fail'));
        // signJoinHandle.complete(signedTransaction);
        // widget.onSign(result: signedTransaction);
      }
    } catch (error) {
      if (error is BackendException) {
        await Toaster.error(error.message);
      } else {
        await Toaster.error('Failed');
      }
      signJoinHandle.complete();
      widget.onSign();
    }

    setState(() {
      isExecuting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isExecuting) {
      return SimpleDialog(
        contentPadding: const EdgeInsets.all(20),
        children: [DialogProgress(title: 'Sign progress', onCancel: _onCancel)],
      );
    }

    return SimpleDialog(
      title: DialogTitle(title: widget.title, icon: widget.icon),
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 8),
          child: const Text(
            'Sign Message',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text(
                'Message',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              children: [
                Text('To: ${widget.tx?.to}'),
                Text('Gas limit: ${widget.tx?.gasLimit}'),
                Text('Gas price: ${widget.tx?.gasPrice}'),
                Text(widget.data!, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
        Consumer<AppState>(
          builder: (context, state, child) {
            return Row(
              children: [
                DialogButton(
                  title: 'SIGN',
                  onPressed: () => _onSign(state),
                  buttonStyle: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  expanded: true,
                ),
                const SizedBox(width: 16),
                DialogButton(
                  title: 'REJECT',
                  onPressed: widget.onReject,
                  buttonStyle: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  expanded: true,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
