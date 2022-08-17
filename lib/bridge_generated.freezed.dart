// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'bridge_generated.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$IncomingMessage {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) msg,
    required TResult Function(int field0) multiply,
    required TResult Function() close,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String field0)? msg,
    TResult Function(int field0)? multiply,
    TResult Function()? close,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? msg,
    TResult Function(int field0)? multiply,
    TResult Function()? close,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IncomingMessage_Msg value) msg,
    required TResult Function(IncomingMessage_Multiply value) multiply,
    required TResult Function(IncomingMessage_Close value) close,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(IncomingMessage_Msg value)? msg,
    TResult Function(IncomingMessage_Multiply value)? multiply,
    TResult Function(IncomingMessage_Close value)? close,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IncomingMessage_Msg value)? msg,
    TResult Function(IncomingMessage_Multiply value)? multiply,
    TResult Function(IncomingMessage_Close value)? close,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IncomingMessageCopyWith<$Res> {
  factory $IncomingMessageCopyWith(
          IncomingMessage value, $Res Function(IncomingMessage) then) =
      _$IncomingMessageCopyWithImpl<$Res>;
}

/// @nodoc
class _$IncomingMessageCopyWithImpl<$Res>
    implements $IncomingMessageCopyWith<$Res> {
  _$IncomingMessageCopyWithImpl(this._value, this._then);

  final IncomingMessage _value;
  // ignore: unused_field
  final $Res Function(IncomingMessage) _then;
}

/// @nodoc
abstract class _$$IncomingMessage_MsgCopyWith<$Res> {
  factory _$$IncomingMessage_MsgCopyWith(_$IncomingMessage_Msg value,
          $Res Function(_$IncomingMessage_Msg) then) =
      __$$IncomingMessage_MsgCopyWithImpl<$Res>;
  $Res call({String field0});
}

/// @nodoc
class __$$IncomingMessage_MsgCopyWithImpl<$Res>
    extends _$IncomingMessageCopyWithImpl<$Res>
    implements _$$IncomingMessage_MsgCopyWith<$Res> {
  __$$IncomingMessage_MsgCopyWithImpl(
      _$IncomingMessage_Msg _value, $Res Function(_$IncomingMessage_Msg) _then)
      : super(_value, (v) => _then(v as _$IncomingMessage_Msg));

  @override
  _$IncomingMessage_Msg get _value => super._value as _$IncomingMessage_Msg;

  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$IncomingMessage_Msg(
      field0 == freezed
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$IncomingMessage_Msg implements IncomingMessage_Msg {
  const _$IncomingMessage_Msg(this.field0);

  @override
  final String field0;

  @override
  String toString() {
    return 'IncomingMessage.msg(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomingMessage_Msg &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  @JsonKey(ignore: true)
  @override
  _$$IncomingMessage_MsgCopyWith<_$IncomingMessage_Msg> get copyWith =>
      __$$IncomingMessage_MsgCopyWithImpl<_$IncomingMessage_Msg>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) msg,
    required TResult Function(int field0) multiply,
    required TResult Function() close,
  }) {
    return msg(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String field0)? msg,
    TResult Function(int field0)? multiply,
    TResult Function()? close,
  }) {
    return msg?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? msg,
    TResult Function(int field0)? multiply,
    TResult Function()? close,
    required TResult orElse(),
  }) {
    if (msg != null) {
      return msg(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IncomingMessage_Msg value) msg,
    required TResult Function(IncomingMessage_Multiply value) multiply,
    required TResult Function(IncomingMessage_Close value) close,
  }) {
    return msg(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(IncomingMessage_Msg value)? msg,
    TResult Function(IncomingMessage_Multiply value)? multiply,
    TResult Function(IncomingMessage_Close value)? close,
  }) {
    return msg?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IncomingMessage_Msg value)? msg,
    TResult Function(IncomingMessage_Multiply value)? multiply,
    TResult Function(IncomingMessage_Close value)? close,
    required TResult orElse(),
  }) {
    if (msg != null) {
      return msg(this);
    }
    return orElse();
  }
}

abstract class IncomingMessage_Msg implements IncomingMessage {
  const factory IncomingMessage_Msg(final String field0) =
      _$IncomingMessage_Msg;

  String get field0;
  @JsonKey(ignore: true)
  _$$IncomingMessage_MsgCopyWith<_$IncomingMessage_Msg> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IncomingMessage_MultiplyCopyWith<$Res> {
  factory _$$IncomingMessage_MultiplyCopyWith(_$IncomingMessage_Multiply value,
          $Res Function(_$IncomingMessage_Multiply) then) =
      __$$IncomingMessage_MultiplyCopyWithImpl<$Res>;
  $Res call({int field0});
}

/// @nodoc
class __$$IncomingMessage_MultiplyCopyWithImpl<$Res>
    extends _$IncomingMessageCopyWithImpl<$Res>
    implements _$$IncomingMessage_MultiplyCopyWith<$Res> {
  __$$IncomingMessage_MultiplyCopyWithImpl(_$IncomingMessage_Multiply _value,
      $Res Function(_$IncomingMessage_Multiply) _then)
      : super(_value, (v) => _then(v as _$IncomingMessage_Multiply));

  @override
  _$IncomingMessage_Multiply get _value =>
      super._value as _$IncomingMessage_Multiply;

  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$IncomingMessage_Multiply(
      field0 == freezed
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$IncomingMessage_Multiply implements IncomingMessage_Multiply {
  const _$IncomingMessage_Multiply(this.field0);

  @override
  final int field0;

  @override
  String toString() {
    return 'IncomingMessage.multiply(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomingMessage_Multiply &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  @JsonKey(ignore: true)
  @override
  _$$IncomingMessage_MultiplyCopyWith<_$IncomingMessage_Multiply>
      get copyWith =>
          __$$IncomingMessage_MultiplyCopyWithImpl<_$IncomingMessage_Multiply>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) msg,
    required TResult Function(int field0) multiply,
    required TResult Function() close,
  }) {
    return multiply(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String field0)? msg,
    TResult Function(int field0)? multiply,
    TResult Function()? close,
  }) {
    return multiply?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? msg,
    TResult Function(int field0)? multiply,
    TResult Function()? close,
    required TResult orElse(),
  }) {
    if (multiply != null) {
      return multiply(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IncomingMessage_Msg value) msg,
    required TResult Function(IncomingMessage_Multiply value) multiply,
    required TResult Function(IncomingMessage_Close value) close,
  }) {
    return multiply(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(IncomingMessage_Msg value)? msg,
    TResult Function(IncomingMessage_Multiply value)? multiply,
    TResult Function(IncomingMessage_Close value)? close,
  }) {
    return multiply?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IncomingMessage_Msg value)? msg,
    TResult Function(IncomingMessage_Multiply value)? multiply,
    TResult Function(IncomingMessage_Close value)? close,
    required TResult orElse(),
  }) {
    if (multiply != null) {
      return multiply(this);
    }
    return orElse();
  }
}

abstract class IncomingMessage_Multiply implements IncomingMessage {
  const factory IncomingMessage_Multiply(final int field0) =
      _$IncomingMessage_Multiply;

  int get field0;
  @JsonKey(ignore: true)
  _$$IncomingMessage_MultiplyCopyWith<_$IncomingMessage_Multiply>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IncomingMessage_CloseCopyWith<$Res> {
  factory _$$IncomingMessage_CloseCopyWith(_$IncomingMessage_Close value,
          $Res Function(_$IncomingMessage_Close) then) =
      __$$IncomingMessage_CloseCopyWithImpl<$Res>;
}

/// @nodoc
class __$$IncomingMessage_CloseCopyWithImpl<$Res>
    extends _$IncomingMessageCopyWithImpl<$Res>
    implements _$$IncomingMessage_CloseCopyWith<$Res> {
  __$$IncomingMessage_CloseCopyWithImpl(_$IncomingMessage_Close _value,
      $Res Function(_$IncomingMessage_Close) _then)
      : super(_value, (v) => _then(v as _$IncomingMessage_Close));

  @override
  _$IncomingMessage_Close get _value => super._value as _$IncomingMessage_Close;
}

/// @nodoc

class _$IncomingMessage_Close implements IncomingMessage_Close {
  const _$IncomingMessage_Close();

  @override
  String toString() {
    return 'IncomingMessage.close()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$IncomingMessage_Close);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) msg,
    required TResult Function(int field0) multiply,
    required TResult Function() close,
  }) {
    return close();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String field0)? msg,
    TResult Function(int field0)? multiply,
    TResult Function()? close,
  }) {
    return close?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? msg,
    TResult Function(int field0)? multiply,
    TResult Function()? close,
    required TResult orElse(),
  }) {
    if (close != null) {
      return close();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IncomingMessage_Msg value) msg,
    required TResult Function(IncomingMessage_Multiply value) multiply,
    required TResult Function(IncomingMessage_Close value) close,
  }) {
    return close(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(IncomingMessage_Msg value)? msg,
    TResult Function(IncomingMessage_Multiply value)? multiply,
    TResult Function(IncomingMessage_Close value)? close,
  }) {
    return close?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IncomingMessage_Msg value)? msg,
    TResult Function(IncomingMessage_Multiply value)? multiply,
    TResult Function(IncomingMessage_Close value)? close,
    required TResult orElse(),
  }) {
    if (close != null) {
      return close(this);
    }
    return orElse();
  }
}

abstract class IncomingMessage_Close implements IncomingMessage {
  const factory IncomingMessage_Close() = _$IncomingMessage_Close;
}

/// @nodoc
mixin _$OutgoingMessage {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) msg,
    required TResult Function(int field0) multiply,
    required TResult Function() close,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String field0)? msg,
    TResult Function(int field0)? multiply,
    TResult Function()? close,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? msg,
    TResult Function(int field0)? multiply,
    TResult Function()? close,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutgoingMessage_Msg value) msg,
    required TResult Function(OutgoingMessage_Multiply value) multiply,
    required TResult Function(OutgoingMessage_Close value) close,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(OutgoingMessage_Msg value)? msg,
    TResult Function(OutgoingMessage_Multiply value)? multiply,
    TResult Function(OutgoingMessage_Close value)? close,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutgoingMessage_Msg value)? msg,
    TResult Function(OutgoingMessage_Multiply value)? multiply,
    TResult Function(OutgoingMessage_Close value)? close,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OutgoingMessageCopyWith<$Res> {
  factory $OutgoingMessageCopyWith(
          OutgoingMessage value, $Res Function(OutgoingMessage) then) =
      _$OutgoingMessageCopyWithImpl<$Res>;
}

/// @nodoc
class _$OutgoingMessageCopyWithImpl<$Res>
    implements $OutgoingMessageCopyWith<$Res> {
  _$OutgoingMessageCopyWithImpl(this._value, this._then);

  final OutgoingMessage _value;
  // ignore: unused_field
  final $Res Function(OutgoingMessage) _then;
}

/// @nodoc
abstract class _$$OutgoingMessage_MsgCopyWith<$Res> {
  factory _$$OutgoingMessage_MsgCopyWith(_$OutgoingMessage_Msg value,
          $Res Function(_$OutgoingMessage_Msg) then) =
      __$$OutgoingMessage_MsgCopyWithImpl<$Res>;
  $Res call({String field0});
}

/// @nodoc
class __$$OutgoingMessage_MsgCopyWithImpl<$Res>
    extends _$OutgoingMessageCopyWithImpl<$Res>
    implements _$$OutgoingMessage_MsgCopyWith<$Res> {
  __$$OutgoingMessage_MsgCopyWithImpl(
      _$OutgoingMessage_Msg _value, $Res Function(_$OutgoingMessage_Msg) _then)
      : super(_value, (v) => _then(v as _$OutgoingMessage_Msg));

  @override
  _$OutgoingMessage_Msg get _value => super._value as _$OutgoingMessage_Msg;

  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$OutgoingMessage_Msg(
      field0 == freezed
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$OutgoingMessage_Msg implements OutgoingMessage_Msg {
  const _$OutgoingMessage_Msg(this.field0);

  @override
  final String field0;

  @override
  String toString() {
    return 'OutgoingMessage.msg(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutgoingMessage_Msg &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  @JsonKey(ignore: true)
  @override
  _$$OutgoingMessage_MsgCopyWith<_$OutgoingMessage_Msg> get copyWith =>
      __$$OutgoingMessage_MsgCopyWithImpl<_$OutgoingMessage_Msg>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) msg,
    required TResult Function(int field0) multiply,
    required TResult Function() close,
  }) {
    return msg(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String field0)? msg,
    TResult Function(int field0)? multiply,
    TResult Function()? close,
  }) {
    return msg?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? msg,
    TResult Function(int field0)? multiply,
    TResult Function()? close,
    required TResult orElse(),
  }) {
    if (msg != null) {
      return msg(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutgoingMessage_Msg value) msg,
    required TResult Function(OutgoingMessage_Multiply value) multiply,
    required TResult Function(OutgoingMessage_Close value) close,
  }) {
    return msg(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(OutgoingMessage_Msg value)? msg,
    TResult Function(OutgoingMessage_Multiply value)? multiply,
    TResult Function(OutgoingMessage_Close value)? close,
  }) {
    return msg?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutgoingMessage_Msg value)? msg,
    TResult Function(OutgoingMessage_Multiply value)? multiply,
    TResult Function(OutgoingMessage_Close value)? close,
    required TResult orElse(),
  }) {
    if (msg != null) {
      return msg(this);
    }
    return orElse();
  }
}

abstract class OutgoingMessage_Msg implements OutgoingMessage {
  const factory OutgoingMessage_Msg(final String field0) =
      _$OutgoingMessage_Msg;

  String get field0;
  @JsonKey(ignore: true)
  _$$OutgoingMessage_MsgCopyWith<_$OutgoingMessage_Msg> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OutgoingMessage_MultiplyCopyWith<$Res> {
  factory _$$OutgoingMessage_MultiplyCopyWith(_$OutgoingMessage_Multiply value,
          $Res Function(_$OutgoingMessage_Multiply) then) =
      __$$OutgoingMessage_MultiplyCopyWithImpl<$Res>;
  $Res call({int field0});
}

/// @nodoc
class __$$OutgoingMessage_MultiplyCopyWithImpl<$Res>
    extends _$OutgoingMessageCopyWithImpl<$Res>
    implements _$$OutgoingMessage_MultiplyCopyWith<$Res> {
  __$$OutgoingMessage_MultiplyCopyWithImpl(_$OutgoingMessage_Multiply _value,
      $Res Function(_$OutgoingMessage_Multiply) _then)
      : super(_value, (v) => _then(v as _$OutgoingMessage_Multiply));

  @override
  _$OutgoingMessage_Multiply get _value =>
      super._value as _$OutgoingMessage_Multiply;

  @override
  $Res call({
    Object? field0 = freezed,
  }) {
    return _then(_$OutgoingMessage_Multiply(
      field0 == freezed
          ? _value.field0
          : field0 // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$OutgoingMessage_Multiply implements OutgoingMessage_Multiply {
  const _$OutgoingMessage_Multiply(this.field0);

  @override
  final int field0;

  @override
  String toString() {
    return 'OutgoingMessage.multiply(field0: $field0)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutgoingMessage_Multiply &&
            const DeepCollectionEquality().equals(other.field0, field0));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(field0));

  @JsonKey(ignore: true)
  @override
  _$$OutgoingMessage_MultiplyCopyWith<_$OutgoingMessage_Multiply>
      get copyWith =>
          __$$OutgoingMessage_MultiplyCopyWithImpl<_$OutgoingMessage_Multiply>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) msg,
    required TResult Function(int field0) multiply,
    required TResult Function() close,
  }) {
    return multiply(field0);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String field0)? msg,
    TResult Function(int field0)? multiply,
    TResult Function()? close,
  }) {
    return multiply?.call(field0);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? msg,
    TResult Function(int field0)? multiply,
    TResult Function()? close,
    required TResult orElse(),
  }) {
    if (multiply != null) {
      return multiply(field0);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutgoingMessage_Msg value) msg,
    required TResult Function(OutgoingMessage_Multiply value) multiply,
    required TResult Function(OutgoingMessage_Close value) close,
  }) {
    return multiply(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(OutgoingMessage_Msg value)? msg,
    TResult Function(OutgoingMessage_Multiply value)? multiply,
    TResult Function(OutgoingMessage_Close value)? close,
  }) {
    return multiply?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutgoingMessage_Msg value)? msg,
    TResult Function(OutgoingMessage_Multiply value)? multiply,
    TResult Function(OutgoingMessage_Close value)? close,
    required TResult orElse(),
  }) {
    if (multiply != null) {
      return multiply(this);
    }
    return orElse();
  }
}

abstract class OutgoingMessage_Multiply implements OutgoingMessage {
  const factory OutgoingMessage_Multiply(final int field0) =
      _$OutgoingMessage_Multiply;

  int get field0;
  @JsonKey(ignore: true)
  _$$OutgoingMessage_MultiplyCopyWith<_$OutgoingMessage_Multiply>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OutgoingMessage_CloseCopyWith<$Res> {
  factory _$$OutgoingMessage_CloseCopyWith(_$OutgoingMessage_Close value,
          $Res Function(_$OutgoingMessage_Close) then) =
      __$$OutgoingMessage_CloseCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OutgoingMessage_CloseCopyWithImpl<$Res>
    extends _$OutgoingMessageCopyWithImpl<$Res>
    implements _$$OutgoingMessage_CloseCopyWith<$Res> {
  __$$OutgoingMessage_CloseCopyWithImpl(_$OutgoingMessage_Close _value,
      $Res Function(_$OutgoingMessage_Close) _then)
      : super(_value, (v) => _then(v as _$OutgoingMessage_Close));

  @override
  _$OutgoingMessage_Close get _value => super._value as _$OutgoingMessage_Close;
}

/// @nodoc

class _$OutgoingMessage_Close implements OutgoingMessage_Close {
  const _$OutgoingMessage_Close();

  @override
  String toString() {
    return 'OutgoingMessage.close()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OutgoingMessage_Close);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String field0) msg,
    required TResult Function(int field0) multiply,
    required TResult Function() close,
  }) {
    return close();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(String field0)? msg,
    TResult Function(int field0)? multiply,
    TResult Function()? close,
  }) {
    return close?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String field0)? msg,
    TResult Function(int field0)? multiply,
    TResult Function()? close,
    required TResult orElse(),
  }) {
    if (close != null) {
      return close();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutgoingMessage_Msg value) msg,
    required TResult Function(OutgoingMessage_Multiply value) multiply,
    required TResult Function(OutgoingMessage_Close value) close,
  }) {
    return close(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(OutgoingMessage_Msg value)? msg,
    TResult Function(OutgoingMessage_Multiply value)? multiply,
    TResult Function(OutgoingMessage_Close value)? close,
  }) {
    return close?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutgoingMessage_Msg value)? msg,
    TResult Function(OutgoingMessage_Multiply value)? multiply,
    TResult Function(OutgoingMessage_Close value)? close,
    required TResult orElse(),
  }) {
    if (close != null) {
      return close(this);
    }
    return orElse();
  }
}

abstract class OutgoingMessage_Close implements OutgoingMessage {
  const factory OutgoingMessage_Close() = _$OutgoingMessage_Close;
}
