import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rust_bridge_template/sign.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'ffi.dart';
import 'keygen.dart';

_keysList() => "storage:KEYS";
_key(String id) => "storage:KEY:$id";
_keyAdmin(String id) => "storage:KEY:ADMIN:$id";
_accessTokenStorage() => "storage:TOKEN:ACCESS";
_refreshTokenStorage() => "storage:TOKEN:REFRESH";

extension IsOk on http.Response {
  bool get ok {
    return (statusCode ~/ 100) == 2;
  }
}

class AuthToken {
  final String token;
  final String validUntil;

  AuthToken(this.token, this.validUntil);

  AuthToken.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        validUntil = json['validUntil'];

  Map<String, dynamic> toJson() => {
        'token': token,
        'validUntil': validUntil,
      };

  @override
  String toString() => jsonEncode(toJson());
}

class Keystore {
  String publicKey;
  String adminKey;
  String shareableKey;

  Keystore(this.publicKey, this.shareableKey, this.adminKey);
}

class KeyRecord {
  final int id;
  final String roomId;
  final int threshold;
  final int parties;
  final String name;
  final String description;
  final List<String> tags;
  final String publicKey;

  KeyRecord(this.id, this.roomId, this.threshold, this.parties, this.name,
      this.description, this.tags, this.publicKey);

  KeyRecord.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        roomId = json['roomId'],
        threshold = json['participantsThreshold'],
        parties = json['parties'] ?? 3,
        name = json['name'],
        description = json['description'],
        tags =
            (json['tags'] as List<dynamic>).map((e) => e.toString()).toList(),
        publicKey = json['publicKey'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'roomId': roomId,
        'participantsThreshold': threshold,
        'parties': parties,
        'name': name,
        'description': description,
        'tags': tags,
        'publicKey': publicKey,
      };
}

class AppState extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  AuthToken? _accessToken;
  AuthToken? _refreshToken;
  String? _shareableKey;
  String? _ownerKey;
  final Set<String> _secretKeys = {};
  final HashMap<String, KeyRecord> _knownKeys = HashMap();
  final String managerUrl = dotenv.env['MANAGER_URL'] ?? "http://10.0.2.2:8000";
  final String backendApiUrl =
      dotenv.env['BACKEND_API_URL'] ?? "http://10.0.2.2:9001";

  initialize() async {
    await _loadStorage();
  }

  AuthToken? get accessToken => _accessToken;
  set accessToken(AuthToken? value) {
    if (_accessToken != value) {
      _accessToken = value;
      _storage.write(
        key: _accessTokenStorage(),
        value: _accessToken.toString(),
      );
      notifyListeners();

      if (_accessToken != null) {
        fetchKeys();
      }
    }
  }

  AuthToken? get refreshToken => _refreshToken;
  set refreshToken(AuthToken? value) {
    if (_refreshToken != value) {
      _refreshToken = value;
      _storage.write(
        key: _refreshTokenStorage(),
        value: _refreshToken.toString(),
      );
      notifyListeners();
    }
  }

  String? get shareableKey => _shareableKey;
  set shareableKey(String? value) {
    if (_shareableKey != value) {
      _shareableKey = value;
      notifyListeners();
    }
  }

  String? get ownerKey => _ownerKey;
  set ownerKey(String? value) {
    if (_ownerKey != value) {
      _ownerKey = value;
      notifyListeners();
    }
  }

  Future<String?> readShareableKey() async {
    return _shareableKey != null
        ? await _storage.read(key: _key(_shareableKey!))
        : null;
  }

  Future<String?> readOwnerKey() async {
    return _ownerKey != null
        ? await _storage.read(key: _key(_ownerKey!))
        : null;
  }

  List<KeyRecord> get knownKeys => _knownKeys.values
      // .where((element) => _secretKeys.contains(element.publicKey))
      .toList();

  List<String> get availableKeys {
    var list = knownKeys.map((k) => k.publicKey).toList();
    list.addAll(_secretKeys);
    return list;
  }

  _loadStorage() async {
    var refreshTokenString = await _storage.read(key: _refreshTokenStorage());
    if (refreshTokenString != null) {
      refreshToken = AuthToken.fromJson(jsonDecode(refreshTokenString));
      var accessTokenString = await _storage.read(key: _accessTokenStorage());
      if (accessTokenString != null) {
        accessToken = AuthToken.fromJson(jsonDecode(accessTokenString));
      }
    }
    _secretKeys.addAll(await _storage
        .read(key: _keysList())
        .then((raw) => raw?.split(";") ?? []));

    notifyListeners();
  }

  addKey(String publicKey, String shareableKey, String adminKey) async {
    if (publicKey.contains(":")) throw "Unsupported id with ':' charater";
    if (_secretKeys.contains(publicKey)) throw "Duplicate id?!";

    _secretKeys.add(publicKey);
    await _storage.write(key: _keysList(), value: _secretKeys.join(":"));
    await _storage.write(key: _key(publicKey), value: shareableKey);
    await _storage.write(key: _keyAdmin(publicKey), value: adminKey);
    await fetchKeys();
    notifyListeners();

    return null;
  }

  generateKey(String? name, String? description) async {
    if (accessToken == null) throw "Forbidden! Please authenticate firstly";
    // begin process
    final answer = await http.post(Uri.parse("$backendApiUrl/api/keys"),
        body: jsonEncode(<String, dynamic>{
          "participantsThreshold": 2,
          "participantsCount": 3,
          "timeoutSeconds": 60,
          "name": name ?? "",
          "description": description ?? "",
          "tags": ["shareable"]
        }),
        headers: apiHeaders);

    if (!answer.ok) {
      log("Status code is ${answer.statusCode}");
      if (answer.statusCode == 403) {}
      throw answer.body;
    }

    final record = jsonDecode(answer.body);
    final String roomId = record['roomId'];
    final shareableKeygenerator =
        await Keygenerator.create(2, managerUrl, roomId);
    final adminKeygenerator = await Keygenerator.create(3, managerUrl, roomId);

    final results = await Future.wait(
        [shareableKeygenerator.keygen(), adminKeygenerator.keygen()]);

    var publicKey = await api.toPublicKey(key: results[0], compressed: true);

    log("Key is $publicKey");

    var key = Keystore(publicKey, results[0], results[1]);
    await addKey(key.publicKey, key.shareableKey, key.adminKey);

    return key;
  }

  signKey(String shareableKey, String message, String hash,
      dynamic metadata) async {
    if (accessToken == null) throw "Forbidden! Please authenticate firstly";

    final answer = await http.post(Uri.parse("$backendApiUrl/api/sign"),
        body: jsonEncode(<String, dynamic>{
          "publicKey": shareableKey,
          "data": hash,
          "participantConfirmations": [1, 2],
          "metadata": metadata,
        }),
        headers: apiHeaders);

    if (!answer.ok) {
      log("Status code is ${answer.statusCode}");
      if (answer.statusCode == 403) {}
      throw answer.body;
    }

    final record = jsonDecode(answer.body);

    final String roomId = record['roomId'];
    final signer = await Signer.create(managerUrl, shareableKey, roomId);
    final signature = await signer.sign(hash);

    return api.toEthereumSignature(
        message: message, signature: signature, chain: 137);
  }

  // storeShareableKey(String id, String key) async {
  //   if (id.contains(":")) {
  //     throw "Unsupported id with ':' charated";
  //   }

  //   if (!_knownKeys.contains(id)) {
  //     _knownKeys.add(id);
  //     await _storage.write(key: _keysList(), value: _knownKeys.join(":"));
  //     notifyListeners();
  //   }
  // }

  // readShareableKey(String id) async {
  //   if (_knownKeys.contains(id)) {
  //     final keyFile = await _storage.read(key: _key(id));
  //     if (keyFile != _shareableKey) {
  //       _shareableKey = keyFile;
  //       notifyListeners();
  //     }
  //   } else if (_shareableKey != null) {
  //     _shareableKey = null;
  //     notifyListeners();
  //   }
  // }

  // setOwnerKey(String key) {
  //   _authToken = key;
  //   notifyListeners();
  // }

  // loadKeys() async {
  //   final list = await _storage.read(key: _keysList());
  //   _knownKeys.addAll(list?.split(";") ?? []);
  // }

  Map<String, String> get headers {
    return <String, String>{
      "Content-Type": "application/json",
      "accept": "application/json",
    };
  }

  Map<String, String>? get apiHeaders {
    return <String, String>{
      ...headers,
      "Authorization":
          accessToken?.token != null ? "Bearer ${accessToken!.token}" : ""
    };
  }

  fetchKeys() async {
    log('fetching keys');
    var response = await http.get(Uri.parse("$backendApiUrl/api/keys"),
        headers: apiHeaders);

    log(response.body);

    final keys = (jsonDecode(response.body) as List<dynamic>)
        .map((element) => KeyRecord.fromJson(element))
        .toList();

    _knownKeys.clear();
    _knownKeys.addEntries(keys
        .where((key) => key.publicKey != "")
        .map((element) => MapEntry(element.publicKey, element)));
    notifyListeners();
  }

  signin(String apiKey) async {
    log('signin');
    var response = await http.post(
      Uri.parse("$backendApiUrl/api/auth/signin"),
      headers: {...headers, "apiKey": apiKey},
    );

    var authTokens = jsonDecode(response.body);
    accessToken = AuthToken.fromJson(authTokens[0]);
    refreshToken = AuthToken.fromJson(authTokens[1]);
  }
}
