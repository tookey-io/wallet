import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tookey/services/wallet_connect/session_dialog.dart';
import 'package:tookey/services/wallet_connect/sign_dialog.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:web3dart/crypto.dart';

import 'package:tookey/ffi.dart';
import 'package:tookey/services/qr_scanner.dart';
import 'package:tookey/services/signer.dart';
import 'package:tookey/state.dart';

class WalletConnect extends StatefulWidget {
  const WalletConnect({Key? key}) : super(key: key);

  @override
  State<WalletConnect> createState() => _WalletConnectState();
}

class _WalletConnectState extends State<WalletConnect> {
  String? _connectionUrl;
  WCSession? _session;
  WCSessionStore? _sessionStore;
  WCPeerMeta? _peerMeta;
  Future<AbstractSigner>? signer;
  Future<String>? _secret;
  late WCClient? _client;

  final walletMeta = WCPeerMeta(
    name: '2K Signer',
    url: 'https://tookey.io',
    description: 'Official Tookey Signer application',
    icons: [],
  );

  _connect() {
    setState(() {
      if (_sessionStore != null) {
        _client?.connectFromSessionStore(_sessionStore!);
      } else if (_connectionUrl != null) {
        _session = WCSession.from(_connectionUrl!);
        _client?.connectNewSession(session: _session!, peerMeta: walletMeta);
      } else {
        _session = null;
      }
    });
  }

  _disconnect() {
    _client?.disconnect();
    setState(() {
      _session = null;
      _sessionStore = null;
    });
  }

  @override
  void initState() {
    _client = WCClient(
      onConnect: _onConnect,
      onDisconnect: _onDisconnect,
      onFailure: _onFailure,
      onSessionRequest: _onSessionRequest,
      onEthSign: _onEthSign,
      onEthSendTransaction: _onEthSendTransaction,
      onEthSignTransaction: _onEthSignTrasaction,
    );
    super.initState();
  }

  _onConnect() {
    log("onConnect");
    setState(() {
      // _session =
      _sessionStore = _client?.sessionStore;
    });
  }

  void _onDisconnect(int? code, String? reason) {
    log("onDisconnect: $code, $reason");
    _disconnect();
  }

  void _onFailure(error) {
    log("onFailure: $error");
    _disconnect();
  }

  void _approveTransactionDialog(int id, WCEthereumTransaction tx) {
    showDialog(
        context: context,
        builder: (context) {
          return SignDialog(
            peerMeta: _client!.remotePeerMeta!,
            message: tx.data!,
            onSign: (state) async {
              String? signedDataHex = await _sign(state!, tx.data!);
              _client?.approveRequest(id: id, result: signedDataHex);
              Navigator.pop(context);
            },
            onReject: () {
              _client?.rejectRequest(id: id);
              Navigator.pop(context);
            },
          );
        });
  }

  void _onEthSignTrasaction(int id, WCEthereumTransaction tx) {
    log("onEthSignTransaction: $id, $tx");
    _approveTransactionDialog(id, tx);
  }

  void _onEthSendTransaction(int id, WCEthereumTransaction tx) {
    log("onEthSendTransaction: $id, $tx");
    _approveTransactionDialog(id, tx);
  }

  void _onEthSign(int id, WCEthereumSignMessage message) async {
    final decoded = (message.type == WCSignType.TYPED_MESSAGE)
        ? message.data!
        : ascii.decode(hexToBytes(message.data!));
    log("_onEthSign: $decoded");

    showDialog(
        context: context,
        builder: (context) {
          return SignDialog(
            peerMeta: _client!.remotePeerMeta!,
            message: decoded,
            onSign: (state) async {
              if (message.type == WCSignType.TYPED_MESSAGE) {
                throw "Not implemented yet";
              }
              String? signedDataHex = await _sign(state!, decoded);
              _client?.approveRequest(id: id, result: signedDataHex);
              Navigator.pop(context);
            },
            onReject: () {
              _client?.rejectRequest(id: id);
              Navigator.pop(context);
            },
          );
        });
  }

  void _onSessionRequest(int id, WCPeerMeta peerMeta) async {
    await showDialog(
      context: context,
      builder: (context) {
        return SessionDialog(
          peerMeta: peerMeta,
          onApprove: (state) async {
            setState(() {
              _sessionStore = _client?.sessionStore;
            });
            String? address = await state!.getEthereumAddress();
            _client?.approveSession(accounts: [address], chainId: 97);
            setState(() {
              _peerMeta = peerMeta;
            });
            Navigator.pop(context);
          },
          onReject: () {
            _client?.rejectSession();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _disconnect();
    super.dispose();
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    _disconnect();
    _connect();
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, child) {
      _secret ??= state.readShareableKey().then((possibleSecret) {
        if (possibleSecret == null) throw "Cannot load secret";
        return possibleSecret;
      });
      return Scaffold(
        appBar: AppBar(
          title: const Text("WalletConnect V1"),
        ),
        body: FutureBuilder(
            future: _secret,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: [
                    if (_session == null)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: (Column(
                          children: [
                            const Spacer(flex: 1),
                            const Icon(Icons.add_link,
                                size: 48, color: Colors.grey),
                            const Padding(padding: EdgeInsets.all(10)),
                            const Text("Wallet connect",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            const Padding(padding: EdgeInsets.all(5)),
                            const Text(
                                "Paste connection url below or use QR scanner"),
                            const Padding(padding: EdgeInsets.all(10)),
                            Row(
                              children: [
                                Flexible(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                        helperText: "Enter connection string"),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                    onChanged: (value) => setState(() {
                                      _connectionUrl = value;
                                    }),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                    onPressed: () {
                                      _connect();
                                    },
                                    child: Row(children: const [
                                      Icon(Icons.cast_connected),
                                      Text(" Connect"),
                                    ])),
                              ],
                            ),
                            const Spacer(flex: 2),
                          ],
                        )),
                      )
                    else ...[
                      const Center(
                          child: Text("Interaction by WalletConnect protocol")),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Center(
                              child: FloatingActionButton(
                                heroTag: 'wc-disconnect',
                                backgroundColor: Colors.white,
                                onPressed: () async {
                                  _disconnect();
                                },
                                child: const Icon(
                                  Icons.exit_to_app,
                                  color: Colors.blue,
                                ),
                              ),
                            )),
                      )
                    ]
                  ],
                );
              } else {
                return Center(
                    // ignore: prefer_const_literals_to_create_immutables
                    child: Column(children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  const Text("Loading secret",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ]));
              }
            }),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(height: 45),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'wc-scan',
          tooltip: "Scan QR",
          child: const Icon(Icons.qr_code_scanner),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return QRScanner(
                  onData: (value) {
                    Navigator.pop(context);
                    setState(() {
                      _connectionUrl = value;
                    });
                    _connect();
                  },
                );
              }),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      );
    });
  }

  Future<String?> _sign(AppState state, String message) async {
    Completer<String?> signJoinHandle = Completer();
    final hash = await api.messageToHash(message: message);
    final metadata = _sessionStore?.remotePeerMeta.toJson();

    state.signKey(message, hash, metadata).then((signature) {
      signJoinHandle.complete(signature);
    }).catchError((e) {
      signJoinHandle.completeError(e);
    });

    showDialog<String>(
        context: context,
        builder: (_) {
          signJoinHandle.future
              .then((signature) => Navigator.pop(context, signature));

          return SimpleDialog(
              contentPadding: const EdgeInsets.all(20),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 15),
                    const Text("Signature progress",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 25),
                    TextButton(
                        onPressed: () async {
                          signJoinHandle.completeError("cancel");
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: const Text("CANCEL"))
                  ],
                ),
              ]);
        });

    return signJoinHandle.future;
  }
}
