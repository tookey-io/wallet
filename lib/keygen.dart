import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_rust_bridge_template/client.dart';
import 'package:flutter_rust_bridge_template/executor.dart';
import 'ffi.dart';

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

// class OfflineSigner extends AbstractSigner {
//   final String ownerKey;

//   final Executor ownerExecutor;
//   final Executor shareableExecutor;

//   OfflineSigner._internal(
//       String key, this.ownerKey, this.ownerExecutor, this.shareableExecutor)
//       : super._internal(key);

//   static Future<OfflineSigner> create(
//       String ownerKey, String shareableKey) async {
//     final ownerExecutor = await Executor.create();
//     final shareableExecutor = await Executor.create();
//     log("Executors: ${ownerExecutor.id} ${shareableExecutor.id}");

//     final signer = OfflineSigner._internal(
//         ownerKey, shareableKey, ownerExecutor, shareableExecutor);

//     await signer.initialize();

//     return signer;
//   }

//   @override
//   Future<String> sign(String hash) async {
//     Completer<String> signature = Completer();

//     connect(Executor from, Executor to, int index, String key) =>
//         from.messages.listen((OutgoingMessage outgoing) async {
//           if (outgoing is OutgoingMessage_Ready) {
//             // begin sign
//             await from.send(IncomingMessage.begin(
//                 scenario: TookeyScenarios.signEcdsa(
//                     parties: Uint16List.fromList([2, 1]),
//                     key: key,
//                     hash: hash)));
//           }

//           if (outgoing is OutgoingMessage_Communication) {
//             log("[${from.id}] Send communication to ${to.id}");
//             await to
//                 .send(IncomingMessage.communication(packet: outgoing.packet));
//           }

//           if (outgoing is OutgoingMessage_Result) {
//             log("[${from.id}] Executor is done (${outgoing.encoded})");
//             signature.complete(outgoing.encoded);
//           }
//         });

//     connect(ownerExecutor, shareableExecutor, 1, ownerKey);
//     connect(shareableExecutor, ownerExecutor, 2, key);

//     return await signature.future;
//   }
// }

// class Signer extends AbstractSigner {
//   final Executor executor;
//   final RoomClient client;

//   late int party;
//   Uint16List? participants;

//   Signer._internal(String key, this.executor, this.client)
//       : super._internal(key) {
//     party = jsonDecode(key)['i'] as int;
//   }

//   static Future<Signer> create(
//       String managerUrl, String localShare, String room) async {
//     var executor = await Executor.create();
//     var client = await RoomClient.connect(managerUrl, room);
//     return Signer._internal(localShare, executor, client);
//   }

//   @override
//   Future<String> sign(String hash) async {
//     Completer<String> signature = Completer();

//     client.messages.listen((event) async {
//       if (signature.isCompleted) {
//         throw "signature is ready";
//       }

//       await executor.send(IncomingMessage.communication(packet: event));
//     }, onDone: () {
//       signature.completeError("client closed before result");
//     }, onError: (e) {
//       signature.completeError(e);
//     }, cancelOnError: true);

//     executor.messages.listen((outgoing) async {
//       log("Outgoin: ${outgoing.runtimeType.toString()}");

//       if (outgoing is OutgoingMessage_Ready) {
//         await executor.send(IncomingMessage_Begin(
//             scenario: TookeyScenarios.signEcdsa(
//                 parties: Uint16List.fromList([2, 1]),
//                 key: key,
//                 hash: hash)));
//       }

//       if (outgoing is OutgoingMessage_Communication) {
//         log("[${executor.id}] Send communication: ${outgoing.packet}");
//         await client.broadcast(outgoing.packet);
//       }

//       if (outgoing is OutgoingMessage_Result) {
//         log("[${executor.id}] Executor is done (${outgoing.encoded})");
//         signature.complete(outgoing.encoded);
//       }
//     }, onDone: () {
//       signature.completeError("closed before result");
//     }, onError: (e) {
//       signature.completeError(e);
//     }, cancelOnError: true);

//     return signature.future;
//   }
// }
