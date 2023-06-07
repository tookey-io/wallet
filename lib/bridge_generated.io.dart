// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.77.1.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import "bridge_definitions.dart";
import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';
import 'bridge_generated.dart';
export 'bridge_generated.dart';
import 'dart:ffi' as ffi;

class NativePlatform extends FlutterRustBridgeBase<NativeWire> {
  NativePlatform(ffi.DynamicLibrary dylib) : super(NativeWire(dylib));

// Section: api2wire

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_String(String raw) {
    return api2wire_uint_8_list(utf8.encoder.convert(raw));
  }

  @protected
  ffi.Pointer<wire_KeygenParams> api2wire_box_autoadd_keygen_params(
      KeygenParams raw) {
    final ptr = inner.new_box_autoadd_keygen_params_0();
    _api_fill_to_wire_keygen_params(raw, ptr.ref);
    return ptr;
  }

  @protected
  ffi.Pointer<wire_SignParams> api2wire_box_autoadd_sign_params(
      SignParams raw) {
    final ptr = inner.new_box_autoadd_sign_params_0();
    _api_fill_to_wire_sign_params(raw, ptr.ref);
    return ptr;
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
// Section: finalizer

// Section: api_fill_to_wire

  void _api_fill_to_wire_box_autoadd_keygen_params(
      KeygenParams apiObj, ffi.Pointer<wire_KeygenParams> wireObj) {
    _api_fill_to_wire_keygen_params(apiObj, wireObj.ref);
  }

  void _api_fill_to_wire_box_autoadd_sign_params(
      SignParams apiObj, ffi.Pointer<wire_SignParams> wireObj) {
    _api_fill_to_wire_sign_params(apiObj, wireObj.ref);
  }

  void _api_fill_to_wire_keygen_params(
      KeygenParams apiObj, wire_KeygenParams wireObj) {
    wireObj.room_id = api2wire_String(apiObj.roomId);
    wireObj.participant_index = api2wire_u16(apiObj.participantIndex);
    wireObj.participants_count = api2wire_u16(apiObj.participantsCount);
    wireObj.participants_threshold = api2wire_u16(apiObj.participantsThreshold);
    wireObj.relay_address = api2wire_String(apiObj.relayAddress);
    wireObj.timeout_seconds = api2wire_u16(apiObj.timeoutSeconds);
  }

  void _api_fill_to_wire_sign_params(
      SignParams apiObj, wire_SignParams wireObj) {
    wireObj.room_id = api2wire_String(apiObj.roomId);
    wireObj.key = api2wire_String(apiObj.key);
    wireObj.data = api2wire_String(apiObj.data);
    wireObj.participants_indexes =
        api2wire_uint_16_list(apiObj.participantsIndexes);
    wireObj.relay_address = api2wire_String(apiObj.relayAddress);
    wireObj.timeout_seconds = api2wire_u16(apiObj.timeoutSeconds);
  }
}

// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_positional_boolean_parameters, annotate_overrides, constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint

/// generated by flutter_rust_bridge
class NativeWire implements FlutterRustBridgeWireBase {
  @internal
  late final dartApi = DartApiDl(init_frb_dart_api_dl);

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

  Object get_dart_object(
    int ptr,
  ) {
    return _get_dart_object(
      ptr,
    );
  }

  late final _get_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Handle Function(ffi.UintPtr)>>(
          'get_dart_object');
  late final _get_dart_object =
      _get_dart_objectPtr.asFunction<Object Function(int)>();

  void drop_dart_object(
    int ptr,
  ) {
    return _drop_dart_object(
      ptr,
    );
  }

  late final _drop_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.UintPtr)>>(
          'drop_dart_object');
  late final _drop_dart_object =
      _drop_dart_objectPtr.asFunction<void Function(int)>();

  int new_dart_opaque(
    Object handle,
  ) {
    return _new_dart_opaque(
      handle,
    );
  }

  late final _new_dart_opaquePtr =
      _lookup<ffi.NativeFunction<ffi.UintPtr Function(ffi.Handle)>>(
          'new_dart_opaque');
  late final _new_dart_opaque =
      _new_dart_opaquePtr.asFunction<int Function(Object)>();

  int init_frb_dart_api_dl(
    ffi.Pointer<ffi.Void> obj,
  ) {
    return _init_frb_dart_api_dl(
      obj,
    );
  }

  late final _init_frb_dart_api_dlPtr =
      _lookup<ffi.NativeFunction<ffi.IntPtr Function(ffi.Pointer<ffi.Void>)>>(
          'init_frb_dart_api_dl');
  late final _init_frb_dart_api_dl = _init_frb_dart_api_dlPtr
      .asFunction<int Function(ffi.Pointer<ffi.Void>)>();

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

  void wire_public_key_to_ethereum_address(
    int port_,
    ffi.Pointer<wire_uint_8_list> public_key,
  ) {
    return _wire_public_key_to_ethereum_address(
      port_,
      public_key,
    );
  }

  late final _wire_public_key_to_ethereum_addressPtr = _lookup<
          ffi.NativeFunction<
              ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>(
      'wire_public_key_to_ethereum_address');
  late final _wire_public_key_to_ethereum_address =
      _wire_public_key_to_ethereum_addressPtr
          .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_private_key_to_public_key(
    int port_,
    ffi.Pointer<wire_uint_8_list> private_key,
    bool compressed,
  ) {
    return _wire_private_key_to_public_key(
      port_,
      private_key,
      compressed,
    );
  }

  late final _wire_private_key_to_public_keyPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>,
              ffi.Bool)>>('wire_private_key_to_public_key');
  late final _wire_private_key_to_public_key =
      _wire_private_key_to_public_keyPtr.asFunction<
          void Function(int, ffi.Pointer<wire_uint_8_list>, bool)>();

  void wire_private_key_to_ethereum_address(
    int port_,
    ffi.Pointer<wire_uint_8_list> private_key,
  ) {
    return _wire_private_key_to_ethereum_address(
      port_,
      private_key,
    );
  }

  late final _wire_private_key_to_ethereum_addressPtr = _lookup<
          ffi.NativeFunction<
              ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>(
      'wire_private_key_to_ethereum_address');
  late final _wire_private_key_to_ethereum_address =
      _wire_private_key_to_ethereum_addressPtr
          .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_transaction_to_message_hash(
    int port_,
    ffi.Pointer<wire_uint_8_list> tx_request,
  ) {
    return _wire_transaction_to_message_hash(
      port_,
      tx_request,
    );
  }

  late final _wire_transaction_to_message_hashPtr = _lookup<
          ffi.NativeFunction<
              ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>(
      'wire_transaction_to_message_hash');
  late final _wire_transaction_to_message_hash =
      _wire_transaction_to_message_hashPtr
          .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_message_to_hash(
    int port_,
    ffi.Pointer<wire_uint_8_list> data,
  ) {
    return _wire_message_to_hash(
      port_,
      data,
    );
  }

  late final _wire_message_to_hashPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64,
              ffi.Pointer<wire_uint_8_list>)>>('wire_message_to_hash');
  late final _wire_message_to_hash = _wire_message_to_hashPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_encode_message_signature(
    int port_,
    ffi.Pointer<wire_uint_8_list> message_hash,
    int chain_id,
    ffi.Pointer<wire_uint_8_list> signature_recid,
  ) {
    return _wire_encode_message_signature(
      port_,
      message_hash,
      chain_id,
      signature_recid,
    );
  }

  late final _wire_encode_message_signaturePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64,
              ffi.Pointer<wire_uint_8_list>,
              ffi.Uint32,
              ffi.Pointer<wire_uint_8_list>)>>('wire_encode_message_signature');
  late final _wire_encode_message_signature =
      _wire_encode_message_signaturePtr.asFunction<
          void Function(int, ffi.Pointer<wire_uint_8_list>, int,
              ffi.Pointer<wire_uint_8_list>)>();

  void wire_encode_transaction(
    int port_,
    ffi.Pointer<wire_uint_8_list> tx_request,
    ffi.Pointer<wire_uint_8_list> signature_recid,
  ) {
    return _wire_encode_transaction(
      port_,
      tx_request,
      signature_recid,
    );
  }

  late final _wire_encode_transactionPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64, ffi.Pointer<wire_uint_8_list>,
              ffi.Pointer<wire_uint_8_list>)>>('wire_encode_transaction');
  late final _wire_encode_transaction = _wire_encode_transactionPtr.asFunction<
      void Function(
          int, ffi.Pointer<wire_uint_8_list>, ffi.Pointer<wire_uint_8_list>)>();

  void wire_keygen(
    int port_,
    ffi.Pointer<wire_KeygenParams> params,
  ) {
    return _wire_keygen(
      port_,
      params,
    );
  }

  late final _wire_keygenPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64, ffi.Pointer<wire_KeygenParams>)>>('wire_keygen');
  late final _wire_keygen = _wire_keygenPtr
      .asFunction<void Function(int, ffi.Pointer<wire_KeygenParams>)>();

  void wire_sign(
    int port_,
    ffi.Pointer<wire_SignParams> params,
  ) {
    return _wire_sign(
      port_,
      params,
    );
  }

  late final _wire_signPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64, ffi.Pointer<wire_SignParams>)>>('wire_sign');
  late final _wire_sign = _wire_signPtr
      .asFunction<void Function(int, ffi.Pointer<wire_SignParams>)>();

  ffi.Pointer<wire_KeygenParams> new_box_autoadd_keygen_params_0() {
    return _new_box_autoadd_keygen_params_0();
  }

  late final _new_box_autoadd_keygen_params_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<wire_KeygenParams> Function()>>(
          'new_box_autoadd_keygen_params_0');
  late final _new_box_autoadd_keygen_params_0 =
      _new_box_autoadd_keygen_params_0Ptr
          .asFunction<ffi.Pointer<wire_KeygenParams> Function()>();

  ffi.Pointer<wire_SignParams> new_box_autoadd_sign_params_0() {
    return _new_box_autoadd_sign_params_0();
  }

  late final _new_box_autoadd_sign_params_0Ptr =
      _lookup<ffi.NativeFunction<ffi.Pointer<wire_SignParams> Function()>>(
          'new_box_autoadd_sign_params_0');
  late final _new_box_autoadd_sign_params_0 = _new_box_autoadd_sign_params_0Ptr
      .asFunction<ffi.Pointer<wire_SignParams> Function()>();

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

  void free_WireSyncReturn(
    WireSyncReturn ptr,
  ) {
    return _free_WireSyncReturn(
      ptr,
    );
  }

  late final _free_WireSyncReturnPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(WireSyncReturn)>>(
          'free_WireSyncReturn');
  late final _free_WireSyncReturn =
      _free_WireSyncReturnPtr.asFunction<void Function(WireSyncReturn)>();
}

final class _Dart_Handle extends ffi.Opaque {}

final class wire_uint_8_list extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_KeygenParams extends ffi.Struct {
  external ffi.Pointer<wire_uint_8_list> room_id;

  @ffi.Uint16()
  external int participant_index;

  @ffi.Uint16()
  external int participants_count;

  @ffi.Uint16()
  external int participants_threshold;

  external ffi.Pointer<wire_uint_8_list> relay_address;

  @ffi.Uint16()
  external int timeout_seconds;
}

final class wire_uint_16_list extends ffi.Struct {
  external ffi.Pointer<ffi.Uint16> ptr;

  @ffi.Int32()
  external int len;
}

final class wire_SignParams extends ffi.Struct {
  external ffi.Pointer<wire_uint_8_list> room_id;

  external ffi.Pointer<wire_uint_8_list> key;

  external ffi.Pointer<wire_uint_8_list> data;

  external ffi.Pointer<wire_uint_16_list> participants_indexes;

  external ffi.Pointer<wire_uint_8_list> relay_address;

  @ffi.Uint16()
  external int timeout_seconds;
}

typedef DartPostCObjectFnType = ffi.Pointer<
    ffi.NativeFunction<
        ffi.Bool Function(DartPort port_id, ffi.Pointer<ffi.Void> message)>>;
typedef DartPort = ffi.Int64;
