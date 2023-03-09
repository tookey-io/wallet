import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tookey/widgets/details/fields/token_address.dart';
import 'package:tookey/widgets/details/fields/any_address.dart';
import 'package:tookey/widgets/details/method_call.dart';
import 'package:web3dart/web3dart.dart';

class MethodCallParameter<T> extends StatefulWidget {
  const MethodCallParameter({
    required this.call,
    required this.parameter,
    required this.data,
    super.key,
  });

  final MethodCall call;
  final FunctionParameter<T> parameter;
  final T data;

  @override
  State<MethodCallParameter<T>> createState() => _MethodCallParameterState<T>();
}

class _MethodCallParameterState<T> extends State<MethodCallParameter<T>> {
  bool _showHelp = false;
  bool _raw = false;

  @override
  Widget build(BuildContext context) {
    final meta = widget.parameter.meta ?? {};
    final name = widget.parameter.name;
    final data = widget.data;
    final description = meta['description'] as String?;
    final hasDescription = description != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text(
                widget.parameter.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (hasDescription)
                SizedBox(
                  width: 16,
                  height: 16,
                  child: IconButton(
                    padding: const EdgeInsets.all(2),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        _showHelp = !_showHelp;
                      });
                    },
                    icon: Icon(
                      _showHelp ? Icons.comments_disabled : Icons.comment,
                      // Icons.question_mark_rounded,
                      size: 12,
                    ),
                  ),
                ),
              SizedBox(
                width: 16,
                height: 16,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    setState(() {
                      _raw = !_raw;
                    });
                  },
                  icon: Icon(
                    _raw ? Icons.raw_off : Icons.raw_on,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasDescription && _showHelp)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              description,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        if (_raw)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.black),
              child: Text(
                widget.data.toString(),
                style: TextStyle(
                  fontSize: 9,
                  overflow: TextOverflow.ellipsis,
                  fontFamily: Platform.isIOS ? 'Courier' : 'monospace',
                ),
              ),
            ),
          )
        else
          Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _showSmartData())
      ],
    );
  }

  Widget _showSmartData() {
    final parameter = widget.parameter;
    final abi = parameter.type;
    final meta = parameter.meta;
    final kind = meta?['kind'];
    final data = widget.data;

    // addresses
    if (abi is AddressType && data is EthereumAddress) {
      if (kind == 'token') {
        // it is token!
        return TokenAddressParameter(
          call: widget.call,
          parameter: parameter,
          data: data,
        );
      }

      return AnyAddressParameter(
          call: widget.call,
          parameter: parameter,
          data: data,
      );
    }

    // if (abi is UintType && data is BigInt) {
    //   if (kind == 'tokenAmount') {
    //     return 
    //   }
    // }

    return Text(
        '${abi.runtimeType} ${parameter.runtimeType} ${data.runtimeType}');
  }
}
