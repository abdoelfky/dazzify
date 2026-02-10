import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/home/data/models/banner_model.dart';
import 'package:dazzify/features/home/data/models/category_model.dart';
import 'package:dazzify/features/home/data/requests/get_all_media_request.dart';
import 'package:dazzify/features/home/data/requests/get_brands_request.dart';
import 'package:dazzify/features/home/data/requests/get_service_review_request.dart';
import 'package:dazzify/features/home/data/requests/get_services_request.dart';
import 'package:dazzify/features/home/data/requests/search_request.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/data/models/reviews_model.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';

abstract class HomeRemoteDatasource {
  const HomeRemoteDatasource();

  Future<List<BannerModel>> getBanners();

  Future<List<CategoryModel>> getMainCategories();

  Future<List<BrandModel>> getPopularBrands({
    required GetBrandsRequest request,
  });

  Future<List<BrandModel>> getTopRatedBrands({
    required GetBrandsRequest request,
  });

  Future<List<ServiceDetailsModel>> getPopularServices({
    required GetServicesRequest request,
  });

  Future<List<ServiceDetailsModel>> getTopRatedServices({
    required GetServicesRequest request,
  });

  Future<List<MediaModel>> getAllMedia({
    required GetAllMediaRequest request,
  });

  Future<List<BrandBranchesModel>> getBrandBranches({
    required String brandId,
  });

  Future<List<ReviewModel>> getServiceReview({
    required GetServiceReviewRequest request,
  });

  Future<List<ServiceDetailsModel>> getMoreLikeThisService({
    required String serviceId,
  });

  Future<ServiceDetailsModel?> getSingleServiceDetails({
    required String serviceId,
  });

  Future<List<dynamic>> search({
    required SearchRequest request,
  });
}
