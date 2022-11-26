// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tookey/ffi.dart';
import 'package:tookey/services/executor.dart';
import 'package:tookey/services/room_client.dart';

part 'signer.g.dart';

abstract class AbstractSigner {
  AbstractSigner._internal(this.key);

  final String key;
  late String _ethereumAddress;

  String get ethereumAddress => _ethereumAddress;

  @mustCallSuper
  Future<void> initialize() async {
    _ethereumAddress = await api.toEthereumAddress(key: key);
  }

  Future<String> sign(String hash);
}

class OfflineSigner extends AbstractSigner {
  OfflineSigner._internal(
    super.key,
    this.ownerKey,
    this.ownerExecutor,
    this.shareableExecutor,
  ) : super._internal();

  final String ownerKey;
  final Executor ownerExecutor;
  final Executor shareableExecutor;

  static Future<OfflineSigner> create(
    String ownerKey,
    String shareableKey,
  ) async {
    final ownerExecutor = await Executor.create();
    final shareableExecutor = await Executor.create();

    log('Executors: ${ownerExecutor.id} ${shareableExecutor.id}');

    final signer = OfflineSigner._internal(
      ownerKey,
      shareableKey,
      ownerExecutor,
      shareableExecutor,
    );

    await signer.initialize();

    return signer;
  }

  @override
  Future<String> sign(String hash) async {
    final signature = Completer<String>();

    StreamSubscription<OutgoingMessage> connect(
      Executor from,
      Executor to,
      int index,
      String key,
    ) {
      return from.messages.listen((OutgoingMessage outgoing) async {
        if (outgoing is OutgoingMessage_Ready) {
          // begin sign
          await from.send(
            IncomingMessage.begin(
              scenario: TookeyScenarios.signEcdsa(
                parties: Uint16List.fromList([2, 1]),
                key: key,
                hash: hash,
              ),
            ),
          );
        }

        if (outgoing is OutgoingMessage_Communication) {
          log('[${from.id}] Send communication to ${to.id}');
          await to.send(IncomingMessage.communication(packet: outgoing.packet));
        }

        if (outgoing is OutgoingMessage_Result) {
          log('[${from.id}] Executor is done (${outgoing.encoded})');
          signature.complete(outgoing.encoded);
        }
      });
    }

    connect(ownerExecutor, shareableExecutor, 1, ownerKey);
    connect(shareableExecutor, ownerExecutor, 2, key);

    return signature.future;
  }
}

class Signer extends AbstractSigner {
  Signer._internal(String key, this.executor, this.client)
      : super._internal(key) {
    party = KeySecret.fromJsonString(key).i;
  }
  final Executor executor;
  final RoomClient client;

  late int party;
  Uint16List? participants;

  static Future<Signer> create(
    String managerUrl,
    String localShare,
    String room,
  ) async {
    final executor = await Executor.create();
    final client = await RoomClient.connect(managerUrl, room);
    return Signer._internal(localShare, executor, client);
  }

  @override
  Future<String> sign(String hash) async {
    final signature = Completer<String>();

    client.messages?.listen(
      (event) async {
        if (signature.isCompleted) throw Exception('Signature is ready');

        await executor.send(IncomingMessage.communication(packet: event));
      },
      onDone: () {
        signature.completeError('client closed before result');
      },
      onError: (dynamic e) {
        signature.completeError(e.toString());
      },
      cancelOnError: true,
    );

    executor.messages.listen(
      (outgoing) async {
        log('Outgoin: ${outgoing.runtimeType.toString()}');

        if (outgoing is OutgoingMessage_Ready) {
          await executor.send(
            IncomingMessage_Begin(
              scenario: TookeyScenarios.signEcdsa(
                parties: Uint16List.fromList([1, 2]),
                key: key,
                hash: hash,
              ),
            ),
          );
        }

        if (outgoing is OutgoingMessage_Communication) {
          log('[${executor.id}] Send communication: ${outgoing.packet}');
          await client.broadcast(outgoing.packet);
        }

        if (outgoing is OutgoingMessage_Result) {
          log('[${executor.id}] Executor is done (${outgoing.encoded})');
          signature.complete(outgoing.encoded);
        }
      },
      onDone: () {
        signature.completeError('closed before result');
      },
      onError: (dynamic e) {
        signature.completeError(e.toString());
      },
      cancelOnError: true,
    );

    return signature.future;
  }
}

@JsonSerializable()
class KeySecret {
  KeySecret(
    this.paillier_dk,
    this.pk_vec,
    this.keys_linear,
    this.paillier_key_vec,
    this.y_sum_s,
    this.h1_h2_n_tilde_vec,
    this.vss_scheme,
    this.i,
    this.t,
    this.n,
  );

  factory KeySecret.fromJson(Map<String, dynamic> json) =>
      _$KeySecretFromJson(json);

  factory KeySecret.fromJsonString(String jsonString) =>
      _$KeySecretFromJson(jsonDecode(jsonString) as Map<String, dynamic>);

  final dynamic paillier_dk;
  final dynamic pk_vec;
  final dynamic keys_linear;
  final dynamic paillier_key_vec;
  final dynamic y_sum_s;
  final dynamic h1_h2_n_tilde_vec;
  final dynamic vss_scheme;
  final int i;
  final int t;
  final int n;

  Map<String, dynamic> toJson() => _$KeySecretToJson(this);
}
