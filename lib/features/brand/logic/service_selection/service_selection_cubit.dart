import 'package:bloc/bloc.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/brand/data/models/brand_categories_model.dart';
import 'package:dazzify/features/brand/data/repositories/brand_repository.dart';
import 'package:dazzify/features/brand/data/requests/get_brand_services_request.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'service_selection_state.dart';

@injectable
class ServiceSelectionCubit extends Cubit<ServiceSelectionState> {
  final BrandRepository _brandRepository;

  ServiceSelectionCubit(
    this._brandRepository,
  ) : super(const ServiceSelectionState());

  Future<void> getBrandCategories({required String brandId}) async {
    emit(state.copyWith(brandCategoriesState: UiState.loading));

    final results = await _brandRepository.getBrandCategories(
      brandId: brandId,
    );

    results.fold(
      (failure) => emit(
        state.copyWith(
          brandCategoriesState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (brandCategories) {
        emit(
          state.copyWith(
            brandCategoriesState: UiState.success,
            brandCategories: brandCategories,
            selectedCategoryId: brandCategories[0].id,
          ),
        );
        getBrandServices(
          categoryId: state.selectedCategoryId,
          branchId: state.selectedBranch.id,
        );
      },
    );
  }

  Future<void> getBrandServices({
    required String categoryId,
    required String branchId,
  }) async {
    if (!state.brandServices.containsKey(categoryId)) {
      emit(state.copyWith(brandServicesState: UiState.loading));

      final request = GetBrandServicesRequest(branchId: branchId);

      final results =
          await _brandRepository.getBrandServicesWithCategoryAndBranch(
        categoryId: categoryId,
        request: request,
      );

      results.fold(
        (failure) => emit(
          state.copyWith(
            brandServicesState: UiState.failure,
            errorMessage: state.errorMessage,
          ),
        ),
        (services) => emit(
          state.copyWith(
            brandServicesState: UiState.success,
            brandServices: Map.from(state.brandServices)
              ..addAll({categoryId: services}),
          ),
        ),
      );
    }
  }

  void selectBranch({required BrandBranchesModel branch}) {
    emit(state.copyWith(selectedBranch: branch));
  }

  void clearServices() {
    emit(
      state.copyWith(
        brandServices: {},
        brandServicesState: UiState.initial,
      ),
    );
  }

  void selectCategory({
    required BrandCategoriesModel brandCategory,
  }) {
    emit(state.copyWith(selectedCategoryId: brandCategory.id));
    getBrandServices(
      branchId: state.selectedBranch.id,
      categoryId: state.selectedCategoryId,
    );
  }

  void selectBookingService({
    required ServiceDetailsModel service,
  }) {
    List<ServiceDetailsModel> selectedServices =
        state.selectedBrandServices.toList();
    List<String> selectedServicesIds = state.selectedBrandServicesIds.toList();
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
      selectedServicesIds.remove(service.id);
      emit(state.copyWith(
        selectedBrandServices: selectedServices,
        selectedBrandServicesIds: selectedServicesIds,
      ));
    } else {
      selectedServices.add(service);
      selectedServicesIds.add(service.id);
      emit(state.copyWith(
        selectedBrandServices: selectedServices,
        selectedBrandServicesIds: selectedServicesIds,
      ));
    }
  }
}
