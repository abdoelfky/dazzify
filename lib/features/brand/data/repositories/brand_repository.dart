import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/brand/data/models/brand_categories_model.dart';
import 'package:dazzify/features/brand/data/requests/get_brand_media_request.dart';
import 'package:dazzify/features/brand/data/requests/get_brand_reviews_request.dart';
import 'package:dazzify/features/brand/data/requests/get_brand_services_request.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/data/models/reviews_model.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';

abstract class BrandRepository {
  Future<Either<Failure, List<BrandBranchesModel>>> getBrandBranches({
    required String brandId,
  });

  Future<Either<Failure, List<MediaModel>>> getBrandImages({
    required GetBrandMediaRequest request,
  });

  Future<Either<Failure, List<MediaModel>>> getBrandReels({
    required GetBrandMediaRequest request,
  });

  Future<Either<Failure, List<ReviewModel>>> getBrandReviews({
    required String brandId,
    required GetBrandReviewsRequest request,
  });

  Future<Either<Failure, List<BrandCategoriesModel>>> getBrandCategories({
    required String brandId,
  });

  Future<Either<Failure, List<ServiceDetailsModel>>>
      getBrandServicesWithCategoryAndBranch({
    required String categoryId,
    required GetBrandServicesRequest request,
  });

  Future<Either<Failure, Unit>> addBrandView({
    required String brandId,
  });

  Future<Either<Failure, ServiceDetailsModel?>> getSingleServiceDetails({
    required String serviceId,
  });

  Future<Either<Failure, BrandModel>> getSingleBrandDetails({
    required String username,
  });
}
