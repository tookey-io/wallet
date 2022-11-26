import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tookey/state.dart';
import 'package:tookey/widgets/dialog/dialog_button.dart';
import 'package:tookey/widgets/dialog/dialog_title.dart';
import 'package:wallet_connect/wallet_connect.dart';

class WalletConnectSessionDialog extends StatelessWidget {
  const WalletConnectSessionDialog({
    super.key,
    required this.peerMeta,
    required this.onApprove,
    required this.onReject,
  });

  final WCPeerMeta peerMeta;
  final void Function(AppState? state) onApprove;
  final void Function() onReject;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: DialogTitle(title: peerMeta.name, icon: peerMeta.icons.first),
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
        Consumer<AppState>(
          builder: (context, state, child) {
            return Row(
              children: [
                DialogButton(
                  title: 'APPROVE',
                  onPressed: () => onApprove(state),
                  buttonStyle: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  expanded: true,
                ),
                const SizedBox(width: 16),
                DialogButton(
                  title: 'REJECT',
                  onPressed: onReject,
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
