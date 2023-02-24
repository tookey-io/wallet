import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tookey/models/key_session.dart';
import 'package:tookey/pages/key/key.card.dart';
import 'package:tookey/pages/key/key.popup.dart';
import 'package:tookey/pages/wallet_connect/wallet_connect.page.dart';
import 'package:tookey/services/backend_client.dart';
import 'package:tookey/services/qr_scanner.dart';
import 'package:tookey/state.dart';
import 'package:tookey/widgets/active_session_button.dart';
import 'package:tookey/widgets/toaster.dart';
import 'package:tookey/widgets/wallet_connect_form.dart';

enum KeyAction { share }

class KeyPage extends StatefulWidget {
  const KeyPage({super.key, required this.keyRecord});

  final KeyRecord keyRecord;

  @override
  State<KeyPage> createState() => _KeyPageState();
}

class _KeyPageState extends State<KeyPage> {
  late Future<String?> _keySecret;

  void _connect(String connectionUrl) {
    log(connectionUrl);

    Navigator.push(
      context,
      MaterialPageRoute<WalletConnectPage>(
        builder: (context) {
          return WalletConnectPage(
            keyRecord: widget.keyRecord,
            connectionUrl: connectionUrl,
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

        final sessions = state.readSessions();

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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      KeyCard(keyRecord: widget.keyRecord),
                      FutureBuilder<List<KeySession>>(
                        future: sessions,
                        builder: (context, snapshot) {
                          // ignore: lines_longer_than_80_chars
                          log('snapshot.data: ${snapshot.data?.length.toString()}');
                          final keySessions = snapshot.data?.where(
                            (element) =>
                                element.publicKey == widget.keyRecord.publicKey,
                          );
                          return keySessions != null
                              ? Column(
                                  children: [
                                    ...keySessions.map(
                                      (session) => ActiveSessionButton(
                                        key: Key(session.hashCode.toString()),
                                        sessionStore: session.store,
                                        network: state
                                            .getNetwork(session.store.chainId),
                                        onTap: () {
                                          log('click session');

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute<
                                                WalletConnectPage>(
                                              builder: (context) {
                                                return WalletConnectPage(
                                                  keyRecord: widget.keyRecord,
                                                  sessionStore: session.store,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    if (keySessions.isNotEmpty)
                                      TextButton(
                                        onPressed: () =>
                                            state.removeAllSessions(),
                                        child: const Text('Close all sessions'),
                                      ),
                                    if (keySessions.length < 3)
                                      Column(
                                        children: [
                                          WalletConnectForm(
                                            key: const Key('walletConnectForm'),
                                            onUrl: _connect,
                                          ),
                                        ],
                                      )
                                  ],
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                );
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                );
              }

              return const CircularProgressIndicator();
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
                      bottom: WalletConnectForm(
                        key: const Key('walletConnectForm'),
                        onUrl: _connect,
                      ),
                      onData: (value) {
                        Navigator.pop(context);
                        if (value.startsWith('wc:')) {
                          _connect(value);
                        } else {
                          Toaster.error('Incorrect QR Code');
                        }
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
