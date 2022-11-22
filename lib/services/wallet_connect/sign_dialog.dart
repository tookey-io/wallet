import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tookey/services/wallet_connect/dialog_title.dart';
import 'package:tookey/state.dart';
import 'package:wallet_connect/wallet_connect.dart';

class SignDialog extends StatelessWidget {
  final WCPeerMeta peerMeta;
  final String message;
  final void Function(AppState? state) onSign;
  final void Function() onReject;

  const SignDialog({
    super.key,
    required this.peerMeta,
    required this.message,
    required this.onSign,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: DialogHeader(peerMeta: peerMeta),
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
                Text(message, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
        Consumer<AppState>(builder: (context, state, child) {
          return Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () => onSign(state),
                  child: const Text('SIGN'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: onReject,
                  child: const Text('REJECT'),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}
