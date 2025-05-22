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
