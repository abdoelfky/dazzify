import 'package:json_annotation/json_annotation.dart';

part 'send_otp_request.g.dart';

@JsonSerializable()
class SendOtpRequest {
  @JsonKey(name: "phoneNumber")
  final String phoneNumber;
  @JsonKey(name: "languagePreference", includeIfNull: false)
  final String? languagePreference;

  const SendOtpRequest({
    required this.phoneNumber,
    this.languagePreference,
  });

  factory SendOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$SendOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpRequestToJson(this);
}
