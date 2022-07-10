import 'package:freezed_annotation/freezed_annotation.dart';

part 'trade_request_body.freezed.dart';
part 'trade_request_body.g.dart';

@freezed
class TradeRequestBody with _$TradeRequestBody {
  factory TradeRequestBody({
    @Default('') String currencyIn,
    @Default('') String currencyOut,
    @Default('') String amountIn,
    @Default('') String recipient,
  }) = _TradeRequestBody;

  factory TradeRequestBody.fromJson(Map<String, dynamic> json) =>
      _$TradeRequestBodyFromJson(json);
}
