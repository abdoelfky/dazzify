import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/brand/logic/booking_from_media/booking_from_media_cubit.dart';
import 'package:dazzify/features/brand/logic/brand/brand_bloc.dart';
import 'package:dazzify/features/brand/presentation/bottom_sheets/chat_branches_sheet.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/logic/comments/comments_bloc.dart';
import 'package:dazzify/features/shared/logic/likes/likes_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_overlay_loading.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/media_comments_sheet/media_comment_sheet.dart';
import 'package:dazzify/features/shared/widgets/media_post_card.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/widgets/comments_closed_bottom_sheet.dart';

@RoutePage()
class SearchPostScreen extends StatefulWidget implements AutoRouteWrapper {
  final MediaModel photo;

  const SearchPostScreen({
    super.key,
    required this.photo,
  });

  @override
  State<SearchPostScreen> createState() => _SearchPostScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<BookingFromMediaCubit>(
        create: (context) => getIt<BookingFromMediaCubit>(),
        child: this,
      ),
      BlocProvider<BrandBloc>(
        create: (context) => getIt<BrandBloc>(),
        child: this,
      ),
    ], child: this);
  }
}

class _SearchPostScreenState extends State<SearchPostScreen> {
  late final LikesCubit _likesCubit;
  late final BrandBloc _brandBloc;
  late final BookingFromMediaCubit _bookingFromMediaCubit;
  bool isLoading = false;

  @override
  void initState() {
    _likesCubit = context.read<LikesCubit>();
    _brandBloc = context.read<BrandBloc>();
    _bookingFromMediaCubit = context.read<BookingFromMediaCubit>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: BlocConsumer<BookingFromMediaCubit, BookingFromMediaState>(
          listener: (context, state) =>
              _bookingFromMediaCubitListener(state, context),
          builder: (BuildContext context, BookingFromMediaState state) {
            return DazzifyOverlayLoading(
              isLoading: isLoading,
              child: Column(
                children: [
                  const DazzifyAppBar(
                    isLeading: true,
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

  void _bookingFromMediaCubitListener(
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

  Widget brandPostsList() {
    return BlocBuilder<BrandBloc, BrandState>(
      builder: (context, state) {
        return CustomFadeAnimation(
            duration: const Duration(milliseconds: 300),
            child: BlocConsumer<LikesCubit, LikesState>(
              listener: (context, state) =>
                  likesCubitListener(state, widget.photo),
              builder: (context, state) {
                return MediaPostCard(
                  brandMedia: widget.photo,
                  isLiked: _likesCubit.state.likesIds.contains(widget.photo.id),
                  onLikeTap: () {
                    _likesCubit.addOrRemoveLike(mediaId: widget.photo.id);
                  },
                  onCommentTap: () {
                    if (widget.photo.commentsCount == null) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: false,
                        builder: (context) {
                          return CommentsClosedBottomSheet();
                        },
                      );
                    }else {
                      handelCommentsTap(widget.photo);
                    }
                  },
                  onSendServiceTap: () {
                    handelSendServiceTap(widget.photo);
                  },
                  onBookingTap: () {
                    _bookingFromMediaCubit.getSingleServiceDetails(
                      serviceId: widget.photo.serviceId,
                    );
                  },
                  onBrandTap: () {
                    handelBrandTap(widget.photo.brand);
                  },
                );
              },
            ));
      },
    );
  }

  void likesCubitListener(LikesState state, MediaModel brandMedia) {
    if (brandMedia.likesCount != null) {
      if (state.addLikeState == UiState.loading) {
        brandMedia.likesCount! + 1;
      }
      if (state.removeLikeState == UiState.loading) {
        brandMedia.likesCount! - 1;
      }
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
    _brandBloc.add(GetBrandBranchesEvent(brandMedia.brand.id));

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      routeSettings: const RouteSettings(
        name: "BranchesBottomSheet",
      ),
      builder: (context) => BlocProvider.value(
        value: _brandBloc,
        child: ChatBranchesSheet(
          sheetType: BranchesSheetType.chat,
          serviceId: brandMedia.serviceId,
          brand: brandMedia.brand,
        ),
      ),
    );
  }

  void handelBrandTap(BrandModel brand) {
    context.navigateTo(
      BrandProfileRoute(brand: brand),
    );
  }
}
