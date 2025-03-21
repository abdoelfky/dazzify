// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_services_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionServicesModel _$TransactionServicesModelFromJson(
        Map<String, dynamic> json) =>
    TransactionServicesModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );

Map<String, dynamic> _$TransactionServicesModelToJson(
        TransactionServicesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'image': instance.image,
    };
