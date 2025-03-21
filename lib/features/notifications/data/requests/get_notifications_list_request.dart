import 'package:json_annotation/json_annotation.dart';

part 'get_notifications_list_request.g.dart';

@JsonSerializable()
class GetNotificationsListRequest {
  @JsonKey(name: "page")
  final int page;

  @JsonKey(name: "limit")
  final int limit;

  const GetNotificationsListRequest({
    required this.page,
    required this.limit,
  });

  factory GetNotificationsListRequest.fromJson(Map<String, dynamic> json) =>
      _$GetNotificationsListRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetNotificationsListRequestToJson(this);
}
