import 'package:json_annotation/json_annotation.dart';

part 'booking_rate_model.g.dart';

@JsonSerializable()
class BookingRateModel {
  @JsonKey(defaultValue: "")
  final String? comment;

  @JsonKey(defaultValue: 0.0)
  final double? rate;

  const BookingRateModel({required this.comment, required this.rate});

  factory BookingRateModel.fromJson(Map<String, dynamic> json) =>
      _$BookingRateModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingRateModelToJson(this);

  const BookingRateModel.empty({
    this.comment = '',
    this.rate = 0.0,
  });

  BookingRateModel copyWith({
    String? comment,
    double? rate,
  }) {
    return BookingRateModel(
      comment: comment ?? this.comment,
      rate: rate ?? this.rate,
    );
  }
}
