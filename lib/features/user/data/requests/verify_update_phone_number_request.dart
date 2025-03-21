import 'package:json_annotation/json_annotation.dart';

part 'verify_update_phone_number_request.g.dart';

@JsonSerializable()
class VerifyUpdatePhoneNumberRequest {
  @JsonKey(name: "newPhoneNumber")
  final String newPhoneNumber;

  @JsonKey(name: "otp")
  final String otp;

  const VerifyUpdatePhoneNumberRequest({
    required this.newPhoneNumber,
    required this.otp,
  });

  factory VerifyUpdatePhoneNumberRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyUpdatePhoneNumberRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyUpdatePhoneNumberRequestToJson(this);
}
