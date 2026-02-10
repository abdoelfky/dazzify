import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/brand/data/models/brand_categories_model.dart';
import 'package:dazzify/features/brand/data/requests/get_brand_media_request.dart';
import 'package:dazzify/features/brand/data/requests/get_brand_reviews_request.dart';
import 'package:dazzify/features/brand/data/requests/get_brand_services_request.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/data/models/reviews_model.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';

abstract class BrandRemoteDataSources {
  Future<List<BrandBranchesModel>> getBrandBranches({
    required String brandId,
  });

  Future<List<MediaModel>> getBrandImages({
    required GetBrandMediaRequest request,
  });

  Future<List<MediaModel>> getBrandReels({
    required GetBrandMediaRequest request,
  });

  Future<List<ReviewModel>> getBrandReviews({
    required String brandId,
    required GetBrandReviewsRequest request,
  });

  Future<List<BrandCategoriesModel>> getBrandCategories({
    required String brandId,
  });

  Future<List<ServiceDetailsModel>> getBrandExtraServices({
    required String brandId,
  });

  Future<List<ServiceDetailsModel>> getBrandServicesWithCategoryAndBranch({
    required String categoryId,
    required GetBrandServicesRequest request,
  });

  Future<void> addBrandView({
    required String brandId,
  });

  Future<ServiceDetailsModel?> getSingleServiceDetails({
    required String serviceId,
  });

  Future<BrandModel> getSingleBrandDetails({
    required String username,
  });
}
