// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_brands_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBrandsRequest _$GetBrandsRequestFromJson(Map<String, dynamic> json) =>
    GetBrandsRequest(
      keyword: json['keyword'] as String?,
      mainCategory: json['mainCategory'] as String?,
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );

Map<String, dynamic> _$GetBrandsRequestToJson(GetBrandsRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('keyword', instance.keyword);
  writeNotNull('mainCategory', instance.mainCategory);
  val['page'] = instance.page;
  val['limit'] = instance.limit;
  return val;
}
