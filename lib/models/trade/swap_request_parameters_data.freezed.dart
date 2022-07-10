// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'swap_request_parameters_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SwapRequestParametersData _$SwapRequestParametersDataFromJson(
    Map<String, dynamic> json) {
  return _SwapRequestParametersData.fromJson(json);
}

/// @nodoc
mixin _$SwapRequestParametersData {
  String get methodName => throw _privateConstructorUsedError;
  List<dynamic> get args => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  Map<String, dynamic> get rawTxn => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SwapRequestParametersDataCopyWith<SwapRequestParametersData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SwapRequestParametersDataCopyWith<$Res> {
  factory $SwapRequestParametersDataCopyWith(SwapRequestParametersData value,
          $Res Function(SwapRequestParametersData) then) =
      _$SwapRequestParametersDataCopyWithImpl<$Res>;
  $Res call(
      {String methodName,
      List<dynamic> args,
      String value,
      Map<String, dynamic> rawTxn});
}

/// @nodoc
class _$SwapRequestParametersDataCopyWithImpl<$Res>
    implements $SwapRequestParametersDataCopyWith<$Res> {
  _$SwapRequestParametersDataCopyWithImpl(this._value, this._then);

  final SwapRequestParametersData _value;
  // ignore: unused_field
  final $Res Function(SwapRequestParametersData) _then;

  @override
  $Res call({
    Object? methodName = freezed,
    Object? args = freezed,
    Object? value = freezed,
    Object? rawTxn = freezed,
  }) {
    return _then(_value.copyWith(
      methodName: methodName == freezed
          ? _value.methodName
          : methodName // ignore: cast_nullable_to_non_nullable
              as String,
      args: args == freezed
          ? _value.args
          : args // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      rawTxn: rawTxn == freezed
          ? _value.rawTxn
          : rawTxn // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
abstract class _$$_SwapRequestParametersDataCopyWith<$Res>
    implements $SwapRequestParametersDataCopyWith<$Res> {
  factory _$$_SwapRequestParametersDataCopyWith(
          _$_SwapRequestParametersData value,
          $Res Function(_$_SwapRequestParametersData) then) =
      __$$_SwapRequestParametersDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {String methodName,
      List<dynamic> args,
      String value,
      Map<String, dynamic> rawTxn});
}

/// @nodoc
class __$$_SwapRequestParametersDataCopyWithImpl<$Res>
    extends _$SwapRequestParametersDataCopyWithImpl<$Res>
    implements _$$_SwapRequestParametersDataCopyWith<$Res> {
  __$$_SwapRequestParametersDataCopyWithImpl(
      _$_SwapRequestParametersData _value,
      $Res Function(_$_SwapRequestParametersData) _then)
      : super(_value, (v) => _then(v as _$_SwapRequestParametersData));

  @override
  _$_SwapRequestParametersData get _value =>
      super._value as _$_SwapRequestParametersData;

  @override
  $Res call({
    Object? methodName = freezed,
    Object? args = freezed,
    Object? value = freezed,
    Object? rawTxn = freezed,
  }) {
    return _then(_$_SwapRequestParametersData(
      methodName: methodName == freezed
          ? _value.methodName
          : methodName // ignore: cast_nullable_to_non_nullable
              as String,
      args: args == freezed
          ? _value.args
          : args // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      rawTxn: rawTxn == freezed
          ? _value.rawTxn
          : rawTxn // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SwapRequestParametersData implements _SwapRequestParametersData {
  _$_SwapRequestParametersData(
      {required this.methodName,
      required this.args,
      required this.value,
      required this.rawTxn});

  factory _$_SwapRequestParametersData.fromJson(Map<String, dynamic> json) =>
      _$$_SwapRequestParametersDataFromJson(json);

  @override
  final String methodName;
  @override
  final List<dynamic> args;
  @override
  final String value;
  @override
  final Map<String, dynamic> rawTxn;

  @override
  String toString() {
    return 'SwapRequestParametersData(methodName: $methodName, args: $args, value: $value, rawTxn: $rawTxn)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SwapRequestParametersData &&
            const DeepCollectionEquality()
                .equals(other.methodName, methodName) &&
            const DeepCollectionEquality().equals(other.args, args) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            const DeepCollectionEquality().equals(other.rawTxn, rawTxn));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(methodName),
      const DeepCollectionEquality().hash(args),
      const DeepCollectionEquality().hash(value),
      const DeepCollectionEquality().hash(rawTxn));

  @JsonKey(ignore: true)
  @override
  _$$_SwapRequestParametersDataCopyWith<_$_SwapRequestParametersData>
      get copyWith => __$$_SwapRequestParametersDataCopyWithImpl<
          _$_SwapRequestParametersData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SwapRequestParametersDataToJson(this);
  }
}

abstract class _SwapRequestParametersData implements SwapRequestParametersData {
  factory _SwapRequestParametersData(
          {required final String methodName,
          required final List<dynamic> args,
          required final String value,
          required final Map<String, dynamic> rawTxn}) =
      _$_SwapRequestParametersData;

  factory _SwapRequestParametersData.fromJson(Map<String, dynamic> json) =
      _$_SwapRequestParametersData.fromJson;

  @override
  String get methodName => throw _privateConstructorUsedError;
  @override
  List<dynamic> get args => throw _privateConstructorUsedError;
  @override
  String get value => throw _privateConstructorUsedError;
  @override
  Map<String, dynamic> get rawTxn => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_SwapRequestParametersDataCopyWith<_$_SwapRequestParametersData>
      get copyWith => throw _privateConstructorUsedError;
}
