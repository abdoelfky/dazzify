part of 'brand_branches_cubit.dart';

class BrandBranchesState extends Equatable {
  final List<BrandBranchesModel> brandBranches;
  final UiState brandBranchesState;
  final String errorMessage;

  const BrandBranchesState({
    this.brandBranchesState = UiState.initial,
    this.brandBranches = const [],
    this.errorMessage = '',
  });

  @override
  List<Object> get props => [
        brandBranchesState,
        brandBranches,
        errorMessage,
      ];

  BrandBranchesState copyWith({
    List<BrandBranchesModel>? brandBranches,
    UiState? brandBranchesState,
    String? errorMessage,
  }) {
    return BrandBranchesState(
      brandBranches: brandBranches ?? this.brandBranches,
      brandBranchesState: brandBranchesState ?? this.brandBranchesState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
