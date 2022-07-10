import 'package:freezed_annotation/freezed_annotation.dart';

part 'chart_item.freezed.dart';
part 'chart_item.g.dart';

@freezed
class ChartItem with _$ChartItem {
  factory ChartItem({
    required num timestamp,
    required double priceChange,
    required double previousPrice,
    required double currentPrice,
  }) = _ChartItem;

  factory ChartItem.fromJson(Map<String, dynamic> json) =>
      _$ChartItemFromJson(json);
}
