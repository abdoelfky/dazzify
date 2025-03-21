import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/exceptions.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/features/brand/data/data_sources/brand_remote_datasource.dart';
import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/brand/data/models/brand_categories_model.dart';
import 'package:dazzify/features/brand/data/repositories/brand_repository.dart';
import 'package:dazzify/features/brand/data/requests/get_brand_media_request.dart';
import 'package:dazzify/features/brand/data/requests/get_brand_reviews_request.dart';
import 'package:dazzify/features/brand/data/requests/get_brand_services_request.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/data/models/reviews_model.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BrandRepository)
class BrandRepositoryImpl implements BrandRepository {
  final BrandRemoteDataSources _brandRemoteDataSource;

  BrandRepositoryImpl(this._brandRemoteDataSource);

  @override
  Future<Either<Failure, List<BrandBranchesModel>>> getBrandBranches({
    required String brandId,
  }) async {
    try {
      List<BrandBranchesModel> brandBranches =
          await _brandRemoteDataSource.getBrandBranches(
        brandId: brandId,
      );
      return Right(brandBranches);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, List<MediaModel>>> getBrandImages({
    required GetBrandMediaRequest request,
  }) async {
    try {
      List<MediaModel> brandImages =
          await _brandRemoteDataSource.getBrandImages(
        request: request,
      );
      return Right(brandImages);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, List<MediaModel>>> getBrandReels({
    required GetBrandMediaRequest request,
  }) async {
    try {
      List<MediaModel> brandReels = await _brandRemoteDataSource.getBrandReels(
        request: request,
      );
      return Right(brandReels);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, List<ReviewModel>>> getBrandReviews({
    required String brandId,
    required GetBrandReviewsRequest request,
  }) async {
    try {
      List<ReviewModel> brandReviews =
          await _brandRemoteDataSource.getBrandReviews(
        brandId: brandId,
        request: request,
      );
      return Right(brandReviews);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, List<BrandCategoriesModel>>> getBrandCategories({
    required String brandId,
  }) async {
    try {
      List<BrandCategoriesModel> categories =
          await _brandRemoteDataSource.getBrandCategories(
        brandId: brandId,
      );
      return Right(categories);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, List<ServiceDetailsModel>>>
      getBrandServicesWithCategoryAndBranch({
    required String categoryId,
    required GetBrandServicesRequest request,
  }) async {
    try {
      List<ServiceDetailsModel> services =
          await _brandRemoteDataSource.getBrandServicesWithCategoryAndBranch(
        categoryId: categoryId,
        request: request,
      );
      return Right(services);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> addBrandView({
    required String brandId,
  }) async {
    try {
      await _brandRemoteDataSource.addBrandView(
        brandId: brandId,
      );

      return const Right(unit);
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
          await _brandRemoteDataSource.getSingleServiceDetails(
        serviceId: serviceId,
      );

      return Right(service);
    } on ServerException catch (exception) {
      return Left(ApiFailure(message: exception.message!));
    }
  }

  @override
  Future<Either<Failure, BrandModel>> getSingleBrandDetails(
      {required String username}) async {
    try {
      BrandModel service = await _brandRemoteDataSource.getSingleBrandDetails(
        username: username,
      );

      return Right(service);
    } on ServerException catch (exception) {
      return Left(
        ApiFailure(
          message: exception.message!,
          errorCode: exception.errorCode,
        ),
      );
    }
  }
}
