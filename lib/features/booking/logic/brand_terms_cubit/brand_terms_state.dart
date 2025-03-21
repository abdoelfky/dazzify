part of 'brand_terms_cubit.dart';

class BrandTermsState extends Equatable {
  final UiState termsState;
  final List<String> brandTerms;
  final List<bool> brandTermsCheckList;
  final String errorMessage;

  const BrandTermsState({
    this.termsState = UiState.initial,
    this.brandTerms = const [],
    this.brandTermsCheckList = const [],
    this.errorMessage = '',
  });

  BrandTermsState copyWith({
    UiState? termsState,
    List<String>? brandTerms,
    List<bool>? brandTermsCheckList,
    String? errorMessage,
  }) {
    return BrandTermsState(
      termsState: termsState ?? this.termsState,
      brandTerms: brandTerms ?? this.brandTerms,
      brandTermsCheckList: brandTermsCheckList ?? this.brandTermsCheckList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        termsState,
        brandTerms,
        brandTermsCheckList,
        errorMessage,
      ];
}
