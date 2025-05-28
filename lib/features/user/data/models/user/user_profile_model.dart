// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dazzify/features/brand/data/models/location_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel {
  @JsonKey(defaultValue: "")
  final String gender;
  @JsonKey(defaultValue: "")
  final String birthday;
  @JsonKey(defaultValue: "")
  final String email;
  @JsonKey(defaultValue: 0)
  final int wallet;
  // @JsonKey(defaultValue: 0)
  // final int age;
  final LocationModel? location;

  const UserProfileModel({
    required this.gender,
    required this.email,
    required this.wallet,
    this.location,
    required this.birthday,
    // required this.age,
  });

  const UserProfileModel.empty({
    this.gender = "",
    this.email = "",
    this.wallet = 0,
    this.location,
    // this.age = 0,
    this.birthday = "",
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);

  UserProfileModel copyWith({
    String? gender,
    String? email,
    String? birthday,
    List<dynamic>? couponsUsed,
    int? wallet,
    // int? age,
    LocationModel? location,
  }) {
    return UserProfileModel(
      gender: gender ?? this.gender,
      email: email ?? this.email,
      wallet: wallet ?? this.wallet,
      // age: age ?? this.age,
      birthday: birthday ?? this.birthday,
      location: location ?? this.location,
    );
  }
}
