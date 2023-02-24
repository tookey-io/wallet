import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tookey/state.dart';
import 'package:tookey/widgets/dialog/dialog_button.dart';
import 'package:tookey/widgets/dialog/dialog_title.dart';
import 'package:wallet_connect/wallet_connect.dart';

class WalletConnectSessionDialog extends StatefulWidget {
  const WalletConnectSessionDialog({
    super.key,
    required this.peerMeta,
    required this.onApprove,
    required this.onReject,
  });

  final WCPeerMeta peerMeta;
  final void Function(int chainId) onApprove;
  final void Function() onReject;

  @override
  State<WalletConnectSessionDialog> createState() =>
      _WalletConnectSessionDialogState();
}

class _WalletConnectSessionDialogState
    extends State<WalletConnectSessionDialog> {
  int? _chainId;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context, listen: false);
    final networks = state.networks;
    final peerMeta = widget.peerMeta;
    final onApprove = widget.onApprove;
    final onReject = widget.onReject;

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
        DropdownButton<int?>(
          itemHeight: 64,
          isExpanded: true,
          value: _chainId,
          items: 
          [
            const DropdownMenuItem(child: Text('Select network'),),
            ...networks
              .map(
                (n) => DropdownMenuItem(
                  value: n.chainId,
                  child: Row(
                    children: [
                      if (n.logo != null)
                        Image.network(
                          n.logo!,
                          width: 24,
                          height: 24,
                        ),
                      Text(' ${n.name}'),
                    ],
                  ),
                ),
              )
              ],
          onChanged: (selected) {
            setState(() {
              _chainId = selected;
            });
          },
        ),
        Row(
          children: [
            DialogButton(
              title: 'APPROVE',
              onPressed: () => _chainId != null ? onApprove(_chainId!) : {},
              buttonStyle: TextButton.styleFrom(
                foregroundColor: Theme.of(context)
                    .colorScheme
                    .secondary
                    .withAlpha(_chainId == null ? 50 : 255),
              ),
              expanded: true,
            ),
            const SizedBox(width: 16),
            DialogButton(
              title: 'REJECT',
              onPressed: onReject,
              buttonStyle: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              expanded: true,
            ),
          ],
        ),
      ],
    );
  }
}
