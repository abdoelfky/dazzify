// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_fees_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppFees _$AppFeesFromJson(Map<String, dynamic> json) => AppFees(
      max: (json['max'] as num).toInt(),
      min: (json['min'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$AppFeesToJson(AppFees instance) => <String, dynamic>{
      'max': instance.max,
      'min': instance.min,
      'percentage': instance.percentage,
    };
