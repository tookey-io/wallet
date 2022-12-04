import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tookey/ffi.dart';
import 'package:tookey/services/backend_client.dart';
import 'package:tookey/state.dart';
import 'package:tookey/widgets/dialog/dialog_button.dart';
import 'package:tookey/widgets/dialog/dialog_progress.dart';
import 'package:tookey/widgets/dialog/dialog_title.dart';
import 'package:tookey/widgets/toaster.dart';

class WalletConnectSignDialog extends StatefulWidget {
  const WalletConnectSignDialog({
    super.key,
    required this.onSign,
    required this.onReject,
    required this.message,
    required this.title,
    this.icon,
    this.metadata,
  });

  final void Function({String? result}) onSign;
  final void Function() onReject;
  final String message;
  final String title;
  final String? icon;
  final Map<String, dynamic>? metadata;

  @override
  State<WalletConnectSignDialog> createState() =>
      _WalletConnectSignDialogState();
}

class _WalletConnectSignDialogState extends State<WalletConnectSignDialog> {
  Completer<String> signJoinHandle = Completer<String>();
  bool isExecuting = false;

  Future<void> _onCancel() async {
    signJoinHandle.completeError('cancel');
    widget.onReject();
  }

  Future<void> _onSign(AppState state) async {
    if (signJoinHandle.isCompleted) signJoinHandle = Completer<String>();
    if (isExecuting) return;

    setState(() {
      isExecuting = true;
    });

    try {
      final hash = await api.messageToHash(message: widget.message);
      final signedTransaction =
          await state.signKey(widget.message, hash, widget.metadata);

      await Toaster.success('Transaction signed');
      await state
          .sendSignedTransaction(signedTransaction)
          .then((value) => Toaster.success('Transaction successfully sent'))
          .catchError((error) => Toaster.error('Transaction send fail'));
      signJoinHandle.complete(signedTransaction);
      widget.onSign(result: signedTransaction);
    } catch (error) {
      if (error is BackendResponseException) {
        if (error.statusCode == 403) await Toaster.error(error.message);
      } else {
        await Toaster.error('Failed');
      }
      signJoinHandle.completeError('');
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
                Text(widget.message, style: const TextStyle(fontSize: 16)),
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
