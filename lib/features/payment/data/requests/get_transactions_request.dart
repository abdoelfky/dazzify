import 'package:json_annotation/json_annotation.dart';

part 'get_transactions_request.g.dart';

@JsonSerializable()
class GetTransactionsRequest {
  @JsonKey(name: "page")
  final int page;

  @JsonKey(name: "limit")
  final int limit;

  @JsonKey(name: "status", includeIfNull: false)
  final String? status;

  const GetTransactionsRequest({
    required this.page,
    required this.limit,
    this.status,
  });

  factory GetTransactionsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetTransactionsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GetTransactionsRequestToJson(this);
}
