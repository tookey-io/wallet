import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wallet_connect/wc_session_store.dart';

part 'key_session.g.dart';

@immutable
@JsonSerializable()
class KeySession {
  const KeySession({required this.store, required this.publicKey});

  factory KeySession.fromJson(Map<String, dynamic> json) =>
      _$KeySessionFromJson(json);

  final WCSessionStore store;
  final String publicKey;
  Map<String, dynamic> toJson() => _$KeySessionToJson(this);

  @override
  int get hashCode {
    return store.toString().hashCode ^ publicKey.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KeySession && other.hashCode == hashCode;
  }
}
