import 'package:json_annotation/json_annotation.dart';

part 'privacy_policy_model.g.dart';

@JsonSerializable()
class PrivacyPolicyModel {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final String content;
  final String createdAt;
  final String updatedAt;

  PrivacyPolicyModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrivacyPolicyModel.fromJson(Map<String, dynamic> json) =>
      _$PrivacyPolicyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrivacyPolicyModelToJson(this);
}

@JsonSerializable()
class PrivacyPoliciesResponseModel {
  final bool success;
  final int statusCode;
  final String message;
  final PrivacyPoliciesDataModel data;

  PrivacyPoliciesResponseModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory PrivacyPoliciesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PrivacyPoliciesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrivacyPoliciesResponseModelToJson(this);
}

@JsonSerializable()
class PrivacyPoliciesDataModel {
  final List<PrivacyPolicyModel> policies;

  PrivacyPoliciesDataModel({
    required this.policies,
  });

  factory PrivacyPoliciesDataModel.fromJson(Map<String, dynamic> json) =>
      _$PrivacyPoliciesDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrivacyPoliciesDataModelToJson(this);
}
