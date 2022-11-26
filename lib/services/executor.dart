import 'dart:convert';
import 'dart:developer';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tookey/ffi.dart';

part 'executor.g.dart';

class Executor {
  Executor(this.id, this.messages);

  late final int id;
  late final Stream<OutgoingMessage> messages;

  static Future<Executor> create() async {
    final id = await api.getNextId();
    final messages = api.initialize(id: id);
    return Executor(id, messages);
  }

  Future<void> send(IncomingMessage msg) {
    log('[$id]: Send incoming message: ${msg.runtimeType.toString()}');
    return api.receive(id: id, value: msg);
  }

  Future<OutgoingMessage> pool() {
    return messages.first;
  }
}

class ExecutorException implements Exception {
  ExecutorException(this.message);
  String message;
}

class ExecutorAlreadyInitialized extends ExecutorException {
  ExecutorAlreadyInitialized() : super('Already initialized');
}

class ExecutorIsNotInitialized extends ExecutorException {
  ExecutorIsNotInitialized() : super('Executor is not initialized yet');
}

@JsonSerializable()
class ExecutionMessage {
  ExecutionMessage(this.sender, this.receiver, this.body);

  factory ExecutionMessage.fromJson(Map<String, dynamic> json) =>
      _$ExecutionMessageFromJson(json);

  factory ExecutionMessage.fromJsonString(String jsonString) =>
      _$ExecutionMessageFromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );

  final int sender;
  final int? receiver;
  final Map<String, dynamic> body;

  Map<String, dynamic> toJson() => _$ExecutionMessageToJson(this);
}
