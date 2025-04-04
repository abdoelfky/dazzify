import 'package:dazzify/features/user/data/models/user/user_profile_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'guest_model.g.dart';


@JsonSerializable()
class GuestModel {
  @JsonKey(defaultValue: false)
  final bool guestMode;
  @JsonKey(defaultValue: "")
  final String? guestToken;
  @JsonKey(defaultValue: "")
  final DateTime? guestTokenExpireTime;

  const GuestModel({
    required this.guestMode,
    this.guestToken,
    this.guestTokenExpireTime,
  });

  factory GuestModel.fromJson(Map<String, dynamic> json) =>
      _$GuestModelFromJson(json);

  Map<String, dynamic> toJson() => _$GuestModelToJson(this);

  const GuestModel.empty({
    this.guestMode = false,
    this.guestToken = "",
    this.guestTokenExpireTime ,

  });

  GuestModel copyWith({
    bool? guestMode,
    String? guestToken,
    DateTime? guestTokenExpireTime,

  }) {
    return GuestModel(
      guestMode: guestMode ?? this.guestMode,
      guestToken: guestToken ?? this.guestToken,
      guestTokenExpireTime: guestTokenExpireTime ?? this.guestTokenExpireTime,

    );
  }
}
