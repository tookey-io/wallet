import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/widgets.dart';
import 'package:wallet_connect/wallet_connect.dart';

class MessageDetails extends StatefulWidget {
  const MessageDetails({super.key, required this.message});

  final WCEthereumSignMessage message;

  @override
  State<MessageDetails> createState() => _MessageDetailsState();
}

class _MessageDetailsState extends State<MessageDetails> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
