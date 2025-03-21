// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reviews_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
      id: json['id'] as String? ?? '',
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] as String? ?? '',
      user: ReviewerModel.fromJson(json['user'] as Map<String, dynamic>),
      isLate: json['isLate'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rate': instance.rate,
      'comment': instance.comment,
      'user': instance.user,
      'isLate': instance.isLate,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
