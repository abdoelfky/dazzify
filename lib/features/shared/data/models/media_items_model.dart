import 'package:json_annotation/json_annotation.dart';

part 'media_items_model.g.dart';

@JsonSerializable()
class MediaItemsModel {
  @JsonKey(defaultValue: "")
  String itemType;
  @JsonKey(defaultValue: "")
  String itemUrl;

  MediaItemsModel({
    required this.itemType,
    required this.itemUrl,
  });

  factory MediaItemsModel.fromJson(Map<String, dynamic> json) =>
      _$MediaItemsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediaItemsModelToJson(this);
}
