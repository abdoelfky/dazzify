// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'service_selection_cubit.dart';

class ServiceSelectionState extends Equatable {
  final UiState brandServicesState;
  final UiState brandCategoriesState;
  final List<BrandCategoriesModel> brandCategories;
  final Map<String, List<ServiceDetailsModel>> brandServices;
  final List<ServiceDetailsModel> selectedBrandServices;
  final List<String> selectedBrandServicesIds;
  final String errorMessage;
  final BrandBranchesModel selectedBranch;
  final String selectedCategoryId;
  final int selectedCategoryIndex;

  const ServiceSelectionState({
    this.brandServicesState = UiState.initial,
    this.brandCategoriesState = UiState.initial,
    this.brandCategories = const [],
    this.brandServices = const {},
    this.selectedBrandServices = const [],
    this.selectedBrandServicesIds = const [],
    this.errorMessage = '',
    this.selectedBranch = const BrandBranchesModel.empty(),
    this.selectedCategoryIndex = 0,
    this.selectedCategoryId = '',
  });

  ServiceSelectionState copyWith({
    UiState? brandServicesState,
    UiState? brandCategoriesState,
    List<BrandCategoriesModel>? brandCategories,
    Map<String, List<ServiceDetailsModel>>? brandServices,
    List<ServiceDetailsModel>? selectedBrandServices,
    List<String>? selectedBrandServicesIds,
    String? errorMessage,
    BrandBranchesModel? selectedBranch,
    String? selectedCategoryId,
    int? selectedCategoryIndex,
  }) {
    return ServiceSelectionState(
      brandServicesState: brandServicesState ?? this.brandServicesState,
      brandCategoriesState: brandCategoriesState ?? this.brandCategoriesState,
      brandCategories: brandCategories ?? this.brandCategories,
      brandServices: brandServices ?? this.brandServices,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      selectedBrandServices:
          selectedBrandServices ?? this.selectedBrandServices,
      selectedBrandServicesIds:
          selectedBrandServicesIds ?? this.selectedBrandServicesIds,
    );
  }

  @override
  List<Object> get props => [
        selectedBrandServicesIds,
        brandCategoriesState,
        brandServicesState,
        brandCategories,
        selectedBrandServices,
        brandServices,
        errorMessage,
        selectedBranch,
        selectedCategoryId,
      ];
}
