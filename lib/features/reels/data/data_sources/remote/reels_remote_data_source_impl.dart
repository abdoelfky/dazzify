import 'package:dartz/dartz.dart';
import 'package:dazzify/core/api/api_consumer.dart';
import 'package:dazzify/core/constants/api_constants.dart';
import 'package:dazzify/features/reels/data/data_sources/remote/reels_remote_data_source.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ReelsRemoteDataSource)
class ReelsRemoteDataSourceImpl implements ReelsRemoteDataSource {
  final ApiConsumer _apiConsumer;

  ReelsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<List<MediaModel>> getReels({
    required String? mainCategoryId,
  }) async {
    return await _apiConsumer.get<MediaModel>(
      ApiConstants.getReels,
      queryParameters: {
        if (mainCategoryId != null) "mainCategory": mainCategoryId,
      },
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: MediaModel.fromJson,
    );
  }

  @override
  Future<Unit> addViewForMedia({
    required String mediaId,
  }) async {
    return await _apiConsumer.post<Unit>(
      ApiConstants.addView(mediaId),
      responseReturnType: ResponseReturnType.unit,
    );
  }
}
