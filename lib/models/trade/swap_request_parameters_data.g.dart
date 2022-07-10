// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swap_request_parameters_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SwapRequestParametersData _$$_SwapRequestParametersDataFromJson(
        Map<String, dynamic> json) =>
    _$_SwapRequestParametersData(
      methodName: json['methodName'] as String,
      args: json['args'] as List<dynamic>,
      value: json['value'] as String,
      rawTxn: json['rawTxn'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$_SwapRequestParametersDataToJson(
        _$_SwapRequestParametersData instance) =>
    <String, dynamic>{
      'methodName': instance.methodName,
      'args': instance.args,
      'value': instance.value,
      'rawTxn': instance.rawTxn,
    };
