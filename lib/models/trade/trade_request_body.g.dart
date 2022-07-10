// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trade_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_TradeRequestBody _$$_TradeRequestBodyFromJson(Map<String, dynamic> json) =>
    _$_TradeRequestBody(
      currencyIn: json['currencyIn'] as String? ?? '',
      currencyOut: json['currencyOut'] as String? ?? '',
      amountIn: json['amountIn'] as String? ?? '',
      recipient: json['recipient'] as String? ?? '',
    );

Map<String, dynamic> _$$_TradeRequestBodyToJson(_$_TradeRequestBody instance) =>
    <String, dynamic>{
      'currencyIn': instance.currencyIn,
      'currencyOut': instance.currencyOut,
      'amountIn': instance.amountIn,
      'recipient': instance.recipient,
    };
