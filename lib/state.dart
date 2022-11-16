import 'dart:collection';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

_keysList() => "storage:KEYS";
_key(String id) => "storage:KEY:$id";
_tokenKey() => "storage:TOKEN";

class AppState extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _accessToken;
  String? _shareableKey;
  String? _ownerKey;
  final HashSet<String> _knownKeys = HashSet();

  String? get accessToken => _accessToken;
  String? get shareableKey => _shareableKey;
  String? get ownerKey => _ownerKey;

  UnmodifiableSetView<String> get knownKeys => UnmodifiableSetView({"0x87b2F4D0B3325D5e29E5d195164424b1135dF71B"});

  setAccessToken(String token) {
    _accessToken = token;
    _storage.write(key: _tokenKey(), value: token);
    notifyListeners();
  }

  removeAccessToken() {
    _accessToken = null;
    _storage.write(key: _tokenKey(), value: _accessToken);
    notifyListeners();
  }

  loadAccessToken() async {
    _accessToken = await _storage.read(key: _tokenKey());
    notifyListeners();
  }

  storeShareableKey(String id, String key) async {
    if (id.contains(":")) {
      throw "Unsupported id with ':' charated";
    }

    if (!_knownKeys.contains(id)) {
      _knownKeys.add(id);
      await _storage.write(key: _keysList(), value: _knownKeys.join(":"));
      notifyListeners();
    }
  }

  readShareableKey(String id) async {
    if (_knownKeys.contains(id)) {
      final keyFile = await _storage.read(key: _key(id));
      if (keyFile != _shareableKey) {
        _shareableKey = keyFile;
        notifyListeners();
      }
    } else if (_shareableKey != null) {
      _shareableKey = null;
      notifyListeners();
    }
  }

  setOwnerKey(String key) {
    _accessToken = key;
    notifyListeners();    
  }

  loadKeys() async {
    final list = await _storage.read(key: _keysList());
    _knownKeys.addAll(list?.split(";") ?? []);
  }
}