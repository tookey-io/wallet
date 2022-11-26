import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart' as path;
import 'package:sse_client/sse_client.dart';
import 'package:tookey/services/backend_client.dart';
import 'package:tookey/services/http_client/http_client.dart';

part 'room_client.g.dart';

class RoomClient {
  RoomClient._internal(String relayUrl, this._room) {
    _baseUri = path.join(relayUrl, 'rooms', _room);
    client = HttpClient(
      client: Dio(BaseOptions(baseUrl: _baseUri)),
      exceptionMapper: <T>(Response<T> response, exception) {
        final data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          return BackendResponseException(
            message: data['message'] as String,
            exception: exception,
          );
        }
        return null;
      },
    );
    log(_baseUri);
  }

  late String _baseUri;
  final String _room;
  int id = -1;

  late HttpClient client;

  late Stream<String>? messages;

  static Future<RoomClient> connect(String relayUrl, String room) async {
    final client = RoomClient._internal(relayUrl, room);
    await client.subscribe();
    await client.issueIndex();
    return client;
  }

  Future<void> issueIndex() async {
    final response =
        await client.post<Map<String, dynamic>>('/issue_unique_idx');

    log('IssueIndex Response is $response');
    if (response.statusCode == 200) {
      id = UniqueIdx.fromJson(response.data!).id;
    } else {
      throw ClientException(
        'Failed with status: ${response.statusCode}. (${response.data!})',
      );
    }
  }

  Future<void> broadcast(String msg) async {
    final response = await client.post<String>(
      '/broadcast',
      data: jsonDecode(msg),
    );

    log('Broadcast Response is $response');
    if (response.statusCode != 200) {
      throw ClientException(
        'Failed with status: ${response.statusCode}. (${response.data!})',
      );
    }
  }

  Future<void> subscribe() async {
    final uri = Uri.parse(path.join(_baseUri, 'subscribe'));
    log('Connect to ${uri.toString()}');
    final sseClient = SseClient.connect(uri);

    if (sseClient.stream == null) {
      throw ClientException('Cannot find SSE stream');
    }

    messages = sseClient.stream!.map((event) => event.toString());

    // TODO(temadev): Rewrite SseClient to allow wait for response
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }
}

class ClientException implements Exception {
  ClientException(this.message);
  String message;
}

@JsonSerializable()
class UniqueIdx {
  UniqueIdx(this.id);

  factory UniqueIdx.fromJson(Map<String, dynamic> json) => UniqueIdx(
        json['unique_idx'] as int,
      );

  final int id;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
      };
}
