part of 'service_details_bloc.dart';

class ServiceDetailsState extends Equatable {
  // States
  final UiState blocState;
  final UiState serviceReviewState;
  final UiState moreLikeThisState;

  // Data
  final List<BrandBranchesModel> brandBranches;
  final List<ServiceDetailsModel> moreLikeThisServices;
  final List<ReviewModel> serviceReview;
  final ServiceDetailsModel service;
  final String errorMessage;
  final bool hasReviewsReachedMax;

  final int errorCode;

  const ServiceDetailsState({
    this.blocState = UiState.initial,
    this.serviceReviewState = UiState.initial,
    this.moreLikeThisState = UiState.initial,
    this.service = const ServiceDetailsModel.empty(),
    this.brandBranches = const [],
    this.serviceReview = const [],
    this.moreLikeThisServices = const [],
    this.errorMessage = '',
    this.hasReviewsReachedMax = false,
    this.errorCode = 0,
  });

  ServiceDetailsState copyWith({
    UiState? blocState,
    UiState? serviceReviewState,
    UiState? moreLikeThisState,
    ServiceDetailsModel? service,
    List<BrandBranchesModel>? brandBranches,
    List<ServiceDetailsModel>? moreLikeThisServices,
    List<ReviewModel>? serviceReview,
    String? errorMessage,
    bool? hasReviewsReachedMax,
    int? errorCode,
  }) {
    return ServiceDetailsState(
      blocState: blocState ?? this.blocState,
      serviceReviewState: serviceReviewState ?? this.serviceReviewState,
      moreLikeThisState: moreLikeThisState ?? this.moreLikeThisState,
      brandBranches: brandBranches ?? this.brandBranches,
      moreLikeThisServices: moreLikeThisServices ?? this.moreLikeThisServices,
      serviceReview: serviceReview ?? this.serviceReview,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReviewsReachedMax: hasReviewsReachedMax ?? this.hasReviewsReachedMax,
      service: service ?? this.service,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  @override
  List<Object> get props => [
        blocState,
        serviceReviewState,
        moreLikeThisState,
        brandBranches,
        moreLikeThisServices,
        serviceReview,
        errorMessage,
        service,
        hasReviewsReachedMax,
        errorCode
      ];
}
