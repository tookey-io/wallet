import 'package:flutter/material.dart';
import 'package:wallet_connect/wallet_connect.dart';

class DialogHeader extends StatelessWidget {
  final WCPeerMeta peerMeta;

  const DialogHeader({
    super.key,
    required this.peerMeta,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (peerMeta.icons.isNotEmpty)
          Container(
            height: 100,
            width: 100,
            padding: const EdgeInsets.only(bottom: 8),
            child: Image.network(peerMeta.icons.first),
          ),
        Text(
          peerMeta.name,
          style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
        ),
      ],
    );
  }
}
