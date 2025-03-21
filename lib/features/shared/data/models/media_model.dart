import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/data/models/media_items_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'media_model.g.dart';

@JsonSerializable()
class MediaModel {
  @JsonKey(defaultValue: "")
  final String id;
  @JsonKey(defaultValue: "")
  final String caption;
  @JsonKey(defaultValue: "")
  final String type;
  @JsonKey(defaultValue: "")
  final String thumbnail;
  @JsonKey(name: "service", defaultValue: "")
  final String serviceId;
  int? likesCount;
  int? commentsCount;
  // @JsonKey(defaultValue: 0)
  int? viewsCount;
  // @JsonKey(defaultValue: 0)
  int? bookingsCount;
  @JsonKey(defaultValue: "")
  final String createdAt;

  final BrandModel brand;
  final List<MediaItemsModel> mediaItems;

  MediaModel({
    required this.id,
    required this.caption,
    required this.type,
    required this.thumbnail,
    required this.serviceId,
    required this.likesCount,
    required this.viewsCount,
    required this.bookingsCount,
    required this.createdAt,
    required this.brand,
    required this.commentsCount,
    required this.mediaItems,
  });

  MediaModel.empty({
    this.id = "",
    this.caption = "",
    this.type = "",
    this.thumbnail = "",
    this.serviceId = "",
    this.likesCount = 0,
    this.viewsCount = 0,
    this.bookingsCount = 0,
    this.createdAt = "",
    this.brand = const BrandModel.empty(),
    this.commentsCount = 0,
    this.mediaItems = const [],
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) =>
      _$MediaModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediaModelToJson(this);
}
