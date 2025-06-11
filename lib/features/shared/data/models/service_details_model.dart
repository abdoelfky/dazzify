import 'package:dazzify/dazzify_app.dart';
import 'package:dazzify/features/home/data/models/service_model.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/data/models/favorite_model.dart';
import 'package:dazzify/features/shared/data/models/in_branches_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_details_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceDetailsModel {
  @JsonKey(defaultValue: "")
  final String id;

  final BrandModel brand;

  @JsonKey(defaultValue: "")
  final String title;

  @JsonKey(defaultValue: "")
  final String description;

  @JsonKey(defaultValue: "")
  final String image;

  @JsonKey(defaultValue: 0)
  final num price;

  @JsonKey(defaultValue: 0)
  final int fees;

  @JsonKey(defaultValue: 0)
  final int duration;

  @JsonKey(defaultValue: 0)
  final int bookingCount;
  @JsonKey(defaultValue: 1)
  final int quantity;

  @JsonKey(defaultValue: [])
  final List<String> includes;

  @JsonKey(defaultValue: "")
  final String serviceLocation;
  @JsonKey(defaultValue: false)
  final bool allowMultipleServicesBook;

  @JsonKey(defaultValue: false)
  final bool allowMultipleServicesCount;

  @JsonKey(defaultValue: 0)
  final int lateLimit;

  @JsonKey(defaultValue: "")
  final String type;

  @JsonKey(defaultValue: 0)
  final double rating;

  @JsonKey(defaultValue: 0)
  final int ratingCount;

  @JsonKey(defaultValue: [])
  final List<InBranchesModel> inBranches;

  @JsonKey(defaultValue: {})
  final Map<String, double> ratingPercentage;

  @JsonKey(defaultValue: [])
  final List<ServiceModel>? services;

  const ServiceDetailsModel({
    required this.id,
    required this.quantity,
    required this.brand,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.fees,
    required this.duration,
    required this.bookingCount,
    required this.includes,
    required this.serviceLocation,
    required this.lateLimit,
    required this.type,
    required this.rating,
    required this.ratingCount,
    required this.inBranches,
    required this.ratingPercentage,
    required this.allowMultipleServicesBook,
    required this.allowMultipleServicesCount,
    this.services,
  });

  const ServiceDetailsModel.empty([
    this.id = '',
    this.brand = const BrandModel.empty(),
    this.title = '',
    this.description = '',
    this.image = '',
    this.price = 0,
    this.fees = 0,
    this.quantity = 0,
    this.duration = 0,
    this.bookingCount = 0,
    this.includes = const [],
    this.serviceLocation = '',
    this.lateLimit = 0,
    this.type = '',
    this.rating = 0,
    this.ratingCount = 0,
    this.allowMultipleServicesBook = false,
    this.allowMultipleServicesCount = false,
    this.inBranches = const [],
    this.services = const [],
    this.ratingPercentage = const {},
  ]);

  ServiceDetailsModel copyWith({
    String? id,
    BrandModel? brand,
    String? title,
    String? description,
    String? image,
    num? price,
    int? fees,
    int? duration,
    int? bookingCount,
    int? quantity,
    List<String>? includes,
    String? serviceLocation,
    bool? allowMultipleServicesBook,
    bool? allowMultipleServicesCount,
    int? lateLimit,
    String? type,
    double? rating,
    int? ratingCount,
    List<InBranchesModel>? inBranches,
    Map<String, double>? ratingPercentage,
    List<ServiceModel>? services,
  }) {
    return ServiceDetailsModel(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      fees: fees ?? this.fees,
      duration: duration ?? this.duration,
      bookingCount: bookingCount ?? this.bookingCount,
      quantity: quantity ?? this.quantity,
      includes: includes ?? this.includes,
      serviceLocation: serviceLocation ?? this.serviceLocation,
      allowMultipleServicesBook:
      allowMultipleServicesBook ?? this.allowMultipleServicesBook,
      allowMultipleServicesCount:
      allowMultipleServicesCount ?? this.allowMultipleServicesCount,
      lateLimit: lateLimit ?? this.lateLimit,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      inBranches: inBranches ?? this.inBranches,
      ratingPercentage: ratingPercentage ?? this.ratingPercentage,
      services: services ?? this.services,
    );
  }

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceDetailsModelToJson(this);

  FavoriteModel toFavoriteModel() {
    return FavoriteModel(
      id: id,
      title: title,
      price: price,
      image: image,
      mainCategory: "",
      deletedAt: "",
    );
  }

  String get locationAvailability {
    final String location = serviceLocation.toLowerCase();
    if (location == 'in') return DazzifyApp.tr.inBranch;
    if (location == 'out') return DazzifyApp.tr.outBranch;
    return DazzifyApp.tr.inOrOutBranch;
  }
}
