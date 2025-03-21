import 'package:json_annotation/json_annotation.dart';

part 'get_location_name_request.g.dart';

@JsonSerializable()
class GetLocationNameRequest {
  @JsonKey(name: "lat")
  final double latitude;
  @JsonKey(name: "lng")
  final double longitude;

  const GetLocationNameRequest({
    required this.latitude,
    required this.longitude,
  });

  factory GetLocationNameRequest.fromJson(Map<String, dynamic> json) =>
      _$GetLocationNameRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetLocationNameRequestToJson(this);
}
