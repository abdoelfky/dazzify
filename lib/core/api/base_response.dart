import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(createToJson: false)
class BaseResponse {
  final String status;
  final dynamic data;
  final BackEndError? error;

  const BaseResponse({
    required this.status,
    this.error,
    this.data,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) =>
      _$BaseResponseFromJson(json);

  bool get isSuccess => status == "success";
}

@JsonSerializable(createToJson: false)
class BackEndError {
  @JsonKey(defaultValue: 0)
  final int code;

  @JsonKey(defaultValue: "")
  final String message;

  BackEndError({
    required this.code,
    required this.message,
  });

  factory BackEndError.fromJson(Map<String, dynamic> json) =>
      _$BackEndErrorFromJson(json);
}
