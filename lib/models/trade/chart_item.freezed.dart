// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'chart_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChartItem _$ChartItemFromJson(Map<String, dynamic> json) {
  return _ChartItem.fromJson(json);
}

/// @nodoc
mixin _$ChartItem {
  num get timestamp => throw _privateConstructorUsedError;
  double get priceChange => throw _privateConstructorUsedError;
  double get previousPrice => throw _privateConstructorUsedError;
  double get currentPrice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChartItemCopyWith<ChartItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChartItemCopyWith<$Res> {
  factory $ChartItemCopyWith(ChartItem value, $Res Function(ChartItem) then) =
      _$ChartItemCopyWithImpl<$Res>;
  $Res call(
      {num timestamp,
      double priceChange,
      double previousPrice,
      double currentPrice});
}

/// @nodoc
class _$ChartItemCopyWithImpl<$Res> implements $ChartItemCopyWith<$Res> {
  _$ChartItemCopyWithImpl(this._value, this._then);

  final ChartItem _value;
  // ignore: unused_field
  final $Res Function(ChartItem) _then;

  @override
  $Res call({
    Object? timestamp = freezed,
    Object? priceChange = freezed,
    Object? previousPrice = freezed,
    Object? currentPrice = freezed,
  }) {
    return _then(_value.copyWith(
      timestamp: timestamp == freezed
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as num,
      priceChange: priceChange == freezed
          ? _value.priceChange
          : priceChange // ignore: cast_nullable_to_non_nullable
              as double,
      previousPrice: previousPrice == freezed
          ? _value.previousPrice
          : previousPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currentPrice: currentPrice == freezed
          ? _value.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$$_ChartItemCopyWith<$Res> implements $ChartItemCopyWith<$Res> {
  factory _$$_ChartItemCopyWith(
          _$_ChartItem value, $Res Function(_$_ChartItem) then) =
      __$$_ChartItemCopyWithImpl<$Res>;
  @override
  $Res call(
      {num timestamp,
      double priceChange,
      double previousPrice,
      double currentPrice});
}

/// @nodoc
class __$$_ChartItemCopyWithImpl<$Res> extends _$ChartItemCopyWithImpl<$Res>
    implements _$$_ChartItemCopyWith<$Res> {
  __$$_ChartItemCopyWithImpl(
      _$_ChartItem _value, $Res Function(_$_ChartItem) _then)
      : super(_value, (v) => _then(v as _$_ChartItem));

  @override
  _$_ChartItem get _value => super._value as _$_ChartItem;

  @override
  $Res call({
    Object? timestamp = freezed,
    Object? priceChange = freezed,
    Object? previousPrice = freezed,
    Object? currentPrice = freezed,
  }) {
    return _then(_$_ChartItem(
      timestamp: timestamp == freezed
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as num,
      priceChange: priceChange == freezed
          ? _value.priceChange
          : priceChange // ignore: cast_nullable_to_non_nullable
              as double,
      previousPrice: previousPrice == freezed
          ? _value.previousPrice
          : previousPrice // ignore: cast_nullable_to_non_nullable
              as double,
      currentPrice: currentPrice == freezed
          ? _value.currentPrice
          : currentPrice // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ChartItem implements _ChartItem {
  _$_ChartItem(
      {required this.timestamp,
      required this.priceChange,
      required this.previousPrice,
      required this.currentPrice});

  factory _$_ChartItem.fromJson(Map<String, dynamic> json) =>
      _$$_ChartItemFromJson(json);

  @override
  final num timestamp;
  @override
  final double priceChange;
  @override
  final double previousPrice;
  @override
  final double currentPrice;

  @override
  String toString() {
    return 'ChartItem(timestamp: $timestamp, priceChange: $priceChange, previousPrice: $previousPrice, currentPrice: $currentPrice)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChartItem &&
            const DeepCollectionEquality().equals(other.timestamp, timestamp) &&
            const DeepCollectionEquality()
                .equals(other.priceChange, priceChange) &&
            const DeepCollectionEquality()
                .equals(other.previousPrice, previousPrice) &&
            const DeepCollectionEquality()
                .equals(other.currentPrice, currentPrice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(timestamp),
      const DeepCollectionEquality().hash(priceChange),
      const DeepCollectionEquality().hash(previousPrice),
      const DeepCollectionEquality().hash(currentPrice));

  @JsonKey(ignore: true)
  @override
  _$$_ChartItemCopyWith<_$_ChartItem> get copyWith =>
      __$$_ChartItemCopyWithImpl<_$_ChartItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ChartItemToJson(this);
  }
}

abstract class _ChartItem implements ChartItem {
  factory _ChartItem(
      {required final num timestamp,
      required final double priceChange,
      required final double previousPrice,
      required final double currentPrice}) = _$_ChartItem;

  factory _ChartItem.fromJson(Map<String, dynamic> json) =
      _$_ChartItem.fromJson;

  @override
  num get timestamp => throw _privateConstructorUsedError;
  @override
  double get priceChange => throw _privateConstructorUsedError;
  @override
  double get previousPrice => throw _privateConstructorUsedError;
  @override
  double get currentPrice => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_ChartItemCopyWith<_$_ChartItem> get copyWith =>
      throw _privateConstructorUsedError;
}
