import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/home/logic/search/search_bloc.dart';
import 'package:dazzify/features/home/presentation/widgets/media_card.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/widgets/brand_card.dart';
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
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _mediaScrollController = ScrollController();
  final ScrollController _brandsScrollController = ScrollController();
  late final SearchBloc searchBloc;
  late MediaType mediaType;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    searchBloc = context.read<SearchBloc>();
    _mediaScrollController.addListener(_onMediaScroll);
    _brandsScrollController.addListener(_onBrandsScroll);
    super.initState();
  }

  void _onMediaScroll() async {
    final maxScroll = _mediaScrollController.position.maxScrollExtent;
    final currentScroll = _mediaScrollController.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      searchBloc.add(GetMediaItemsEvent());
    }
  }

  void _onBrandsScroll() async {
    final maxScroll = _brandsScrollController.position.maxScrollExtent;
    final currentScroll = _brandsScrollController.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      String keyWord = _textController.text;

      searchBloc.add(GetMoreBrandsEvent(keyWord: keyWord));
    }
  }

  @override
  void dispose() {
    _mediaScrollController
      ..removeListener(_onMediaScroll)
      ..dispose();

    _brandsScrollController
      ..removeListener(_onBrandsScroll)
      ..dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          _textController.clear();
          searchBloc.add(const RefreshEvent());
          await Future.delayed(const Duration(seconds: 2));
        },
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
                    context.router.navigate(const HomeTabRoute());
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16).r,
                child: DazzifyTextFormField(
                  borderSide: BorderSide.none,
                  prefixIconData: SolarIconsOutline.magnifier,
                  maxLength: 100,
                  fillColor:
                      context.colorScheme.inversePrimary.withValues(alpha: 0.1),
                  hintText: context.tr.search.toLowerCase(),
                  controller: _textController,
                  validator: (value) => null,
                  textInputType: TextInputType.text,
                  onChanged: (keyWord) {
                    if (keyWord.isNotEmpty) {
                      _logger.logEvent(
                        event: AppEvents.searchSearch,
                        searchText: keyWord,
                      );
                    }
                    searchBloc.add(GetSearchResultsEvent(keyWord: keyWord));
                  },
                  onSubmit: (keyWord) {
                    _logger.logEvent(event: AppEvents.searchClickSearch);
                  },
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  switch (state.blocState) {
                    case UiState.initial:
                    case UiState.loading:
                      return Expanded(
                        child: DazzifyLoadingShimmer(
                          dazzifyLoadingType: DazzifyLoadingType.gridView,
                          cardWidth: 104.w,
                          cardHeight: 100.h,
                        ),
                      );
                    case UiState.failure:
                      return Expanded(
                        child: ErrorDataWidget(
                          errorDataType: DazzifyErrorDataType.screen,
                          message: state.errorMessage,
                          onTap: () {
                            searchBloc.add(GetMediaItemsEvent());
                          },
                        ),
                      );
                    case UiState.success:
                      if (state.showMediaItems) {
                        if (state.media.isEmpty) {
                          return Expanded(
                            child: EmptyDataWidget(
                              message: context.tr.noMedia,
                            ),
                          );
                        } else {
                          return Expanded(
                            child: CustomFadeAnimation(
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
                                    final media = searchBloc.state.media[index];
                                    mediaType = getMediaType(media.type);

                                    switch (mediaType) {
                                      case MediaType.album:
                                        return MediaCard(
                                          imageUrl: media.thumbnail,
                                          onTap: () {
                                            _logger.logEvent(
                                              event: AppEvents.searchClickMedia,
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
                                              event: AppEvents.searchClickMedia,
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
                                              event: AppEvents.searchClickMedia,
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
                            ),
                          );
                        }
                      } else {
                        if (state.brands.isEmpty) {
                          return Expanded(
                            child: EmptyDataWidget(
                              message: context.tr.noSearchResult,
                            ),
                          );
                        } else {
                          return Expanded(
                            child: ListView.separated(
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
                                  (BuildContext context, int index) => SizedBox(
                                height: 16.h,
                              ),
                            ),
                          );
                        }
                      }
                  }
                },
              ),
            ],
          ),
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
