import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tookey/state.dart';
import 'package:tookey/widgets/details/fields/types/token_info.dart';
import 'package:tookey/widgets/details/method_call.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';

class TokenAddressParameter extends StatefulWidget {
  const TokenAddressParameter({
    required this.call,
    required this.parameter,
    required this.data,
    super.key,
  });

  final MethodCall call;
  final FunctionParameter<dynamic> parameter;
  final EthereumAddress data;

  @override
  State<TokenAddressParameter> createState() => _TokenAddressParameterState();
}

class _TokenAddressParameterState extends State<TokenAddressParameter> {
  Future<TokenInfo?> _tokenInfoFuture = Future.value();
  String? _logoUri = '';
  String? _infoUri = '';

  @override
  void initState() {
    final state = Provider.of<AppState>(context, listen: false);
    final chainId = widget.call.chainId;
    final network = state.getNetwork(chainId);
    final infoUri = network.tokenInfoUrl(widget.data.hexEip55);
    final logoUri = network.tokenLogoUrl(widget.data.hexEip55);

    if (_logoUri != logoUri || _infoUri != infoUri) {
      _logoUri = logoUri;
      _infoUri = infoUri;
      _tokenInfoFuture = _getTokenInfo();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context, listen: false);
    return FutureBuilder<TokenInfo?>(
      future: _tokenInfoFuture,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (snapshot.error != null) {
          return Text(snapshot.error.toString());
        }
        if (data != null) {
          return Row(
            children: [
              if (data.logo != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Image.network(data.logo!),
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.symbol,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    data.name,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 16,
                height: 16,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  color: Theme.of(context).disabledColor,
                  onPressed: () async {
                    log(
                      '${widget.call.chainId} -> ${state.getNetwork(widget.call.chainId)}',
                    );
                    final uri = state
                        .getNetwork(widget.call.chainId)
                        .tokenExplorerUrl(widget.data.hexEip55);

                    log(uri.toString());

                    if (uri != null) {
                      await launchUrl(
                        Uri.parse(uri),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.open_in_new_rounded,
                    size: 16,
                  ),
                ),
              )
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const CircularProgressIndicator(),
            ],
          );
        }
      },
    );
  }

  Future<TokenInfo?> _getTokenInfo() async {
    if (_infoUri == null) {
      return null;
    }

    final tokenInfoJson =
        await http.get(Uri.parse(_infoUri!)).then((response) => response.body);

    final tokenInfo = TokenInfo.fromJsonString(tokenInfoJson)..logo = _logoUri;

    return tokenInfo;
  }
}
