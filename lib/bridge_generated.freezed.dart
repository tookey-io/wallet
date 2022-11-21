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
    required TResult Function(TookeyScenarios scenario) begin,
    required TResult Function(int index, int? party) participant,
    required TResult Function(Uint16List indexes, Uint16List parties) group,
    required TResult Function(String packet) communication,
    required TResult Function() close,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(TookeyScenarios scenario)? begin,
    TResult Function(int index, int? party)? participant,
    TResult Function(Uint16List indexes, Uint16List parties)? group,
    TResult Function(String packet)? communication,
    TResult Function()? close,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(TookeyScenarios scenario)? begin,
    TResult Function(int index, int? party)? participant,
    TResult Function(Uint16List indexes, Uint16List parties)? group,
    TResult Function(String packet)? communication,
    TResult Function()? close,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IncomingMessage_Begin value) begin,
    required TResult Function(IncomingMessage_Participant value) participant,
    required TResult Function(IncomingMessage_Group value) group,
    required TResult Function(IncomingMessage_Communication value)
        communication,
    required TResult Function(IncomingMessage_Close value) close,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(IncomingMessage_Begin value)? begin,
    TResult Function(IncomingMessage_Participant value)? participant,
    TResult Function(IncomingMessage_Group value)? group,
    TResult Function(IncomingMessage_Communication value)? communication,
    TResult Function(IncomingMessage_Close value)? close,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IncomingMessage_Begin value)? begin,
    TResult Function(IncomingMessage_Participant value)? participant,
    TResult Function(IncomingMessage_Group value)? group,
    TResult Function(IncomingMessage_Communication value)? communication,
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
abstract class _$$IncomingMessage_BeginCopyWith<$Res> {
  factory _$$IncomingMessage_BeginCopyWith(_$IncomingMessage_Begin value,
          $Res Function(_$IncomingMessage_Begin) then) =
      __$$IncomingMessage_BeginCopyWithImpl<$Res>;
  $Res call({TookeyScenarios scenario});

  $TookeyScenariosCopyWith<$Res> get scenario;
}

/// @nodoc
class __$$IncomingMessage_BeginCopyWithImpl<$Res>
    extends _$IncomingMessageCopyWithImpl<$Res>
    implements _$$IncomingMessage_BeginCopyWith<$Res> {
  __$$IncomingMessage_BeginCopyWithImpl(_$IncomingMessage_Begin _value,
      $Res Function(_$IncomingMessage_Begin) _then)
      : super(_value, (v) => _then(v as _$IncomingMessage_Begin));

  @override
  _$IncomingMessage_Begin get _value => super._value as _$IncomingMessage_Begin;

  @override
  $Res call({
    Object? scenario = freezed,
  }) {
    return _then(_$IncomingMessage_Begin(
      scenario: scenario == freezed
          ? _value.scenario
          : scenario // ignore: cast_nullable_to_non_nullable
              as TookeyScenarios,
    ));
  }

  @override
  $TookeyScenariosCopyWith<$Res> get scenario {
    return $TookeyScenariosCopyWith<$Res>(_value.scenario, (value) {
      return _then(_value.copyWith(scenario: value));
    });
  }
}

/// @nodoc

class _$IncomingMessage_Begin implements IncomingMessage_Begin {
  const _$IncomingMessage_Begin({required this.scenario});

  @override
  final TookeyScenarios scenario;

  @override
  String toString() {
    return 'IncomingMessage.begin(scenario: $scenario)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomingMessage_Begin &&
            const DeepCollectionEquality().equals(other.scenario, scenario));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(scenario));

  @JsonKey(ignore: true)
  @override
  _$$IncomingMessage_BeginCopyWith<_$IncomingMessage_Begin> get copyWith =>
      __$$IncomingMessage_BeginCopyWithImpl<_$IncomingMessage_Begin>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(TookeyScenarios scenario) begin,
    required TResult Function(int index, int? party) participant,
    required TResult Function(Uint16List indexes, Uint16List parties) group,
    required TResult Function(String packet) communication,
    required TResult Function() close,
  }) {
    return begin(scenario);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(TookeyScenarios scenario)? begin,
    TResult Function(int index, int? party)? participant,
    TResult Function(Uint16List indexes, Uint16List parties)? group,
    TResult Function(String packet)? communication,
    TResult Function()? close,
  }) {
    return begin?.call(scenario);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(TookeyScenarios scenario)? begin,
    TResult Function(int index, int? party)? participant,
    TResult Function(Uint16List indexes, Uint16List parties)? group,
    TResult Function(String packet)? communication,
    TResult Function()? close,
    required TResult orElse(),
  }) {
    if (begin != null) {
      return begin(scenario);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IncomingMessage_Begin value) begin,
    required TResult Function(IncomingMessage_Participant value) participant,
    required TResult Function(IncomingMessage_Group value) group,
    required TResult Function(IncomingMessage_Communication value)
        communication,
    required TResult Function(IncomingMessage_Close value) close,
  }) {
    return begin(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(IncomingMessage_Begin value)? begin,
    TResult Function(IncomingMessage_Participant value)? participant,
    TResult Function(IncomingMessage_Group value)? group,
    TResult Function(IncomingMessage_Communication value)? communication,
    TResult Function(IncomingMessage_Close value)? close,
  }) {
    return begin?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IncomingMessage_Begin value)? begin,
    TResult Function(IncomingMessage_Participant value)? participant,
    TResult Function(IncomingMessage_Group value)? group,
    TResult Function(IncomingMessage_Communication value)? communication,
    TResult Function(IncomingMessage_Close value)? close,
    required TResult orElse(),
  }) {
    if (begin != null) {
      return begin(this);
    }
    return orElse();
  }
}

abstract class IncomingMessage_Begin implements IncomingMessage {
  const factory IncomingMessage_Begin(
      {required final TookeyScenarios scenario}) = _$IncomingMessage_Begin;

  TookeyScenarios get scenario;
  @JsonKey(ignore: true)
  _$$IncomingMessage_BeginCopyWith<_$IncomingMessage_Begin> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IncomingMessage_ParticipantCopyWith<$Res> {
  factory _$$IncomingMessage_ParticipantCopyWith(
          _$IncomingMessage_Participant value,
          $Res Function(_$IncomingMessage_Participant) then) =
      __$$IncomingMessage_ParticipantCopyWithImpl<$Res>;
  $Res call({int index, int? party});
}

/// @nodoc
class __$$IncomingMessage_ParticipantCopyWithImpl<$Res>
    extends _$IncomingMessageCopyWithImpl<$Res>
    implements _$$IncomingMessage_ParticipantCopyWith<$Res> {
  __$$IncomingMessage_ParticipantCopyWithImpl(
      _$IncomingMessage_Participant _value,
      $Res Function(_$IncomingMessage_Participant) _then)
      : super(_value, (v) => _then(v as _$IncomingMessage_Participant));

  @override
  _$IncomingMessage_Participant get _value =>
      super._value as _$IncomingMessage_Participant;

  @override
  $Res call({
    Object? index = freezed,
    Object? party = freezed,
  }) {
    return _then(_$IncomingMessage_Participant(
      index: index == freezed
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      party: party == freezed
          ? _value.party
          : party // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$IncomingMessage_Participant implements IncomingMessage_Participant {
  const _$IncomingMessage_Participant({required this.index, this.party});

  @override
  final int index;
  @override
  final int? party;

  @override
  String toString() {
    return 'IncomingMessage.participant(index: $index, party: $party)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomingMessage_Participant &&
            const DeepCollectionEquality().equals(other.index, index) &&
            const DeepCollectionEquality().equals(other.party, party));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(index),
      const DeepCollectionEquality().hash(party));

  @JsonKey(ignore: true)
  @override
  _$$IncomingMessage_ParticipantCopyWith<_$IncomingMessage_Participant>
      get copyWith => __$$IncomingMessage_ParticipantCopyWithImpl<
          _$IncomingMessage_Participant>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(TookeyScenarios scenario) begin,
    required TResult Function(int index, int? party) participant,
    required TResult Function(Uint16List indexes, Uint16List parties) group,
    required TResult Function(String packet) communication,
    required TResult Function() close,
  }) {
    return participant(index, party);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(TookeyScenarios scenario)? begin,
    TResult Function(int index, int? party)? participant,
    TResult Function(Uint16List indexes, Uint16List parties)? group,
    TResult Function(String packet)? communication,
    TResult Function()? close,
  }) {
    return participant?.call(index, party);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(TookeyScenarios scenario)? begin,
    TResult Function(int index, int? party)? participant,
    TResult Function(Uint16List indexes, Uint16List parties)? group,
    TResult Function(String packet)? communication,
    TResult Function()? close,
    required TResult orElse(),
  }) {
    if (participant != null) {
      return participant(index, party);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IncomingMessage_Begin value) begin,
    required TResult Function(IncomingMessage_Participant value) participant,
    required TResult Function(IncomingMessage_Group value) group,
    required TResult Function(IncomingMessage_Communication value)
        communication,
    required TResult Function(IncomingMessage_Close value) close,
  }) {
    return participant(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(IncomingMessage_Begin value)? begin,
    TResult Function(IncomingMessage_Participant value)? participant,
    TResult Function(IncomingMessage_Group value)? group,
    TResult Function(IncomingMessage_Communication value)? communication,
    TResult Function(IncomingMessage_Close value)? close,
  }) {
    return participant?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IncomingMessage_Begin value)? begin,
    TResult Function(IncomingMessage_Participant value)? participant,
    TResult Function(IncomingMessage_Group value)? group,
    TResult Function(IncomingMessage_Communication value)? communication,
    TResult Function(IncomingMessage_Close value)? close,
    required TResult orElse(),
  }) {
    if (participant != null) {
      return participant(this);
    }
    return orElse();
  }
}

abstract class IncomingMessage_Participant implements IncomingMessage {
  const factory IncomingMessage_Participant(
      {required final int index,
      final int? party}) = _$IncomingMessage_Participant;

  int get index;
  int? get party;
  @JsonKey(ignore: true)
  _$$IncomingMessage_ParticipantCopyWith<_$IncomingMessage_Participant>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IncomingMessage_GroupCopyWith<$Res> {
  factory _$$IncomingMessage_GroupCopyWith(_$IncomingMessage_Group value,
          $Res Function(_$IncomingMessage_Group) then) =
      __$$IncomingMessage_GroupCopyWithImpl<$Res>;
  $Res call({Uint16List indexes, Uint16List parties});
}

/// @nodoc
class __$$IncomingMessage_GroupCopyWithImpl<$Res>
    extends _$IncomingMessageCopyWithImpl<$Res>
    implements _$$IncomingMessage_GroupCopyWith<$Res> {
  __$$IncomingMessage_GroupCopyWithImpl(_$IncomingMessage_Group _value,
      $Res Function(_$IncomingMessage_Group) _then)
      : super(_value, (v) => _then(v as _$IncomingMessage_Group));

  @override
  _$IncomingMessage_Group get _value => super._value as _$IncomingMessage_Group;

  @override
  $Res call({
    Object? indexes = freezed,
    Object? parties = freezed,
  }) {
    return _then(_$IncomingMessage_Group(
      indexes: indexes == freezed
          ? _value.indexes
          : indexes // ignore: cast_nullable_to_non_nullable
              as Uint16List,
      parties: parties == freezed
          ? _value.parties
          : parties // ignore: cast_nullable_to_non_nullable
              as Uint16List,
    ));
  }
}

/// @nodoc

class _$IncomingMessage_Group implements IncomingMessage_Group {
  const _$IncomingMessage_Group({required this.indexes, required this.parties});

  @override
  final Uint16List indexes;
  @override
  final Uint16List parties;

  @override
  String toString() {
    return 'IncomingMessage.group(indexes: $indexes, parties: $parties)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomingMessage_Group &&
            const DeepCollectionEquality().equals(other.indexes, indexes) &&
            const DeepCollectionEquality().equals(other.parties, parties));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(indexes),
      const DeepCollectionEquality().hash(parties));

  @JsonKey(ignore: true)
  @override
  _$$IncomingMessage_GroupCopyWith<_$IncomingMessage_Group> get copyWith =>
      __$$IncomingMessage_GroupCopyWithImpl<_$IncomingMessage_Group>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(TookeyScenarios scenario) begin,
    required TResult Function(int index, int? party) participant,
    required TResult Function(Uint16List indexes, Uint16List parties) group,
    required TResult Function(String packet) communication,
    required TResult Function() close,
  }) {
    return group(indexes, parties);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(TookeyScenarios scenario)? begin,
    TResult Function(int index, int? party)? participant,
    TResult Function(Uint16List indexes, Uint16List parties)? group,
    TResult Function(String packet)? communication,
    TResult Function()? close,
  }) {
    return group?.call(indexes, parties);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(TookeyScenarios scenario)? begin,
    TResult Function(int index, int? party)? participant,
    TResult Function(Uint16List indexes, Uint16List parties)? group,
    TResult Function(String packet)? communication,
    TResult Function()? close,
    required TResult orElse(),
  }) {
    if (group != null) {
      return group(indexes, parties);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IncomingMessage_Begin value) begin,
    required TResult Function(IncomingMessage_Participant value) participant,
    required TResult Function(IncomingMessage_Group value) group,
    required TResult Function(IncomingMessage_Communication value)
        communication,
    required TResult Function(IncomingMessage_Close value) close,
  }) {
    return group(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(IncomingMessage_Begin value)? begin,
    TResult Function(IncomingMessage_Participant value)? participant,
    TResult Function(IncomingMessage_Group value)? group,
    TResult Function(IncomingMessage_Communication value)? communication,
    TResult Function(IncomingMessage_Close value)? close,
  }) {
    return group?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IncomingMessage_Begin value)? begin,
    TResult Function(IncomingMessage_Participant value)? participant,
    TResult Function(IncomingMessage_Group value)? group,
    TResult Function(IncomingMessage_Communication value)? communication,
    TResult Function(IncomingMessage_Close value)? close,
    required TResult orElse(),
  }) {
    if (group != null) {
      return group(this);
    }
    return orElse();
  }
}

abstract class IncomingMessage_Group implements IncomingMessage {
  const factory IncomingMessage_Group(
      {required final Uint16List indexes,
      required final Uint16List parties}) = _$IncomingMessage_Group;

  Uint16List get indexes;
  Uint16List get parties;
  @JsonKey(ignore: true)
  _$$IncomingMessage_GroupCopyWith<_$IncomingMessage_Group> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IncomingMessage_CommunicationCopyWith<$Res> {
  factory _$$IncomingMessage_CommunicationCopyWith(
          _$IncomingMessage_Communication value,
          $Res Function(_$IncomingMessage_Communication) then) =
      __$$IncomingMessage_CommunicationCopyWithImpl<$Res>;
  $Res call({String packet});
}

/// @nodoc
class __$$IncomingMessage_CommunicationCopyWithImpl<$Res>
    extends _$IncomingMessageCopyWithImpl<$Res>
    implements _$$IncomingMessage_CommunicationCopyWith<$Res> {
  __$$IncomingMessage_CommunicationCopyWithImpl(
      _$IncomingMessage_Communication _value,
      $Res Function(_$IncomingMessage_Communication) _then)
      : super(_value, (v) => _then(v as _$IncomingMessage_Communication));

  @override
  _$IncomingMessage_Communication get _value =>
      super._value as _$IncomingMessage_Communication;

  @override
  $Res call({
    Object? packet = freezed,
  }) {
    return _then(_$IncomingMessage_Communication(
      packet: packet == freezed
          ? _value.packet
          : packet // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$IncomingMessage_Communication implements IncomingMessage_Communication {
  const _$IncomingMessage_Communication({required this.packet});

  @override
  final String packet;

  @override
  String toString() {
    return 'IncomingMessage.communication(packet: $packet)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IncomingMessage_Communication &&
            const DeepCollectionEquality().equals(other.packet, packet));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(packet));

  @JsonKey(ignore: true)
  @override
  _$$IncomingMessage_CommunicationCopyWith<_$IncomingMessage_Communication>
      get copyWith => __$$IncomingMessage_CommunicationCopyWithImpl<
          _$IncomingMessage_Communication>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(TookeyScenarios scenario) begin,
    required TResult Function(int index, int? party) participant,
    required TResult Function(Uint16List indexes, Uint16List parties) group,
    required TResult Function(String packet) communication,
    required TResult Function() close,
  }) {
    return communication(packet);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(TookeyScenarios scenario)? begin,
    TResult Function(int index, int? party)? participant,
    TResult Function(Uint16List indexes, Uint16List parties)? group,
    TResult Function(String packet)? communication,
    TResult Function()? close,
  }) {
    return communication?.call(packet);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(TookeyScenarios scenario)? begin,
    TResult Function(int index, int? party)? participant,
    TResult Function(Uint16List indexes, Uint16List parties)? group,
    TResult Function(String packet)? communication,
    TResult Function()? close,
    required TResult orElse(),
  }) {
    if (communication != null) {
      return communication(packet);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(IncomingMessage_Begin value) begin,
    required TResult Function(IncomingMessage_Participant value) participant,
    required TResult Function(IncomingMessage_Group value) group,
    required TResult Function(IncomingMessage_Communication value)
        communication,
    required TResult Function(IncomingMessage_Close value) close,
  }) {
    return communication(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(IncomingMessage_Begin value)? begin,
    TResult Function(IncomingMessage_Participant value)? participant,
    TResult Function(IncomingMessage_Group value)? group,
    TResult Function(IncomingMessage_Communication value)? communication,
    TResult Function(IncomingMessage_Close value)? close,
  }) {
    return communication?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IncomingMessage_Begin value)? begin,
    TResult Function(IncomingMessage_Participant value)? participant,
    TResult Function(IncomingMessage_Group value)? group,
    TResult Function(IncomingMessage_Communication value)? communication,
    TResult Function(IncomingMessage_Close value)? close,
    required TResult orElse(),
  }) {
    if (communication != null) {
      return communication(this);
    }
    return orElse();
  }
}

abstract class IncomingMessage_Communication implements IncomingMessage {
  const factory IncomingMessage_Communication({required final String packet}) =
      _$IncomingMessage_Communication;

  String get packet;
  @JsonKey(ignore: true)
  _$$IncomingMessage_CommunicationCopyWith<_$IncomingMessage_Communication>
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
    required TResult Function(TookeyScenarios scenario) begin,
    required TResult Function(int index, int? party) participant,
    required TResult Function(Uint16List indexes, Uint16List parties) group,
    required TResult Function(String packet) communication,
    required TResult Function() close,
  }) {
    return close();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(TookeyScenarios scenario)? begin,
    TResult Function(int index, int? party)? participant,
    TResult Function(Uint16List indexes, Uint16List parties)? group,
    TResult Function(String packet)? communication,
    TResult Function()? close,
  }) {
    return close?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(TookeyScenarios scenario)? begin,
    TResult Function(int index, int? party)? participant,
    TResult Function(Uint16List indexes, Uint16List parties)? group,
    TResult Function(String packet)? communication,
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
    required TResult Function(IncomingMessage_Begin value) begin,
    required TResult Function(IncomingMessage_Participant value) participant,
    required TResult Function(IncomingMessage_Group value) group,
    required TResult Function(IncomingMessage_Communication value)
        communication,
    required TResult Function(IncomingMessage_Close value) close,
  }) {
    return close(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(IncomingMessage_Begin value)? begin,
    TResult Function(IncomingMessage_Participant value)? participant,
    TResult Function(IncomingMessage_Group value)? group,
    TResult Function(IncomingMessage_Communication value)? communication,
    TResult Function(IncomingMessage_Close value)? close,
  }) {
    return close?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(IncomingMessage_Begin value)? begin,
    TResult Function(IncomingMessage_Participant value)? participant,
    TResult Function(IncomingMessage_Group value)? group,
    TResult Function(IncomingMessage_Communication value)? communication,
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
    required TResult Function() start,
    required TResult Function() ready,
    required TResult Function(ErrCode code, String message) issue,
    required TResult Function(String packet) communication,
    required TResult Function(String encoded) result,
    required TResult Function() close,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? start,
    TResult Function()? ready,
    TResult Function(ErrCode code, String message)? issue,
    TResult Function(String packet)? communication,
    TResult Function(String encoded)? result,
    TResult Function()? close,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? start,
    TResult Function()? ready,
    TResult Function(ErrCode code, String message)? issue,
    TResult Function(String packet)? communication,
    TResult Function(String encoded)? result,
    TResult Function()? close,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutgoingMessage_Start value) start,
    required TResult Function(OutgoingMessage_Ready value) ready,
    required TResult Function(OutgoingMessage_Issue value) issue,
    required TResult Function(OutgoingMessage_Communication value)
        communication,
    required TResult Function(OutgoingMessage_Result value) result,
    required TResult Function(OutgoingMessage_Close value) close,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(OutgoingMessage_Start value)? start,
    TResult Function(OutgoingMessage_Ready value)? ready,
    TResult Function(OutgoingMessage_Issue value)? issue,
    TResult Function(OutgoingMessage_Communication value)? communication,
    TResult Function(OutgoingMessage_Result value)? result,
    TResult Function(OutgoingMessage_Close value)? close,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutgoingMessage_Start value)? start,
    TResult Function(OutgoingMessage_Ready value)? ready,
    TResult Function(OutgoingMessage_Issue value)? issue,
    TResult Function(OutgoingMessage_Communication value)? communication,
    TResult Function(OutgoingMessage_Result value)? result,
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
abstract class _$$OutgoingMessage_StartCopyWith<$Res> {
  factory _$$OutgoingMessage_StartCopyWith(_$OutgoingMessage_Start value,
          $Res Function(_$OutgoingMessage_Start) then) =
      __$$OutgoingMessage_StartCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OutgoingMessage_StartCopyWithImpl<$Res>
    extends _$OutgoingMessageCopyWithImpl<$Res>
    implements _$$OutgoingMessage_StartCopyWith<$Res> {
  __$$OutgoingMessage_StartCopyWithImpl(_$OutgoingMessage_Start _value,
      $Res Function(_$OutgoingMessage_Start) _then)
      : super(_value, (v) => _then(v as _$OutgoingMessage_Start));

  @override
  _$OutgoingMessage_Start get _value => super._value as _$OutgoingMessage_Start;
}

/// @nodoc

class _$OutgoingMessage_Start implements OutgoingMessage_Start {
  const _$OutgoingMessage_Start();

  @override
  String toString() {
    return 'OutgoingMessage.start()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OutgoingMessage_Start);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() start,
    required TResult Function() ready,
    required TResult Function(ErrCode code, String message) issue,
    required TResult Function(String packet) communication,
    required TResult Function(String encoded) result,
    required TResult Function() close,
  }) {
    return start();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? start,
    TResult Function()? ready,
    TResult Function(ErrCode code, String message)? issue,
    TResult Function(String packet)? communication,
    TResult Function(String encoded)? result,
    TResult Function()? close,
  }) {
    return start?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? start,
    TResult Function()? ready,
    TResult Function(ErrCode code, String message)? issue,
    TResult Function(String packet)? communication,
    TResult Function(String encoded)? result,
    TResult Function()? close,
    required TResult orElse(),
  }) {
    if (start != null) {
      return start();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutgoingMessage_Start value) start,
    required TResult Function(OutgoingMessage_Ready value) ready,
    required TResult Function(OutgoingMessage_Issue value) issue,
    required TResult Function(OutgoingMessage_Communication value)
        communication,
    required TResult Function(OutgoingMessage_Result value) result,
    required TResult Function(OutgoingMessage_Close value) close,
  }) {
    return start(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(OutgoingMessage_Start value)? start,
    TResult Function(OutgoingMessage_Ready value)? ready,
    TResult Function(OutgoingMessage_Issue value)? issue,
    TResult Function(OutgoingMessage_Communication value)? communication,
    TResult Function(OutgoingMessage_Result value)? result,
    TResult Function(OutgoingMessage_Close value)? close,
  }) {
    return start?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutgoingMessage_Start value)? start,
    TResult Function(OutgoingMessage_Ready value)? ready,
    TResult Function(OutgoingMessage_Issue value)? issue,
    TResult Function(OutgoingMessage_Communication value)? communication,
    TResult Function(OutgoingMessage_Result value)? result,
    TResult Function(OutgoingMessage_Close value)? close,
    required TResult orElse(),
  }) {
    if (start != null) {
      return start(this);
    }
    return orElse();
  }
}

abstract class OutgoingMessage_Start implements OutgoingMessage {
  const factory OutgoingMessage_Start() = _$OutgoingMessage_Start;
}

/// @nodoc
abstract class _$$OutgoingMessage_ReadyCopyWith<$Res> {
  factory _$$OutgoingMessage_ReadyCopyWith(_$OutgoingMessage_Ready value,
          $Res Function(_$OutgoingMessage_Ready) then) =
      __$$OutgoingMessage_ReadyCopyWithImpl<$Res>;
}

/// @nodoc
class __$$OutgoingMessage_ReadyCopyWithImpl<$Res>
    extends _$OutgoingMessageCopyWithImpl<$Res>
    implements _$$OutgoingMessage_ReadyCopyWith<$Res> {
  __$$OutgoingMessage_ReadyCopyWithImpl(_$OutgoingMessage_Ready _value,
      $Res Function(_$OutgoingMessage_Ready) _then)
      : super(_value, (v) => _then(v as _$OutgoingMessage_Ready));

  @override
  _$OutgoingMessage_Ready get _value => super._value as _$OutgoingMessage_Ready;
}

/// @nodoc

class _$OutgoingMessage_Ready implements OutgoingMessage_Ready {
  const _$OutgoingMessage_Ready();

  @override
  String toString() {
    return 'OutgoingMessage.ready()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$OutgoingMessage_Ready);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() start,
    required TResult Function() ready,
    required TResult Function(ErrCode code, String message) issue,
    required TResult Function(String packet) communication,
    required TResult Function(String encoded) result,
    required TResult Function() close,
  }) {
    return ready();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? start,
    TResult Function()? ready,
    TResult Function(ErrCode code, String message)? issue,
    TResult Function(String packet)? communication,
    TResult Function(String encoded)? result,
    TResult Function()? close,
  }) {
    return ready?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? start,
    TResult Function()? ready,
    TResult Function(ErrCode code, String message)? issue,
    TResult Function(String packet)? communication,
    TResult Function(String encoded)? result,
    TResult Function()? close,
    required TResult orElse(),
  }) {
    if (ready != null) {
      return ready();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutgoingMessage_Start value) start,
    required TResult Function(OutgoingMessage_Ready value) ready,
    required TResult Function(OutgoingMessage_Issue value) issue,
    required TResult Function(OutgoingMessage_Communication value)
        communication,
    required TResult Function(OutgoingMessage_Result value) result,
    required TResult Function(OutgoingMessage_Close value) close,
  }) {
    return ready(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(OutgoingMessage_Start value)? start,
    TResult Function(OutgoingMessage_Ready value)? ready,
    TResult Function(OutgoingMessage_Issue value)? issue,
    TResult Function(OutgoingMessage_Communication value)? communication,
    TResult Function(OutgoingMessage_Result value)? result,
    TResult Function(OutgoingMessage_Close value)? close,
  }) {
    return ready?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutgoingMessage_Start value)? start,
    TResult Function(OutgoingMessage_Ready value)? ready,
    TResult Function(OutgoingMessage_Issue value)? issue,
    TResult Function(OutgoingMessage_Communication value)? communication,
    TResult Function(OutgoingMessage_Result value)? result,
    TResult Function(OutgoingMessage_Close value)? close,
    required TResult orElse(),
  }) {
    if (ready != null) {
      return ready(this);
    }
    return orElse();
  }
}

abstract class OutgoingMessage_Ready implements OutgoingMessage {
  const factory OutgoingMessage_Ready() = _$OutgoingMessage_Ready;
}

/// @nodoc
abstract class _$$OutgoingMessage_IssueCopyWith<$Res> {
  factory _$$OutgoingMessage_IssueCopyWith(_$OutgoingMessage_Issue value,
          $Res Function(_$OutgoingMessage_Issue) then) =
      __$$OutgoingMessage_IssueCopyWithImpl<$Res>;
  $Res call({ErrCode code, String message});
}

/// @nodoc
class __$$OutgoingMessage_IssueCopyWithImpl<$Res>
    extends _$OutgoingMessageCopyWithImpl<$Res>
    implements _$$OutgoingMessage_IssueCopyWith<$Res> {
  __$$OutgoingMessage_IssueCopyWithImpl(_$OutgoingMessage_Issue _value,
      $Res Function(_$OutgoingMessage_Issue) _then)
      : super(_value, (v) => _then(v as _$OutgoingMessage_Issue));

  @override
  _$OutgoingMessage_Issue get _value => super._value as _$OutgoingMessage_Issue;

  @override
  $Res call({
    Object? code = freezed,
    Object? message = freezed,
  }) {
    return _then(_$OutgoingMessage_Issue(
      code: code == freezed
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as ErrCode,
      message: message == freezed
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$OutgoingMessage_Issue implements OutgoingMessage_Issue {
  const _$OutgoingMessage_Issue({required this.code, required this.message});

  @override
  final ErrCode code;
  @override
  final String message;

  @override
  String toString() {
    return 'OutgoingMessage.issue(code: $code, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutgoingMessage_Issue &&
            const DeepCollectionEquality().equals(other.code, code) &&
            const DeepCollectionEquality().equals(other.message, message));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(code),
      const DeepCollectionEquality().hash(message));

  @JsonKey(ignore: true)
  @override
  _$$OutgoingMessage_IssueCopyWith<_$OutgoingMessage_Issue> get copyWith =>
      __$$OutgoingMessage_IssueCopyWithImpl<_$OutgoingMessage_Issue>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() start,
    required TResult Function() ready,
    required TResult Function(ErrCode code, String message) issue,
    required TResult Function(String packet) communication,
    required TResult Function(String encoded) result,
    required TResult Function() close,
  }) {
    return issue(code, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? start,
    TResult Function()? ready,
    TResult Function(ErrCode code, String message)? issue,
    TResult Function(String packet)? communication,
    TResult Function(String encoded)? result,
    TResult Function()? close,
  }) {
    return issue?.call(code, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? start,
    TResult Function()? ready,
    TResult Function(ErrCode code, String message)? issue,
    TResult Function(String packet)? communication,
    TResult Function(String encoded)? result,
    TResult Function()? close,
    required TResult orElse(),
  }) {
    if (issue != null) {
      return issue(code, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutgoingMessage_Start value) start,
    required TResult Function(OutgoingMessage_Ready value) ready,
    required TResult Function(OutgoingMessage_Issue value) issue,
    required TResult Function(OutgoingMessage_Communication value)
        communication,
    required TResult Function(OutgoingMessage_Result value) result,
    required TResult Function(OutgoingMessage_Close value) close,
  }) {
    return issue(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(OutgoingMessage_Start value)? start,
    TResult Function(OutgoingMessage_Ready value)? ready,
    TResult Function(OutgoingMessage_Issue value)? issue,
    TResult Function(OutgoingMessage_Communication value)? communication,
    TResult Function(OutgoingMessage_Result value)? result,
    TResult Function(OutgoingMessage_Close value)? close,
  }) {
    return issue?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutgoingMessage_Start value)? start,
    TResult Function(OutgoingMessage_Ready value)? ready,
    TResult Function(OutgoingMessage_Issue value)? issue,
    TResult Function(OutgoingMessage_Communication value)? communication,
    TResult Function(OutgoingMessage_Result value)? result,
    TResult Function(OutgoingMessage_Close value)? close,
    required TResult orElse(),
  }) {
    if (issue != null) {
      return issue(this);
    }
    return orElse();
  }
}

abstract class OutgoingMessage_Issue implements OutgoingMessage {
  const factory OutgoingMessage_Issue(
      {required final ErrCode code,
      required final String message}) = _$OutgoingMessage_Issue;

  ErrCode get code;
  String get message;
  @JsonKey(ignore: true)
  _$$OutgoingMessage_IssueCopyWith<_$OutgoingMessage_Issue> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OutgoingMessage_CommunicationCopyWith<$Res> {
  factory _$$OutgoingMessage_CommunicationCopyWith(
          _$OutgoingMessage_Communication value,
          $Res Function(_$OutgoingMessage_Communication) then) =
      __$$OutgoingMessage_CommunicationCopyWithImpl<$Res>;
  $Res call({String packet});
}

/// @nodoc
class __$$OutgoingMessage_CommunicationCopyWithImpl<$Res>
    extends _$OutgoingMessageCopyWithImpl<$Res>
    implements _$$OutgoingMessage_CommunicationCopyWith<$Res> {
  __$$OutgoingMessage_CommunicationCopyWithImpl(
      _$OutgoingMessage_Communication _value,
      $Res Function(_$OutgoingMessage_Communication) _then)
      : super(_value, (v) => _then(v as _$OutgoingMessage_Communication));

  @override
  _$OutgoingMessage_Communication get _value =>
      super._value as _$OutgoingMessage_Communication;

  @override
  $Res call({
    Object? packet = freezed,
  }) {
    return _then(_$OutgoingMessage_Communication(
      packet: packet == freezed
          ? _value.packet
          : packet // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$OutgoingMessage_Communication implements OutgoingMessage_Communication {
  const _$OutgoingMessage_Communication({required this.packet});

  @override
  final String packet;

  @override
  String toString() {
    return 'OutgoingMessage.communication(packet: $packet)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutgoingMessage_Communication &&
            const DeepCollectionEquality().equals(other.packet, packet));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(packet));

  @JsonKey(ignore: true)
  @override
  _$$OutgoingMessage_CommunicationCopyWith<_$OutgoingMessage_Communication>
      get copyWith => __$$OutgoingMessage_CommunicationCopyWithImpl<
          _$OutgoingMessage_Communication>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() start,
    required TResult Function() ready,
    required TResult Function(ErrCode code, String message) issue,
    required TResult Function(String packet) communication,
    required TResult Function(String encoded) result,
    required TResult Function() close,
  }) {
    return communication(packet);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? start,
    TResult Function()? ready,
    TResult Function(ErrCode code, String message)? issue,
    TResult Function(String packet)? communication,
    TResult Function(String encoded)? result,
    TResult Function()? close,
  }) {
    return communication?.call(packet);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? start,
    TResult Function()? ready,
    TResult Function(ErrCode code, String message)? issue,
    TResult Function(String packet)? communication,
    TResult Function(String encoded)? result,
    TResult Function()? close,
    required TResult orElse(),
  }) {
    if (communication != null) {
      return communication(packet);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutgoingMessage_Start value) start,
    required TResult Function(OutgoingMessage_Ready value) ready,
    required TResult Function(OutgoingMessage_Issue value) issue,
    required TResult Function(OutgoingMessage_Communication value)
        communication,
    required TResult Function(OutgoingMessage_Result value) result,
    required TResult Function(OutgoingMessage_Close value) close,
  }) {
    return communication(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(OutgoingMessage_Start value)? start,
    TResult Function(OutgoingMessage_Ready value)? ready,
    TResult Function(OutgoingMessage_Issue value)? issue,
    TResult Function(OutgoingMessage_Communication value)? communication,
    TResult Function(OutgoingMessage_Result value)? result,
    TResult Function(OutgoingMessage_Close value)? close,
  }) {
    return communication?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutgoingMessage_Start value)? start,
    TResult Function(OutgoingMessage_Ready value)? ready,
    TResult Function(OutgoingMessage_Issue value)? issue,
    TResult Function(OutgoingMessage_Communication value)? communication,
    TResult Function(OutgoingMessage_Result value)? result,
    TResult Function(OutgoingMessage_Close value)? close,
    required TResult orElse(),
  }) {
    if (communication != null) {
      return communication(this);
    }
    return orElse();
  }
}

abstract class OutgoingMessage_Communication implements OutgoingMessage {
  const factory OutgoingMessage_Communication({required final String packet}) =
      _$OutgoingMessage_Communication;

  String get packet;
  @JsonKey(ignore: true)
  _$$OutgoingMessage_CommunicationCopyWith<_$OutgoingMessage_Communication>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OutgoingMessage_ResultCopyWith<$Res> {
  factory _$$OutgoingMessage_ResultCopyWith(_$OutgoingMessage_Result value,
          $Res Function(_$OutgoingMessage_Result) then) =
      __$$OutgoingMessage_ResultCopyWithImpl<$Res>;
  $Res call({String encoded});
}

/// @nodoc
class __$$OutgoingMessage_ResultCopyWithImpl<$Res>
    extends _$OutgoingMessageCopyWithImpl<$Res>
    implements _$$OutgoingMessage_ResultCopyWith<$Res> {
  __$$OutgoingMessage_ResultCopyWithImpl(_$OutgoingMessage_Result _value,
      $Res Function(_$OutgoingMessage_Result) _then)
      : super(_value, (v) => _then(v as _$OutgoingMessage_Result));

  @override
  _$OutgoingMessage_Result get _value =>
      super._value as _$OutgoingMessage_Result;

  @override
  $Res call({
    Object? encoded = freezed,
  }) {
    return _then(_$OutgoingMessage_Result(
      encoded: encoded == freezed
          ? _value.encoded
          : encoded // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$OutgoingMessage_Result implements OutgoingMessage_Result {
  const _$OutgoingMessage_Result({required this.encoded});

  @override
  final String encoded;

  @override
  String toString() {
    return 'OutgoingMessage.result(encoded: $encoded)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OutgoingMessage_Result &&
            const DeepCollectionEquality().equals(other.encoded, encoded));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(encoded));

  @JsonKey(ignore: true)
  @override
  _$$OutgoingMessage_ResultCopyWith<_$OutgoingMessage_Result> get copyWith =>
      __$$OutgoingMessage_ResultCopyWithImpl<_$OutgoingMessage_Result>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() start,
    required TResult Function() ready,
    required TResult Function(ErrCode code, String message) issue,
    required TResult Function(String packet) communication,
    required TResult Function(String encoded) result,
    required TResult Function() close,
  }) {
    return result(encoded);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? start,
    TResult Function()? ready,
    TResult Function(ErrCode code, String message)? issue,
    TResult Function(String packet)? communication,
    TResult Function(String encoded)? result,
    TResult Function()? close,
  }) {
    return result?.call(encoded);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? start,
    TResult Function()? ready,
    TResult Function(ErrCode code, String message)? issue,
    TResult Function(String packet)? communication,
    TResult Function(String encoded)? result,
    TResult Function()? close,
    required TResult orElse(),
  }) {
    if (result != null) {
      return result(encoded);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(OutgoingMessage_Start value) start,
    required TResult Function(OutgoingMessage_Ready value) ready,
    required TResult Function(OutgoingMessage_Issue value) issue,
    required TResult Function(OutgoingMessage_Communication value)
        communication,
    required TResult Function(OutgoingMessage_Result value) result,
    required TResult Function(OutgoingMessage_Close value) close,
  }) {
    return result(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(OutgoingMessage_Start value)? start,
    TResult Function(OutgoingMessage_Ready value)? ready,
    TResult Function(OutgoingMessage_Issue value)? issue,
    TResult Function(OutgoingMessage_Communication value)? communication,
    TResult Function(OutgoingMessage_Result value)? result,
    TResult Function(OutgoingMessage_Close value)? close,
  }) {
    return result?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutgoingMessage_Start value)? start,
    TResult Function(OutgoingMessage_Ready value)? ready,
    TResult Function(OutgoingMessage_Issue value)? issue,
    TResult Function(OutgoingMessage_Communication value)? communication,
    TResult Function(OutgoingMessage_Result value)? result,
    TResult Function(OutgoingMessage_Close value)? close,
    required TResult orElse(),
  }) {
    if (result != null) {
      return result(this);
    }
    return orElse();
  }
}

abstract class OutgoingMessage_Result implements OutgoingMessage {
  const factory OutgoingMessage_Result({required final String encoded}) =
      _$OutgoingMessage_Result;

  String get encoded;
  @JsonKey(ignore: true)
  _$$OutgoingMessage_ResultCopyWith<_$OutgoingMessage_Result> get copyWith =>
      throw _privateConstructorUsedError;
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
    required TResult Function() start,
    required TResult Function() ready,
    required TResult Function(ErrCode code, String message) issue,
    required TResult Function(String packet) communication,
    required TResult Function(String encoded) result,
    required TResult Function() close,
  }) {
    return close();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function()? start,
    TResult Function()? ready,
    TResult Function(ErrCode code, String message)? issue,
    TResult Function(String packet)? communication,
    TResult Function(String encoded)? result,
    TResult Function()? close,
  }) {
    return close?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? start,
    TResult Function()? ready,
    TResult Function(ErrCode code, String message)? issue,
    TResult Function(String packet)? communication,
    TResult Function(String encoded)? result,
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
    required TResult Function(OutgoingMessage_Start value) start,
    required TResult Function(OutgoingMessage_Ready value) ready,
    required TResult Function(OutgoingMessage_Issue value) issue,
    required TResult Function(OutgoingMessage_Communication value)
        communication,
    required TResult Function(OutgoingMessage_Result value) result,
    required TResult Function(OutgoingMessage_Close value) close,
  }) {
    return close(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(OutgoingMessage_Start value)? start,
    TResult Function(OutgoingMessage_Ready value)? ready,
    TResult Function(OutgoingMessage_Issue value)? issue,
    TResult Function(OutgoingMessage_Communication value)? communication,
    TResult Function(OutgoingMessage_Result value)? result,
    TResult Function(OutgoingMessage_Close value)? close,
  }) {
    return close?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(OutgoingMessage_Start value)? start,
    TResult Function(OutgoingMessage_Ready value)? ready,
    TResult Function(OutgoingMessage_Issue value)? issue,
    TResult Function(OutgoingMessage_Communication value)? communication,
    TResult Function(OutgoingMessage_Result value)? result,
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

/// @nodoc
mixin _$TookeyScenarios {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index, int parties, int threashold)
        keygenEcdsa,
    required TResult Function(Uint16List parties, String key, String hash)
        signEcdsa,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(int index, int parties, int threashold)? keygenEcdsa,
    TResult Function(Uint16List parties, String key, String hash)? signEcdsa,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index, int parties, int threashold)? keygenEcdsa,
    TResult Function(Uint16List parties, String key, String hash)? signEcdsa,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TookeyScenarios_KeygenECDSA value) keygenEcdsa,
    required TResult Function(TookeyScenarios_SignECDSA value) signEcdsa,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(TookeyScenarios_KeygenECDSA value)? keygenEcdsa,
    TResult Function(TookeyScenarios_SignECDSA value)? signEcdsa,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TookeyScenarios_KeygenECDSA value)? keygenEcdsa,
    TResult Function(TookeyScenarios_SignECDSA value)? signEcdsa,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TookeyScenariosCopyWith<$Res> {
  factory $TookeyScenariosCopyWith(
          TookeyScenarios value, $Res Function(TookeyScenarios) then) =
      _$TookeyScenariosCopyWithImpl<$Res>;
}

/// @nodoc
class _$TookeyScenariosCopyWithImpl<$Res>
    implements $TookeyScenariosCopyWith<$Res> {
  _$TookeyScenariosCopyWithImpl(this._value, this._then);

  final TookeyScenarios _value;
  // ignore: unused_field
  final $Res Function(TookeyScenarios) _then;
}

/// @nodoc
abstract class _$$TookeyScenarios_KeygenECDSACopyWith<$Res> {
  factory _$$TookeyScenarios_KeygenECDSACopyWith(
          _$TookeyScenarios_KeygenECDSA value,
          $Res Function(_$TookeyScenarios_KeygenECDSA) then) =
      __$$TookeyScenarios_KeygenECDSACopyWithImpl<$Res>;
  $Res call({int index, int parties, int threashold});
}

/// @nodoc
class __$$TookeyScenarios_KeygenECDSACopyWithImpl<$Res>
    extends _$TookeyScenariosCopyWithImpl<$Res>
    implements _$$TookeyScenarios_KeygenECDSACopyWith<$Res> {
  __$$TookeyScenarios_KeygenECDSACopyWithImpl(
      _$TookeyScenarios_KeygenECDSA _value,
      $Res Function(_$TookeyScenarios_KeygenECDSA) _then)
      : super(_value, (v) => _then(v as _$TookeyScenarios_KeygenECDSA));

  @override
  _$TookeyScenarios_KeygenECDSA get _value =>
      super._value as _$TookeyScenarios_KeygenECDSA;

  @override
  $Res call({
    Object? index = freezed,
    Object? parties = freezed,
    Object? threashold = freezed,
  }) {
    return _then(_$TookeyScenarios_KeygenECDSA(
      index: index == freezed
          ? _value.index
          : index // ignore: cast_nullable_to_non_nullable
              as int,
      parties: parties == freezed
          ? _value.parties
          : parties // ignore: cast_nullable_to_non_nullable
              as int,
      threashold: threashold == freezed
          ? _value.threashold
          : threashold // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$TookeyScenarios_KeygenECDSA implements TookeyScenarios_KeygenECDSA {
  const _$TookeyScenarios_KeygenECDSA(
      {required this.index, required this.parties, required this.threashold});

  @override
  final int index;
  @override
  final int parties;
  @override
  final int threashold;

  @override
  String toString() {
    return 'TookeyScenarios.keygenEcdsa(index: $index, parties: $parties, threashold: $threashold)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TookeyScenarios_KeygenECDSA &&
            const DeepCollectionEquality().equals(other.index, index) &&
            const DeepCollectionEquality().equals(other.parties, parties) &&
            const DeepCollectionEquality()
                .equals(other.threashold, threashold));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(index),
      const DeepCollectionEquality().hash(parties),
      const DeepCollectionEquality().hash(threashold));

  @JsonKey(ignore: true)
  @override
  _$$TookeyScenarios_KeygenECDSACopyWith<_$TookeyScenarios_KeygenECDSA>
      get copyWith => __$$TookeyScenarios_KeygenECDSACopyWithImpl<
          _$TookeyScenarios_KeygenECDSA>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index, int parties, int threashold)
        keygenEcdsa,
    required TResult Function(Uint16List parties, String key, String hash)
        signEcdsa,
  }) {
    return keygenEcdsa(index, parties, threashold);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(int index, int parties, int threashold)? keygenEcdsa,
    TResult Function(Uint16List parties, String key, String hash)? signEcdsa,
  }) {
    return keygenEcdsa?.call(index, parties, threashold);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index, int parties, int threashold)? keygenEcdsa,
    TResult Function(Uint16List parties, String key, String hash)? signEcdsa,
    required TResult orElse(),
  }) {
    if (keygenEcdsa != null) {
      return keygenEcdsa(index, parties, threashold);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TookeyScenarios_KeygenECDSA value) keygenEcdsa,
    required TResult Function(TookeyScenarios_SignECDSA value) signEcdsa,
  }) {
    return keygenEcdsa(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(TookeyScenarios_KeygenECDSA value)? keygenEcdsa,
    TResult Function(TookeyScenarios_SignECDSA value)? signEcdsa,
  }) {
    return keygenEcdsa?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TookeyScenarios_KeygenECDSA value)? keygenEcdsa,
    TResult Function(TookeyScenarios_SignECDSA value)? signEcdsa,
    required TResult orElse(),
  }) {
    if (keygenEcdsa != null) {
      return keygenEcdsa(this);
    }
    return orElse();
  }
}

abstract class TookeyScenarios_KeygenECDSA implements TookeyScenarios {
  const factory TookeyScenarios_KeygenECDSA(
      {required final int index,
      required final int parties,
      required final int threashold}) = _$TookeyScenarios_KeygenECDSA;

  int get index;
  int get parties;
  int get threashold;
  @JsonKey(ignore: true)
  _$$TookeyScenarios_KeygenECDSACopyWith<_$TookeyScenarios_KeygenECDSA>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TookeyScenarios_SignECDSACopyWith<$Res> {
  factory _$$TookeyScenarios_SignECDSACopyWith(
          _$TookeyScenarios_SignECDSA value,
          $Res Function(_$TookeyScenarios_SignECDSA) then) =
      __$$TookeyScenarios_SignECDSACopyWithImpl<$Res>;
  $Res call({Uint16List parties, String key, String hash});
}

/// @nodoc
class __$$TookeyScenarios_SignECDSACopyWithImpl<$Res>
    extends _$TookeyScenariosCopyWithImpl<$Res>
    implements _$$TookeyScenarios_SignECDSACopyWith<$Res> {
  __$$TookeyScenarios_SignECDSACopyWithImpl(_$TookeyScenarios_SignECDSA _value,
      $Res Function(_$TookeyScenarios_SignECDSA) _then)
      : super(_value, (v) => _then(v as _$TookeyScenarios_SignECDSA));

  @override
  _$TookeyScenarios_SignECDSA get _value =>
      super._value as _$TookeyScenarios_SignECDSA;

  @override
  $Res call({
    Object? parties = freezed,
    Object? key = freezed,
    Object? hash = freezed,
  }) {
    return _then(_$TookeyScenarios_SignECDSA(
      parties: parties == freezed
          ? _value.parties
          : parties // ignore: cast_nullable_to_non_nullable
              as Uint16List,
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      hash: hash == freezed
          ? _value.hash
          : hash // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TookeyScenarios_SignECDSA implements TookeyScenarios_SignECDSA {
  const _$TookeyScenarios_SignECDSA(
      {required this.parties, required this.key, required this.hash});

  @override
  final Uint16List parties;
  @override
  final String key;
  @override
  final String hash;

  @override
  String toString() {
    return 'TookeyScenarios.signEcdsa(parties: $parties, key: $key, hash: $hash)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TookeyScenarios_SignECDSA &&
            const DeepCollectionEquality().equals(other.parties, parties) &&
            const DeepCollectionEquality().equals(other.key, key) &&
            const DeepCollectionEquality().equals(other.hash, hash));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(parties),
      const DeepCollectionEquality().hash(key),
      const DeepCollectionEquality().hash(hash));

  @JsonKey(ignore: true)
  @override
  _$$TookeyScenarios_SignECDSACopyWith<_$TookeyScenarios_SignECDSA>
      get copyWith => __$$TookeyScenarios_SignECDSACopyWithImpl<
          _$TookeyScenarios_SignECDSA>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int index, int parties, int threashold)
        keygenEcdsa,
    required TResult Function(Uint16List parties, String key, String hash)
        signEcdsa,
  }) {
    return signEcdsa(parties, key, hash);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(int index, int parties, int threashold)? keygenEcdsa,
    TResult Function(Uint16List parties, String key, String hash)? signEcdsa,
  }) {
    return signEcdsa?.call(parties, key, hash);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int index, int parties, int threashold)? keygenEcdsa,
    TResult Function(Uint16List parties, String key, String hash)? signEcdsa,
    required TResult orElse(),
  }) {
    if (signEcdsa != null) {
      return signEcdsa(parties, key, hash);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(TookeyScenarios_KeygenECDSA value) keygenEcdsa,
    required TResult Function(TookeyScenarios_SignECDSA value) signEcdsa,
  }) {
    return signEcdsa(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(TookeyScenarios_KeygenECDSA value)? keygenEcdsa,
    TResult Function(TookeyScenarios_SignECDSA value)? signEcdsa,
  }) {
    return signEcdsa?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(TookeyScenarios_KeygenECDSA value)? keygenEcdsa,
    TResult Function(TookeyScenarios_SignECDSA value)? signEcdsa,
    required TResult orElse(),
  }) {
    if (signEcdsa != null) {
      return signEcdsa(this);
    }
    return orElse();
  }
}

abstract class TookeyScenarios_SignECDSA implements TookeyScenarios {
  const factory TookeyScenarios_SignECDSA(
      {required final Uint16List parties,
      required final String key,
      required final String hash}) = _$TookeyScenarios_SignECDSA;

  Uint16List get parties;
  String get key;
  String get hash;
  @JsonKey(ignore: true)
  _$$TookeyScenarios_SignECDSACopyWith<_$TookeyScenarios_SignECDSA>
      get copyWith => throw _privateConstructorUsedError;
}
