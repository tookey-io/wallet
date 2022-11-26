import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tookey/pages/wallet_connect/wallet_connect_session.dialog.dart';
import 'package:tookey/pages/wallet_connect/wallet_connect_sign.dialog.dart';
import 'package:wallet_connect/utils/hex.dart';
import 'package:wallet_connect/wallet_connect.dart';

enum KeyAction { diconnect, share, remove }

class WalletConnectPage extends StatefulWidget {
  const WalletConnectPage({
    super.key,
    required this.title,
    required this.connectionUrl,
  });

  final String title;
  final String connectionUrl;

  @override
  State<WalletConnectPage> createState() => _WalletConnectPageState();
}

class _WalletConnectPageState extends State<WalletConnectPage> {
  WCSession? _wcSession;
  WCSessionStore? _wcSessionStore;

  late WCClient? _wcClient = WCClient(
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

  final walletMeta = WCPeerMeta(
    name: '2K Signer',
    url: 'https://tookey.io',
    description: 'Official Tookey Signer application',
    icons: [],
  );

  @override
  void initState() {
    log('initState');

    super.initState();

    _wcClient = WCClient(
      onConnect: _onConnect,
      onDisconnect: _onDisconnect,
      onFailure: _onFailure,
      onSessionRequest: _onSessionRequest,
      onEthSign: _onEthSign,
      onEthSendTransaction: _onEthSendTransaction,
      onEthSignTransaction: _onEthSignTrasaction,
    );

    _wcSession = WCSession.from(widget.connectionUrl);

    if (_wcSessionStore != null) {
      _wcClient?.connectFromSessionStore(_wcSessionStore!);
    } else if (_wcSession != null) {
      _wcClient?.connectNewSession(session: _wcSession!, peerMeta: walletMeta);
    }
  }

  void _onConnect() {
    log('onConnect');
  }

  void _disconnect() {
    // _wcClient?.disconnect();
    _wcClient?.killSession();

    if (mounted) Navigator.pop(context);
  }

  void _onDisconnect(int? code, String? reason) {
    log('onDisconnect: $code, $reason');

    setState(() {
      _wcSession = null;
      _wcSessionStore = null;
    });
  }

  void _onFailure(dynamic error) {
    log('onFailure: $error');

    setState(() {
      _wcSession = null;
      _wcSessionStore = null;
    });
  }

  Future<void> _approveTransactionDialog(int id, WCEthereumTransaction tx) {
    return showDialog(
      context: context,
      builder: (context) {
        return WalletConnectSignDialog(
          title: _wcClient!.remotePeerMeta!.name,
          icon: _wcClient!.remotePeerMeta!.icons.first,
          message: tx.data!,
          metadata: _wcSessionStore?.remotePeerMeta.toJson(),
          onSign: ({result}) {
            if (result != null) {
              _wcClient?.approveRequest(id: id, result: result);
            }

            if (mounted) Navigator.pop(context);
          },
          onReject: () {
            _wcClient?.rejectRequest(id: id);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _onEthSignTrasaction(int id, WCEthereumTransaction tx) {
    log('onEthSignTransaction: $id, $tx');

    _approveTransactionDialog(id, tx);
  }

  void _onEthSendTransaction(int id, WCEthereumTransaction tx) {
    log('onEthSendTransaction: $id, $tx');

    _approveTransactionDialog(id, tx);
  }

  Future<void> _onEthSign(int id, WCEthereumSignMessage message) async {
    log('_onEthSign: $message');

    final decoded = (message.type == WCSignType.TYPED_MESSAGE)
        ? message.data!
        : ascii.decode(hexToBytes(message.data!));

    return showDialog(
      context: context,
      builder: (context) {
        return WalletConnectSignDialog(
          title: _wcClient!.remotePeerMeta!.name,
          icon: _wcClient!.remotePeerMeta!.icons.first,
          message: decoded,
          metadata: _wcSessionStore?.remotePeerMeta.toJson(),
          onSign: ({result}) {
            // if (message.type == WCSignType.TYPED_MESSAGE) {
            //   throw 'Not implemented yet';
            // }

            if (result != null) {
              _wcClient?.approveRequest(id: id, result: result);
            }

            if (mounted) Navigator.pop(context);
          },
          onReject: () {
            _wcClient?.rejectRequest(id: id);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _onSessionRequest(int id, WCPeerMeta peerMeta) async {
    log('_onSessionRequest');

    return showDialog(
      context: context,
      builder: (context) {
        return WalletConnectSessionDialog(
          peerMeta: peerMeta,
          onApprove: (state) async {
            setState(() {
              _wcSessionStore = _wcClient?.sessionStore;
            });

            final address = await state!.getShareableAddress();
            if (address != null) {
              _wcClient?.approveSession(accounts: [address], chainId: 97);
            }

            if (mounted) Navigator.pop(context);
          },
          onReject: () {
            _wcClient?.rejectSession();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    log('widget');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text('Interaction by WalletConnectPage protocol'),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 45),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'wc-disconnect',
        backgroundColor: Colors.redAccent,
        onPressed: _disconnect,
        child: const Icon(Icons.exit_to_app_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
