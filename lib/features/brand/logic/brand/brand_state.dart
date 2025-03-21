part of 'brand_bloc.dart';

class BrandState extends Equatable {
  // States
  final UiState branchesState;
  final UiState photosState;
  final UiState reelsState;
  final UiState reviewsState;
  final UiState brandDetailsState;
  final int errorCode;

  // Data
  final UiState addingBrandViewState;
  final List<BrandBranchesModel> brandBranches;
  final List<MediaModel> photos;
  final List<MediaModel> reels;
  final List<ReviewModel> reviews;
  final BrandModel brandDetails;
  final String errorMessage;
  final bool hasPhotosReachedMax;
  final bool hasReelsReachedMax;
  final bool hasReviewsReachedMax;

  const BrandState({
    this.branchesState = UiState.initial,
    this.photosState = UiState.initial,
    this.reelsState = UiState.initial,
    this.reviewsState = UiState.initial,
    this.addingBrandViewState = UiState.initial,
    this.brandDetailsState = UiState.initial,
    this.errorCode = 0,
    this.brandBranches = const [],
    this.photos = const [],
    this.reels = const [],
    this.reviews = const [],
    this.errorMessage = "",
    this.brandDetails = const BrandModel.empty(),
    this.hasPhotosReachedMax = false,
    this.hasReelsReachedMax = false,
    this.hasReviewsReachedMax = false,
  });

  @override
  List<Object> get props => [
        branchesState,
        photosState,
        reelsState,
        reviewsState,
        brandDetailsState,
        errorCode,
        addingBrandViewState,
        brandBranches,
        photos,
        reels,
        reviews,
        errorMessage,
        hasPhotosReachedMax,
        hasReelsReachedMax,
        hasReviewsReachedMax,
      ];

  BrandState copyWith({
    UiState? branchesState,
    UiState? photosState,
    UiState? reelsState,
    UiState? brandDetailsState,
    UiState? reviewsState,
    UiState? addingBrandViewState,
    int? errorCode,
    List<BrandBranchesModel>? brandBranches,
    List<MediaModel>? photos,
    List<MediaModel>? reels,
    List<ReviewModel>? reviews,
    BrandModel? brandDetails,
    String? errorMessage,
    bool? hasPhotosReachedMax,
    bool? hasReelsReachedMax,
    bool? hasReviewsReachedMax,
  }) {
    return BrandState(
      branchesState: branchesState ?? this.branchesState,
      photosState: photosState ?? this.photosState,
      reelsState: reelsState ?? this.reelsState,
      reviewsState: reviewsState ?? this.reviewsState,
      brandDetailsState: brandDetailsState ?? this.brandDetailsState,
      addingBrandViewState: addingBrandViewState ?? this.addingBrandViewState,
      brandBranches: brandBranches ?? this.brandBranches,
      errorCode: errorCode ?? this.errorCode,
      photos: photos ?? this.photos,
      reels: reels ?? this.reels,
      reviews: reviews ?? this.reviews,
      brandDetails: brandDetails ?? this.brandDetails,
      errorMessage: errorMessage ?? this.errorMessage,
      hasPhotosReachedMax: hasPhotosReachedMax ?? this.hasPhotosReachedMax,
      hasReelsReachedMax: hasReelsReachedMax ?? this.hasReelsReachedMax,
      hasReviewsReachedMax: hasReviewsReachedMax ?? this.hasReviewsReachedMax,
    );
  }
}
