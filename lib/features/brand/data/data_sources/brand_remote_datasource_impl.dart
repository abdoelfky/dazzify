import 'package:dartz/dartz.dart';
import 'package:dazzify/core/api/api_consumer.dart';
import 'package:dazzify/core/constants/api_constants.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/features/brand/data/data_sources/brand_remote_datasource.dart';
import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/brand/data/models/brand_categories_model.dart';
import 'package:dazzify/features/brand/data/requests/get_brand_media_request.dart';
import 'package:dazzify/features/brand/data/requests/get_brand_reviews_request.dart';
import 'package:dazzify/features/brand/data/requests/get_brand_services_request.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/data/models/reviews_model.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BrandRemoteDataSources)
class BrandRemoteDataSourcesImpl implements BrandRemoteDataSources {
  final ApiConsumer _apiConsumer;

  BrandRemoteDataSourcesImpl(this._apiConsumer);

  @override
  Future<List<BrandBranchesModel>> getBrandBranches(
      {required String brandId}) async {
    return await _apiConsumer.get<BrandBranchesModel>(
      ApiConstants.getVendorBrandBranches(
        brandId: brandId,
      ),
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: BrandBranchesModel.fromJson,
    );
  }

  @override
  Future<List<MediaModel>> getBrandImages({
    required GetBrandMediaRequest request,
  }) async {
    return await _apiConsumer.get<MediaModel>(
      ApiConstants.brandMedia,
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: MediaModel.fromJson,
      queryParameters: {
        "page": request.page,
        "limit": request.limit,
        "brandId": request.brandId,
        "type": "photo-album",
        "sort": request.sort,
      },
    );
  }

  @override
  Future<List<MediaModel>> getBrandReels({
    required GetBrandMediaRequest request,
  }) async {
    return await _apiConsumer.get<MediaModel>(
      ApiConstants.brandMedia,
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: MediaModel.fromJson,
      queryParameters: {
        "page": request.page,
        "limit": request.limit,
        "brandId": request.brandId,
        "type": "video",
        "sort": request.sort,
      },
    );
  }

  @override
  Future<List<ReviewModel>> getBrandReviews({
    required String brandId,
    required GetBrandReviewsRequest request,
  }) async {
    return await _apiConsumer.get<ReviewModel>(
      ApiConstants.getVendorBrandReviews(brandId: brandId),
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: ReviewModel.fromJson,
      queryParameters: {
        AppConstants.page: request.page,
        AppConstants.limit: request.limit,
      },
    );
  }

  @override
  Future<List<BrandCategoriesModel>> getBrandCategories({
    required String brandId,
  }) async {
    return await _apiConsumer.get<BrandCategoriesModel>(
      ApiConstants.getVendorBrandCategories(
        brandId: brandId,
      ),
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: BrandCategoriesModel.fromJson,
    );
  }

  @override
  Future<List<ServiceDetailsModel>> getBrandExtraServices({
    required String brandId,
  }) async {
    return await _apiConsumer.get<ServiceDetailsModel>(
      ApiConstants.getBrandExtraServices(brandId: brandId),
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: ServiceDetailsModel.fromJson,
    );
  }

  @override
  Future<List<ServiceDetailsModel>> getBrandServicesWithCategoryAndBranch({
    required String categoryId,
    required GetBrandServicesRequest request,
  }) async {
    return await _apiConsumer.get<ServiceDetailsModel>(
      ApiConstants.getBrandServicesWithCategoryAndBranch(
        categoryId: categoryId,
      ),
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: ServiceDetailsModel.fromJson,
      queryParameters: {
        AppConstants.branchId: request.branchId,
      },
    );
  }

  @override
  Future<Unit> addBrandView({
    required String brandId,
  }) async {
    return await _apiConsumer.post<void>(
      ApiConstants.addBrandView(brandId: brandId),
      responseReturnType: ResponseReturnType.unit,
    );
  }

  @override
  Future<ServiceDetailsModel?> getSingleServiceDetails({
    required String serviceId,
  }) async {
    return await _apiConsumer.get<ServiceDetailsModel?>(
      ApiConstants.getSingleServiceDetails(serviceId: serviceId),
      responseReturnType: ResponseReturnType.fromJson,
      fromJsonMethod: ServiceDetailsModel.fromJson,
    );
  }

  @override
  Future<BrandModel> getSingleBrandDetails({
    required String username,
  }) async {
    return await _apiConsumer.get<BrandModel?>(
      ApiConstants.getSingleBrandDetails(username: username),
      responseReturnType: ResponseReturnType.fromJson,
      fromJsonMethod: BrandModel.fromJson,
    );
  }
}
