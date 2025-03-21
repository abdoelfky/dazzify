import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/exceptions.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/home/data/data_sources/remote/home_remote_datasource.dart';
import 'package:dazzify/features/home/data/models/banner_model.dart';
import 'package:dazzify/features/home/data/models/category_model.dart';
import 'package:dazzify/features/home/data/repositories/home_repository.dart';
import 'package:dazzify/features/home/data/requests/get_all_media_request.dart';
import 'package:dazzify/features/home/data/requests/get_brands_request.dart';
import 'package:dazzify/features/home/data/requests/get_service_review_request.dart';
import 'package:dazzify/features/home/data/requests/get_services_request.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/data/models/reviews_model.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl extends HomeRepository {
  final HomeRemoteDatasource _remoteDatasource;

  const HomeRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, List<BannerModel>>> getBanners() async {
    try {
      List<BannerModel> banners = await _remoteDatasource.getBanners();

      return Right(banners);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, List<BrandModel>>> getPopularBrands({
    required GetBrandsRequest request,
  }) async {
    try {
      List<BrandModel> popularBrands = await _remoteDatasource.getPopularBrands(
        request: request,
      );

      return Right(popularBrands);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, List<BrandModel>>> getTopRatedBrands({
    required GetBrandsRequest request,
  }) async {
    try {
      List<BrandModel> topRatedBrands =
          await _remoteDatasource.getTopRatedBrands(
        request: request,
      );

      return Right(topRatedBrands);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, List<CategoryModel>>> getMainCategories() async {
    try {
      List<CategoryModel> categories =
          await _remoteDatasource.getMainCategories();

      return Right(categories);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, List<ServiceDetailsModel>>> getPopularServices({
    required GetServicesRequest request,
  }) async {
    try {
      List<ServiceDetailsModel> services =
          await _remoteDatasource.getPopularServices(
        request: request,
      );

      return Right(services);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, List<ServiceDetailsModel>>> getTopRatedServices({
    required GetServicesRequest request,
  }) async {
    try {
      List<ServiceDetailsModel> services =
          await _remoteDatasource.getTopRatedServices(
        request: request,
      );

      return Right(services);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, List<MediaModel>>> getAllMedia({
    required GetAllMediaRequest request,
  }) async {
    try {
      List<MediaModel> media = await _remoteDatasource.getAllMedia(
        request: request,
      );

      return Right(media);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, List<BrandBranchesModel>>> getBrandBranches({
    required String brandId,
  }) async {
    try {
      List<BrandBranchesModel> brandBranches =
          await _remoteDatasource.getBrandBranches(
        brandId: brandId,
      );
      return Right(brandBranches);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, List<ReviewModel>>> getServiceReview({
    required GetServiceReviewRequest request,
  }) async {
    try {
      List<ReviewModel> service = await _remoteDatasource.getServiceReview(
        request: request,
      );
      return Right(service);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, List<ServiceDetailsModel>>> getMoreLikeThisService({
    required String serviceId,
  }) async {
    try {
      List<ServiceDetailsModel> service =
          await _remoteDatasource.getMoreLikeThisService(
        serviceId: serviceId,
      );
      return Right(service);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, ServiceDetailsModel?>> getSingleServiceDetails({
    required String serviceId,
  }) async {
    try {
      ServiceDetailsModel? service =
          await _remoteDatasource.getSingleServiceDetails(
        serviceId: serviceId,
      );

      return Right(service);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }
}
