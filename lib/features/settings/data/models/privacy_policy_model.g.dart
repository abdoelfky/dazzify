// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_policy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrivacyPolicyModel _$PrivacyPolicyModelFromJson(Map<String, dynamic> json) =>
    PrivacyPolicyModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$PrivacyPolicyModelToJson(PrivacyPolicyModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

PrivacyPoliciesResponseModel _$PrivacyPoliciesResponseModelFromJson(
        Map<String, dynamic> json) =>
    PrivacyPoliciesResponseModel(
      success: json['success'] as bool,
      statusCode: (json['statusCode'] as num).toInt(),
      message: json['message'] as String,
      data: PrivacyPoliciesDataModel.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PrivacyPoliciesResponseModelToJson(
        PrivacyPoliciesResponseModel instance) =>
    <String, dynamic>{
      'success': instance.success,
      'statusCode': instance.statusCode,
      'message': instance.message,
      'data': instance.data,
    };

PrivacyPoliciesDataModel _$PrivacyPoliciesDataModelFromJson(
        Map<String, dynamic> json) =>
    PrivacyPoliciesDataModel(
      policies: (json['policies'] as List<dynamic>)
          .map((e) => PrivacyPolicyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PrivacyPoliciesDataModelToJson(
        PrivacyPoliciesDataModel instance) =>
    <String, dynamic>{
      'policies': instance.policies,
    };
