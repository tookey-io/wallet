import 'dart:developer';

import 'package:flutter/material.dart';

typedef UrlCallback = void Function(String);

class WalletConnectForm extends StatefulWidget {
  const WalletConnectForm({super.key, required this.onUrl});
  final UrlCallback onUrl;

  @override
  State<WalletConnectForm> createState() => _WalletConnectFormState();
}

class _WalletConnectFormState extends State<WalletConnectForm> {
  String _connectionUrl = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.add_link,
          size: 48,
          color: Colors.grey,
        ),
        const Padding(padding: EdgeInsets.all(8)),
        const Text(
          'Wallet connect',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Padding(padding: EdgeInsets.all(6)),
        const Text(
          'Paste connection url below or use QR scanner',
        ),
        const Padding(padding: EdgeInsets.all(10)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: TextField(
                decoration: const InputDecoration(
                  isDense: true,
                  label: Text('Connection string'),
                  fillColor: Colors.black12,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white12, width: 2),
                  ),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() {
                  _connectionUrl = value;
                }),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                log('press $_connectionUrl');
                final uri = _connectionUrl;
                widget.onUrl(uri);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 50),
              ),
              child: Row(
                children: const [
                  Icon(Icons.cast_connected),
                  Text(' Connect'),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
