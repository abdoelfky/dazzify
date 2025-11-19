import 'package:bloc/bloc.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/brand/data/models/brand_categories_model.dart';
import 'package:dazzify/features/brand/data/repositories/brand_repository.dart';
import 'package:dazzify/features/brand/data/requests/get_brand_services_request.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:mwidgets/mwidgets.dart';

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
        if (brandCategories.isEmpty) {
          emit(
            state.copyWith(
              brandCategoriesState: UiState.success,
              brandCategories: brandCategories,
              brandServicesState: UiState.success,
              brandServices: {},
            ),
          );
        } else {
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
        }
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

  void removeServicesSelected({required int index}) {
    // emit(state.copyWith(brandServicesState: UiState.loading));

    // Ensure the index is within bounds
    if (index >= 0 && index < state.selectedBrandServices.length) {
      List<ServiceDetailsModel> selectedServices =
          List.from(state.selectedBrandServices); // Create a copy of the list
      List<String> selectedServicesIds = List.from(
          state.selectedBrandServicesIds); // Create a copy of the IDs list

      // Remove the service at the given index
      selectedServices.removeAt(index);
      selectedServicesIds.removeAt(index);
      // Emit the updated state with the modified lists
      emit(state.copyWith(
        // brandServicesState: UiState.success,
        selectedBrandServices: selectedServices,
        selectedBrandServicesIds: selectedServicesIds,
      ));
    } else {
      // Handle the case where the index is out of range
      // kPrint("Invalid index: $index");
    }
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
    final selectedServices = List<ServiceDetailsModel>.from(state.selectedBrandServices);
    final selectedServicesIds = List<String>.from(state.selectedBrandServicesIds);

    final isSelected = selectedServicesIds.contains(service.id);

    if (isSelected) {
      selectedServices.removeWhere((s) => s.id == service.id);
      selectedServicesIds.remove(service.id);
    } else {
      selectedServices.add(service);
      selectedServicesIds.add(service.id);
    }

    emit(state.copyWith(
      selectedBrandServices: selectedServices,
      selectedBrandServicesIds: selectedServicesIds,
    ));
  }

  void updateServiceQuantity({
    required String serviceId,
    required int quantity,
  }) {
    final updatedServices = Map<String, List<ServiceDetailsModel>>.from(state.brandServices);

    for (var category in updatedServices.keys) {
      updatedServices[category] = updatedServices[category]!.map((service) {
        if (service.id == serviceId) {
          return service.copyWith(quantity: quantity);
        } else if (quantity > 1) {
          // Reset all other services to quantity 1 when current service quantity > 1
          return service.copyWith(quantity: 1);
        }
        return service;
      }).toList();
    }

    final updatedSelected = state.selectedBrandServices.map((s) {
      if (s.id == serviceId) {
        return s.copyWith(quantity: quantity);
      } else if (quantity > 1) {
        // Reset all other selected services to quantity 1
        return s.copyWith(quantity: 1);
      }
      return s;
    }).toList();

    emit(state.copyWith(
      brandServices: updatedServices,
      selectedBrandServices: updatedSelected,
    ));
  }

}
