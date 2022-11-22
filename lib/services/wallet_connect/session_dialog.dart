import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tookey/services/wallet_connect/dialog_title.dart';
import 'package:tookey/state.dart';
import 'package:wallet_connect/wallet_connect.dart';

class SessionDialog extends StatelessWidget {
  final WCPeerMeta peerMeta;
  final void Function(AppState? state) onApprove;
  final void Function() onReject;

  const SessionDialog({
    super.key,
    required this.peerMeta,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: DialogHeader(peerMeta: peerMeta),
      contentPadding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        if (peerMeta.description.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(peerMeta.description),
          ),
        if (peerMeta.url.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('Connection to ${peerMeta.url}'),
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
                  onPressed: () => onApprove(state),
                  child: const Text('APPROVE'),
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
