import 'package:json_annotation/json_annotation.dart';

part 'add_user_info_request.g.dart';

@JsonSerializable()
class AddUserInfoRequest {
  @JsonKey(name: "fullName")
  final String fullName;
  @JsonKey(name: "gender")
  final String gender;
  @JsonKey(name: "email")
  final String email;
  // @JsonKey(name: "age")
  // final int age;
  @JsonKey(name: "birthday")
  final String birthDay;
  @JsonKey(name: "languagePreference")
  final String lang;

  const AddUserInfoRequest({
    required this.fullName,
    required this.gender,
    required this.email,
    required this.birthDay,
    // required this.age,
    required this.lang,
  });

  factory AddUserInfoRequest.fromJson(Map<String, dynamic> json) =>
      _$AddUserInfoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddUserInfoRequestToJson(this);
}
