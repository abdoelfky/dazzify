import 'package:json_annotation/json_annotation.dart';

part 'update_profile_info_request.g.dart';

@JsonSerializable()
class UpdateProfileInfoRequest {
  @JsonKey(name: "email", includeIfNull: false)
  final String? email;

  @JsonKey(name: "gender", includeIfNull: false)
  final String? gender;

  @JsonKey(name: "birthday", includeIfNull: false)
  final String? birthday;

  // @JsonKey(name: "age", includeIfNull: false)
  // final int? age;

  const UpdateProfileInfoRequest({
    this.email,
    this.gender,
    this.birthday,
    // this.age,
  });

  factory UpdateProfileInfoRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileInfoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileInfoRequestToJson(this);
}
