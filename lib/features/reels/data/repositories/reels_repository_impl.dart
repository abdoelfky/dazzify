import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/exceptions.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/features/reels/data/data_sources/remote/reels_remote_data_source.dart';
import 'package:dazzify/features/reels/data/repositories/reels_repository.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ReelsRepository)
class ReelsRepositoryImpl implements ReelsRepository {
  final ReelsRemoteDataSource _reelsRemoteDataSource;

  ReelsRepositoryImpl(this._reelsRemoteDataSource);

  @override
  Future<Either<Failure, List<MediaModel>>> getReels({
    required String? mainCategoryId,
  }) async {
    try {
      List<MediaModel> result = await _reelsRemoteDataSource.getReels(
        mainCategoryId: mainCategoryId,
      );
      return Right(result);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> addViewForMedia({
    required String mediaId,
  }) async {
    try {
      await _reelsRemoteDataSource.addViewForMedia(
        mediaId: mediaId,
      );
      return const Right(unit);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }
}
