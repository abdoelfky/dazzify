import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/services/search_history_service.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/home/logic/search/search_bloc.dart';
import 'package:dazzify/features/home/presentation/widgets/media_card.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/data/data_sources/local/local_datasource.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/logic/favorite/favorite_cubit.dart';
import 'package:dazzify/features/shared/widgets/brand_card.dart';
import 'package:dazzify/features/shared/widgets/top_rated_card.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/dazzify_text_form_field.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:solar_icons/solar_icons.dart';

@RoutePage()
class SearchInputScreen extends StatefulWidget {
  const SearchInputScreen({super.key});

  @override
  State<SearchInputScreen> createState() => _SearchInputScreenState();
}

class _SearchInputScreenState extends State<SearchInputScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final SearchHistoryService _searchHistoryService =
      getIt<SearchHistoryService>();
  final AppEventsLogger _logger = getIt<AppEventsLogger>();
  final ScrollController _mediaScrollController = ScrollController();
  final ScrollController _brandsScrollController = ScrollController();
  final ScrollController _servicesScrollController = ScrollController();
  final LocalDataSource _localDataSource = getIt<LocalDataSource>();
  late final SearchBloc searchBloc;
  List<String> _searchHistory = [];
  bool _hasSearched = false;
  SearchType _selectedSearchType = SearchType.brand;
  Timer? _historyDebounceTimer;
  static const Duration _historyDebounceDuration = Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    searchBloc = context.read<SearchBloc>();
    _loadSearchHistory();
    _loadSearchType();
    _mediaScrollController.addListener(_onMediaScroll);
    _brandsScrollController.addListener(_onBrandsScroll);
    _servicesScrollController.addListener(_onServicesScroll);
    // Auto focus on the text field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _loadSearchType() {
    final savedType = _localDataSource.getSearchType();
    setState(() {
      _selectedSearchType = SearchTypeExtension.fromString(savedType);
    });
  }

  Future<void> _saveSearchType(SearchType type) async {
    await _localDataSource.saveSearchType(searchType: type.value);
  }

  void _onMediaScroll() async {
    final maxScroll = _mediaScrollController.position.maxScrollExtent;
    final currentScroll = _mediaScrollController.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      searchBloc.add(GetMediaItemsEvent());
    }
  }

  void _onBrandsScroll() async {
    if (_selectedSearchType == SearchType.brand) {
      final maxScroll = _brandsScrollController.position.maxScrollExtent;
      final currentScroll = _brandsScrollController.offset;
      if (currentScroll >= (maxScroll * 0.8)) {
        String keyWord = _textController.text;
        searchBloc.add(GetMoreBrandsEvent(keyWord: keyWord));
      }
    }
  }

  void _onServicesScroll() async {
    final maxScroll = _servicesScrollController.position.maxScrollExtent;
    final currentScroll = _servicesScrollController.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      String keyWord = _textController.text;
      searchBloc.add(GetMoreServicesEvent(keyWord: keyWord));
    }
  }

  void _loadSearchHistory() {
    setState(() {
      _searchHistory = _searchHistoryService.getSearchHistory();
    });
  }

  void _scheduleAddToHistory(String keyword) {
    final trimmed = keyword.trim();
    if (trimmed.isEmpty) return;
    _historyDebounceTimer?.cancel();
    _historyDebounceTimer = Timer(_historyDebounceDuration, () async {
      await _searchHistoryService.addToHistory(trimmed);
      if (mounted) _loadSearchHistory();
    });
  }

  Future<void> _onSearch(String keyword) async {
    if (keyword.trim().isNotEmpty) {
      _historyDebounceTimer?.cancel();
      await _searchHistoryService.addToHistory(keyword.trim());
      _loadSearchHistory();

      _logger.logEvent(
        event: AppEvents.searchSearch,
        searchText: keyword,
      );

      setState(() {
        _hasSearched = true;
      });

      searchBloc.add(EmitSearchLoadingEvent(
          searchType: _selectedSearchType.value));
      searchBloc.add(GetSearchResultsEvent(
        keyWord: keyword.trim(),
        searchType: _selectedSearchType.value,
      ));
    }
  }

  void _onSearchTypeChanged(SearchType type) {
    setState(() {
      _selectedSearchType = type;
    });
    _saveSearchType(type);

    // Only re-search if we have a keyword and don't already have results for this tab with same keyword
    final keyword = _textController.text.trim();
    if (keyword.isEmpty || !_hasSearched) return;

    final state = searchBloc.state;
    final alreadyHasBrands = type == SearchType.brand &&
        state.brands.isNotEmpty &&
        (state.lastBrandsKeyword ?? '') == keyword;
    final alreadyHasServices = type == SearchType.service &&
        state.services.isNotEmpty &&
        (state.lastServicesKeyword ?? '') == keyword;

    if (alreadyHasBrands || alreadyHasServices) return;

    searchBloc.add(EmitSearchLoadingEvent(searchType: type.value));
    searchBloc.add(GetSearchResultsEvent(
      keyWord: keyword,
      searchType: type.value,
    ));
  }

  void _onHistoryItemTap(String searchTerm) {
    _textController.text = searchTerm;
    _onSearch(searchTerm);
  }

  Future<void> _onClearHistory() async {
    await _searchHistoryService.clearHistory();
    _loadSearchHistory();
  }

  Future<void> _onRemoveHistoryItem(String searchTerm) async {
    await _searchHistoryService.removeFromHistory(searchTerm);
    _loadSearchHistory();
  }

  @override
  void dispose() {
    _historyDebounceTimer?.cancel();
    _textController.dispose();
    _focusNode.dispose();
    _mediaScrollController
      ..removeListener(_onMediaScroll)
      ..dispose();
    _brandsScrollController
      ..removeListener(_onBrandsScroll)
      ..dispose();
    _servicesScrollController
      ..removeListener(_onServicesScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0).r,
              child: DazzifyAppBar(
                title: context.tr.search,
                isLeading: true,
                onBackTap: () {
                  _logger.logEvent(event: AppEvents.searchClickBack);
                  context.maybePop();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16).r,
              child: Column(
                children: [
                  DazzifyTextFormField(
                    borderSide: BorderSide.none,
                    prefixIconData: SolarIconsOutline.magnifier,
                    maxLength: 100,
                    fillColor: context.colorScheme.inversePrimary
                        .withValues(alpha: 0.1),
                    hintText: context.tr.search.toLowerCase(),
                    controller: _textController,
                    focusNode: _focusNode,
                    validator: (value) => null,
                    textInputType: TextInputType.text,
                    onChanged: (keyWord) {
                      if (keyWord.isEmpty) {
                        _historyDebounceTimer?.cancel();
                        setState(() {
                          _hasSearched = false;
                        });
                        searchBloc.add(const ClearSearchEvent());
                      } else {
                        setState(() => _hasSearched = true);
                        searchBloc.add(EmitSearchLoadingEvent(
                            searchType: _selectedSearchType.value));
                        searchBloc.add(GetSearchResultsEvent(
                          keyWord: keyWord.trim(),
                          searchType: _selectedSearchType.value,
                        ));
                        _scheduleAddToHistory(keyWord);
                      }
                    },
                    onSubmit: (keyWord) {
                      _logger.logEvent(event: AppEvents.searchClickSearch);
                      _onSearch(keyWord);
                    },
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      borderRadius: BorderRadius.circular(24).r,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _onSearchTypeChanged(SearchType.brand),
                            behavior: HitTestBehavior.opaque,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  context.tr.brand,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight:
                                        _selectedSearchType == SearchType.brand
                                            ? FontWeight.bold
                                            : FontWeight.w400,
                                    color: _selectedSearchType ==
                                            SearchType.brand
                                        ? context.colorScheme.primary
                                        : context.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 2.h,
                                  width: double.infinity,
                                  color: _selectedSearchType == SearchType.brand
                                      ? context.colorScheme.primary
                                      : Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                _onSearchTypeChanged(SearchType.service),
                            behavior: HitTestBehavior.opaque,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  context.tr.service,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    fontWeight: _selectedSearchType ==
                                            SearchType.service
                                        ? FontWeight.bold
                                        : FontWeight.w400,
                                    color: _selectedSearchType ==
                                            SearchType.service
                                        ? context.colorScheme.primary
                                        : context.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: 2.h,
                                  width: double.infinity,
                                  color:
                                      _selectedSearchType == SearchType.service
                                          ? context.colorScheme.primary
                                          : Colors.transparent,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Expanded(
              child: _hasSearched
                  ? BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        switch (state.blocState) {
                          case UiState.initial:
                          case UiState.loading:
                            return _selectedSearchType == SearchType.brand
                                ? const DazzifyLoadingShimmer(
                                    dazzifyLoadingType:
                                        DazzifyLoadingType.brands,
                                  )
                                : DazzifyLoadingShimmer(
                                    dazzifyLoadingType:
                                        DazzifyLoadingType.gridView,
                                    cardWidth: 104.w,
                                    cardHeight: 100.h,
                                  );
                          case UiState.failure:
                            return ErrorDataWidget(
                              errorDataType: DazzifyErrorDataType.screen,
                              message: state.errorMessage,
                              onTap: () {
                                if (state.showMediaItems) {
                                  searchBloc.add(GetMediaItemsEvent());
                                } else {
                                  final keyword =
                                      _textController.text.trim();
                                  if (keyword.isNotEmpty) {
                                    searchBloc.add(EmitSearchLoadingEvent(
                                        searchType:
                                            _selectedSearchType.value));
                                    searchBloc.add(GetSearchResultsEvent(
                                      keyWord: keyword,
                                      searchType: _selectedSearchType.value,
                                    ));
                                  } else {
                                    searchBloc.add(GetMediaItemsEvent());
                                  }
                                }
                              },
                            );
                          case UiState.success:
                            if (state.showMediaItems) {
                              if (state.media.isEmpty) {
                                return EmptyDataWidget(
                                  message: context.tr.noMedia,
                                );
                              } else {
                                return CustomFadeAnimation(
                                  child: MasonryGridView.builder(
                                    controller: _mediaScrollController,
                                    padding: const EdgeInsets.only(
                                      top: 0,
                                      bottom: 30,
                                      right: 16,
                                      left: 16,
                                    ).r,
                                    itemCount: state.media.length + 1,
                                    gridDelegate:
                                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                    ),
                                    mainAxisSpacing: 8.r,
                                    crossAxisSpacing: 8.r,
                                    itemBuilder: (context, index) {
                                      if (index >= state.media.length) {
                                        if (state.hasMediaReachMax) {
                                          return const SizedBox.shrink();
                                        } else {
                                          return SizedBox(
                                            height: 110.h,
                                            width: 130.w,
                                            child: const Center(
                                              child: LoadingAnimation(),
                                            ),
                                          );
                                        }
                                      } else {
                                        final media =
                                            searchBloc.state.media[index];
                                        final mediaType =
                                            getMediaType(media.type);

                                        switch (mediaType) {
                                          case MediaType.album:
                                            return MediaCard(
                                              imageUrl: media.thumbnail,
                                              onTap: () {
                                                _logger.logEvent(
                                                  event: AppEvents
                                                      .searchClickMedia,
                                                  mediaId: media.id,
                                                );
                                                _showPhotoScreen(media);
                                              },
                                              isVideo: false,
                                              isAlbum: true,
                                            );
                                          case MediaType.photo:
                                            return MediaCard(
                                              imageUrl: media.thumbnail,
                                              onTap: () {
                                                _logger.logEvent(
                                                  event: AppEvents
                                                      .searchClickMedia,
                                                  mediaId: media.id,
                                                );
                                                _showPhotoScreen(media);
                                              },
                                              isVideo: false,
                                              isAlbum: false,
                                            );
                                          case MediaType.video:
                                            return MediaCard(
                                              imageUrl: media.thumbnail,
                                              onTap: () {
                                                _logger.logEvent(
                                                  event: AppEvents
                                                      .searchClickMedia,
                                                  mediaId: media.id,
                                                );
                                                context.pushRoute(
                                                  ReelViewerRoute(reel: media),
                                                );
                                              },
                                              isVideo: true,
                                              isAlbum: false,
                                            );
                                          case MediaType.none:
                                            return const SizedBox.shrink();
                                        }
                                      }
                                    },
                                  ),
                                );
                              }
                            } else {
                              // Search results: success with empty list = no results (don't show loading)
                              if (_selectedSearchType == SearchType.brand) {
                                if (state.brands.isEmpty) {
                                  return EmptyDataWidget(
                                    message: context.tr.noSearchResult,
                                  );
                                } else {
                                  return ListView.separated(
                                    itemCount: state.brands.length + 1,
                                    padding: const EdgeInsets.only(
                                      top: 0,
                                      bottom: 90,
                                      right: 16,
                                      left: 16,
                                    ).r,
                                    controller: _brandsScrollController,
                                    itemBuilder: (context, index) {
                                      if (index >= state.brands.length) {
                                        if (state.hasBrandsReachMax) {
                                          return const SizedBox.shrink();
                                        } else {
                                          return SizedBox(
                                            height: 25.r,
                                            width: context.screenWidth,
                                            child: LoadingAnimation(
                                              height: 25.r,
                                              width: 25.r,
                                            ),
                                          );
                                        }
                                      } else {
                                        return BrandCard(
                                          brand: state.brands[index],
                                          onTap: () {
                                            _logger.logEvent(
                                              event: AppEvents.searchClickBrand,
                                              brandId: state.brands[index].id,
                                            );
                                            navigateToBrandProfile(
                                              context: context,
                                              brand: state.brands[index],
                                              index: index,
                                            );
                                          },
                                        );
                                      }
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            SizedBox(
                                      height: 16.h,
                                    ),
                                  );
                                }
                              } else {
                                // Show services: success with empty list = no results (don't show loading)
                                if (state.services.isEmpty) {
                                  return EmptyDataWidget(
                                    message: context.tr.noSearchResult,
                                  );
                                } else {
                                  return GridView.builder(
                                    controller: _servicesScrollController,
                                    itemCount: state.services.length + 1,
                                    padding: const EdgeInsets.only(
                                      top: 24,
                                      bottom: 90,
                                      right: 16,
                                      left: 16,
                                    ).r,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 150 / 300,
                                      crossAxisSpacing: 8.w,
                                      mainAxisSpacing: 16.h,
                                    ),
                                    itemBuilder: (context, index) {
                                      if (index >= state.services.length) {
                                        if (state.hasServicesReachMax) {
                                          return const SizedBox.shrink();
                                        } else {
                                          return const Center(
                                            child: LoadingAnimation(),
                                          );
                                        }
                                      } else {
                                        final service = state.services[index];
                                        return BlocBuilder<FavoriteCubit,
                                            FavoriteState>(
                                          builder: (context, favoriteState) {
                                            return TopRatedServiceCard(
                                              title: service.title,
                                              image: service.image,
                                              price: service.price,
                                              originalPrice:
                                                  service.originalPrice,
                                              onTap: () {
                                                _logger.logEvent(
                                                  event: AppEvents
                                                      .homeClickService,
                                                  serviceId: service.id,
                                                );
                                                context.pushRoute(
                                                  ServiceDetailsRoute(
                                                      service: service),
                                                );
                                              },
                                              onFavoriteTap: () {
                                                final favoriteCubit = context
                                                    .read<FavoriteCubit>();
                                                final isFavorite = favoriteCubit
                                                    .state.favoriteIds
                                                    .contains(service.id);
                                                if (isFavorite) {
                                                  _logger.logEvent(
                                                    event: AppEvents
                                                        .homeClickRemoveFavourite,
                                                    serviceId: service.id,
                                                  );
                                                } else {
                                                  _logger.logEvent(
                                                    event: AppEvents
                                                        .homeClickAddFavourite,
                                                    serviceId: service.id,
                                                  );
                                                }
                                                favoriteCubit
                                                    .addOrRemoveFromFavorite(
                                                  favoriteService:
                                                      service.toFavoriteModel(),
                                                );
                                              },
                                              isFavorite: favoriteState
                                                  .favoriteIds
                                                  .contains(service.id),
                                            );
                                          },
                                        );
                                      }
                                    },
                                  );
                                }
                              }
                            }
                        }
                      },
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16).r,
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.tr.recentSearches,
                                style:
                                    context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (_searchHistory.isNotEmpty)
                                TextButton(
                                  onPressed: _onClearHistory,
                                  child: Text(
                                    context.tr.clear,
                                    style:
                                        context.textTheme.bodySmall?.copyWith(
                                      color: context.colorScheme.error,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16).r,
                          child: _searchHistory.isEmpty
                              ? Text(
                                  context.tr.noRecentSearches,
                                  style: context.textTheme.bodyMedium?.copyWith(
                                    color: context.colorScheme.onSurfaceVariant,
                                  ),
                                )
                              : Wrap(
                                  spacing: 10.w,
                                  runSpacing: 10.h,
                                  children: _searchHistory
                                      .take(8)
                                      .map((searchTerm) => _HistoryChip(
                                            searchTerm: searchTerm,
                                            onTap: () =>
                                                _onHistoryItemTap(searchTerm),
                                            onRemove: () =>
                                                _onRemoveHistoryItem(searchTerm),
                                          ))
                                      .toList(),
                                ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void navigateToBrandProfile({
    required BuildContext context,
    required BrandModel brand,
    required int index,
  }) {
    context.pushRoute(
      BrandProfileRoute(brand: brand),
    );
  }

  void _showPhotoScreen(MediaModel photo) {
    context.pushRoute(
      SearchPostRoute(photo: photo),
    );
  }
}

class _HistoryChip extends StatelessWidget {
  final String searchTerm;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _HistoryChip({
    required this.searchTerm,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20).r,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20).r,
            border: Border.all(
              color: context.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                SolarIconsOutline.clockCircle,
                size: 18.r,
                color: context.colorScheme.primary,
              ),
              SizedBox(width: 8.w),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 160.w),
                child: Text(
                  searchTerm,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: context.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 4.w),
              GestureDetector(
                onTap: onRemove,
                child: Icon(
                  SolarIconsOutline.closeCircle,
                  size: 18.r,
                  color: context.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
