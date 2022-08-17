import 'dart:convert';

import 'package:flutter_rust_bridge_template/client.dart';
import 'package:flutter_rust_bridge_template/executor.dart';
import 'ffi.dart';

class Signer {
  final String localShare;
  final List<int> participants;
  final Executor executor;
  final RoomClient client;
  Signer._internal(this.executor, this.localShare, this.participants, this.client);

  static Future<Signer> create(String managerUrl, String localShare, {
    List<int>? participants,
    String room = "default-signing-offline"
  }) async {
    var executor = await Executor.create();
    var client = await RoomClient.connect(managerUrl, room);
    client.subscribe()?.listen((event) {
      executor.send(IncomingMessage.msg(event));
    });
    return Signer._internal(executor, localShare, participants ?? [1,2], client);
  }

  Future<String> sign(String hash) async {
    await for (final outgoing in executor.messages) {
      if (outgoing is OutgoingMessage_Msg) {
        ExecutionMessage msg = ExecutionMessage.fromJson(jsonDecode(outgoing.field0));
      }
    }
    return "Hi";
  }
}