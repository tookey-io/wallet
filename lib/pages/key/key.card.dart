import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tookey/ffi.dart';
import 'package:tookey/services/backend_client.dart';
import 'package:tookey/widgets/toaster.dart';

class KeyCard extends StatelessWidget {
  const KeyCard({super.key, required this.keyRecord});

  final KeyRecord keyRecord;

  @override
  Widget build(BuildContext context) {
    final address =
        api.publicKeyToEthereumAddress(publicKey: keyRecord.publicKey);
    return Card(
      child: Column(
        children: [
          // ListTile(
          //   title: Text(keyRecord.name),
          //   // subtitle: const Text('Name'),
          //   leading: const Icon(Icons.title, color: Colors.white70),
          // ),
          if (keyRecord.description != '')
            ListTile(
              title: Text(
                keyRecord.description,
                style: const TextStyle(fontSize: 12),
              ),
              // subtitle: const Text('Description'),
              leading: const Icon(Icons.info, color: Colors.white70),
            ),
          ListTile(
            onTap: () async {
              final awaitedAddress = await address;
              await Clipboard.setData(ClipboardData(text: awaitedAddress));
              await Toaster.success('Wallet address copied to clipboard');
            },
            title: FutureBuilder<String>(
              future: address,
              builder: (context, snapshot) => Text(
                overflow: TextOverflow.ellipsis,
                snapshot.data != null ? snapshot.data! : '...',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            // subtitle: const Text('Public key'),
            leading: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
