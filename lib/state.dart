import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tookey/ffi.dart';
import 'package:tookey/models/key_session.dart';
import 'package:tookey/services/backend_client.dart';
import 'package:tookey/services/networks.dart';
import 'package:web3dart/web3dart.dart';

String _keysList() => 'storage:KEYS';

String _key(String id) => 'storage:KEY:$id';

String _refreshTokenStorage() => 'storage:TOKEN:REFRESH';

String _sessionList() => 'storage:SESSIONS';

String _session(String key) => 'storage:SESSION:$key';

class AppState extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Set<String> _secretKeys = {};
  final Set<String> _sessionKeys = {};
  final HashMap<String, KeyRecord> _knownKeys = HashMap();
  final String relayUrl = dotenv.env['RELAY_URL'] ?? '';
  final String backendApiUrl = dotenv.env['BACKEND_API_URL'] ?? '';

  final HashMap<String, Network> _networks = HashMap();

  String? _shareableKey;
  String? _ownerKey;
  AuthToken? _refreshToken;
  BackendClient? backend;

  Future<void> removeAllSessions() async {
    _sessionKeys.removeAll(_sessionKeys.toList());
    await _storage.write(key: _sessionList(), value: _sessionKeys.join(':'));

    notifyListeners();
  }

  Future<void> removeSession(KeySession session) async {
    final hash = session.hashCode.toString();

    log('remove session $hash');
    log('known sessions: ${_sessionKeys.join(', ')}');

    if (_sessionKeys.contains(hash)) {
      _sessionKeys.remove(hash);
      await _storage.write(key: _sessionList(), value: _sessionKeys.join(':'));
      await _storage.delete(key: _session(hash));
      notifyListeners();
    }
  }

  Future<void> saveSession(KeySession session) async {
    final hash = session.hashCode.toString();

    log('save session $hash');

    if (!_sessionKeys.contains(hash)) {
      _sessionKeys.add(hash);
      await _storage.write(key: _sessionList(), value: _sessionKeys.join(':'));
      await _storage.write(
        key: _session(hash),
        value: jsonEncode(session.toJson()),
      );
      notifyListeners();
    }
  }

  Future<List<KeySession>> readSessions() async {
    log('read sessions');
    return Future.wait(
      _sessionKeys.map(
        (key) => _storage.read(key: _session(key)).then(
              (raw) => raw != null
                  ? KeySession.fromJson(
                      jsonDecode(raw) as Map<String, dynamic>,
                    )
                  : null,
            ),
      ),
    ).then(
      (map) => map.whereType<KeySession>().toList(),
    );
  }

  Network getNetwork(int chainId) {
    return networks.firstWhere(
      (element) => element.chainId == chainId,
    );
  }

  void addNetwork(Network network) {
    if (!_networks.containsKey(network.name)) {
      _networks[network.name] = network;

      notifyListeners();
    }
  }

  void addNetworks(Iterable<Network> networks) {
    for (final n in networks) {
      addNetwork(n);
    }
  }

  Iterable<Network> get networks => _networks.values;

  List<String> get secretKeys => _secretKeys.toList();

  Future<void> initialize() async {
    await _loadStorage();
    backend = await BackendClient.create(
      baseUrl: backendApiUrl,
      refreshToken: _refreshToken,
    );
    // await fetchKeys();
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
        ? await api.privateKeyToEthereumAddress(privateKey: shareableKey)
        : null;
  }

  List<KeyRecord> get allKeys => _knownKeys.values.toList();

  List<KeyRecord> get unknownKeys =>
      allKeys.where((k) => !_secretKeys.contains(k.publicKey)).toList();

  List<KeyRecord> get knownKeys =>
      allKeys.where((k) => _secretKeys.contains(k.publicKey)).toList();

  Future<void> _loadStorage() async {
    // await _storage.deleteAll();
    final refreshTokenString = await _storage.read(key: _refreshTokenStorage());
    if (refreshTokenString != null) {
      refreshToken = AuthToken.fromJsonString(refreshTokenString);
    }
    _secretKeys.addAll(
      await _storage
          .read(key: _keysList())
          .then((raw) => raw?.split(':') ?? []),
    );

    _sessionKeys.addAll(
      await _storage
          .read(key: _sessionList())
          .then((raw) => raw?.split(':') ?? []),
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

  Future<void> shareKey({String? key, String? name, String? subject}) async {
    key ??= await readShareableKey();
    name ??= _shareableKey;
    if (key == null) throw ArgumentError('Key not found');
    final data = Uint8List.fromList(key.codeUnits);

    final fileName = name != null ? '$name.json' : 'backup-key.json';
    final directory = await getTemporaryDirectory();

    final xfile = XFile.fromData(
      data,
      name: fileName,
      path: directory.path,
      mimeType: 'application/json',
    );

    final filePath = path.join(xfile.path, fileName);
    await xfile.saveTo(filePath);

    await Share.shareXFiles([XFile(filePath)], subject: subject);
  }

  Future<String> sendSignedTransaction(Uint8List signedTransaction) async {
    final ethClient = Web3Client(dotenv.env['NODE_URL']!, Client());
    return ethClient.sendRawTransaction(signedTransaction);
  }

  Future<String> importKey(String importedKey) async {
    log('start import key');
    final publicKey = await api.privateKeyToPublicKey(
      privateKey: importedKey,
      compressed: true,
    );

    log(publicKey);

    await addKey(publicKey, importedKey);

    return publicKey;
  }

  Future<List<Keystore>> generateKey(String? name, String? description) async {
    final keyRecord = await backend?.generateKey(
      name: name,
      description: description,
    );

    final roomId = keyRecord!.roomId;

    KeygenParams paramsFor(int index) {
      return KeygenParams(
        roomId: roomId,
        participantIndex: index,
        participantsCount: 3,
        participantsThreshold: 1,
        relayAddress: relayUrl,
        timeoutSeconds: 60,
      );
    }

    final results = await Future.wait(
      [api.keygen(params: paramsFor(2)), api.keygen(params: paramsFor(3))],
    );

    final publicKey = await api.privateKeyToPublicKey(
      privateKey: results[0].key!,
      compressed: true,
    );

    log('Key is $publicKey');

    final shareableKey = Keystore(publicKey, results[0].key!);
    final adminKey = Keystore(publicKey, results[1].key!);

    await addKey(shareableKey.publicKey, shareableKey.shareableKey);

    return [shareableKey, adminKey];
  }

  Future<String> signKey(
    String message,
    String hash,
    Map<String, dynamic>? metadata,
  ) async {
    log('Waiting for approve in telegram');

    final signRecord = await backend?.signKey(
      shareableKey!,
      message,
      hash,
      metadata: metadata,
    );

    log('Approved');

    final localShare = await readShareableKey();

    final roomId = signRecord!.roomId;

    final params = SignParams(
      roomId: roomId,
      key: localShare!,
      data: hash,
      participantsIndexes: Uint16List.fromList([1, 2]),
      relayAddress: relayUrl,
      timeoutSeconds: 60,
    );
    final result = await api.sign(params: params);
    if (result.result == null) throw Exception(result.error);
    return result.result!;
  }

  Future<void> fetchKeys() async {
    final keys = await backend?.fetchKeys();

    _knownKeys
      ..clear()
      ..addEntries(
        keys!
            .where((key) => key.publicKey != '')
            .map((element) => MapEntry(element.publicKey, element)),
      );
    // notifyListeners();
  }

  Future<void> signin(String apiKey) async {
    final authToken = await backend?.signin(apiKey);
    if (authToken != null) refreshToken = authToken;
    notifyListeners();
  }

  void signout() {
    log('signout');
    refreshToken = null;
    notifyListeners();
  }
}

class Keystore {
  Keystore(this.publicKey, this.shareableKey);

  String publicKey;
  String shareableKey;
}
