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
  final List<ServiceDetailsModel> services;
  final bool hasServicesReachMax;

  const SearchState({
    this.blocState = UiState.initial,
    this.errorMessage = '',
    this.showMediaItems = true,
    this.media = const [],
    this.hasMediaReachMax = false,
    this.brands = const [],
    this.hasBrandsReachMax = false,
    this.services = const [],
    this.hasServicesReachMax = false,
  });

  SearchState copyWith({
    UiState? blocState,
    String? errorMessage,
    bool? showMediaItems,
    List<MediaModel>? media,
    bool? hasMediaReachMax,
    List<BrandModel>? brands,
    bool? hasBrandsReachMax,
    List<ServiceDetailsModel>? services,
    bool? hasServicesReachMax,
  }) {
    return SearchState(
      blocState: blocState ?? this.blocState,
      errorMessage: errorMessage ?? this.errorMessage,
      showMediaItems: showMediaItems ?? this.showMediaItems,
      media: media ?? this.media,
      hasMediaReachMax: hasMediaReachMax ?? this.hasMediaReachMax,
      brands: brands ?? this.brands,
      hasBrandsReachMax: hasBrandsReachMax ?? this.hasBrandsReachMax,
      services: services ?? this.services,
      hasServicesReachMax: hasServicesReachMax ?? this.hasServicesReachMax,
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
        services,
        hasServicesReachMax,
      ];
}
