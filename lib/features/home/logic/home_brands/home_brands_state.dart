part of 'home_brands_bloc.dart';

class HomeBrandsState extends Equatable {
  // States
  final UiState popularBrandsState;
  final UiState topRatedBrandsState;

  // Data
  final List<BrandModel> popularBrands;
  final List<BrandModel> topRatedBrands;

  final String errorMessage;
  final bool hasPopularReachedMax;
  final bool hasTopRatedReachedMax;

  const HomeBrandsState({
    this.popularBrandsState = UiState.initial,
    this.topRatedBrandsState = UiState.initial,
    this.popularBrands = const [],
    this.topRatedBrands = const [],
    this.errorMessage = '',
    this.hasPopularReachedMax = false,
    this.hasTopRatedReachedMax = false,
  });

  HomeBrandsState copyWith({
    UiState? popularBrandsState,
    UiState? topRatedBrandsState,
    List<BrandModel>? popularBrands,
    List<BrandModel>? topRatedBrands,
    String? errorMessage,
    bool? hasPopularReachedMax,
    bool? hasTopRatedReachedMax,
  }) {
    return HomeBrandsState(
      popularBrandsState: popularBrandsState ?? this.popularBrandsState,
      topRatedBrandsState: topRatedBrandsState ?? this.topRatedBrandsState,
      popularBrands: popularBrands ?? this.popularBrands,
      topRatedBrands: topRatedBrands ?? this.topRatedBrands,
      errorMessage: errorMessage ?? this.errorMessage,
      hasPopularReachedMax: hasPopularReachedMax ?? this.hasPopularReachedMax,
      hasTopRatedReachedMax:
          hasTopRatedReachedMax ?? this.hasTopRatedReachedMax,
    );
  }

  @override
  List<Object> get props => [
        popularBrandsState,
        topRatedBrandsState,
        popularBrands,
        topRatedBrands,
        errorMessage,
        hasPopularReachedMax,
        hasTopRatedReachedMax,
      ];
}
