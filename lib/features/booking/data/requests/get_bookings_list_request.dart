import 'package:json_annotation/json_annotation.dart';

part 'get_bookings_list_request.g.dart';

@JsonSerializable()
class GetBookingsListRequest {
  @JsonKey(name: "page")
  final int page;
  @JsonKey(name: "limit")
  final int limit;

  const GetBookingsListRequest({
    required this.page,
    required this.limit,
  });

  factory GetBookingsListRequest.fromJson(Map<String, dynamic> json) =>
      _$GetBookingsListRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetBookingsListRequestToJson(this);
}
