import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rust_bridge_template/pages/qr_scanner.dart';
import 'package:wallet_connect/wallet_connect.dart';
import 'package:web3dart/crypto.dart';

import '../ffi.dart';
import '../sign.dart';

class WalletConnect extends StatefulWidget {
  WalletConnect({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WalletConnectState();
}

class _WalletConnectState extends State<WalletConnect> {
  String? _connectionUrl;
  WCPeerMeta? _peer;
  WCSession? _session;
  WCSessionStore? _store;
  Future<AbstractSigner>? signer;

  late WCClient? _client;
  final walletMeta = WCPeerMeta(
    name: '2K Signer',
    url: 'https://tookey.io',
    description: 'Official Tookey Signer application',
    icons: [],
  );

  _connect() {
    setState(() {
      if (_store != null) {
        _client?.connectFromSessionStore(_store!);
      } else {
        _session =
            _connectionUrl != null ? WCSession.from(_connectionUrl!) : null;

        if (_session != null) {
          _client?.connectNewSession(session: _session!, peerMeta: walletMeta);
        }
      }
    });
  }

  _disconnect() {
    _client?.disconnect();
    setState(() {
      _session = null;
      _store = null;
    });
  }

  @override
  void initState() {
    api.connectLogger().listen((event) {
      log("Rust log: $event");
    });

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
      _store = _client?.sessionStore;
    });
  }

  void _onDisconnect(code, reason) {
    log("onDisconnect: $code, $reason");
    _disconnect();
    // Respond to disconnect callback
  }

  void _onFailure(error) {
    log("onFailure: $error");
    _disconnect();
    // Respond to connection failure callback
  }

  void _onEthSignTrasaction(id, tx) {
    log("onEthSignTransaction: $id, $tx");
    // Respond to eth_signTransaction request callback
  }

  void _onEthSendTransaction(id, tx) {
    log("onEthSendTransaction: $id, $tx");
    // Respond to eth_sendTransaction request callback
  }

  void _onEthSign(dynamic id, WCEthereumSignMessage message) async {
    final decoded = (message.type == WCSignType.TYPED_MESSAGE)
        ? message.data!
        : ascii.decode(hexToBytes(message.data!));

    log("message to sign: $decoded");

    showDialog(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: Column(
            children: [
              if (_client!.remotePeerMeta!.icons.isNotEmpty)
                Container(
                  height: 100.0,
                  width: 100.0,
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.network(_client!.remotePeerMeta!.icons.first),
                ),
              Text(
                _client!.remotePeerMeta!.name,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 8.0),
              child: const Text(
                'Sign Message',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: const Text(
                    'Message',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  children: [
                    Text(
                      decoded,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () async {
                      String signedDataHex;
                      if (message.type == WCSignType.TYPED_MESSAGE) {
                        throw "not implemented yet";
                      } else {
                        final hash =
                            await api.messageToHash(message: message.data!);
                        signedDataHex =
                            await _sign(decoded, hash).then((s) => s!);

                        log("Signed Data hex: $signedDataHex");

                        _client?.approveRequest(id: id, result: signedDataHex);
                        
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('SIGN'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      _client?.rejectRequest(id: id);
                      Navigator.pop(context);
                    },
                    child: Text('REJECT'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _onSessionRequest(id, peerMeta) async {
    final address = await OfflineSigner.create(
            await rootBundle.loadString("assets/owner-keystore.json"),
            await rootBundle.loadString("assets/shareable-keystore.json"))
        .then((signer) => signer.ethereumAddress);

    final approvedAddresses = await showDialog<List<String>>(
      context: context,
      builder: (_) {
        return SimpleDialog(
          title: Column(
            children: [
              if (peerMeta.icons.isNotEmpty)
                Container(
                  height: 100.0,
                  width: 100.0,
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Image.network(peerMeta.icons.first),
                ),
              Text(peerMeta.name),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
          children: [
            if (peerMeta.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(peerMeta.description),
              ),
            if (peerMeta.url.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Connection to ${peerMeta.url}'),
              ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () async {
                      setState(() {
                        _store = _client?.sessionStore;
                      });
                      Navigator.pop(context, [address]);
                    },
                    child: const Text('APPROVE'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      Navigator.pop(context, []);
                    },
                    child: const Text('REJECT'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (approvedAddresses != null) {
      _client?.approveSession(
        accounts: approvedAddresses,
        chainId: 137,
      );

      setState(() {
        _peer = peerMeta;
      });
    } else {
      _client?.rejectSession();
    }
  }

  @override
  void dispose() {
    api.connectLogger().listen((event) {
      log("Rust log: $event");
    });

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("WalletConnect V1"),
        // backgroundColor: Colors.transparent,
        // shadowColor: Colors.transparent,
        // actions: [
        // AppBarAction(child: const Icon(Icons.close), onTap: () {}),
        // ],
      ),
      body: Stack(
        children: [
          _session == null
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: (Column(
                    children: [
                      const Spacer(flex: 1),
                      const Icon(Icons.add_link, size: 48, color: Colors.grey),
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
                            style: Theme.of(context).textTheme.bodyText1,
                            onChanged: (value) => setState(() {
                              _connectionUrl = value;
                            }),
                          )),
                          const SizedBox(width: 10),
                          ElevatedButton(
                              onPressed: () {
                                _connect();
                              },
                              child: Row(children: const [
                                Icon(Icons.cast_connected),
                                Text("Connect")
                              ])),
                        ],
                      ),
                      const Spacer(flex: 2),
                    ],
                  )),
                )
              : const Center(
                  child: Text("Interaction by WalletConnect protocol")),
          _session != null
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: FloatingActionButton(
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
              : Column(
                  children: [],
                )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 45.0),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Scan QR",
        child: const Icon(Icons.qr_code_scanner),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRScanner()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<String?> _sign(String message, String hash) async {
    Completer<String?> signJoinHandle = Completer();
    _apiSign() async {
      final signature = await OfflineSigner.create(
              await rootBundle.loadString("assets/owner-keystore.json"),
              await rootBundle.loadString("assets/shareable-keystore.json"))
          .then((signer) => signer.sign(hash));

      return api.toEthereumSignature(
          message: message, signature: signature, chain: 137);
    }

    _apiSign().then((signature) {
      signJoinHandle.complete(signature);
    }).catchError((e) {
      signJoinHandle.completeError(e);
    });

    return showDialog<String>(
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
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: const Text("Cancel"))
                  ],
                ),
              ]);
        });
  }
}
