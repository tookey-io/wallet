import 'dart:math';

import 'ffi.dart';

class ExecutorException implements Exception {
  String message;
  ExecutorException(this.message);
}

class ExecutorAlreadyInitialized extends ExecutorException {
  ExecutorAlreadyInitialized() : super("Already initialized");
}

class ExecutorIsNotInitialized extends ExecutorException {
  ExecutorIsNotInitialized() : super("Executor is not initialized yet");
}

class ExecutionMessage {
  final int sender;
  final int? receiver;
  final dynamic body;

  ExecutionMessage(this.sender, this.receiver, this.body);

  ExecutionMessage.fromJson(Map<String, dynamic> json)
      : sender = json['sender'],
        receiver = json['receiver'],
        body = json['body'];

  Map<String, dynamic> toJson() => {
        'sender': sender,
        'receiver': receiver,
        'body': body,
      };
}

class Executor {
  late final int id;
  late final Stream<OutgoingMessage> messages;

  Executor(this.id, this.messages);

  static Future<Executor> create() async {
    // TODO:
    // int id = await api.getNextId();
    var id = Random().nextInt(999);
    var messages = api.createOutgoingStream(id: id);
    return Executor(id, messages);
  }

  Future<void> send(IncomingMessage msg) {
    return api.sendIncoming(id: id, value: msg);
  }

  Future<OutgoingMessage> pool() {
    return messages.first;
  }
}
