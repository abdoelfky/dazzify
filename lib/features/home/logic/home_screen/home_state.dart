part of 'home_cubit.dart';

class HomeState extends Equatable {
  // States
  final UiState bannersState;
  final UiState categoriesState;
  final UiState popularBrandsState;
  final UiState topRatedBrandsState;
  final UiState popularServicesState;
  final UiState topRatedServicesState;
  final UiState singleServiceState;

  // Data
  final List<BannerModel> banners;
  final List<CategoryModel> mainCategories;
  final List<BrandModel> popularBrands;
  final List<BrandModel> topRatedBrands;
  final List<ServiceDetailsModel> popularServices;
  final List<ServiceDetailsModel> topRatedServices;
  final ServiceDetailsModel singleService;
  final String errorMessage;

  const HomeState({
    this.bannersState = UiState.initial,
    this.categoriesState = UiState.initial,
    this.popularBrandsState = UiState.initial,
    this.topRatedBrandsState = UiState.initial,
    this.popularServicesState = UiState.initial,
    this.topRatedServicesState = UiState.initial,
    this.singleServiceState = UiState.initial,
    this.banners = const [],
    this.mainCategories = const [],
    this.popularBrands = const [],
    this.topRatedBrands = const [],
    this.popularServices = const [],
    this.topRatedServices = const [],
    this.singleService = const ServiceDetailsModel.empty(),
    this.errorMessage = '',
  });

  HomeState copyWith({
    UiState? bannersState,
    UiState? categoriesState,
    UiState? popularBrandsState,
    UiState? topRatedBrandsState,
    UiState? popularServicesState,
    UiState? topRatedServicesState,
    UiState? singleServiceState,
    List<BannerModel>? banners,
    List<CategoryModel>? mainCategories,
    List<BrandModel>? popularBrands,
    List<BrandModel>? topRatedBrands,
    List<ServiceDetailsModel>? popularServices,
    List<ServiceDetailsModel>? topRatedServices,
    ServiceDetailsModel? singleService,
    String? errorMessage,
  }) {
    return HomeState(
      bannersState: bannersState ?? this.bannersState,
      categoriesState: categoriesState ?? this.categoriesState,
      popularBrandsState: popularBrandsState ?? this.popularBrandsState,
      topRatedBrandsState: topRatedBrandsState ?? this.topRatedBrandsState,
      popularServicesState: popularServicesState ?? this.popularServicesState,
      topRatedServicesState:
          topRatedServicesState ?? this.topRatedServicesState,
      singleServiceState: singleServiceState ?? this.singleServiceState,
      banners: banners ?? this.banners,
      mainCategories: mainCategories ?? this.mainCategories,
      popularBrands: popularBrands ?? this.popularBrands,
      topRatedBrands: topRatedBrands ?? this.topRatedBrands,
      popularServices: popularServices ?? this.popularServices,
      topRatedServices: topRatedServices ?? this.topRatedServices,
      errorMessage: errorMessage ?? this.errorMessage,
      singleService: singleService ?? this.singleService,
    );
  }

  @override
  List<Object> get props => [
        bannersState,
        categoriesState,
        popularBrandsState,
        topRatedBrandsState,
        popularServicesState,
        topRatedServicesState,
        singleServiceState,
        banners,
        mainCategories,
        popularBrands,
        topRatedBrands,
        popularServices,
        topRatedServices,
        singleService,
        errorMessage,
      ];
}
