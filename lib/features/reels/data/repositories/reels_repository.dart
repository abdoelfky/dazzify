import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';

abstract class ReelsRepository {
  Future<Either<Failure, List<MediaModel>>> getReels({
    required String? mainCategoryId,
  });

  Future<Either<Failure, Unit>> addViewForMedia({
    required String mediaId,
  });
}
