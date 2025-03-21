import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel {
  @JsonKey(defaultValue: "")
  final String otp;
  @JsonKey(defaultValue: 0)
  final int user;

  const AuthModel({
    required this.otp,
    required this.user,
  });

  const AuthModel.empty([
    this.otp = "",
    this.user = 0,
  ]);

  bool get isNewUser {
    return user == 0;
  }

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthModelToJson(this);
}
