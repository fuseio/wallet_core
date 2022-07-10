// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChartItem _$$_ChartItemFromJson(Map<String, dynamic> json) => _$_ChartItem(
      timestamp: json['timestamp'] as num,
      priceChange: (json['priceChange'] as num).toDouble(),
      previousPrice: (json['previousPrice'] as num).toDouble(),
      currentPrice: (json['currentPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$$_ChartItemToJson(_$_ChartItem instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'priceChange': instance.priceChange,
      'previousPrice': instance.previousPrice,
      'currentPrice': instance.currentPrice,
    };
