import 'package:auto_route/auto_route.dart';
import 'package:dazzify/features/brand/logic/booking_from_media/booking_from_media_cubit.dart';
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart';
import 'package:dazzify/features/shared/enums/banners_action_enum.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannerHelper {
  static void onBannerTap({
    required HomeState homeState,
    required BookingFromMediaState bookingState,
    required int index,
    required BuildContext context,
    required BannersAction bannersAction,
  }) async {
    switch (bannersAction) {
      case BannersAction.initial:
        return;
      case BannersAction.url:
        return _openUrlAction(homeState, index, context);
      case BannersAction.mainCategory:
        return _navigateToRoute(
          context,
          CategoryRoute(
            categoryName: homeState.banners[index].mainCategory!.name,
            categoryId: homeState.banners[index].mainCategory!.id,
          ),
        );
      case BannersAction.brand:
        return _navigateToRoute(
          context,
          BrandProfileRoute(brand: homeState.banners[index].brand!),
        );
      case BannersAction.service:
        context.read<HomeCubit>().getSingleServiceDetails(
              serviceId: homeState.banners[index].service!.serviceId,
            );
      case BannersAction.transaction:
        return context.router.navigate(
          const ProfileTabRoute(
            children: [
              ProfileRoute(),
              PaymentRoutes(children: [TransactionRoute()])
            ],
          ),
        );
      case BannersAction.coupon:
        return _takeCouponCopy(context, homeState, index);
      case BannersAction.none:
        return;
    }
  }

  static void _openUrlAction(
      HomeState state, int index, BuildContext context) async {
    final url = state.banners[index].url!;
    context.pushRoute(WebViewRoute(url: url));
  }

  static void _navigateToRoute(
    BuildContext context,
    PageRouteInfo route,
  ) async {
    context.pushRoute(route);
  }

  static void _takeCouponCopy(
      BuildContext context, HomeState state, int index) {
    final coupon = ClipboardData(text: state.banners[index].coupon!);
    Clipboard.setData(coupon);
    DazzifyToastBar.showCoupon();
  }
}
