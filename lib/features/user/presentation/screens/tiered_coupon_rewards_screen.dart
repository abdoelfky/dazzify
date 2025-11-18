import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_overlay_loading.dart';
import 'package:dazzify/features/user/logic/tiered_coupon/tiered_coupon_cubit.dart';
import 'package:dazzify/features/user/logic/tiered_coupon/tiered_coupon_state.dart';
import 'package:dazzify/features/user/presentation/screens/tiered_coupon_details_screen.dart';
import 'package:dazzify/features/user/presentation/widgets/tiered_coupon_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class TieredCouponRewardsScreen extends StatefulWidget {
  const TieredCouponRewardsScreen({super.key});

  @override
  State<TieredCouponRewardsScreen> createState() =>
      _TieredCouponRewardsScreenState();
}

class _TieredCouponRewardsScreenState extends State<TieredCouponRewardsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch coupons when screen is loaded
    context.read<TieredCouponCubit>().getTieredCouponRewards();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/couponsBackground.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: DazzifyAppBar(
                  isLeading: true,
                  title: context.tr.coupons,
                ),
              ),
              Expanded(
                child: BlocBuilder<TieredCouponCubit, TieredCouponState>(
                builder: (context, state) {
                  if (state.uiState == UiState.loading) {
                    return const DazzifyOverlayLoading(
                      isLoading: true,
                      child: SizedBox.expand(),
                    );
                  }

                  if (state.uiState == UiState.failure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64.r,
                            color: Colors.red,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            state.errorMessage,
                            style: context.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<TieredCouponCubit>()
                                  .getTieredCouponRewards();
                            },
                            child: Text(context.tr.retry),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state.coupons.isEmpty) {
                    return Center(
                      child: Text(
                        context.tr.noCouponsAvailable,
                        style: context.textTheme.bodyLarge,
                      ),
                    );
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Header text
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: constraints.maxWidth * 0.9,
                              ),
                              child: Text(
                                context.tr.startWithFirstCoupon,
                                style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF7B3FF2),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 20.h),
                            
                            // Coupons list
                            ...List.generate(state.coupons.length, (index) {
                              final coupon = state.coupons[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 16.h),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 600.w,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (!coupon.locked) {
                                        // Capture the cubit before entering the builder
                                        final cubit = context.read<TieredCouponCubit>();
                                        // Navigate to details screen
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => BlocProvider.value(
                                              value: cubit,
                                              child: TieredCouponDetailsScreen(
                                                coupon: coupon,
                                                couponIndex: index,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: TieredCouponCard(
                                      coupon: coupon,
                                      onScratchComplete: () {
                                        context
                                            .read<TieredCouponCubit>()
                                            .openNewRewardLevel(index);
                                      },
                                      couponIndex: index,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
