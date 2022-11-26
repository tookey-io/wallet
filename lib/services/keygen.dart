import 'dart:async';
import 'dart:developer';

import 'package:tookey/ffi.dart';
import 'package:tookey/services/executor.dart';
import 'package:tookey/services/room_client.dart';

class Keygen {
  Keygen._internal(this.index, this.executor, this.client);
  final int index;
  final Executor executor;
  final RoomClient client;

  static Future<Keygen> create(
    int index,
    String relayUrl,
    String roomId,
  ) async {
    final executor = await Executor.create();
    final client = await RoomClient.connect(relayUrl, roomId);
    return Keygen._internal(index, executor, client);
  }

  Future<String> keygen() async {
    final key = Completer<String>();

    executor.messages.listen(
      (outgoing) async {
        log('Outgoin: ${outgoing.runtimeType.toString()}');

        if (outgoing is OutgoingMessage_Issue) {
          log('[${executor.id}] Receive issue '
              '(${outgoing.code}: ${outgoing.message})');
          key.completeError('closed with issue');
        }

        if (outgoing is OutgoingMessage_Ready) {
          Future.delayed(const Duration(milliseconds: 200), () async {
            await executor.send(
              IncomingMessage_Begin(
                scenario: TookeyScenarios.keygenEcdsa(
                  index: index,
                  parties: 3,
                  threashold: 1,
                ),
              ),
            );

            client.messages?.listen(
              (event) async {
                if (key.isCompleted) {
                  log('key is ready');
                  return;
                }

                final message = ExecutionMessage.fromJsonString(event);
                final sender = message.sender;
                final receiver = message.receiver;
                log('${client.id} receives '
                    "${message.body.keys.join(' ')} from ${sender.toString()}");
                if (sender == client.id ||
                    (receiver != null && receiver != client.id)) {
                  log('ignore my message');
                } else {
                  await executor
                      .send(IncomingMessage.communication(packet: event));
                }
              },
              onDone: () {
                key.completeError('client closed before result');
              },
              onError: (dynamic e) {
                key.completeError(e.toString());
              },
              cancelOnError: true,
            );
          });
        }

        if (outgoing is OutgoingMessage_Communication) {
          log('[${executor.id}] Send communication');
          await client.broadcast(outgoing.packet);
        }

        if (outgoing is OutgoingMessage_Result) {
          log('[${executor.id}] Executor is done');
          key.complete(outgoing.encoded);
        }
      },
      onDone: () {
        key.completeError('closed before result');
      },
      onError: (dynamic e) {
        key.completeError(e.toString());
      },
      cancelOnError: true,
    );

    return key.future;
  }
}
