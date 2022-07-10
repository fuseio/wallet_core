// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'trade.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Trade _$TradeFromJson(Map<String, dynamic> json) {
  return _Trade.fromJson(json);
}

/// @nodoc
mixin _$Trade {
  String get inputAmount => throw _privateConstructorUsedError;
  String get outputAmount => throw _privateConstructorUsedError;
  List<String> get route => throw _privateConstructorUsedError;
  String get inputToken => throw _privateConstructorUsedError;
  String get outputToken => throw _privateConstructorUsedError;
  String get executionPrice => throw _privateConstructorUsedError;
  String get nextMidPrice => throw _privateConstructorUsedError;
  String get priceImpact => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TradeCopyWith<Trade> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TradeCopyWith<$Res> {
  factory $TradeCopyWith(Trade value, $Res Function(Trade) then) =
      _$TradeCopyWithImpl<$Res>;
  $Res call(
      {String inputAmount,
      String outputAmount,
      List<String> route,
      String inputToken,
      String outputToken,
      String executionPrice,
      String nextMidPrice,
      String priceImpact});
}

/// @nodoc
class _$TradeCopyWithImpl<$Res> implements $TradeCopyWith<$Res> {
  _$TradeCopyWithImpl(this._value, this._then);

  final Trade _value;
  // ignore: unused_field
  final $Res Function(Trade) _then;

  @override
  $Res call({
    Object? inputAmount = freezed,
    Object? outputAmount = freezed,
    Object? route = freezed,
    Object? inputToken = freezed,
    Object? outputToken = freezed,
    Object? executionPrice = freezed,
    Object? nextMidPrice = freezed,
    Object? priceImpact = freezed,
  }) {
    return _then(_value.copyWith(
      inputAmount: inputAmount == freezed
          ? _value.inputAmount
          : inputAmount // ignore: cast_nullable_to_non_nullable
              as String,
      outputAmount: outputAmount == freezed
          ? _value.outputAmount
          : outputAmount // ignore: cast_nullable_to_non_nullable
              as String,
      route: route == freezed
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inputToken: inputToken == freezed
          ? _value.inputToken
          : inputToken // ignore: cast_nullable_to_non_nullable
              as String,
      outputToken: outputToken == freezed
          ? _value.outputToken
          : outputToken // ignore: cast_nullable_to_non_nullable
              as String,
      executionPrice: executionPrice == freezed
          ? _value.executionPrice
          : executionPrice // ignore: cast_nullable_to_non_nullable
              as String,
      nextMidPrice: nextMidPrice == freezed
          ? _value.nextMidPrice
          : nextMidPrice // ignore: cast_nullable_to_non_nullable
              as String,
      priceImpact: priceImpact == freezed
          ? _value.priceImpact
          : priceImpact // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_TradeCopyWith<$Res> implements $TradeCopyWith<$Res> {
  factory _$$_TradeCopyWith(_$_Trade value, $Res Function(_$_Trade) then) =
      __$$_TradeCopyWithImpl<$Res>;
  @override
  $Res call(
      {String inputAmount,
      String outputAmount,
      List<String> route,
      String inputToken,
      String outputToken,
      String executionPrice,
      String nextMidPrice,
      String priceImpact});
}

/// @nodoc
class __$$_TradeCopyWithImpl<$Res> extends _$TradeCopyWithImpl<$Res>
    implements _$$_TradeCopyWith<$Res> {
  __$$_TradeCopyWithImpl(_$_Trade _value, $Res Function(_$_Trade) _then)
      : super(_value, (v) => _then(v as _$_Trade));

  @override
  _$_Trade get _value => super._value as _$_Trade;

  @override
  $Res call({
    Object? inputAmount = freezed,
    Object? outputAmount = freezed,
    Object? route = freezed,
    Object? inputToken = freezed,
    Object? outputToken = freezed,
    Object? executionPrice = freezed,
    Object? nextMidPrice = freezed,
    Object? priceImpact = freezed,
  }) {
    return _then(_$_Trade(
      inputAmount: inputAmount == freezed
          ? _value.inputAmount
          : inputAmount // ignore: cast_nullable_to_non_nullable
              as String,
      outputAmount: outputAmount == freezed
          ? _value.outputAmount
          : outputAmount // ignore: cast_nullable_to_non_nullable
              as String,
      route: route == freezed
          ? _value.route
          : route // ignore: cast_nullable_to_non_nullable
              as List<String>,
      inputToken: inputToken == freezed
          ? _value.inputToken
          : inputToken // ignore: cast_nullable_to_non_nullable
              as String,
      outputToken: outputToken == freezed
          ? _value.outputToken
          : outputToken // ignore: cast_nullable_to_non_nullable
              as String,
      executionPrice: executionPrice == freezed
          ? _value.executionPrice
          : executionPrice // ignore: cast_nullable_to_non_nullable
              as String,
      nextMidPrice: nextMidPrice == freezed
          ? _value.nextMidPrice
          : nextMidPrice // ignore: cast_nullable_to_non_nullable
              as String,
      priceImpact: priceImpact == freezed
          ? _value.priceImpact
          : priceImpact // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Trade implements _Trade {
  _$_Trade(
      {required this.inputAmount,
      required this.outputAmount,
      required this.route,
      required this.inputToken,
      required this.outputToken,
      required this.executionPrice,
      required this.nextMidPrice,
      required this.priceImpact});

  factory _$_Trade.fromJson(Map<String, dynamic> json) =>
      _$$_TradeFromJson(json);

  @override
  final String inputAmount;
  @override
  final String outputAmount;
  @override
  final List<String> route;
  @override
  final String inputToken;
  @override
  final String outputToken;
  @override
  final String executionPrice;
  @override
  final String nextMidPrice;
  @override
  final String priceImpact;

  @override
  String toString() {
    return 'Trade(inputAmount: $inputAmount, outputAmount: $outputAmount, route: $route, inputToken: $inputToken, outputToken: $outputToken, executionPrice: $executionPrice, nextMidPrice: $nextMidPrice, priceImpact: $priceImpact)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Trade &&
            const DeepCollectionEquality()
                .equals(other.inputAmount, inputAmount) &&
            const DeepCollectionEquality()
                .equals(other.outputAmount, outputAmount) &&
            const DeepCollectionEquality().equals(other.route, route) &&
            const DeepCollectionEquality()
                .equals(other.inputToken, inputToken) &&
            const DeepCollectionEquality()
                .equals(other.outputToken, outputToken) &&
            const DeepCollectionEquality()
                .equals(other.executionPrice, executionPrice) &&
            const DeepCollectionEquality()
                .equals(other.nextMidPrice, nextMidPrice) &&
            const DeepCollectionEquality()
                .equals(other.priceImpact, priceImpact));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(inputAmount),
      const DeepCollectionEquality().hash(outputAmount),
      const DeepCollectionEquality().hash(route),
      const DeepCollectionEquality().hash(inputToken),
      const DeepCollectionEquality().hash(outputToken),
      const DeepCollectionEquality().hash(executionPrice),
      const DeepCollectionEquality().hash(nextMidPrice),
      const DeepCollectionEquality().hash(priceImpact));

  @JsonKey(ignore: true)
  @override
  _$$_TradeCopyWith<_$_Trade> get copyWith =>
      __$$_TradeCopyWithImpl<_$_Trade>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TradeToJson(this);
  }
}

abstract class _Trade implements Trade {
  factory _Trade(
      {required final String inputAmount,
      required final String outputAmount,
      required final List<String> route,
      required final String inputToken,
      required final String outputToken,
      required final String executionPrice,
      required final String nextMidPrice,
      required final String priceImpact}) = _$_Trade;

  factory _Trade.fromJson(Map<String, dynamic> json) = _$_Trade.fromJson;

  @override
  String get inputAmount => throw _privateConstructorUsedError;
  @override
  String get outputAmount => throw _privateConstructorUsedError;
  @override
  List<String> get route => throw _privateConstructorUsedError;
  @override
  String get inputToken => throw _privateConstructorUsedError;
  @override
  String get outputToken => throw _privateConstructorUsedError;
  @override
  String get executionPrice => throw _privateConstructorUsedError;
  @override
  String get nextMidPrice => throw _privateConstructorUsedError;
  @override
  String get priceImpact => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_TradeCopyWith<_$_Trade> get copyWith =>
      throw _privateConstructorUsedError;
}
