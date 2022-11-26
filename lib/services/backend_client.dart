import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tookey/services/http_client/http_client.dart';
import 'package:tookey/widgets/toaster.dart';

part 'backend_client.g.dart';

class BackendClient {
  BackendClient._create(String? baseUrl) {
    client = HttpClient(
      client: Dio(BaseOptions(baseUrl: baseUrl ?? '')),
      exceptionMapper: <T>(Response<T> response, exception) {
        final data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          if (response.statusCode == 403) {
            Toaster.error(data['message'] as String);
          }
          return BackendResponseException(
            message: data['message'] as String,
            exception: exception,
          );
        }
        return null;
      },
    );
  }

  late HttpClient client;

  static Future<BackendClient> create({String? baseUrl}) async {
    final component = BackendClient._create(baseUrl);
    return component;
  }

  Future<AuthTokens> signin(String apiKey) async {
    log('signin');

    final response = await client.post<Map<String, dynamic>>(
      '/api/auth/signin',
      options: Options(
        headers: {
          'accept': 'application/json',
          'apiKey': apiKey,
        },
      ),
    );

    return AuthTokens.fromJson(response.data!);
  }

  Future<List<KeyRecord>> fetchKeys(String? token) async {
    log('fetchKeys');

    final response = await client.get<Map<String, dynamic>>(
      '/api/keys',
      options: Options(
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    final keys = KeysList.fromJson(response.data!);
    return keys.items;
  }

  Future<KeyRecord> generateKey(
    String? token, {
    String? name,
    String? description,
  }) async {
    log('generateKey');

    final response = await client.post<Map<String, dynamic>>(
      '/api/keys',
      data: {
        'participantsThreshold': 2,
        'participantsCount': 3,
        'timeoutSeconds': 60,
        'name': name ?? '',
        'description': description ?? '',
        'tags': ['shareable']
      },
      options: Options(
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return KeyRecord.fromJson(response.data!);
  }

  Future<SignRecord?> signKey(
    String? token,
    String publicKey,
    String message,
    String hash, {
    Map<String, dynamic>? metadata,
  }) async {
    log('signKey');

    final response = await client.post<Map<String, dynamic>>(
      '/api/keys/sign',
      data: {
        'publicKey': publicKey,
        'data': hash,
        'participantsConfirmations': [1, 2],
        'metadata': metadata,
      },
      options: Options(
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return SignRecord.fromJson(response.data!);
  }
}

class BackendResponseException
    extends NetworkResponseException<Exception, dynamic> {
  BackendResponseException({
    required this.message,
    required super.exception,
  });

  final String message;
}

@JsonSerializable()
class AuthToken {
  AuthToken(
    this.token,
    this.validUntil,
  );

  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);

  factory AuthToken.fromJsonString(String jsonString) =>
      _$AuthTokenFromJson(jsonDecode(jsonString) as Map<String, dynamic>);

  final String token;
  final String validUntil;

  Map<String, dynamic> toJson() => _$AuthTokenToJson(this);

  @override
  String toString() => jsonEncode(toJson());
}

@JsonSerializable()
class AuthTokens {
  AuthTokens(
    this.access,
    this.refresh,
  );

  factory AuthTokens.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensFromJson(json);

  AuthToken access;
  AuthToken refresh;

  Map<String, dynamic> toJson() => _$AuthTokensToJson(this);
}

@JsonSerializable()
class KeyRecord {
  KeyRecord(
    this.id,
    this.roomId,
    this.participantsThreshold,
    this.timeoutSeconds,
    this.name,
    this.description,
    this.tags,
    this.participants,
    this.publicKey,
  );

  factory KeyRecord.fromJson(Map<String, dynamic> json) =>
      _$KeyRecordFromJson(json);

  final int id;
  final String roomId;
  final int participantsThreshold;
  final int timeoutSeconds;
  final String name;
  final String description;
  final List<String> tags;
  final List<int> participants;
  final String publicKey;

  Map<String, dynamic> toJson() => _$KeyRecordToJson(this);
}

@JsonSerializable()
class KeysList {
  KeysList(
    this.items,
  );

  factory KeysList.fromJson(Map<String, dynamic> json) =>
      _$KeysListFromJson(json);

  List<KeyRecord> items;

  Map<String, dynamic> toJson() => _$KeysListToJson(this);
}

@JsonSerializable()
class SignRecord {
  SignRecord(
    this.id,
    this.roomId,
    this.participantsConfirmations,
    this.data,
    this.metadata,
  );

  factory SignRecord.fromJson(Map<String, dynamic> json) =>
      _$SignRecordFromJson(json);

  final int id;
  final String roomId;
  final List<int> participantsConfirmations;
  final String data;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> toJson() => _$SignRecordToJson(this);
}
