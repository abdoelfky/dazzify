import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
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
  late final ScrollController _controller;
  bool isLoading = false;

  @override
  void initState() {
    likesCubit = context.read<LikesCubit>();
    brandBloc = widget.brandBloc;
    favoriteCubit = context.read<FavoriteCubit>();
    _bookingFromMediaCubit = context.read<BookingFromMediaCubit>();

    _controller = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _moveToIndex();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int getDescriptionLinesCount(String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: context.textTheme.labelMedium,
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    );

    textPainter.layout(maxWidth: context.screenWidth - 32);

    return textPainter.computeLineMetrics().length;
  }

  void _moveToIndex() {
    if (widget.photoIndex != 0) {
      int descriptionLines = getDescriptionLinesCount(
        brandBloc.state.photos[widget.photoIndex].caption,
      );
      if (descriptionLines >= 2) {
        _controller.jumpTo(
          widget.photoIndex * context.screenHeight * 0.70,
        );
      } else {
        _controller.jumpTo(
          widget.photoIndex * context.screenHeight * 0.64,
        );
      }
    }
  }

  void _onScroll() async {
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      brandBloc.add(
        GetBrandImagesEvent(widget.brandId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: BlocConsumer<BookingFromMediaCubit, BookingFromMediaState>(
          listener: (context, state) =>
              bookingFromMediaCubitListener(state, context),
          builder: (BuildContext context, BookingFromMediaState state) {
            return DazzifyOverlayLoading(
              isLoading: isLoading,
              child: Column(
                children: [
                  DazzifyAppBar(
                    isLeading: true,
                    title: "${widget.brandName} ${DazzifyApp.tr.posts}",
                    textStyle: context.textTheme.titleMedium,
                  ),
                  brandPostsList(),
                ],
              ),
            );
          },
        ),
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
    return Expanded(
      child: BlocBuilder<BrandBloc, BrandState>(
        builder: (context, state) {
          return CustomFadeAnimation(
            duration: const Duration(milliseconds: 300),
            child: ListView.separated(
              controller: _controller,
              itemCount: state.photos.length + 1,
              itemBuilder: (context, index) {
                if (index >= state.photos.length) {
                  if (state.hasPhotosReachedMax) {
                    return const SizedBox.shrink();
                  } else {
                    return LoadingAnimation(
                      height: 50.h,
                      width: 50.w,
                    );
                  }
                } else {
                  final brandMedia = state.photos[index];
                  return BlocConsumer<LikesCubit, LikesState>(
                    listener: (context, state) =>
                        likesCubitListener(state, brandMedia),
                    builder: (context, state) {
                      return MediaPostCard(
                        brandMedia: brandMedia,
                        isLiked:
                            likesCubit.state.likesIds.contains(brandMedia.id),
                        onLikeTap: () {
                          likesCubit.addOrRemoveLike(mediaId: brandMedia.id);
                        },
                        onCommentTap: () {
                          if (AuthLocalDatasourceImpl().checkGuestMode()) {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: false,
                              builder: (context) {
                                return GuestModeBottomSheet();
                              },
                            );
                          }else if (brandMedia.commentsCount==null) {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: false,
                              builder: (context) {
                                return CommentsClosedBottomSheet();
                              },
                            );
                          }else {
                            handelCommentsTap(brandMedia);
                          }
                        },
                        onSendServiceTap: () {
                          if (AuthLocalDatasourceImpl().checkGuestMode()) {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: false,
                              builder: (context) {
                                return GuestModeBottomSheet();
                              },
                            );
                          }else {
                            handelSendServiceTap(brandMedia);
                          }
                        },
                        onBookingTap: () {
                          _bookingFromMediaCubit.getSingleServiceDetails(
                            serviceId: brandMedia.serviceId,
                          );
                        },
                      );
                    },
                  );
                }
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8);
              },
            ),
          );
        },
      ),
    );
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
        ),
      ),
    );
  }
}
