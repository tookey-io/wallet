import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tookey/models/key_session.dart';
import 'package:tookey/pages/key/key.card.dart';
import 'package:tookey/pages/wallet_connect/wallet_connect_session.dialog.dart';
import 'package:tookey/pages/wallet_connect/wallet_connect_sign.dialog.dart';
import 'package:tookey/services/backend_client.dart';
import 'package:tookey/state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet_connect/utils/hex.dart';
import 'package:wallet_connect/wallet_connect.dart';

enum KeyAction { diconnect, share, remove }

enum EventLogType { success, danger, warning, info }

class EventLog {
  const EventLog(this.value, {this.type});
  final String value;
  final EventLogType? type;
}

class WalletConnectPage extends StatefulWidget {
  const WalletConnectPage({
    super.key,
    required this.keyRecord,
    this.connectionUrl,
    this.sessionStore,
  });

  final String? connectionUrl;
  final WCSessionStore? sessionStore;
  final KeyRecord keyRecord;

  @override
  State<WalletConnectPage> createState() => _WalletConnectPageState();
}

class _WalletConnectPageState extends State<WalletConnectPage> {
  WCSession? _wcSession;
  WCSessionStore? _wcSessionStore;

  late WCClient _wcClient = WCClient(
    onConnect: _onConnect,
    onDisconnect: _onDisconnect,
    onFailure: _onFailure,
    onSessionRequest: _onSessionRequest,
    onEthSign: _onEthSign,
    onEthSendTransaction: _onEthSendTransaction,
    onEthSignTransaction: _onEthSignTrasaction,
  );

  Completer<String> signJoinHandle = Completer<String>();
  bool isExecuting = false;

  List<EventLog> wcLog = [];

  final walletMeta = WCPeerMeta(
    name: '2K Signer',
    url: 'https://tookey.io',
    description: 'Official Tookey Signer application',
    icons: [],
  );

  @override
  void initState() {
    log('initState \nconnection url: ${widget.connectionUrl} \nstore: ${widget.sessionStore?.toString()} \nclient: ${_wcClient.toString()}');
    logEvent('Initializing ...', type: EventLogType.info);

    super.initState();

    if (widget.connectionUrl != null) {
      _wcSession = WCSession.from(widget.connectionUrl!);
    }

    _wcClient = WCClient(
      onConnect: _onConnect,
      onDisconnect: _onDisconnect,
      onFailure: _onFailure,
      onSessionRequest: _onSessionRequest,
      onEthSign: _onEthSign,
      onEthSendTransaction: _onEthSendTransaction,
      onEthSignTransaction: _onEthSignTrasaction,
    );
    _wcSessionStore = widget.sessionStore;

    if (_wcSessionStore != null) {
      _wcClient.connectFromSessionStore(_wcSessionStore!);
    } else if (_wcSession != null && _wcSession != WCSession.empty()) {
      _wcClient.connectNewSession(session: _wcSession!, peerMeta: walletMeta);
    } else {
      Navigator.pop(context);
    }
  }

  void logEvent(String value, {EventLogType? type}) {
    log('wcLog: $value');
    setState(() {
      wcLog.add(EventLog(value, type: type));
    });
  }

  void _onConnect() {
    log('onConnect');
  }

  Future<void> _disconnect() async {
    log('_disconnect, $mounted');

    await _wcClient.killSession();

    // JUST UPDATE
    setState(() {});
  }

  void _onDisconnect(int? code, String? reason) {
    log('onDisconnect: $code, $reason, $mounted');

    if (!mounted) return;
    final state = Provider.of<AppState>(context, listen: false);
    setState(() {
      if (_wcSessionStore != null) {
        // ignore: lines_longer_than_80_chars
        log('remove session: ${_wcSessionStore.toString()} ${widget.keyRecord.publicKey}');
        state.removeSession(
          KeySession(
            store: _wcSessionStore!,
            publicKey: widget.keyRecord.publicKey,
          ),
        );
      }
      _wcSession = null;
      _wcSessionStore = null;
    });
    logEvent('Disonnected', type: EventLogType.info);
    Navigator.pop(context);
  }

  void _onFailure(dynamic error) {
    log('onFailure: $error');
    logEvent('Failure: $error', type: EventLogType.danger);

    if (!mounted) return;
    setState(() {
      _wcSession = null;
      _wcSessionStore = null;
    });
  }

  Future<void> _approveTransactionDialog(int id, WCEthereumTransaction tx) {
    logEvent('from: ${tx.from}');
    if (tx.to != null) logEvent('to: ${tx.to}');
    if (tx.nonce != null) logEvent('nonce: ${tx.nonce}');
    if (tx.gasPrice != null) logEvent('gasPrice: ${tx.gasPrice}');
    if (tx.maxFeePerGas != null) logEvent('maxFeePerGas: ${tx.maxFeePerGas}');
    if (tx.maxPriorityFeePerGas != null) {
      logEvent('maxPriorityFeePerGas: ${tx.maxPriorityFeePerGas}');
    }
    if (tx.gas != null) logEvent('gas: ${tx.gas}');
    if (tx.gasLimit != null) logEvent('gasLimit: ${tx.gasLimit}');
    if (tx.value != null) logEvent('value: ${tx.value}');
    if (tx.data != null) logEvent('data: ${tx.data}');

    if (_wcSessionStore == null) {
      return Future.value();
    }

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WalletConnectSignDialog(
          title: _wcClient.remotePeerMeta!.name,
          icon: _wcClient.remotePeerMeta!.icons.first,
          tx: tx,
          data: tx.data,
          metadata: _wcSessionStore?.remotePeerMeta.toJson(),
          onSign: ({result}) {
            if (result != null) {
              _wcClient.approveRequest(id: id, result: result);
              logEvent(
                '[$id] Transaction approved',
                type: EventLogType.success,
              );
            } else {
              _wcClient.rejectRequest(id: id);
              logEvent(
                '[$id] Transaction failed',
                type: EventLogType.danger,
              );
            }

            if (mounted) Navigator.pop(context);
          },
          onReject: () {
            _wcClient.rejectRequest(id: id);
            logEvent('[$id] Transaction rejected', type: EventLogType.danger);
            Navigator.pop(context);
          },
          chainId: _wcSessionStore!.chainId,
        );
      },
    );
  }

  void _onEthSignTrasaction(int id, WCEthereumTransaction tx) {
    log('onEthSignTransaction: $id, $tx');
    logEvent('[$id] Sign transaction request', type: EventLogType.warning);

    _approveTransactionDialog(id, tx);
  }

  void _onEthSendTransaction(int id, WCEthereumTransaction tx) {
    log('onEthSendTransaction: $id, $tx');
    logEvent('[$id] Send transaction request', type: EventLogType.warning);

    _approveTransactionDialog(id, tx);
  }

  Future<void> _onEthSign(int id, WCEthereumSignMessage message) async {
    log('_onEthSign: $message');
    logEvent('[$id] Sign message', type: EventLogType.warning);
    logEvent('raw: ${message.raw}');
    logEvent('type: ${message.type}');

    final decoded = (message.type == WCSignType.TYPED_MESSAGE)
        ? message.data!
        : ascii.decode(hexToBytes(message.data!));

    if (_wcSessionStore == null) {
      return;
    }

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WalletConnectSignDialog(
          title: _wcClient.remotePeerMeta!.name,
          icon: _wcClient.remotePeerMeta!.icons.first,
          message: message,
          data: decoded,
          metadata: _wcSessionStore?.remotePeerMeta.toJson(),
          onSign: ({result}) {
            // if (message.type == WCSignType.TYPED_MESSAGE) {
            //   throw 'Not implemented yet';
            // }

            if (result != null) {
              _wcClient.approveRequest(id: id, result: result);
            }

            if (mounted) Navigator.pop(context);
          },
          onReject: () {
            _wcClient.rejectRequest(id: id);
            Navigator.pop(context);
          },
          chainId: _wcSessionStore!.chainId,
        );
      },
    );
  }

  Future<void> _onSessionRequest(int id, WCPeerMeta peerMeta) async {
    log('_onSessionRequest');
    logEvent('[$id] Connection', type: EventLogType.warning);
    logEvent('url: ${peerMeta.url}');
    logEvent('name: ${peerMeta.name}');
    logEvent('description: ${peerMeta.description}');

    final state = Provider.of<AppState>(context, listen: false);

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return WalletConnectSessionDialog(
          peerMeta: peerMeta,
          onApprove: (chainId) async {
            final address = await state.getShareableAddress();
            if (address != null) {
              _wcClient.approveSession(
                accounts: [address],
                chainId: chainId,
              );

              setState(() {
                _wcSessionStore = _wcClient.sessionStore;
                if (_wcSessionStore != null) {
                  // ignore: lines_longer_than_80_chars
                  log('save session: ${_wcSessionStore.toString()} ${widget.keyRecord.publicKey}');
                  state.saveSession(
                    KeySession(
                      store: _wcSessionStore!,
                      publicKey: widget.keyRecord.publicKey,
                    ),
                  );
                }
              });

              logEvent('[$id] Connection approved', type: EventLogType.success);
            }

            if (mounted) Navigator.pop(ctx);
          },
          onReject: () {
            _wcClient.rejectSession();
            logEvent('[$id] Connection rejected', type: EventLogType.danger);
            Navigator.pop(ctx);
            _disconnect();
          },
        );
      },
    );
  }

  Color? getEventLogColor(EventLogType? type) {
    if (type == EventLogType.success) return Colors.green;
    if (type == EventLogType.danger) return Colors.red;
    if (type == EventLogType.warning) return Colors.orange;
    if (type == EventLogType.info) return Colors.blue;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, child) {
        final network = _wcSessionStore != null
            ? state.getNetwork(_wcSessionStore!.chainId)
            : null;
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.keyRecord.name),
            leading: BackButton(
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
            child: Column(
              children: [
                KeyCard(keyRecord: widget.keyRecord),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      if (_wcSessionStore != null)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Image.network(
                                _wcSessionStore!.remotePeerMeta.icons.first,
                                width: 24,
                                height: 24,
                              ),
                            ),
                            Text(
                              _wcSessionStore!.remotePeerMeta.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      if (_wcSessionStore != null)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            _wcSessionStore!.remotePeerMeta.description,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (_wcSessionStore != null)
                            TextButton(
                              onPressed: () async {
                                await launchUrl(
                                  Uri.parse(
                                    _wcSessionStore!.remotePeerMeta.url,
                                  ),
                                );
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.explore),
                                  Text(' Website'),
                                ],
                              ),
                            ),
                          if (network != null && network.website != null)
                            TextButton(
                              onPressed: () async {
                                await launchUrl(
                                  Uri.parse(
                                    network.website!,
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  if (network.logo != null)
                                    Image.network(
                                      network.logo!,
                                      width: 24,
                                      height: 24,
                                    ),
                                  Text(' ${network.name}'),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Ink(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        ...wcLog.map((e) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(
                                       vertical: 2,
                                     ),
                                  child: Icon(
                                    Icons.circle,
                                    size: 9,
                                    color: getEventLogColor(e.type),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    e.value,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: Platform.isIOS
                                          ? 'Courier'
                                          : 'monospace',
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          // body: Padding(
          //   padding: const EdgeInsets.all(20),
          //   child:
          // ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Container(height: 45),
          ),
          floatingActionButton: FloatingActionButton(
            heroTag: 'wc-disconnect',
            backgroundColor: Colors.grey,
            onPressed: _disconnect,
            child: const Icon(Icons.exit_to_app_outlined),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
