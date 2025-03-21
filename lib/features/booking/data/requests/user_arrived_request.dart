import 'package:json_annotation/json_annotation.dart';

part 'user_arrived_request.g.dart';

@JsonSerializable()
class UserArrivedRequest {
  @JsonKey(name: "longitude")
  final double longitude;
  @JsonKey(name: "latitude")
  final double latitude;

  const UserArrivedRequest({
    required this.longitude,
    required this.latitude,
  });

  factory UserArrivedRequest.fromJson(Map<String, dynamic> json) =>
      _$UserArrivedRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UserArrivedRequestToJson(this);
}
