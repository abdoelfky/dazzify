import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/home/data/models/banner_model.dart';
import 'package:dazzify/features/home/data/models/category_model.dart';
import 'package:dazzify/features/home/data/repositories/home_repository.dart';
import 'package:dazzify/features/home/data/requests/get_brands_request.dart';
import 'package:dazzify/features/home/data/requests/get_services_request.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'home_state.dart';

List<CategoryModel> mainCategories = [];

@injectable
class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;
  int popularBrandsPage = 1;
  int topRatedBrandsPage = 1;
  int popularServicesPage = 1;
  int limit = 20;

  HomeCubit(
    this._repository,
  ) : super(const HomeState());

  Future<void> getBanners() async {
    emit(state.copyWith(bannersState: UiState.loading));

    Either<Failure, List<BannerModel>> result = await _repository.getBanners();

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          bannersState: UiState.failure,
        ),
      ),
      (banners) => emit(
        state.copyWith(
          banners: banners,
          bannersState: UiState.success,
        ),
      ),
    );
  }

  Future<void> getMainCategories() async {
    if (mainCategories.isEmpty) {
      emit(state.copyWith(categoriesState: UiState.loading));

      final result = await _repository.getMainCategories();

      result.fold(
          (failure) => emit(
                state.copyWith(
                  errorMessage: failure.message,
                  categoriesState: UiState.failure,
                ),
              ), (categories) {
        mainCategories = categories;

        emit(
          state.copyWith(
            mainCategories: categories,
            categoriesState: UiState.success,
          ),
        );
      });
    }
  }

  Future<void> getPopularBrands() async {
    emit(state.copyWith(popularBrandsState: UiState.loading));

    final result = await _repository.getPopularBrands(
      request: GetBrandsRequest(
        page: popularBrandsPage,
        limit: limit,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          popularBrandsState: UiState.failure,
        ),
      ),
      (popularBrands) => emit(
        state.copyWith(
          popularBrands: popularBrands,
          popularBrandsState: UiState.success,
        ),
      ),
    );
  }

  Future<void> getTopRatedBrands() async {
    emit(state.copyWith(topRatedBrandsState: UiState.loading));

    final result = await _repository.getTopRatedBrands(
      request: GetBrandsRequest(
        page: topRatedBrandsPage,
        limit: limit,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          topRatedBrandsState: UiState.failure,
        ),
      ),
      (popularBrands) => emit(
        state.copyWith(
          topRatedBrands: popularBrands,
          topRatedBrandsState: UiState.success,
        ),
      ),
    );
  }

  Future<void> getPopularServices() async {
    emit(state.copyWith(popularServicesState: UiState.loading));

    final result = await _repository.getPopularServices(
      request: GetServicesRequest(
        page: popularServicesPage,
        limit: limit,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          popularServicesState: UiState.failure,
        ),
      ),
      (popularServices) => emit(
        state.copyWith(
          popularServices: popularServices,
          popularServicesState: UiState.success,
        ),
      ),
    );
  }

  Future<void> getTopRatedServices() async {
    emit(state.copyWith(topRatedServicesState: UiState.loading));

    final result = await _repository.getTopRatedServices(
      request: GetServicesRequest(
        page: topRatedBrandsPage,
        limit: limit,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          topRatedServicesState: UiState.failure,
        ),
      ),
      (topRatedServices) => emit(
        state.copyWith(
          topRatedServices: topRatedServices,
          topRatedServicesState: UiState.success,
        ),
      ),
    );
  }

  Future<void> getSingleServiceDetails({required String serviceId}) async {
    emit(state.copyWith(
      singleServiceState: UiState.loading,
    ));

    final results = await _repository.getSingleServiceDetails(
      serviceId: serviceId,
    );

    results.fold(
      (failure) => emit(
        state.copyWith(
          singleServiceState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (service) => emit(
        state.copyWith(
          singleServiceState: UiState.success,
          singleService: service,
        ),
      ),
    );
  }
}
