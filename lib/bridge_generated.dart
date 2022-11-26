// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.49.2.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names

import 'dart:convert';
import 'dart:async';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:freezed_annotation/freezed_annotation.dart' hide protected;

import 'package:meta/meta.dart';
import 'package:meta/meta.dart';
import 'dart:ffi' as ffi;

part 'bridge_generated.freezed.dart';

abstract class Native {
  Future<String> toPublicKey(
      {required String key, required bool compressed, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kToPublicKeyConstMeta;

  Future<String> toEthereumAddress({required String key, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kToEthereumAddressConstMeta;

  Future<String> messageToHash({required String message, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kMessageToHashConstMeta;

  Future<String> toEthereumSignature(
      {required String message,
      required String signature,
      required int chain,
      dynamic hint});

  FlutterRustBridgeTaskConstMeta get kToEthereumSignatureConstMeta;

  Stream<String> connectLogger({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kConnectLoggerConstMeta;

  /// Returns next available id for initialize execution
  Future<int> getNextId({dynamic hint});

  FlutterRustBridgeTaskConstMeta get kGetNextIdConstMeta;

  /// Creates channel to obtain outgoing messages for broadcast/send them
  Stream<OutgoingMessage> initialize({required int id, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kInitializeConstMeta;

  Future<void> receive(
      {required int id, required IncomingMessage value, dynamic hint});

  FlutterRustBridgeTaskConstMeta get kReceiveConstMeta;

  Future<OutgoingMessage> criticalStaticMethodOutgoingMessage(
      {required String message, dynamic hint});

  FlutterRustBridgeTaskConstMeta
      get kCriticalStaticMethodOutgoingMessageConstMeta;

  Future<OutgoingMessage> invalidStaticMethodOutgoingMessage(
      {required String message, dynamic hint});

  FlutterRustBridgeTaskConstMeta
      get kInvalidStaticMethodOutgoingMessageConstMeta;
}

enum ErrCode {
  Internal,
  InvalidMessage,
  Critical,
}

@freezed
class IncomingMessage with _$IncomingMessage {
  const factory IncomingMessage.begin({
    required TookeyScenarios scenario,
  }) = IncomingMessage_Begin;
  const factory IncomingMessage.participant({
    required int index,
    int? party,
  }) = IncomingMessage_Participant;
  const factory IncomingMessage.group({
    required Uint16List indexes,
    required Uint16List parties,
  }) = IncomingMessage_Group;
  const factory IncomingMessage.communication({
    required String packet,
  }) = IncomingMessage_Communication;
  const factory IncomingMessage.close() = IncomingMessage_Close;
}

@freezed
class OutgoingMessage with _$OutgoingMessage {
  const factory OutgoingMessage.start() = OutgoingMessage_Start;
  const factory OutgoingMessage.ready() = OutgoingMessage_Ready;
  const factory OutgoingMessage.issue({
    required ErrCode code,
    required String message,
  }) = OutgoingMessage_Issue;
  const factory OutgoingMessage.communication({
    required String packet,
  }) = OutgoingMessage_Communication;
  const factory OutgoingMessage.result({
    required String encoded,
  }) = OutgoingMessage_Result;
  const factory OutgoingMessage.close() = OutgoingMessage_Close;
}

@freezed
class TookeyScenarios with _$TookeyScenarios {
  const factory TookeyScenarios.keygenEcdsa({
    required int index,
    required int parties,
    required int threashold,
  }) = TookeyScenarios_KeygenECDSA;
  const factory TookeyScenarios.signEcdsa({
    required Uint16List parties,
    required String key,
    required String hash,
  }) = TookeyScenarios_SignECDSA;
}

class NativeImpl implements Native {
  final NativePlatform _platform;
  factory NativeImpl(ExternalLibrary dylib) =>
      NativeImpl.raw(NativePlatform(dylib));

  /// Only valid on web/WASM platforms.
  factory NativeImpl.wasm(FutureOr<WasmModule> module) =>
      NativeImpl(module as ExternalLibrary);
  NativeImpl.raw(this._platform);
  Future<String> toPublicKey(
          {required String key, required bool compressed, dynamic hint}) =>
      _platform.executeNormal(FlutterRustBridgeTask(
        callFfi: (port_) => _platform.inner.wire_to_public_key(
            port_, _platform.api2wire_String(key), compressed),
        parseSuccessData: _wire2api_String,
        constMeta: kToPublicKeyConstMeta,
        argValues: [key, compressed],
        hint: hint,
      ));

  FlutterRustBridgeTaskConstMeta get kToPublicKeyConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "to_public_key",
        argNames: ["key", "compressed"],
      );

  Future<String> toEthereumAddress({required String key, dynamic hint}) =>
      _platform.executeNormal(FlutterRustBridgeTask(
        callFfi: (port_) => _platform.inner
            .wire_to_ethereum_address(port_, _platform.api2wire_String(key)),
        parseSuccessData: _wire2api_String,
        constMeta: kToEthereumAddressConstMeta,
        argValues: [key],
        hint: hint,
      ));

  FlutterRustBridgeTaskConstMeta get kToEthereumAddressConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "to_ethereum_address",
        argNames: ["key"],
      );

  Future<String> messageToHash({required String message, dynamic hint}) =>
      _platform.executeNormal(FlutterRustBridgeTask(
        callFfi: (port_) => _platform.inner
            .wire_message_to_hash(port_, _platform.api2wire_String(message)),
        parseSuccessData: _wire2api_String,
        constMeta: kMessageToHashConstMeta,
        argValues: [message],
        hint: hint,
      ));

  FlutterRustBridgeTaskConstMeta get kMessageToHashConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "message_to_hash",
        argNames: ["message"],
      );

  Future<String> toEthereumSignature(
          {required String message,
          required String signature,
          required int chain,
          dynamic hint}) =>
      _platform.executeNormal(FlutterRustBridgeTask(
        callFfi: (port_) => _platform.inner.wire_to_ethereum_signature(
            port_,
            _platform.api2wire_String(message),
            _platform.api2wire_String(signature),
            api2wire_u32(chain)),
        parseSuccessData: _wire2api_String,
        constMeta: kToEthereumSignatureConstMeta,
        argValues: [message, signature, chain],
        hint: hint,
      ));

  FlutterRustBridgeTaskConstMeta get kToEthereumSignatureConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "to_ethereum_signature",
        argNames: ["message", "signature", "chain"],
      );

  Stream<String> connectLogger({dynamic hint}) =>
      _platform.executeStream(FlutterRustBridgeTask(
        callFfi: (port_) => _platform.inner.wire_connect_logger(port_),
        parseSuccessData: _wire2api_String,
        constMeta: kConnectLoggerConstMeta,
        argValues: [],
        hint: hint,
      ));

  FlutterRustBridgeTaskConstMeta get kConnectLoggerConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "connect_logger",
        argNames: [],
      );

  Future<int> getNextId({dynamic hint}) =>
      _platform.executeNormal(FlutterRustBridgeTask(
        callFfi: (port_) => _platform.inner.wire_get_next_id(port_),
        parseSuccessData: _wire2api_u32,
        constMeta: kGetNextIdConstMeta,
        argValues: [],
        hint: hint,
      ));

  FlutterRustBridgeTaskConstMeta get kGetNextIdConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "get_next_id",
        argNames: [],
      );

  Stream<OutgoingMessage> initialize({required int id, dynamic hint}) =>
      _platform.executeStream(FlutterRustBridgeTask(
        callFfi: (port_) =>
            _platform.inner.wire_initialize(port_, api2wire_u32(id)),
        parseSuccessData: _wire2api_outgoing_message,
        constMeta: kInitializeConstMeta,
        argValues: [id],
        hint: hint,
      ));

  FlutterRustBridgeTaskConstMeta get kInitializeConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "initialize",
        argNames: ["id"],
      );

  Future<void> receive(
          {required int id, required IncomingMessage value, dynamic hint}) =>
      _platform.executeNormal(FlutterRustBridgeTask(
        callFfi: (port_) => _platform.inner.wire_receive(
            port_,
            api2wire_u32(id),
            _platform.api2wire_box_autoadd_incoming_message(value)),
        parseSuccessData: _wire2api_unit,
        constMeta: kReceiveConstMeta,
        argValues: [id, value],
        hint: hint,
      ));

  FlutterRustBridgeTaskConstMeta get kReceiveConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "receive",
        argNames: ["id", "value"],
      );

  Future<OutgoingMessage> criticalStaticMethodOutgoingMessage(
          {required String message, dynamic hint}) =>
      _platform.executeNormal(FlutterRustBridgeTask(
        callFfi: (port_) => _platform.inner
            .wire_critical__static_method__OutgoingMessage(
                port_, _platform.api2wire_String(message)),
        parseSuccessData: _wire2api_outgoing_message,
        constMeta: kCriticalStaticMethodOutgoingMessageConstMeta,
        argValues: [message],
        hint: hint,
      ));

  FlutterRustBridgeTaskConstMeta
      get kCriticalStaticMethodOutgoingMessageConstMeta =>
          const FlutterRustBridgeTaskConstMeta(
            debugName: "critical__static_method__OutgoingMessage",
            argNames: ["message"],
          );

  Future<OutgoingMessage> invalidStaticMethodOutgoingMessage(
          {required String message, dynamic hint}) =>
      _platform.executeNormal(FlutterRustBridgeTask(
        callFfi: (port_) => _platform.inner
            .wire_invalid__static_method__OutgoingMessage(
                port_, _platform.api2wire_String(message)),
        parseSuccessData: _wire2api_outgoing_message,
        constMeta: kInvalidStaticMethodOutgoingMessageConstMeta,
        argValues: [message],
        hint: hint,
      ));

  FlutterRustBridgeTaskConstMeta
      get kInvalidStaticMethodOutgoingMessageConstMeta =>
          const FlutterRustBridgeTaskConstMeta(
            debugName: "invalid__static_method__OutgoingMessage",
            argNames: ["message"],
          );

// Section: wire2api

  String _wire2api_String(dynamic raw) {
    return raw as String;
  }

  ErrCode _wire2api_err_code(dynamic raw) {
    return ErrCode.values[raw];
  }

  int _wire2api_i32(dynamic raw) {
    return raw as int;
  }

  OutgoingMessage _wire2api_outgoing_message(dynamic raw) {
    switch (raw[0]) {
      case 0:
        return OutgoingMessage_Start();
      case 1:
        return OutgoingMessage_Ready();
      case 2:
        return OutgoingMessage_Issue(
          code: _wire2api_err_code(raw[1]),
          message: _wire2api_String(raw[2]),
        );
      case 3:
        return OutgoingMessage_Communication(
          packet: _wire2api_String(raw[1]),
        );
      case 4:
        return OutgoingMessage_Result(
          encoded: _wire2api_String(raw[1]),
        );
      case 5:
        return OutgoingMessage_Close();
      default:
        throw Exception("unreachable");
    }
  }

  int _wire2api_u32(dynamic raw) {
    return raw as int;
  }

  int _wire2api_u8(dynamic raw) {
    return raw as int;
  }

  Uint8List _wire2api_uint_8_list(dynamic raw) {
    return raw as Uint8List;
  }

  void _wire2api_unit(dynamic raw) {
    return;
  }
}

// Section: api2wire

@protected
bool api2wire_bool(bool raw) {
  return raw;
}

@protected
int api2wire_u16(int raw) {
  return raw;
}

@protected
int api2wire_u32(int raw) {
  return raw;
}

@protected
int api2wire_u8(int raw) {
  return raw;
}

class NativePlatform extends FlutterRustBridgeBase<NativeWire> {
  NativePlatform(ffi.DynamicLibrary dylib) : super(NativeWire(dylib));
// Section: api2wire

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_String(String raw) {
    return api2wire_uint_8_list(utf8.encoder.convert(raw));
  }

  @protected
  ffi.Pointer<wire_IncomingMessage> api2wire_box_autoadd_incoming_message(
      IncomingMessage raw) {
    final ptr = inner.new_box_autoadd_incoming_message_0();
    _api_fill_to_wire_incoming_message(raw, ptr.ref);
    return ptr;
  }

  @protected
  ffi.Pointer<wire_TookeyScenarios> api2wire_box_autoadd_tookey_scenarios(
      TookeyScenarios raw) {
    final ptr = inner.new_box_autoadd_tookey_scenarios_0();
    _api_fill_to_wire_tookey_scenarios(raw, ptr.ref);
    return ptr;
  }

  @protected
  ffi.Pointer<ffi.Uint16> api2wire_box_autoadd_u16(int raw) {
    return inner.new_box_autoadd_u16_0(api2wire_u16(raw));
  }

  @protected
  ffi.Pointer<ffi.Uint16> api2wire_opt_box_autoadd_u16(int? raw) {
    return raw == null ? ffi.nullptr : api2wire_box_autoadd_u16(raw);
  }

  @protected
  ffi.Pointer<wire_uint_16_list> api2wire_uint_16_list(Uint16List raw) {
    final ans = inner.new_uint_16_list_0(raw.length);
    ans.ref.ptr.asTypedList(raw.length).setAll(0, raw);
    return ans;
  }

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_uint_8_list(Uint8List raw) {
    final ans = inner.new_uint_8_list_0(raw.length);
    ans.ref.ptr.asTypedList(raw.length).setAll(0, raw);
    return ans;
  }
// Section: api_fill_to_wire

  void _api_fill_to_wire_box_autoadd_incoming_message(
      IncomingMessage apiObj, ffi.Pointer<wire_IncomingMessage> wireObj) {
    _api_fill_to_wire_incoming_message(apiObj, wireObj.ref);
  }

  void _api_fill_to_wire_box_autoadd_tookey_scenarios(
      TookeyScenarios apiObj, ffi.Pointer<wire_TookeyScenarios> wireObj) {
    _api_fill_to_wire_tookey_scenarios(apiObj, wireObj.ref);
  }

  void _api_fill_to_wire_incoming_message(
      IncomingMessage apiObj, wire_IncomingMessage wireObj) {
    if (apiObj is IncomingMessage_Begin) {
      wireObj.tag = 0;
      wireObj.kind = inner.inflate_IncomingMessage_Begin();
      wireObj.kind.ref.Begin.ref.scenario =
          api2wire_box_autoadd_tookey_scenarios(apiObj.scenario);
      return;
    }
    if (apiObj is IncomingMessage_Participant) {
      wireObj.tag = 1;
      wireObj.kind = inner.inflate_IncomingMessage_Participant();
      wireObj.kind.ref.Participant.ref.index = api2wire_u16(apiObj.index);
      wireObj.kind.ref.Participant.ref.party =
          api2wire_opt_box_autoadd_u16(apiObj.party);
      return;
    }
    if (apiObj is IncomingMessage_Group) {
      wireObj.tag = 2;
      wireObj.kind = inner.inflate_IncomingMessage_Group();
      wireObj.kind.ref.Group.ref.indexes =
          api2wire_uint_16_list(apiObj.indexes);
      wireObj.kind.ref.Group.ref.parties =
          api2wire_uint_16_list(apiObj.parties);
      return;
    }
    if (apiObj is IncomingMessage_Communication) {
      wireObj.tag = 3;
      wireObj.kind = inner.inflate_IncomingMessage_Communication();
      wireObj.kind.ref.Communication.ref.packet =
          api2wire_String(apiObj.packet);
      return;
    }
    if (apiObj is IncomingMessage_Close) {
      wireObj.tag = 4;
      return;
    }
  }

  void _api_fill_to_wire_tookey_scenarios(
      TookeyScenarios apiObj, wire_TookeyScenarios wireObj) {
    if (apiObj is TookeyScenarios_KeygenECDSA) {
      wireObj.tag = 0;
      wireObj.kind = inner.inflate_TookeyScenarios_KeygenECDSA();
      wireObj.kind.ref.KeygenECDSA.ref.index = api2wire_u16(apiObj.index);
      wireObj.kind.ref.KeygenECDSA.ref.parties = api2wire_u16(apiObj.parties);
      wireObj.kind.ref.KeygenECDSA.ref.threashold =
          api2wire_u16(apiObj.threashold);
      return;
    }
    if (apiObj is TookeyScenarios_SignECDSA) {
      wireObj.tag = 1;
      wireObj.kind = inner.inflate_TookeyScenarios_SignECDSA();
      wireObj.kind.ref.SignECDSA.ref.parties =
          api2wire_uint_16_list(apiObj.parties);
      wireObj.kind.ref.SignECDSA.ref.key = api2wire_String(apiObj.key);
      wireObj.kind.ref.SignECDSA.ref.hash = api2wire_String(apiObj.hash);
      return;
    }
  }
}

// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_positional_boolean_parameters, annotate_overrides, constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.

/// generated by flutter_rust_bridge
class NativeWire implements FlutterRustBridgeWireBase {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  NativeWire(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  NativeWire.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void store_dart_post_cobject(
    DartPostCObjectFnType ptr,
  ) {
    return _store_dart_post_cobject(
      ptr,
    );
  }

  late final _store_dart_post_cobjectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(DartPostCObjectFnType)>>(
          'store_dart_post_cobject');
  late final _store_dart_post_cobject = _store_dart_post_cobjectPtr
      .asFunction<void Function(DartPostCObjectFnType)>();

  void wire_to_public_key(
    int port_,
    ffi.Pointer<wire_uint_8_list> key,
    bool compressed,
  ) {
    return _wire_to_public_key(
      port_,
      key,
      compressed,
    );
  }

  late final _wire_to_public_keyPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>,
              ffi.Bool)>>('wire_to_public_key');
  late final _wire_to_public_key = _wire_to_public_keyPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>, bool)>();

  void wire_to_ethereum_address(
    int port_,
    ffi.Pointer<wire_uint_8_list> key,
  ) {
    return _wire_to_ethereum_address(
      port_,
      key,
    );
  }

  late final _wire_to_ethereum_addressPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64,
              ffi.Pointer<wire_uint_8_list>)>>('wire_to_ethereum_address');
  late final _wire_to_ethereum_address = _wire_to_ethereum_addressPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_message_to_hash(
    int port_,
    ffi.Pointer<wire_uint_8_list> message,
  ) {
    return _wire_message_to_hash(
      port_,
      message,
    );
  }

  late final _wire_message_to_hashPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64,
              ffi.Pointer<wire_uint_8_list>)>>('wire_message_to_hash');
  late final _wire_message_to_hash = _wire_message_to_hashPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_to_ethereum_signature(
    int port_,
    ffi.Pointer<wire_uint_8_list> message,
    ffi.Pointer<wire_uint_8_list> signature,
    int chain,
  ) {
    return _wire_to_ethereum_signature(
      port_,
      message,
      signature,
      chain,
    );
  }

  late final _wire_to_ethereum_signaturePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64,
              ffi.Pointer<wire_uint_8_list>,
              ffi.Pointer<wire_uint_8_list>,
              ffi.Uint32)>>('wire_to_ethereum_signature');
  late final _wire_to_ethereum_signature =
      _wire_to_ethereum_signaturePtr.asFunction<
          void Function(int, ffi.Pointer<wire_uint_8_list>,
              ffi.Pointer<wire_uint_8_list>, int)>();

  void wire_connect_logger(
    int port_,
  ) {
    return _wire_connect_logger(
      port_,
    );
  }

  late final _wire_connect_loggerPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_connect_logger');
  late final _wire_connect_logger =
      _wire_connect_loggerPtr.asFunction<void Function(int)>();

  void wire_get_next_id(
    int port_,
  ) {
    return _wire_get_next_id(
      port_,
    );
  }

  late final _wire_get_next_idPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_get_next_id');
  late final _wire_get_next_id =
      _wire_get_next_idPtr.asFunction<void Function(int)>();

  void wire_initialize(
    int port_,
    int id,
  ) {
    return _wire_initialize(
      port_,
      id,
    );
  }

  late final _wire_initializePtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64, ffi.Uint32)>>(
          'wire_initialize');
  late final _wire_initialize =
      _wire_initializePtr.asFunction<void Function(int, int)>();

  void wire_receive(
    int port_,
    int id,
    ffi.Pointer<wire_IncomingMessage> value,
  ) {
    return _wire_receive(
      port_,
      id,
      value,
    );
  }

  late final _wire_receivePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Uint32,
              ffi.Pointer<wire_IncomingMessage>)>>('wire_receive');
  late final _wire_receive = _wire_receivePtr
      .asFunction<void Function(int, int, ffi.Pointer<wire_IncomingMessage>)>();

  void wire_critical__static_method__OutgoingMessage(
    int port_,
    ffi.Pointer<wire_uint_8_list> message,
  ) {
    return _wire_critical__static_method__OutgoingMessage(
      port_,
      message,
    );
  }

  late final _wire_critical__static_method__OutgoingMessagePtr = _lookup<
          ffi.NativeFunction<
              ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>(
      'wire_critical__static_method__OutgoingMessage');
  late final _wire_critical__static_method__OutgoingMessage =
      _wire_critical__static_method__OutgoingMessagePtr
          .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_invalid__static_method__OutgoingMessage(
    int port_,
    ffi.Pointer<wire_uint_8_list> message,
  ) {
    return _wire_invalid__static_method__OutgoingMessage(
      port_,
      message,
    );
  }

  late final _wire_invalid__static_method__OutgoingMessagePtr = _lookup<
          ffi.NativeFunction<
              ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>(
      'wire_invalid__static_method__OutgoingMessage');
  late final _wire_invalid__static_method__OutgoingMessage =
      _wire_invalid__static_method__OutgoingMessagePtr
          .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  ffi.Pointer<wire_IncomingMessage> new_box_autoadd_incoming_message_0() {
    return _new_box_autoadd_incoming_message_0();
  }

  late final _new_box_autoadd_incoming_message_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<wire_IncomingMessage> Function()>>(
          'new_box_autoadd_incoming_message_0');
  late final _new_box_autoadd_incoming_message_0 =
      _new_box_autoadd_incoming_message_0Ptr
          .asFunction<ffi.Pointer<wire_IncomingMessage> Function()>();

  ffi.Pointer<wire_TookeyScenarios> new_box_autoadd_tookey_scenarios_0() {
    return _new_box_autoadd_tookey_scenarios_0();
  }

  late final _new_box_autoadd_tookey_scenarios_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<wire_TookeyScenarios> Function()>>(
          'new_box_autoadd_tookey_scenarios_0');
  late final _new_box_autoadd_tookey_scenarios_0 =
      _new_box_autoadd_tookey_scenarios_0Ptr
          .asFunction<ffi.Pointer<wire_TookeyScenarios> Function()>();

  ffi.Pointer<ffi.Uint16> new_box_autoadd_u16_0(
    int value,
  ) {
    return _new_box_autoadd_u16_0(
      value,
    );
  }

  late final _new_box_autoadd_u16_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<ffi.Uint16> Function(ffi.Uint16)>>(
          'new_box_autoadd_u16_0');
  late final _new_box_autoadd_u16_0 = _new_box_autoadd_u16_0Ptr
      .asFunction<ffi.Pointer<ffi.Uint16> Function(int)>();

  ffi.Pointer<wire_uint_16_list> new_uint_16_list_0(
    int len,
  ) {
    return _new_uint_16_list_0(
      len,
    );
  }

  late final _new_uint_16_list_0Ptr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_uint_16_list> Function(
              ffi.Int32)>>('new_uint_16_list_0');
  late final _new_uint_16_list_0 = _new_uint_16_list_0Ptr
      .asFunction<ffi.Pointer<wire_uint_16_list> Function(int)>();

  ffi.Pointer<wire_uint_8_list> new_uint_8_list_0(
    int len,
  ) {
    return _new_uint_8_list_0(
      len,
    );
  }

  late final _new_uint_8_list_0Ptr = _lookup<
      ffi.NativeFunction<
          ffi.Pointer<wire_uint_8_list> Function(
              ffi.Int32)>>('new_uint_8_list_0');
  late final _new_uint_8_list_0 = _new_uint_8_list_0Ptr
      .asFunction<ffi.Pointer<wire_uint_8_list> Function(int)>();

  ffi.Pointer<IncomingMessageKind> inflate_IncomingMessage_Begin() {
    return _inflate_IncomingMessage_Begin();
  }

  late final _inflate_IncomingMessage_BeginPtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<IncomingMessageKind> Function()>>(
          'inflate_IncomingMessage_Begin');
  late final _inflate_IncomingMessage_Begin = _inflate_IncomingMessage_BeginPtr
      .asFunction<ffi.Pointer<IncomingMessageKind> Function()>();

  ffi.Pointer<IncomingMessageKind> inflate_IncomingMessage_Participant() {
    return _inflate_IncomingMessage_Participant();
  }

  late final _inflate_IncomingMessage_ParticipantPtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<IncomingMessageKind> Function()>>(
          'inflate_IncomingMessage_Participant');
  late final _inflate_IncomingMessage_Participant =
      _inflate_IncomingMessage_ParticipantPtr
          .asFunction<ffi.Pointer<IncomingMessageKind> Function()>();

  ffi.Pointer<IncomingMessageKind> inflate_IncomingMessage_Group() {
    return _inflate_IncomingMessage_Group();
  }

  late final _inflate_IncomingMessage_GroupPtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<IncomingMessageKind> Function()>>(
          'inflate_IncomingMessage_Group');
  late final _inflate_IncomingMessage_Group = _inflate_IncomingMessage_GroupPtr
      .asFunction<ffi.Pointer<IncomingMessageKind> Function()>();

  ffi.Pointer<IncomingMessageKind> inflate_IncomingMessage_Communication() {
    return _inflate_IncomingMessage_Communication();
  }

  late final _inflate_IncomingMessage_CommunicationPtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<IncomingMessageKind> Function()>>(
          'inflate_IncomingMessage_Communication');
  late final _inflate_IncomingMessage_Communication =
      _inflate_IncomingMessage_CommunicationPtr
          .asFunction<ffi.Pointer<IncomingMessageKind> Function()>();

  ffi.Pointer<TookeyScenariosKind> inflate_TookeyScenarios_KeygenECDSA() {
    return _inflate_TookeyScenarios_KeygenECDSA();
  }

  late final _inflate_TookeyScenarios_KeygenECDSAPtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<TookeyScenariosKind> Function()>>(
          'inflate_TookeyScenarios_KeygenECDSA');
  late final _inflate_TookeyScenarios_KeygenECDSA =
      _inflate_TookeyScenarios_KeygenECDSAPtr
          .asFunction<ffi.Pointer<TookeyScenariosKind> Function()>();

  ffi.Pointer<TookeyScenariosKind> inflate_TookeyScenarios_SignECDSA() {
    return _inflate_TookeyScenarios_SignECDSA();
  }

  late final _inflate_TookeyScenarios_SignECDSAPtr =
      _lookup<ffi.NativeFunction<ffi.Pointer<TookeyScenariosKind> Function()>>(
          'inflate_TookeyScenarios_SignECDSA');
  late final _inflate_TookeyScenarios_SignECDSA =
      _inflate_TookeyScenarios_SignECDSAPtr
          .asFunction<ffi.Pointer<TookeyScenariosKind> Function()>();

  void free_WireSyncReturnStruct(
    WireSyncReturnStruct val,
  ) {
    return _free_WireSyncReturnStruct(
      val,
    );
  }

  late final _free_WireSyncReturnStructPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(WireSyncReturnStruct)>>(
          'free_WireSyncReturnStruct');
  late final _free_WireSyncReturnStruct = _free_WireSyncReturnStructPtr
      .asFunction<void Function(WireSyncReturnStruct)>();
}

class wire_uint_8_list extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.Int32()
  external int len;
}

class wire_TookeyScenarios_KeygenECDSA extends ffi.Struct {
  @ffi.Uint16()
  external int index;

  @ffi.Uint16()
  external int parties;

  @ffi.Uint16()
  external int threashold;
}

class wire_uint_16_list extends ffi.Struct {
  external ffi.Pointer<ffi.Uint16> ptr;

  @ffi.Int32()
  external int len;
}

class wire_TookeyScenarios_SignECDSA extends ffi.Struct {
  external ffi.Pointer<wire_uint_16_list> parties;

  external ffi.Pointer<wire_uint_8_list> key;

  external ffi.Pointer<wire_uint_8_list> hash;
}

class TookeyScenariosKind extends ffi.Union {
  external ffi.Pointer<wire_TookeyScenarios_KeygenECDSA> KeygenECDSA;

  external ffi.Pointer<wire_TookeyScenarios_SignECDSA> SignECDSA;
}

class wire_TookeyScenarios extends ffi.Struct {
  @ffi.Int32()
  external int tag;

  external ffi.Pointer<TookeyScenariosKind> kind;
}

class wire_IncomingMessage_Begin extends ffi.Struct {
  external ffi.Pointer<wire_TookeyScenarios> scenario;
}

class wire_IncomingMessage_Participant extends ffi.Struct {
  @ffi.Uint16()
  external int index;

  external ffi.Pointer<ffi.Uint16> party;
}

class wire_IncomingMessage_Group extends ffi.Struct {
  external ffi.Pointer<wire_uint_16_list> indexes;

  external ffi.Pointer<wire_uint_16_list> parties;
}

class wire_IncomingMessage_Communication extends ffi.Struct {
  external ffi.Pointer<wire_uint_8_list> packet;
}

class wire_IncomingMessage_Close extends ffi.Opaque {}

class IncomingMessageKind extends ffi.Union {
  external ffi.Pointer<wire_IncomingMessage_Begin> Begin;

  external ffi.Pointer<wire_IncomingMessage_Participant> Participant;

  external ffi.Pointer<wire_IncomingMessage_Group> Group;

  external ffi.Pointer<wire_IncomingMessage_Communication> Communication;

  external ffi.Pointer<wire_IncomingMessage_Close> Close;
}

class wire_IncomingMessage extends ffi.Struct {
  @ffi.Int32()
  external int tag;

  external ffi.Pointer<IncomingMessageKind> kind;
}

typedef DartPostCObjectFnType = ffi.Pointer<
    ffi.NativeFunction<ffi.Bool Function(DartPort, ffi.Pointer<ffi.Void>)>>;
typedef DartPort = ffi.Int64;
