import 'package:flutter/material.dart';
import 'package:tookey/services/networks.dart';
import 'package:wallet_connect/wc_session_store.dart';

class ActiveSessionButton extends StatelessWidget {
  const ActiveSessionButton({
    super.key,
    required this.network,
    required this.sessionStore,
    required this.onTap,
  });

  final Network network;
  final WCSessionStore sessionStore;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              padding: const EdgeInsets.all(8),
              child: Image.network(sessionStore.remotePeerMeta.icons.first),
            ),
            Center(
              child: Text(
                sessionStore.remotePeerMeta.name,
              ),
            ),
            const Spacer(),
            Center(
              child: Container(
                height: 32,
                width: 32,
                padding: const EdgeInsets.all(8),
                child: network.logo != null
                    ? Image.network(network.logo!)
                    : Text(network.symbol),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
