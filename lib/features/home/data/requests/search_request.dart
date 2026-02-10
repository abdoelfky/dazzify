import 'package:json_annotation/json_annotation.dart';
part 'search_request.g.dart';

@JsonSerializable()
class SearchRequest {
  @JsonKey(name: "searchType")
  final String searchType;

  @JsonKey(name: "searchKeyWord")
  final String searchKeyWord;

  @JsonKey(name: "page")
  final int page;

  @JsonKey(name: "limit")
  final int limit;

  const SearchRequest({
    required this.searchType,
    required this.searchKeyWord,
    required this.page,
    required this.limit,
  });

  factory SearchRequest.fromJson(Map<String, dynamic> json) =>
      _$SearchRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SearchRequestToJson(this);
}

