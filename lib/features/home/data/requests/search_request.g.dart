// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchRequest _$SearchRequestFromJson(Map<String, dynamic> json) =>
    SearchRequest(
      searchType: json['searchType'] as String,
      searchKeyWord: json['searchKeyWord'] as String,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$SearchRequestToJson(SearchRequest instance) =>
    <String, dynamic>{
      'searchType': instance.searchType,
      'searchKeyWord': instance.searchKeyWord,
      'page': instance.page,
      'limit': instance.limit,
    };
