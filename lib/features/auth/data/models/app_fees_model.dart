import 'package:json_annotation/json_annotation.dart';
part 'app_fees_model.g.dart';

@JsonSerializable()
class AppFees {
  final int max;
  final int min;
  final double percentage;

  const AppFees({
    required this.max,
    required this.min,
    required this.percentage,
  });

  factory AppFees.fromJson(Map<String, dynamic> json) =>
      _$AppFeesFromJson(json);

  Map<String, dynamic> toJson() => _$AppFeesToJson(this);
}
