import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/features/brand/logic/booking_from_media/booking_from_media_cubit.dart';
import 'package:dazzify/features/brand/logic/brand/brand_bloc.dart';
import 'package:dazzify/features/brand/presentation/bottom_sheets/chat_branches_sheet.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/logic/comments/comments_bloc.dart';
import 'package:dazzify/features/shared/logic/likes/likes_cubit.dart';
import 'package:dazzify/features/shared/widgets/comments_closed_bottom_sheet.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/dazzify_overlay_loading.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/favorite_icon_button.dart';
import 'package:dazzify/features/shared/widgets/media_comments_sheet/media_comment_sheet.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';
import 'package:photo_view/photo_view.dart';

@RoutePage(name: 'DazzifyPhotoViewerRoute')
class DazzifyPhotoViewer extends StatefulWidget implements AutoRouteWrapper {
  final bool isProfilePicture;
  final String name;
  final String? userAvatar;
  final String imageUrl;
  final dynamic heroAnimationKey;
  final MediaModel? media;

  const DazzifyPhotoViewer({
    super.key,
    this.isProfilePicture = false,
    required this.name,
    this.userAvatar,
    required this.imageUrl,
    required this.heroAnimationKey,
    this.media,
  });

  @override
  State<DazzifyPhotoViewer> createState() => _DazzifyPhotoViewerState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<CommentsBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<BookingFromMediaCubit>(),
        )
      ],
      child: this,
    );
  }
}

class _DazzifyPhotoViewerState extends State<DazzifyPhotoViewer> {
  late final ValueNotifier<bool> _isControlsVisible;
  late final PhotoViewScaleStateController _photoViewController;
  late final CommentsBloc commentsBloc;
  late final UserCubit userCubit;
  late final LikesCubit likesCubit;
  late final BookingFromMediaCubit bookingFromMediaCubit;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    commentsBloc = context.read<CommentsBloc>();
    userCubit = context.read<UserCubit>();
    likesCubit = context.read<LikesCubit>();
    bookingFromMediaCubit = context.read<BookingFromMediaCubit>();
    _isControlsVisible = ValueNotifier(true);
    _photoViewController = PhotoViewScaleStateController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          context.maybePop();
        }
      },
      child: CustomFadeAnimation(
        duration: const Duration(milliseconds: 300),
        child: Scaffold(
          body: Stack(
            children: [
              photoViewer(),
              arrowBack(),
              PositionedDirectional(
                top: 125.h,
                start: 15.w,
                child: !widget.isProfilePicture
                    ? profilePictureWithName()
                    : const SizedBox.shrink(),
              ),
              if (widget.isProfilePicture == false) controlButtons(),
              if (widget.isProfilePicture == false)
                BlocConsumer<BookingFromMediaCubit, BookingFromMediaState>(
                  listener: (context, state) {
                    switch (state.blocState) {
                      case UiState.initial:
                      case UiState.loading:
                        isLoading = true;
                      case UiState.success:
                        context.pushRoute(
                          ServiceDetailsRoute(
                            service: state.service,
                          ),
                        );
                        isLoading = false;
                      case UiState.failure:
                        isLoading = false;
                        DazzifyToastBar.showError(
                          message: state.errorMessage,
                        );
                    }
                  },
                  builder: (BuildContext context, BookingFromMediaState state) {
                    return DazzifyOverlayLoading(
                      isLoading: isLoading,
                      child: const SizedBox(),
                    );
                  },
                )
            ],
          ),
        ),
      ),
    );
  }

  PositionedDirectional arrowBack() {
    return PositionedDirectional(
      top: 50.h,
      start: 0,
      child: ValueListenableBuilder(
        valueListenable: _isControlsVisible,
        builder: (context, value, child) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Visibility(
            key: ValueKey(value),
            visible: value,
            child: DazzifyAppBar(
              isLeading: true,
              title: widget.name,
            ),
          ),
        ),
      ),
    );
  }

  Widget photoViewer() {
    return PhotoView(
      scaleStateController: _photoViewController,
      minScale: PhotoViewComputedScale.contained,
      filterQuality: FilterQuality.high,
      heroAttributes: PhotoViewHeroAttributes(tag: widget.heroAnimationKey),
      loadingBuilder: (context, event) {
        return Center(
          child: CircularProgressIndicator(
            color: context.colorScheme.primary,
          ),
        );
      },
      backgroundDecoration: const BoxDecoration(
        color: Color(0xFF000B14),
      ),
      scaleStateChangedCallback: (value) {
        if (_photoViewController.scaleState == PhotoViewScaleState.initial) {
          _isControlsVisible.value = true;
        } else {
          _isControlsVisible.value = false;
        }
        debugPrint('${_photoViewController.scaleState}');
        debugPrint('${_photoViewController.isZooming}');
      },
      imageProvider: DazzifyCachedNetworkImageProvider(
        widget.imageUrl,
      ),
    );
  }

  ValueListenableBuilder<bool> profilePictureWithName() {
    return ValueListenableBuilder(
      valueListenable: _isControlsVisible,
      builder: (context, value, child) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Visibility(
          key: ValueKey(value),
          visible: value,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 46.h,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: onBrandDataTap,
                      child: ClipOval(
                        child: DazzifyCachedNetworkImage(
                          imageUrl: '${widget.userAvatar}',
                          width: 38.r,
                          height: 38.r,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    GestureDetector(
                      onTap: onBrandDataTap,
                      child: DText(
                        widget.name,
                        style: context.textTheme.labelLarge!.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PositionedDirectional controlButtons() {
    return PositionedDirectional(
      bottom: 50.r,
      start: 0,
      end: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).r,
        child: ValueListenableBuilder(
          valueListenable: _isControlsVisible,
          builder: (context, value, child) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Visibility(
              key: ValueKey(value),
              visible: value,
              child: Column(
                children: [
                  Divider(
                    color: const Color(0xFF1F2429),
                    indent: 16.r,
                    endIndent: 16.r,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      BlocConsumer<LikesCubit, LikesState>(
                        listener: (context, state) {
                          if (state.addLikeState == UiState.success) {
                            if (widget.media!.likesCount != null) {
                              widget.media!.likesCount! + 1;
                            }
                          }
                          if (state.removeLikeState == UiState.success) {
                            if (widget.media!.likesCount != null) {
                              widget.media!.likesCount! - 1;
                            }
                          }
                        },
                        buildWhen: (previous, current) =>
                            previous.addLikeState != current.addLikeState ||
                            previous.removeLikeState != current.removeLikeState,
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FavoriteIconButton(
                                hasBackGround: false,
                                iconSize: 24.r,
                                favoriteColor: context.colorScheme.error,
                                isFavorite: state.likesIds.contains(
                                  widget.media!.id,
                                ),
                                onFavoriteTap: onFavoriteTap,
                              ),
                              if (widget.media!.likesCount != null)
                                DText(
                                  widget.media!.likesCount.toString(),
                                  style: context.textTheme.labelSmall!.copyWith(
                                    color: context.colorScheme.outline,
                                  ),
                                )
                            ],
                          );
                        },
                      ),
                      SizedBox(width: 4.w),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: onCommentsTap,
                            icon: Icon(
                              SolarIconsOutline.chatRound,
                              size: 24.r,
                            ),
                          ),
                          DText(
                            widget.media!.commentsCount.toString(),
                            style: context.textTheme.labelSmall!.copyWith(
                              color: context.colorScheme.outline,
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 4.w),
                      IconButton(
                        onPressed: onChatTap,
                        icon: Icon(
                          SolarIconsOutline.plain,
                          size: 24.r,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          context
                              .read<BookingFromMediaCubit>()
                              .getSingleServiceDetails(
                                serviceId: widget.media!.serviceId,
                              );
                        },
                        icon: Icon(
                          SolarIconsOutline.calendar,
                          size: 24.r,
                        ),
                      ),
                      SizedBox(width: 8.w),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onFavoriteTap() {
    likesCubit.addOrRemoveLike(
      mediaId: widget.media!.id,
    );
  }

  void onCommentsTap() {
    if (widget.media!.commentsCount == null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        builder: (context) {
          return CommentsClosedBottomSheet();
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        routeSettings: const RouteSettings(
          name: "ViewerCommentsSheet",
        ),
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: commentsBloc,
            ),
            BlocProvider.value(
              value: userCubit,
            ),
          ],
          child: MediaCommentsSheet(
            media: widget.media!,
          ),
        ),
      );
    }
  }

  void onChatTap() {
    final BrandBloc brandBloc = getIt<BrandBloc>();
    final media = widget.media;

    brandBloc.add(
      GetBrandBranchesEvent(
        media!.brand.id,
      ),
    );

    // Determine chat source by checking if we came from brand or search
    // Since DazzifyPhotoViewer is opened from BrandPostsScreen or SearchPostScreen,
    // we'll check the route name to infer the source
    ChatSource chatSource = ChatSource.brandMedia; // Default to brand
    
    try {
      // Use AutoRoute's router to check the current route
      final router = context.router;
      final routeName = router.current.name;
      
      // Check if current route indicates search
      if (routeName.contains('SearchPost') || routeName.contains('search-post') ||
          routeName.contains('Search') || routeName.contains('search')) {
        chatSource = ChatSource.searchMedia;
      } else if (routeName.contains('BrandPosts') || routeName.contains('brand-posts') ||
                 routeName.contains('Brand') || routeName.contains('brand')) {
        chatSource = ChatSource.brandMedia;
      }
      // If route name is DazzifyPhotoViewerRoute, we can't determine from route name alone
      // In this case, we default to brandMedia (most common case)
    } catch (e) {
      // If we can't determine, default to brand (since most media access is from brand)
      chatSource = ChatSource.brandMedia;
    }

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
          serviceId: media.serviceId,
          brand: media.brand,
          chatSource: chatSource,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _isControlsVisible.dispose();
    _photoViewController.dispose();
    super.dispose();
  }

  void onBrandDataTap() {
    final profile = widget.media!.brand;
    context.pushRoute(
      BrandProfileRoute(
        brand: profile,
      ),
    );
  }
}
