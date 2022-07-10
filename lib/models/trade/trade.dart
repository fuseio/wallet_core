import 'package:freezed_annotation/freezed_annotation.dart';

part 'trade.freezed.dart';
part 'trade.g.dart';

@freezed
class Trade with _$Trade {
  factory Trade({
    required String inputAmount,
    required String outputAmount,
    required List<String> route,
    required String inputToken,
    required String outputToken,
    required String executionPrice,
    required String nextMidPrice,
    required String priceImpact,
  }) = _Trade;

  factory Trade.fromJson(Map<String, dynamic> json) =>
      _$TradeFromJson(json);
}
