import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tookey/widgets/details/method_call.dart';

class MethodSignature extends StatefulWidget {
  const MethodSignature({
    required this.call,
    super.key,
  });

  final MethodCall call;

  @override
  State<MethodSignature> createState() => _MethodSignatureState();
}

class _MethodSignatureState extends State<MethodSignature> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'Call ${widget.call.method.name}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        if (widget.call.method.docs.notice != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(widget.call.method.docs.notice!),
          ),
        if (widget.call.method.docs.dev != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ExpansionTile(
              title: const Text('Dev notice'),
              children: [Text(widget.call.method.docs.dev!)],
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Colors.black),
            child: Text(
              widget.call.method.encodeName(),
              style: TextStyle(
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
                fontFamily: Platform.isIOS ? 'Courier' : 'monospace',
              ),
            ),
          ),
        )
      ],
    );
  }
}
