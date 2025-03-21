import 'package:json_annotation/json_annotation.dart';

part 'update_profile_location_request.g.dart';

@JsonSerializable()
class UpdateProfileLocationRequest {
  @JsonKey(name: "longitude")
  final double longitude;

  @JsonKey(name: "latitude")
  final double latitude;

  const UpdateProfileLocationRequest({
    required this.longitude,
    required this.latitude,
  });

  factory UpdateProfileLocationRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileLocationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateProfileLocationRequestToJson(this);
}
