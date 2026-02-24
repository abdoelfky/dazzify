part of 'search_bloc.dart';

class SearchState extends Equatable {
  final UiState blocState;
  final String errorMessage;
  final bool
      showMediaItems; //show media items or search result in the screen view
  final List<MediaModel> media;
  final bool hasMediaReachMax;
  final List<BrandModel> brands;
  final bool hasBrandsReachMax;
  final bool isLoadingBrandsMore;
  final List<ServiceDetailsModel> services;
  final bool hasServicesReachMax;
  final bool isLoadingServicesMore;
  final String? lastBrandsKeyword;
  final String? lastServicesKeyword;

  const SearchState({
    this.blocState = UiState.initial,
    this.errorMessage = '',
    this.showMediaItems = true,
    this.media = const [],
    this.hasMediaReachMax = false,
    this.brands = const [],
    this.hasBrandsReachMax = false,
    this.isLoadingBrandsMore = false,
    this.services = const [],
    this.hasServicesReachMax = false,
    this.isLoadingServicesMore = false,
    this.lastBrandsKeyword,
    this.lastServicesKeyword,
  });

  SearchState copyWith({
    UiState? blocState,
    String? errorMessage,
    bool? showMediaItems,
    List<MediaModel>? media,
    bool? hasMediaReachMax,
    List<BrandModel>? brands,
    bool? hasBrandsReachMax,
    bool? isLoadingBrandsMore,
    List<ServiceDetailsModel>? services,
    bool? hasServicesReachMax,
    bool? isLoadingServicesMore,
    String? lastBrandsKeyword,
    String? lastServicesKeyword,
  }) {
    return SearchState(
      blocState: blocState ?? this.blocState,
      errorMessage: errorMessage ?? this.errorMessage,
      showMediaItems: showMediaItems ?? this.showMediaItems,
      media: media ?? this.media,
      hasMediaReachMax: hasMediaReachMax ?? this.hasMediaReachMax,
      brands: brands ?? this.brands,
      hasBrandsReachMax: hasBrandsReachMax ?? this.hasBrandsReachMax,
      isLoadingBrandsMore: isLoadingBrandsMore ?? this.isLoadingBrandsMore,
      services: services ?? this.services,
      hasServicesReachMax: hasServicesReachMax ?? this.hasServicesReachMax,
      isLoadingServicesMore: isLoadingServicesMore ?? this.isLoadingServicesMore,
      lastBrandsKeyword: lastBrandsKeyword ?? this.lastBrandsKeyword,
      lastServicesKeyword: lastServicesKeyword ?? this.lastServicesKeyword,
    );
  }

  @override
  List<Object?> get props => [
        blocState,
        errorMessage,
        showMediaItems,
        media,
        hasMediaReachMax,
        brands,
        hasBrandsReachMax,
        isLoadingBrandsMore,
        services,
        hasServicesReachMax,
        isLoadingServicesMore,
        lastBrandsKeyword,
        lastServicesKeyword,
      ];
}
