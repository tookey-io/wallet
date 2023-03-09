import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tookey/services/networks.dart';
import 'package:tookey/state.dart';
import 'package:tookey/widgets/details/fields/token_address.dart';
import 'package:tookey/widgets/details/fields/types/token_info.dart';
import 'package:tookey/widgets/details/method_call.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';

class ERC20Info {
  ERC20Info(this.name, this.symbol, this.decimals);

  final String name;
  final String symbol;
  final int decimals;
}

class AnyAddressParameter extends StatefulWidget {
  const AnyAddressParameter({
    required this.call,
    required this.parameter,
    required this.data,
    super.key,
  });

  final MethodCall call;
  final FunctionParameter<dynamic> parameter;
  final EthereumAddress data;

  @override
  State<AnyAddressParameter> createState() => _AnyAddressParameterState();
}

class _AnyAddressParameterState extends State<AnyAddressParameter> {
  Future<TokenInfo?> _tokenInfoFuture = Future.value();
  Future<bool> _isContractFuture = Future.delayed(
    const Duration(days: 100),
    () => false,
  );
  String? _tokenInfoUri = '';

  @override
  void didUpdateWidget(covariant AnyAddressParameter oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    final state = Provider.of<AppState>(context, listen: false);
    final chainId = widget.call.chainId;
    final network = state.getNetwork(chainId);
    final tokenInfoUri = network.tokenInfoUrl(widget.data.hexEip55);

    if (_tokenInfoUri != tokenInfoUri) {
      _tokenInfoUri = tokenInfoUri;
      _tokenInfoFuture = _getTokenInfo();
      _isContractFuture = _getIsContract(network);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TokenInfo?>(
      future: _tokenInfoFuture,
      builder: (context, tokenInfoSnapshot) {
        final tokenInfo = tokenInfoSnapshot.data;
        if (tokenInfoSnapshot.error != null) {
          // Just address
          return FutureBuilder<bool>(
            future: _isContractFuture,
            builder: (context, isContractSnapshot) {
              final isContract = isContractSnapshot.data;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      color: Theme.of(context).disabledColor,
                      onPressed: () async {
                        final uri = Provider.of<AppState>(context)
                            .getNetwork(widget.call.chainId)
                            .addressExplorerUrl(widget.data.hexEip55);

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
                  ),
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isContract != null && isContract
                              ? 'Smart Contract'
                              : 'Address',
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          widget.data.toString(),
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      color: Theme.of(context).disabledColor,
                      onPressed: () async {
                        final uri = Provider.of<AppState>(context)
                            .getNetwork(widget.call.chainId)
                            .addressExplorerUrl(widget.data.hexEip55);

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
            },
          );
        }
        if (tokenInfo != null) {
          return TokenAddressParameter(
            call: widget.call,
            parameter: widget.parameter,
            data: widget.data,
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
    if (_tokenInfoUri == null) {
      return null;
    }

    final tokenInfoJson = await http
        .get(Uri.parse(_tokenInfoUri!))
        .then((response) => response.body);

    final tokenInfo = TokenInfo.fromJsonString(tokenInfoJson);

    return tokenInfo;
  }

  Future<bool> _getIsContract(Network network) async {
    final web3 = Web3Client(network.rpc, http.Client());
    final code = await web3.getCode(widget.data);

    return code.isNotEmpty;
  }
}
