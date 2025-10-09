import 'package:dazzify/core/api/api_consumer.dart';
import 'package:dazzify/core/constants/api_constants.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/errors/exceptions.dart';
import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/home/data/data_sources/remote/home_remote_datasource.dart';
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
import 'package:injectable/injectable.dart';

@LazySingleton(as: HomeRemoteDatasource)
class HomeRemoteDatasourceImpl implements HomeRemoteDatasource {
  final ApiConsumer _apiConsumer;

  const HomeRemoteDatasourceImpl(this._apiConsumer);

  @override
  Future<List<BannerModel>> getBanners() async {
    try {
      return await _apiConsumer.get<BannerModel>(
        ApiConstants.banners,
        responseReturnType: ResponseReturnType.fromJsonList,
        fromJsonMethod: BannerModel.fromJson,
      );
    } on SessionCancelledException {
      return [];
    }
  }

  @override
  Future<List<BrandModel>> getPopularBrands({
    required GetBrandsRequest request,
  }) async {
    Map<String, dynamic> queryParameters = {
      ...request.toJson(),
      AppConstants.sort: AppConstants.totalBookingsCountDesc,
    };

    try {
      return await _apiConsumer.get<BrandModel>(
        ApiConstants.brands,
        queryParameters: queryParameters,
        responseReturnType: ResponseReturnType.fromJsonList,
        fromJsonMethod: BrandModel.fromJson,
      );
    } on SessionCancelledException {
      return [];
    }
  }

  @override
  Future<List<BrandModel>> getTopRatedBrands({
    required GetBrandsRequest request,
  }) async {
    try {
      return await _apiConsumer.get<BrandModel>(
        ApiConstants.brands,
        queryParameters: {
          ...request.toJson(),
          AppConstants.sort: AppConstants.ratingDesc,
        },
        responseReturnType: ResponseReturnType.fromJsonList,
        fromJsonMethod: BrandModel.fromJson,
      );
    } on SessionCancelledException {
      return [];
    }
  }

  @override
  Future<List<CategoryModel>> getMainCategories() async {
    try {
      return await _apiConsumer.get<CategoryModel>(
        ApiConstants.mainCategories,
        responseReturnType: ResponseReturnType.fromJsonList,
        fromJsonMethod: CategoryModel.fromJson,
      );
    } on SessionCancelledException {
      return [];
    }
  }

  @override
  Future<List<ServiceDetailsModel>> getPopularServices({
    required GetServicesRequest request,
  }) async {
    try {
      return await _apiConsumer.get<ServiceDetailsModel>(
        ApiConstants.services,
        queryParameters: {
          ...request.toJson(),
          AppConstants.sort: AppConstants.bookingCountDesc,
        },
        responseReturnType: ResponseReturnType.fromJsonList,
        fromJsonMethod: ServiceDetailsModel.fromJson,
      );
    } on SessionCancelledException {
      return [];
    }
  }

  @override
  Future<List<ServiceDetailsModel>> getTopRatedServices({
    required GetServicesRequest request,
  }) async {
    try {
      return await _apiConsumer.get<ServiceDetailsModel>(
        ApiConstants.services,
        queryParameters: {
          ...request.toJson(),
          AppConstants.sort: AppConstants.ratingDesc,
        },
        responseReturnType: ResponseReturnType.fromJsonList,
        fromJsonMethod: ServiceDetailsModel.fromJson,
      );
    } on SessionCancelledException {
      return [];
    }
  }

  @override
  Future<List<MediaModel>> getAllMedia({
    required GetAllMediaRequest request,
  }) async {
    return await _apiConsumer.get<MediaModel>(
      ApiConstants.getMediaList,
      queryParameters: {
        AppConstants.type: AppConstants.mix,
        ...request.toJson(),
      },
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: MediaModel.fromJson,
    );
  }

  @override
  Future<List<ReviewModel>> getServiceReview({
    required GetServiceReviewRequest request,
  }) async {
    return await _apiConsumer.get<ReviewModel>(
      ApiConstants.serviceReview(request.serviceId),
      queryParameters: {
        AppConstants.page: request.page,
        AppConstants.limit: request.limit,
      },
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: ReviewModel.fromJson,
    );
  }

  @override
  Future<List<ServiceDetailsModel>> getMoreLikeThisService({
    required String serviceId,
  }) async {
    return await _apiConsumer.get<ServiceDetailsModel>(
      ApiConstants.moreLikeThisService(serviceId),
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: ServiceDetailsModel.fromJson,
    );
  }

  @override
  Future<List<BrandBranchesModel>> getBrandBranches({
    required String brandId,
  }) async {
    return await _apiConsumer.get<BrandBranchesModel>(
      ApiConstants.getVendorBrandBranches(brandId: brandId),
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: BrandBranchesModel.fromJson,
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
}
