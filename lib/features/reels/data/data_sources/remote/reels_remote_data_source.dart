import 'package:dazzify/features/shared/data/models/media_model.dart';

abstract class ReelsRemoteDataSource {
  Future<List<MediaModel>> getReels({
    required String? mainCategoryId,
  });

  Future<void> addViewForMedia({
    required String mediaId,
  });
}
