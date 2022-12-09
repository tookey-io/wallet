import 'package:flutter/material.dart';
import 'package:tookey/services/backend_client.dart';

class KeyCard extends StatelessWidget {
  const KeyCard({super.key, required this.keyRecord});

  final KeyRecord keyRecord;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(keyRecord.name),
            // subtitle: const Text('Name'),
            leading: const Icon(Icons.title, color: Colors.white70),
          ),
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
            title: Text(
              keyRecord.publicKey,
              style: const TextStyle(fontSize: 12),
            ),
            // subtitle: const Text('Public key'),
            leading: const Icon(Icons.key, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
