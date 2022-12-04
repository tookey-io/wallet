import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tookey/services/http_client/http_client.dart';

part 'backend_client.g.dart';

class BackendClient {
  BackendClient._create({
    String? baseUrl,
    AuthToken? refreshToken,
  }) {
    _refreshToken = refreshToken;
    final dio =
        Dio(BaseOptions(baseUrl: baseUrl ?? '', followRedirects: false));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (
          RequestOptions options,
          RequestInterceptorHandler handler,
        ) async {
          if (options.headers['withAuthorization'] == null) {
            return handler.next(options);
          }

          options.headers.remove('withAuthorization');

          if (_accessToken != null) {
            options.headers['Authorization'] = 'Bearer ${_accessToken!.token}';
          }
          return handler.next(options);
        },
        onError: (DioError e, ErrorInterceptorHandler handler) async {
          final options = e.requestOptions;

          if (e.response?.statusCode == 401) {
            if (options.headers['apiKey'] != null) return handler.next(e);
            await refreshAccessToken();

            options.headers['Authorization'] = 'Bearer ${_accessToken!.token}';

            return await client
                ?.request<dynamic>(
                  options.path,
                  options: Options(
                    method: options.method,
                    headers: options.headers,
                  ),
                  onReceiveProgress: options.onReceiveProgress,
                  data: options.data,
                  queryParameters: options.queryParameters,
                )
                .then((response) => handler.resolve(response))
                .catchError((_) => handler.next(e));
          }

          handler.next(e);
        },
      ),
    );

    client = HttpClient(
      client: dio,
      exceptionMapper: <T>(Response<T> response, exception) {
        final data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          return BackendException(
            message: data['message'] as String,
            exception: exception,
          );
        }
        return null;
      },
    );
  }

  HttpClient? client;
  AuthToken? _accessToken;
  AuthToken? _refreshToken;

  static Future<BackendClient> create({
    String? baseUrl,
    AuthToken? refreshToken,
  }) async {
    final component = BackendClient._create(
      baseUrl: baseUrl,
      refreshToken: refreshToken,
    );
    return component;
  }

  Future<void> refreshAccessToken() async {
    final response = await client!.post<Map<String, dynamic>>(
      '/api/auth/refresh',
      options: Options(
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer ${_refreshToken!.token}',
        },
      ),
    );

    _accessToken = AuthToken.fromJson(response.data!);

    log('refreshAccessToken ${_accessToken!.token}');
  }

  Future<AuthToken> signin(String apiKey) async {
    log('signin');

    final response = await client!.post<Map<String, dynamic>>(
      '/api/auth/signin',
      options: Options(
        headers: {
          'accept': 'application/json',
          'apiKey': apiKey,
        },
      ),
    );

    final authTokens = AuthTokens.fromJson(response.data!);
    _accessToken = authTokens.access;
    _refreshToken = authTokens.refresh;

    return authTokens.refresh;
  }

  Future<List<KeyRecord>> fetchKeys() async {
    log('fetchKeys');

    final response = await client!.get<Map<String, dynamic>>(
      '/api/keys',
      options: Options(
        headers: {
          'accept': 'application/json',
          'withAuthorization': true,
        },
      ),
    );

    final keys = KeysList.fromJson(response.data!);
    return keys.items;
  }

  Future<KeyRecord> generateKey({
    String? name,
    String? description,
  }) async {
    log('generateKey');

    final response = await client!.post<Map<String, dynamic>>(
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
          'withAuthorization': true,
        },
      ),
    );

    return KeyRecord.fromJson(response.data!);
  }

  Future<SignRecord?> signKey(
    String publicKey,
    String message,
    String hash, {
    Map<String, dynamic>? metadata,
  }) async {
    log('signKey');

    final response = await client!.post<Map<String, dynamic>>(
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
          'withAuthorization': true,
        },
      ),
    );

    return SignRecord.fromJson(response.data!);
  }
}

class BackendException extends NetworkResponseException<Exception, dynamic> {
  BackendException({
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
