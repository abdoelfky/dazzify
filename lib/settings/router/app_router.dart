import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/navigation/custom_page_transitions.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/auth/logic/auth_cubit.dart';
import 'package:dazzify/features/auth/presentation/screens/auth_screen.dart';
import 'package:dazzify/features/auth/presentation/screens/otp_verify_screen.dart';
import 'package:dazzify/features/auth/presentation/screens/user_info_screen.dart';
import 'package:dazzify/features/booking/logic/booking_cubit/booking_cubit.dart';
import 'package:dazzify/features/booking/logic/booking_review/booking_review_cubit.dart';
import 'package:dazzify/features/booking/logic/service_invoice_cubit/service_invoice_cubit.dart';
import 'package:dazzify/features/booking/presentation/bottom_sheets/booking_review_sheet.dart';
import 'package:dazzify/features/booking/presentation/screens/multiple_service_availability_screen.dart';
import 'package:dazzify/features/booking/presentation/screens/service_availability_screen.dart';
import 'package:dazzify/features/booking/presentation/screens/service_booking_confirmation_screen.dart';
import 'package:dazzify/features/booking/presentation/screens/service_invoice_screen.dart';
import 'package:dazzify/features/booking/presentation/screens/view_location_screen.dart';
import 'package:dazzify/features/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/brand/data/models/location_model.dart';
import 'package:dazzify/features/brand/logic/brand/brand_bloc.dart';
import 'package:dazzify/features/brand/logic/service_selection/service_selection_cubit.dart';
import 'package:dazzify/features/brand/presentation/screens/brand_posts_screen.dart';
import 'package:dazzify/features/brand/presentation/screens/brand_profile_screen.dart';
import 'package:dazzify/features/brand/presentation/screens/brand_reels_screen.dart';
import 'package:dazzify/features/brand/presentation/screens/brand_service_booking_screen.dart';
import 'package:dazzify/features/chat/logic/conversations_cubit.dart';
import 'package:dazzify/features/chat/presentation/screens/chat_screen.dart';
import 'package:dazzify/features/chat/presentation/screens/conversations_screen.dart';
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart';
import 'package:dazzify/features/home/logic/search/search_bloc.dart';
import 'package:dazzify/features/home/logic/service_details/service_details_bloc.dart';
import 'package:dazzify/features/home/presentation/screens/category_screen.dart';
import 'package:dazzify/features/home/presentation/screens/home_screen.dart';
import 'package:dazzify/features/home/presentation/screens/popular_brands_screen.dart';
import 'package:dazzify/features/home/presentation/screens/popular_services_screen.dart';
import 'package:dazzify/features/home/presentation/screens/reel_viewer_screen.dart';
import 'package:dazzify/features/home/presentation/screens/search_post_screen.dart';
import 'package:dazzify/features/home/presentation/screens/search_screen.dart';
import 'package:dazzify/features/home/presentation/screens/see_all_reviews_screen.dart';
import 'package:dazzify/features/home/presentation/screens/service_details_screen.dart';
import 'package:dazzify/features/home/presentation/screens/top_rated_brands_screen.dart';
import 'package:dazzify/features/home/presentation/screens/top_rated_services_screen.dart';
import 'package:dazzify/features/notifications/presentation/notfications_screen.dart';
import 'package:dazzify/features/payment/logic/payment_methods/payment_methods_cubit.dart';
import 'package:dazzify/features/payment/logic/transactions/transaction_bloc.dart';
import 'package:dazzify/features/payment/presentation/screens/payment_method_screen.dart';
import 'package:dazzify/features/payment/presentation/screens/payment_web_view.dart';
import 'package:dazzify/features/payment/presentation/screens/transaction_screen.dart';
import 'package:dazzify/features/reels/logic/reels_bloc.dart';
import 'package:dazzify/features/reels/presentation/screens/reels_screen.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:dazzify/features/shared/logic/favorite/favorite_cubit.dart';
import 'package:dazzify/features/shared/logic/likes/likes_cubit.dart';
import 'package:dazzify/features/shared/logic/socket/socket_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_photo_viewer.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/maintenance_screen.dart';
import 'package:dazzify/features/shared/widgets/splash_screen.dart';
import 'package:dazzify/features/shared/widgets/web_view_screen.dart';
import 'package:dazzify/features/user/logic/issue/issue_bloc.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';
import 'package:dazzify/features/user/presentation/screens/booking_status_screen.dart';
import 'package:dazzify/features/user/presentation/screens/bookings_history_screen.dart';
import 'package:dazzify/features/user/presentation/screens/issue_screen.dart';
import 'package:dazzify/features/user/presentation/screens/issue_status_screen.dart';
import 'package:dazzify/features/user/presentation/screens/my_favorite_screen.dart';
import 'package:dazzify/features/user/presentation/screens/profile_screen.dart';
import 'package:dazzify/features/user/presentation/screens/user_locations_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => CustomPageTransitions.slideAndFade();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: UnAuthenticatedRoute.page,
          initial: true,
          children: [
            AutoRoute(
              initial: true,
              page: SplashRoute.page,
            ),
            AutoRoute(
              page: AuthRoute.page,
            ),
            AutoRoute(
              page: MaintenanceRoute.page,
            ),
            AutoRoute(
              page: OtpVerifyRoute.page,
            ),
            AutoRoute(
              page: UserInfoRoute.page,
            ),
          ],
        ),
        AutoRoute(
          page: AuthenticatedRoute.page,
          children: [
            AutoRoute(
              page: BottomNavBarRoute.page,
              initial: true,
              children: [
                AutoRoute(
                  page: HomeTabRoute.page,
                  initial: true,
                  children: [
                    AutoRoute(
                      page: HomeRoute.page,
                      initial: true,
                    ),
                    AutoRoute(
                      page: MyFavoriteRoute.page,
                    ),
                    AutoRoute(
                      page: BookingStatusRoute.page,
                    ),
                    AutoRoute(
                      page: CategoryRoute.page,
                    ),
                    AutoRoute(
                      page: PopularBrandsRoute.page,
                    ),
                    AutoRoute(
                      page: TopRatedBrandsRoute.page,
                    ),
                    AutoRoute(
                      page: PopularServicesRoute.page,
                    ),
                    AutoRoute(
                      page: NotificationsRoute.page,
                    ),
                    AutoRoute(
                      page: TopRatedServicesRoute.page,
                    ),
                    AutoRoute(
                      page: TransactionRoute.page,
                    ),
                  ],
                ),
                AutoRoute(
                  page: ReelsTabRoute.page,
                  children: [
                    AutoRoute(
                      initial: true,
                      page: ReelsRoute.page,
                    ),
                  ],
                ),
                AutoRoute(
                  page: SearchTabRoute.page,
                  children: [
                    AutoRoute(
                      page: SearchRoute.page,
                    ),
                    AutoRoute(
                      page: ReelViewerRoute.page,
                    ),
                  ],
                ),
                AutoRoute(
                  page: ChatTabRoute.page,
                  children: [
                    AutoRoute(
                      initial: true,
                      page: ConversationsRoute.page,
                    ),
                  ],
                ),
                AutoRoute(
                  page: ProfileTabRoute.page,
                  children: [
                    AutoRoute(
                      page: ProfileRoute.page,
                      initial: true,
                    ),
                    AutoRoute(
                      page: MyFavoriteRoute.page,
                    ),
                    AutoRoute(
                      page: BookingsHistoryRoute.page,
                    ),
                    AutoRoute(
                      page: BookingStatusRoute.page,
                    ),
                    AutoRoute(
                      page: IssueRoutes.page,
                      children: [
                        AutoRoute(
                          page: IssueRoute.page,
                        ),
                        AutoRoute(
                          page: IssueStatusRoute.page,
                        ),
                      ],
                    ),
                    AutoRoute(
                      page: PaymentRoutes.page,
                      children: [
                        AutoRoute(
                          page: TransactionRoute.page,
                        ),
                        AutoRoute(
                          page: PaymentMethodRoute.page,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            AutoRoute(
              page: ChatRoute.page,
            ),
            AutoRoute(
              page: UserLocationRoute.page,
            ),
            AutoRoute(
              page: ViewLocationRoute.page,
            ),
            AutoRoute(
              page: DazzifyPhotoViewerRoute.page,
            ),
            AutoRoute(
              page: BrandProfileRoute.page,
            ),
            AutoRoute(
              page: BrandPostsRoute.page,
            ),
            AutoRoute(
              page: SearchPostRoute.page,
            ),
            AutoRoute(
              page: BrandReelsRoute.page,
            ),
            AutoRoute(
              page: ServiceDetailsRoute.page,
            ),
            AutoRoute(
              page: SeeAllReviewsRoute.page,
            ),
            AutoRoute(
              page: ServiceBookingConfirmationRoute.page,
            ),
            AutoRoute(
              page: BrandServiceBookingRoute.page,
            ),
            AutoRoute(
              page: ServiceAvailabilityRoute.page,
            ),
            AutoRoute(
              page: MultipleServiceAvailabilityRoute.page,
            ),
            AutoRoute(
              page: ServiceInvoiceRoute.page,
            ),
            AutoRoute(
              page: PaymentWebViewRoute.page,
            ),
            AutoRoute(
              page: WebViewRoute.page,
            ),
          ],
        )
      ];
}

@RoutePage(name: "UnAuthenticatedRoute")
class UnAuthenticated extends AutoRouter implements AutoRouteWrapper {
  const UnAuthenticated({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: this,
    );
  }
}

@RoutePage(name: "AuthenticatedRoute")
class Authenticated extends AutoRouter implements AutoRouteWrapper {
  const Authenticated({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<TransactionBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<PaymentMethodsCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<SocketCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<FavoriteCubit>()
            ..getFavoriteIds()
            ..getFavoriteModels(),
        ),
        BlocProvider(
          create: (context) => getIt<UserCubit>()..getUser(),
        ),
        BlocProvider(
          create: (context) => getIt<BookingCubit>()..getLastActiveBookings(),
        ),
        BlocProvider(
          create: (context) => getIt<LikesCubit>()..getLikesIds(),
        ),
        BlocProvider<ConversationsCubit>(
          create: (context) => getIt<ConversationsCubit>()..getConversations(),
        ),
        BlocProvider<BookingReviewCubit>(
          create: (context) => getIt<BookingReviewCubit>(),
          lazy: false,
        )
      ],
      child: BlocListener<BookingReviewCubit, BookingReviewState>(
        listener: (context, state) {
          if (state.bookingReviewRequestState == UiState.success) {
            // Check if the review sheet is not already open to prevent duplicates
            final currentRoute = ModalRoute.of(context)?.settings.name;
            if (currentRoute != "ServiceSelectionBottomSheet") {
              showBookingReviewSheet(
                userModel: context.read<UserCubit>().state.userModel,
                context: context,
                bookingReviewCubit: context.read<BookingReviewCubit>(),
              );
            }
          }
          if (state.addReviewState == UiState.success) {
            context.maybePop();
            DazzifyToastBar.showSuccess(
              message: context.tr.reviewCreatedSuccessfully,
            );
          } else if (state.addReviewState == UiState.failure) {
            DazzifyToastBar.showError(
              message: state.addReviewError,
            );
          }
        },
        child: this,
      ),
    );
  }
}

@RoutePage(name: "HomeTabRoute")
class Home extends AutoRouter implements AutoRouteWrapper {
  const Home({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()
        ..getBanners()
        ..getMainCategories()
        ..getPopularBrands()
        ..getTopRatedBrands()
        ..getPopularServices()
        ..getTopRatedServices(),
      child: this,
    );
  }
}

@RoutePage(name: "SearchTabRoute")
class SearchTab extends AutoRouter implements AutoRouteWrapper {
  const SearchTab({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SearchBloc>()..add(GetMediaItemsEvent()),
      child: this,
    );
  }
}

@RoutePage(name: "ReelsTabRoute")
class ReelsTab extends AutoRouter implements AutoRouteWrapper {
  const ReelsTab({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ReelsBloc>()
        ..add(
          const GetReelsEvent(),
        ),
      child: this,
    );
  }
}

@RoutePage(name: "VendorRoutes")
class VendorRoute extends AutoRouter implements AutoRouteWrapper {
  const VendorRoute({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BrandBloc>(),
      child: this,
    );
  }
}

@RoutePage(name: "ChatTabRoute")
class ChatTab extends AutoRouter {
  const ChatTab({super.key});
}

@RoutePage(name: "ProfileTabRoute")
class ProfileTab extends AutoRouter {
  const ProfileTab({super.key});
}

@RoutePage(name: "BrandRoute")
class Brand extends AutoRouter implements AutoRouteWrapper {
  const Brand({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BrandBloc>(),
      child: this,
    );
  }
}

@RoutePage(name: "IssueRoutes")
class Issue extends AutoRouter implements AutoRouteWrapper {
  const Issue({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<IssueBloc>()..add(const GetIssueEvent()),
      child: this,
    );
  }
}

@RoutePage(name: "PaymentRoutes")
class Payment extends AutoRouter {
  const Payment({super.key});
}
