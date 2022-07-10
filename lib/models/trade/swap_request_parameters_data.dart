import 'package:freezed_annotation/freezed_annotation.dart';

part 'swap_request_parameters_data.freezed.dart';
part 'swap_request_parameters_data.g.dart';

@freezed
class SwapRequestParametersData with _$SwapRequestParametersData {
  factory SwapRequestParametersData({
    required String methodName,
    required List<dynamic> args,
    required String value,
    required Map<String, dynamic> rawTxn,
  }) = _SwapRequestParametersData;

  factory SwapRequestParametersData.fromJson(Map<String, dynamic> json) =>
      _$SwapRequestParametersDataFromJson(json);
}
