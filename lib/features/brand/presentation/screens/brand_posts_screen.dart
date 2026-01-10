import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/core/util/functions.dart';
import 'package:dazzify/dazzify_app.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource_impl.dart';
import 'package:dazzify/features/brand/logic/booking_from_media/booking_from_media_cubit.dart';
import 'package:dazzify/features/brand/logic/brand/brand_bloc.dart';
import 'package:dazzify/features/brand/presentation/bottom_sheets/chat_branches_sheet.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/logic/comments/comments_bloc.dart';
import 'package:dazzify/features/shared/logic/favorite/favorite_cubit.dart';
import 'package:dazzify/features/shared/logic/likes/likes_cubit.dart';
import 'package:dazzify/features/shared/widgets/comments_closed_bottom_sheet.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_overlay_loading.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/guest_mode_bottom_sheet.dart';
import 'package:dazzify/features/shared/widgets/media_comments_sheet/media_comment_sheet.dart';
import 'package:dazzify/features/shared/widgets/media_post_card.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

@RoutePage()
class BrandPostsScreen extends StatefulWidget implements AutoRouteWrapper {
  final String brandName;
  final String brandId;
  final int photoIndex;
  final BrandBloc brandBloc;

  const BrandPostsScreen({
    super.key,
    required this.photoIndex,
    required this.brandName,
    required this.brandId,
    required this.brandBloc,
  });

  @override
  State<BrandPostsScreen> createState() => _BrandPostsScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BookingFromMediaCubit>(
          create: (context) => getIt<BookingFromMediaCubit>(),
          child: this,
        ),
        BlocProvider.value(
          value: brandBloc,
          child: this,
        ),
      ],
      child: this,
    );
  }
}

class _BrandPostsScreenState extends State<BrandPostsScreen> {
  late final LikesCubit likesCubit;
  late final BrandBloc brandBloc;
  late final FavoriteCubit favoriteCubit;
  late final BookingFromMediaCubit _bookingFromMediaCubit;
  late final ItemScrollController _itemScrollController;
  late final ItemPositionsListener _itemPositionsListener;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();
  bool isLoading = false;

  @override
  void initState() {
    likesCubit = context.read<LikesCubit>();
    brandBloc = widget.brandBloc;
    favoriteCubit = context.read<FavoriteCubit>();
    _bookingFromMediaCubit = context.read<BookingFromMediaCubit>();

    _itemScrollController = ItemScrollController();
    _itemPositionsListener = ItemPositionsListener.create();
    _itemPositionsListener.itemPositions.addListener(_onScroll);

    // Scroll to the selected photo index after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex();
    });

    super.initState();
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onScroll);
    super.dispose();
  }

  void _scrollToIndex() {
    if (widget.photoIndex == 0) return;

    // Wait for the list to be fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_itemScrollController.isAttached) {
            _itemScrollController.scrollTo(
              index: widget.photoIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: 0.0, // Show the item from the top of the viewport
            );
          }
        });
      });
    });
  }

  void _onScroll() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    // Get the last visible item index
    final lastVisibleIndex = positions
        .where((position) => position.itemTrailingEdge > 0)
        .reduce((max, position) =>
            position.itemTrailingEdge > max.itemTrailingEdge ? position : max)
        .index;

    // Load more if we're near the end (within last 5 items)
    if (lastVisibleIndex >= brandBloc.state.photos.length - 5) {
      brandBloc.add(
        GetBrandImagesEvent(widget.brandId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: BlocConsumer<BookingFromMediaCubit, BookingFromMediaState>(
        listener: (context, state) =>
            bookingFromMediaCubitListener(state, context),
        builder: (BuildContext context, BookingFromMediaState state) {
          return DazzifyOverlayLoading(
            isLoading: isLoading,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: DazzifyAppBar(
                    isLeading: true,
                    title:
                        "${truncateText(widget.brandName, 25)} ${DazzifyApp.tr.posts}",
                    textStyle: context.textTheme.titleMedium,
                    onBackTap: () {
                      _logger.logEvent(event: AppEvents.brandMediaClickBack);
                      context.maybePop();
                    },
                  ),
                ),
                brandPostsList(),
              ],
            ),
          );
        },
      ),
    );
  }

  void bookingFromMediaCubitListener(
    BookingFromMediaState state,
    BuildContext context,
  ) {
    switch (state.blocState) {
      case UiState.initial:
      case UiState.loading:
        isLoading = true;
      case UiState.success:
        context.pushRoute(ServiceDetailsRoute(service: state.service));
        isLoading = false;
      case UiState.failure:
        isLoading = false;
        DazzifyToastBar.showError(
          message: state.errorMessage,
        );
    }
  }

  Expanded brandPostsList() {
    return Expanded(child: BlocBuilder<BrandBloc, BrandState>(
      builder: (context, brandState) {
        return CustomFadeAnimation(
          duration: const Duration(milliseconds: 300),
          child: ScrollablePositionedList.builder(
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
            itemCount: brandState.photos.length + 1,
            itemBuilder: (context, index) {
              if (index >= brandState.photos.length) {
                if (brandState.hasPhotosReachedMax) {
                  return const SizedBox.shrink();
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: LoadingAnimation(
                        height: 50.h,
                        width: 50.w,
                      ),
                    ),
                  );
                }
              } else {
                final brandMedia = brandState.photos[index];
                return BlocConsumer<LikesCubit, LikesState>(
                  listener: (context, likesState) =>
                      likesCubitListener(likesState, brandMedia),
                  builder: (context, likesState) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < brandState.photos.length - 1 ? 8.h : 0,
                      ),
                      child: MediaPostCard(
                        brandMedia: brandMedia,
                        isLiked:
                            likesCubit.state.likesIds.contains(brandMedia.id),
                        onLikeTap: () {
                          if (AuthLocalDatasourceImpl().checkGuestMode()) {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: false,
                              builder: (context) {
                                return GuestModeBottomSheet();
                              },
                            );
                          } else {
                            likesCubit.addOrRemoveLike(mediaId: brandMedia.id);
                          }
                        },
                        onCommentTap: () {
                          _logger.logEvent(
                              event: AppEvents.brandMediaClickComments);
                          if (AuthLocalDatasourceImpl().checkGuestMode()) {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: false,
                              builder: (context) {
                                return GuestModeBottomSheet();
                              },
                            );
                          } else if (brandMedia.commentsCount == null) {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: false,
                              builder: (context) {
                                return CommentsClosedBottomSheet();
                              },
                            );
                          } else {
                            handelCommentsTap(brandMedia);
                          }
                        },
                        onSendServiceTap: () {
                          handelSendServiceTap(brandMedia);
                        },
                        onBookingTap: () {
                          _logger.logEvent(
                              event: AppEvents.brandMediaClickBook);
                          _bookingFromMediaCubit.getSingleServiceDetails(
                            serviceId: brandMedia.serviceId,
                          );
                        },
                        onBrandTap: () {
                          _logger.logEvent(
                            event: AppEvents.brandMediaClickBrand,
                            brandId: brandMedia.brand.id,
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        );
      },
    ));
  }

  void likesCubitListener(LikesState state, MediaModel brandMedia) {
    if (state.addLikeState == UiState.loading &&
        likesCubit.currentMediaId == brandMedia.id) {
      if (brandMedia.likesCount != null) brandMedia.likesCount! + 1;
    }
    if (state.removeLikeState == UiState.loading &&
        likesCubit.currentMediaId == brandMedia.id) {
      if (brandMedia.likesCount != null) brandMedia.likesCount! - 1;
    }
  }

  void handelCommentsTap(MediaModel media) {
    final commentsBloc = getIt<CommentsBloc>();
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      routeSettings: const RouteSettings(name: "PostsComments"),
      builder: (ctx) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: commentsBloc),
          BlocProvider.value(value: context.read<UserCubit>()),
        ],
        child: MediaCommentsSheet(media: media),
      ),
    );
  }

  void handelSendServiceTap(MediaModel brandMedia) {
    if (AuthLocalDatasourceImpl().checkGuestMode()) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        builder: (context) {
          return GuestModeBottomSheet();
        },
      );
    } else {
      brandBloc.add(GetBrandBranchesEvent(brandMedia.brand.id));

      showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        routeSettings: const RouteSettings(
          name: "BranchesBottomSheet",
        ),
        builder: (context) => BlocProvider.value(
          value: brandBloc,
          child: ChatBranchesSheet(
            sheetType: BranchesSheetType.chat,
            serviceId: brandMedia.serviceId,
            brand: brandMedia.brand,
            chatSource: ChatSource.brandMedia,
          ),
        ),
      );
    }
  }
}
