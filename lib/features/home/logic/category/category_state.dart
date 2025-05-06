part of 'category_bloc.dart';

class CategoryState extends Equatable {
  final UiState blocState;
  final String errorMessage;
  final bool hasReachedMax;
  final List<BrandModel> brands;

  const CategoryState({
    this.blocState = UiState.initial,
    this.errorMessage = '',
    this.hasReachedMax = false,
    this.brands = const [],
  });

  CategoryState copyWith({
    UiState? blocState,
    String? errorMessage,
    bool? hasReachedMax,
    List<BrandModel>? brands,
  }) {
    // Sort the brands by points if a new list is provided
    final sortedBrands = brands != null
        ? (List<BrandModel>.from(brands)
      ..sort((a, b) => b.points!.compareTo(a.points!))) // Descending order
        : this.brands;

    return CategoryState(
      blocState: blocState ?? this.blocState,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      brands: sortedBrands
      // brands: brands ?? this.brands,
    );
  }

  @override
  List<Object?> get props => [
        blocState,
        errorMessage,
        hasReachedMax,
        brands,
      ];
}
