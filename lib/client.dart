import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:universal_html/html.dart' as html;

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:universal_html/html.dart' as html;
import 'package:path/path.dart' as path;
import 'package:sse_client/sse_client.dart';

class ClientException implements Exception {
  String message;
  ClientException(this.message);
}

class UniqueIdx {
  final int _idx;
  UniqueIdx(this._idx);

    int get id => _idx;

  UniqueIdx.fromJson(Map<String, dynamic> json) : _idx = json['unique_idx'];
}

class RoomClient {
  late String _baseUri;
  final String _room;
  int _id = -1;

  RoomClient._internal(String managerEndpoint, this._room) {
    _baseUri = path.join(managerEndpoint, "rooms", _room);
  }

  static Future<RoomClient> connect(String managerEndpoint, String room) async {
    var client = RoomClient._internal(managerEndpoint, room);
    await client.issueIndex();
    return client;
  }

  Future<void> issueIndex() async {
    var uri = Uri.parse(path.join(_baseUri, "issue_unique_idx"));

    log("Post ${uri.toString()}");

    var response = await http.post(uri);

    log("Response is $response");
    if (response.statusCode == 200) {
      _id = UniqueIdx.fromJson(jsonDecode(response.body)).id;
    } else {
      throw ClientException(
          'Request failed with status: ${response.statusCode}. (${response.body})');
    }
  }

  Stream<String>? subscribe() {
    var uri = Uri.parse(path.join(_baseUri, "subscribe"));
    log("Connect to ${uri.toString()}");
    var client = SseClient.connect(uri);

    return client.stream?.map((event) => event.toString());
  }

  Future<String> broadcast(String msg) async {
    var uri = Uri.parse(path.join(_baseUri, "broadcast"));

    var response = await http.post(uri, body: msg);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw ClientException(
          'Request failed with status: ${response.statusCode}. (${response.body})');
    }
  }
}
