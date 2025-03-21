import 'package:dazzify/features/user/data/models/user/user_profile_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(defaultValue: "")
  final String id;
  @JsonKey(defaultValue: "")
  final String fullName;
  final String? picture;
  @JsonKey(defaultValue: "")
  final String username;
  @JsonKey(defaultValue: "")
  final String phoneNumber;
  @JsonKey(defaultValue: "")
  final String deletedAt;
  @JsonKey(defaultValue: "en")
  final String languagePreference;
  final UserProfileModel profile;
  @JsonKey(defaultValue: 0)
  final int points;

  const UserModel({
    required this.id,
    required this.fullName,
    this.picture,
    required this.username,
    required this.phoneNumber,
    required this.deletedAt,
    required this.profile,
    required this.points,
    required this.languagePreference,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  const UserModel.empty({
    this.id = "",
    this.fullName = "",
    this.picture,
    this.username = "",
    this.phoneNumber = "",
    this.deletedAt = "",
    this.languagePreference = "en",
    this.profile = const UserProfileModel.empty(),
    this.points = 0,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? picture,
    String? username,
    String? phoneNumber,
    String? deletedAt,
    String? languagePreference,
    UserProfileModel? profile,
    int? points,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      picture: picture ?? this.picture,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      deletedAt: deletedAt ?? this.deletedAt,
      languagePreference: languagePreference ?? this.languagePreference,
      profile: profile ?? this.profile,
      points: points ?? this.points,
    );
  }
}
