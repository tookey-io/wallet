import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:tookey/ffi.dart';
import 'package:tookey/services/room_client.dart';
import 'package:tookey/services/executor.dart';

class Keygenerator {
  final int index;
  final Executor executor;
  final RoomClient client;
  Keygenerator._internal(this.index, this.executor, this.client);

  static Future<Keygenerator> create(
      int index, String managerUrl, String roomId) async {
    var executor = await Executor.create();
    var client = await RoomClient.connect(managerUrl, roomId);
    return Keygenerator._internal(index, executor, client);
  }

  Future<String> keygen() async {
    Completer<String> key = Completer();

    executor.messages.listen((outgoing) async {
      log("Outgoin: ${outgoing.runtimeType.toString()}");

      if (outgoing is OutgoingMessage_Issue) {
        log("[${executor.id}] Receive issue (${outgoing.code}: ${outgoing.message})");
        key.completeError("closed with issue");
      }

      if (outgoing is OutgoingMessage_Ready) {
        await Future.delayed(const Duration(milliseconds: 200));
        await executor.send(IncomingMessage_Begin(
            scenario: TookeyScenarios.keygenEcdsa(
                index: index, parties: 3, threashold: 1)));

        client.messages.listen((event) async {
          if (key.isCompleted) throw "key is ready";

          var json = jsonDecode(event);
          var sender = jsonDecode(event)["sender"];
          var receiver = jsonDecode(event)["receiver"];
          log("${client.id} receives ${json['body'].keys.join(" ")} from ${sender.toString()}");
          if (sender == client.id ||
              (receiver != null && receiver != client.id)) {
            log("ignore my message");
          } else {
            await executor.send(IncomingMessage.communication(packet: event));
          }
        }, onDone: () {
          key.completeError("client closed before result");
        }, onError: (e) {
          key.completeError(e);
        }, cancelOnError: true);
      }

      if (outgoing is OutgoingMessage_Communication) {
        log("[${executor.id}] Send communication");
        await client.broadcast(outgoing.packet);
      }

      if (outgoing is OutgoingMessage_Result) {
        log("[${executor.id}] Executor is done");
        key.complete(outgoing.encoded);
      }
    }, onDone: () {
      key.completeError("closed before result");
    }, onError: (e) {
      key.completeError(e);
    }, cancelOnError: true);

    return await key.future;
  }
}
