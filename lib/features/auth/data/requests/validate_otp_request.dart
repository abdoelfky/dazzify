import 'package:json_annotation/json_annotation.dart';

part 'validate_otp_request.g.dart';

@JsonSerializable()
class ValidateOtpRequest {
  @JsonKey(name: "phoneNumber")
  final String phoneNumber;
  @JsonKey(name: "otp")
  final String otpCode;
  @JsonKey(name: "languagePreference", includeIfNull: false)
  final String? lang;

  const ValidateOtpRequest({
    required this.phoneNumber,
    required this.otpCode,
    this.lang,
  });

  factory ValidateOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$ValidateOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ValidateOtpRequestToJson(this);
}
