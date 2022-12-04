import 'dart:collection';
import 'dart:core';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tookey/ffi.dart';
import 'package:tookey/services/backend_client.dart';
import 'package:tookey/services/keygen.dart';
import 'package:tookey/services/signer.dart';

String _keysList() => 'storage:KEYS';
String _key(String id) => 'storage:KEY:$id';
String _accessTokenStorage() => 'storage:TOKEN:ACCESS';
String _refreshTokenStorage() => 'storage:TOKEN:REFRESH';

class AppState extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Set<String> _secretKeys = {};
  final HashMap<String, KeyRecord> _knownKeys = HashMap();
  final String relayUrl = dotenv.env['RELAY_URL'] ?? '';
  final String backendApiUrl = dotenv.env['BACKEND_API_URL'] ?? '';
  final String nodeUrl = dotenv.env['NODE_URL'] ?? '';

  AuthToken? _accessToken;
  AuthToken? _refreshToken;
  String? _shareableKey;
  String? _ownerKey;
  BackendClient? backend;

  Future<void> initialize() async {
    backend = await BackendClient.create(baseUrl: backendApiUrl);
    await _loadStorage();
  }

  AuthToken? get accessToken => _accessToken;
  set accessToken(AuthToken? value) {
    if (_accessToken != value) {
      _accessToken = value;
      if (_accessToken != null) {
        _storage.write(
          key: _accessTokenStorage(),
          value: _accessToken.toString(),
        );
        fetchKeys();
      } else {
        _storage.delete(key: _accessTokenStorage());
      }
      notifyListeners();
    }
  }

  AuthToken? get refreshToken => _refreshToken;
  set refreshToken(AuthToken? value) {
    if (_refreshToken != value) {
      _refreshToken = value;
      if (_refreshToken != null) {
        _storage.write(
          key: _refreshTokenStorage(),
          value: _refreshToken.toString(),
        );
      } else {
        _storage.delete(key: _refreshTokenStorage());
      }

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

  Future<String?> getShareableAddress() async {
    final shareableKey = await readShareableKey();
    return shareableKey != null
        ? await api.toEthereumAddress(key: shareableKey)
        : null;
  }

  List<KeyRecord> get knownKeys => _knownKeys.values
      // .where((element) => _secretKeys.contains(element.publicKey))
      .toList();

  List<String> get availableKeys {
    final list = knownKeys.map((k) => k.publicKey).toList();
    // ignore: cascade_invocations
    list.addAll(_secretKeys);
    return list;
  }

  Future<void> _loadStorage() async {
    // await _storage.deleteAll();
    final refreshTokenString = await _storage.read(key: _refreshTokenStorage());
    if (refreshTokenString != null) {
      refreshToken = AuthToken.fromJsonString(refreshTokenString);
      final accessTokenString = await _storage.read(key: _accessTokenStorage());
      if (accessTokenString != null) {
        accessToken = AuthToken.fromJsonString(accessTokenString);
      }
    }
    _secretKeys.addAll(
      await _storage
          .read(key: _keysList())
          .then((raw) => raw?.split(';') ?? []),
    );

    notifyListeners();
  }

  Future<void> addKey(String publicKey, String shareableKey) async {
    if (publicKey.contains(':')) {
      throw UnsupportedError("Unsupported id with ':' charater");
    }
    if (_secretKeys.contains(publicKey) == false) {
      // throw "Duplicate id?!";
      _secretKeys.add(publicKey);
      await _storage.write(key: _keysList(), value: _secretKeys.join(':'));
      await _storage.write(key: _key(publicKey), value: shareableKey);
    }

    await fetchKeys();
    notifyListeners();

    return;
  }

  Future<void> shareKey([String? shareableKey]) async {
    shareableKey ??= await readShareableKey();
    if (shareableKey == null) throw ArgumentError('Key not found');
    final data = Uint8List.fromList(shareableKey.codeUnits);
    await Share.shareXFiles([
      XFile.fromData(
        data,
        name: 'key.json',
        mimeType: 'application/json',
      ),
    ]);
  }

  Future<void> sendSignedTransaction(String signedTransaction) async {
    // final provider = ethers.Providers().jsonRpcProvider(url: nodeUrl);
    // provider.sendTransaction(new TransactionRequest())
    // final httpClient = Client();
    // final ethClient = Web3Client(nodeUrl, httpClient);
    // final data = Uint8List.fromList(signedTransaction.codeUnits);
    // await ethClient.sendRawTransaction(data);
  }

  Future<void> importKey(String importedKey) async {
    final publicKey = await api.toPublicKey(key: importedKey, compressed: true);

    // TODO(temadev): backend, save to participants, approve
    await addKey(publicKey, importedKey);
  }

  Future<List<Keystore>> generateKey(String? name, String? description) async {
    final keyRecord = await backend?.generateKey(
      accessToken?.token,
      name: name,
      description: description,
    );

    final roomId = keyRecord!.roomId;

    final shareableKeygen = await Keygen.create(2, relayUrl, roomId);
    final adminKeygen = await Keygen.create(3, relayUrl, roomId);

    final results = await Future.wait([
      shareableKeygen.keygen(),
      adminKeygen.keygen(),
    ]);

    final publicKey = await api.toPublicKey(key: results[0], compressed: true);

    log('Key is $publicKey');

    final shareableKey = Keystore(publicKey, results[0]);
    final adminKey = Keystore(publicKey, results[1]);

    await addKey(shareableKey.publicKey, shareableKey.shareableKey);

    return [shareableKey, adminKey];
  }

  Future<String> signKey(
    String message,
    String hash,
    Map<String, dynamic>? metadata,
  ) async {
    final signRecord = await backend?.signKey(
      accessToken?.token,
      shareableKey!,
      message,
      hash,
      metadata: metadata,
    );

    final localShare = await readShareableKey();

    final roomId = signRecord!.roomId;

    final signer = await Signer.create(relayUrl, localShare!, roomId);
    final signature = await signer.sign(hash);

    final ethSignature = await api.toEthereumSignature(
      message: message,
      signature: signature,
      chain: 97,
    );

    return ethSignature;
  }

  Future<void> fetchKeys() async {
    final keys = await backend?.fetchKeys(accessToken?.token);
    _knownKeys
      ..clear()
      ..addEntries(
        keys!
            .where((key) => key.publicKey != '')
            .map((element) => MapEntry(element.publicKey, element)),
      );
    notifyListeners();
  }

  Future<void> signin(String apiKey) async {
    final authTokens = await backend?.signin(apiKey);
    if (authTokens?.access != null) accessToken = authTokens?.access;
    if (authTokens?.refresh != null) refreshToken = authTokens?.refresh;
    notifyListeners();
  }

  void signout() {
    log('signout');
    accessToken = null;
    refreshToken = null;
    notifyListeners();
  }
}

class Keystore {
  Keystore(this.publicKey, this.shareableKey);

  String publicKey;
  String shareableKey;
}
