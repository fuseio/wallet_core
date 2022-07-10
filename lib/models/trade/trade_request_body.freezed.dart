// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'trade_request_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TradeRequestBody _$TradeRequestBodyFromJson(Map<String, dynamic> json) {
  return _TradeRequestBody.fromJson(json);
}

/// @nodoc
mixin _$TradeRequestBody {
  String get currencyIn => throw _privateConstructorUsedError;
  String get currencyOut => throw _privateConstructorUsedError;
  String get amountIn => throw _privateConstructorUsedError;
  String get recipient => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TradeRequestBodyCopyWith<TradeRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TradeRequestBodyCopyWith<$Res> {
  factory $TradeRequestBodyCopyWith(
          TradeRequestBody value, $Res Function(TradeRequestBody) then) =
      _$TradeRequestBodyCopyWithImpl<$Res>;
  $Res call(
      {String currencyIn,
      String currencyOut,
      String amountIn,
      String recipient});
}

/// @nodoc
class _$TradeRequestBodyCopyWithImpl<$Res>
    implements $TradeRequestBodyCopyWith<$Res> {
  _$TradeRequestBodyCopyWithImpl(this._value, this._then);

  final TradeRequestBody _value;
  // ignore: unused_field
  final $Res Function(TradeRequestBody) _then;

  @override
  $Res call({
    Object? currencyIn = freezed,
    Object? currencyOut = freezed,
    Object? amountIn = freezed,
    Object? recipient = freezed,
  }) {
    return _then(_value.copyWith(
      currencyIn: currencyIn == freezed
          ? _value.currencyIn
          : currencyIn // ignore: cast_nullable_to_non_nullable
              as String,
      currencyOut: currencyOut == freezed
          ? _value.currencyOut
          : currencyOut // ignore: cast_nullable_to_non_nullable
              as String,
      amountIn: amountIn == freezed
          ? _value.amountIn
          : amountIn // ignore: cast_nullable_to_non_nullable
              as String,
      recipient: recipient == freezed
          ? _value.recipient
          : recipient // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_TradeRequestBodyCopyWith<$Res>
    implements $TradeRequestBodyCopyWith<$Res> {
  factory _$$_TradeRequestBodyCopyWith(
          _$_TradeRequestBody value, $Res Function(_$_TradeRequestBody) then) =
      __$$_TradeRequestBodyCopyWithImpl<$Res>;
  @override
  $Res call(
      {String currencyIn,
      String currencyOut,
      String amountIn,
      String recipient});
}

/// @nodoc
class __$$_TradeRequestBodyCopyWithImpl<$Res>
    extends _$TradeRequestBodyCopyWithImpl<$Res>
    implements _$$_TradeRequestBodyCopyWith<$Res> {
  __$$_TradeRequestBodyCopyWithImpl(
      _$_TradeRequestBody _value, $Res Function(_$_TradeRequestBody) _then)
      : super(_value, (v) => _then(v as _$_TradeRequestBody));

  @override
  _$_TradeRequestBody get _value => super._value as _$_TradeRequestBody;

  @override
  $Res call({
    Object? currencyIn = freezed,
    Object? currencyOut = freezed,
    Object? amountIn = freezed,
    Object? recipient = freezed,
  }) {
    return _then(_$_TradeRequestBody(
      currencyIn: currencyIn == freezed
          ? _value.currencyIn
          : currencyIn // ignore: cast_nullable_to_non_nullable
              as String,
      currencyOut: currencyOut == freezed
          ? _value.currencyOut
          : currencyOut // ignore: cast_nullable_to_non_nullable
              as String,
      amountIn: amountIn == freezed
          ? _value.amountIn
          : amountIn // ignore: cast_nullable_to_non_nullable
              as String,
      recipient: recipient == freezed
          ? _value.recipient
          : recipient // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TradeRequestBody implements _TradeRequestBody {
  _$_TradeRequestBody(
      {this.currencyIn = '',
      this.currencyOut = '',
      this.amountIn = '',
      this.recipient = ''});

  factory _$_TradeRequestBody.fromJson(Map<String, dynamic> json) =>
      _$$_TradeRequestBodyFromJson(json);

  @override
  @JsonKey()
  final String currencyIn;
  @override
  @JsonKey()
  final String currencyOut;
  @override
  @JsonKey()
  final String amountIn;
  @override
  @JsonKey()
  final String recipient;

  @override
  String toString() {
    return 'TradeRequestBody(currencyIn: $currencyIn, currencyOut: $currencyOut, amountIn: $amountIn, recipient: $recipient)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TradeRequestBody &&
            const DeepCollectionEquality()
                .equals(other.currencyIn, currencyIn) &&
            const DeepCollectionEquality()
                .equals(other.currencyOut, currencyOut) &&
            const DeepCollectionEquality().equals(other.amountIn, amountIn) &&
            const DeepCollectionEquality().equals(other.recipient, recipient));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(currencyIn),
      const DeepCollectionEquality().hash(currencyOut),
      const DeepCollectionEquality().hash(amountIn),
      const DeepCollectionEquality().hash(recipient));

  @JsonKey(ignore: true)
  @override
  _$$_TradeRequestBodyCopyWith<_$_TradeRequestBody> get copyWith =>
      __$$_TradeRequestBodyCopyWithImpl<_$_TradeRequestBody>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TradeRequestBodyToJson(this);
  }
}

abstract class _TradeRequestBody implements TradeRequestBody {
  factory _TradeRequestBody(
      {final String currencyIn,
      final String currencyOut,
      final String amountIn,
      final String recipient}) = _$_TradeRequestBody;

  factory _TradeRequestBody.fromJson(Map<String, dynamic> json) =
      _$_TradeRequestBody.fromJson;

  @override
  String get currencyIn => throw _privateConstructorUsedError;
  @override
  String get currencyOut => throw _privateConstructorUsedError;
  @override
  String get amountIn => throw _privateConstructorUsedError;
  @override
  String get recipient => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_TradeRequestBodyCopyWith<_$_TradeRequestBody> get copyWith =>
      throw _privateConstructorUsedError;
}
