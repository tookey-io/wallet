import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tookey/pages/key/key.popup.dart';
import 'package:tookey/pages/wallet_connect/wallet_connect.page.dart';
import 'package:tookey/services/backend_client.dart';
import 'package:tookey/services/qr_scanner.dart';
import 'package:tookey/state.dart';

enum KeyAction { share }

class KeyPage extends StatefulWidget {
  const KeyPage({super.key, required this.keyRecord});

  final KeyRecord keyRecord;

  @override
  State<KeyPage> createState() => _KeyPageState();
}

class _KeyPageState extends State<KeyPage> {
  late Future<String?> _keySecret;
  String? _connectionUrl;

  void _connect(connectionUrl) {
    Navigator.push(
      context,
      MaterialPageRoute<WalletConnectPage>(
        builder: (context) {
          return WalletConnectPage(
            title: widget.keyRecord.name,
            connectionUrl: _connectionUrl!,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        _keySecret = state.readShareableKey().then((secret) => secret ?? '');

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.keyRecord.name),
            actions: const [KeyPopup()],
          ),
          body: FutureBuilder(
            future: _keySecret,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data != '') {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Spacer(),
                      const Icon(
                        Icons.add_link,
                        size: 48,
                        color: Colors.grey,
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      const Text(
                        'Wallet connect',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(5)),
                      const Text(
                        'Paste connection url below or use QR scanner',
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      Row(
                        children: [
                          Flexible(
                            child: TextField(
                              decoration: const InputDecoration(
                                helperText: 'Enter connection string',
                              ),
                              style: Theme.of(context).textTheme.bodyText1,
                              onChanged: (value) => setState(() {
                                _connectionUrl = value;
                              }),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _connect(_connectionUrl),
                            child: Row(
                              children: const [
                                Icon(Icons.cast_connected),
                                Text(' Connect'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    children: const [
                      SizedBox(height: 20),
                      Text(
                        'Add secret button',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Container(height: 45),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'wc-scan',
            tooltip: 'Scan QR',
            child: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<QRScanner>(
                  builder: (context) {
                    return QRScanner(
                      onData: (value) {
                        Navigator.pop(context);
                        setState(() {
                          _connectionUrl = value;
                        });
                        _connect(_connectionUrl);
                      },
                    );
                  },
                ),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
