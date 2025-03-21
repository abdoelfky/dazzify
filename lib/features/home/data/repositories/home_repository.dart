import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/home/data/models/banner_model.dart';
import 'package:dazzify/features/home/data/models/category_model.dart';
import 'package:dazzify/features/home/data/requests/get_all_media_request.dart';
import 'package:dazzify/features/home/data/requests/get_brands_request.dart';
import 'package:dazzify/features/home/data/requests/get_service_review_request.dart';
import 'package:dazzify/features/home/data/requests/get_services_request.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/data/models/reviews_model.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';

abstract class HomeRepository {
  const HomeRepository();

  Future<Either<Failure, List<BannerModel>>> getBanners();

  Future<Either<Failure, List<CategoryModel>>> getMainCategories();

  Future<Either<Failure, List<BrandModel>>> getPopularBrands({
    required GetBrandsRequest request,
  });

  Future<Either<Failure, List<BrandModel>>> getTopRatedBrands({
    required GetBrandsRequest request,
  });

  Future<Either<Failure, List<ServiceDetailsModel>>> getPopularServices({
    required GetServicesRequest request,
  });

  Future<Either<Failure, List<ServiceDetailsModel>>> getTopRatedServices({
    required GetServicesRequest request,
  });

  Future<Either<Failure, List<MediaModel>>> getAllMedia({
    required GetAllMediaRequest request,
  });

  Future<Either<Failure, List<BrandBranchesModel>>> getBrandBranches({
    required String brandId,
  });

  Future<Either<Failure, List<ReviewModel>>> getServiceReview({
    required GetServiceReviewRequest request,
  });

  Future<Either<Failure, List<ServiceDetailsModel>>> getMoreLikeThisService({
    required String serviceId,
  });

  Future<Either<Failure, ServiceDetailsModel?>> getSingleServiceDetails({
    required String serviceId,
  });
}
