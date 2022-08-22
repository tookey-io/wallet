import 'dart:developer';
import 'dart:math' as math;
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
  final Map<String, dynamic> body;

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
    int id = await api.getNextId();
    var messages = api.initialize(id: id);
    return Executor(id, messages);
  }

  Future<void> send(IncomingMessage msg) {
    log("[$id]: Send incoming message: ${msg.runtimeType.toString()}");
    return api.receive(id: id, value: msg);
  }

  Future<OutgoingMessage> pool() {
    return messages.first;
  }
}
