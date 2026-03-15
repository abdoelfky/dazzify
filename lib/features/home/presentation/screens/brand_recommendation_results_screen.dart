import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/brand/presentation/bottom_sheets/branch_selection_bottom_sheet.dart';
import 'package:dazzify/features/home/data/models/brand_recommendation_model.dart';
import 'package:dazzify/features/shared/logic/favorite/favorite_cubit.dart';
import 'package:dazzify/features/shared/widgets/brand_card.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:solar_icons/solar_icons.dart';

@RoutePage()
class BrandRecommendationResultsScreen extends StatelessWidget {
  const BrandRecommendationResultsScreen({
    super.key,
    required this.recommendation,
  });

  final BrandRecommendationModel recommendation;

  @override
  Widget build(BuildContext context) {
    final AppEventsLogger _logger = getIt<AppEventsLogger>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            DazzifyAppBar(
              title: context.tr.recommendations,
              isLeading: true,
              onBackTap: () {
                _logger.logEvent(event: AppEvents.brandRecommendationBack);
                context.maybePop();
              },
            ),
            Expanded(
              child: RecommendationResultsBody(recommendation: recommendation),
            ),
          ],
        ),
      ),
    );
  }

  static String formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }

  static String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}

/// Shared body for results screen and details-by-id screen.
class RecommendationResultsBody extends StatelessWidget {
  const RecommendationResultsBody({super.key, required this.recommendation});

  final BrandRecommendationModel recommendation;

  @override
  Widget build(BuildContext context) {
    final AppEventsLogger _logger = getIt<AppEventsLogger>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Card
          Container(
                      padding: const EdgeInsets.all(20).r,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            context.colorScheme.primaryContainer,
                            context.colorScheme.secondaryContainer,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20).r,
                        boxShadow: [
                          BoxShadow(
                            color: context.colorScheme.primary.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                SolarIconsBold.chart,
                                color: context.colorScheme.primary,
                                size: 24.r,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                context.tr.recommendations,
                                style: context.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      context.tr.totalBudget,
                                      style: context.textTheme.bodyMedium?.copyWith(
                                        color: context.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '${BrandRecommendationResultsScreen.formatNumber(recommendation.totalBudget)} ${context.tr.egp}',
                                        style: context.textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: context.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40.h,
                                margin: const EdgeInsets.symmetric(horizontal: 12).r,
                                color: context.colorScheme.outline.withValues(alpha: 0.3),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      context.tr.eventDate,
                                      style: context.textTheme.bodyMedium?.copyWith(
                                        color: context.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        BrandRecommendationResultsScreen.formatDate(recommendation.date),
                                        style: context.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Categories with Brands
                    ...recommendation.categories.map((categoryRec) {
                      return _CategorySection(
                        categoryRecommendation: categoryRec,
                        onBrandTap: (brand) {
                          _logger.logEvent(
                            event: AppEvents.brandRecommendationClickBrand,
                            brandId: brand.id,
                          );
                          // Show branches first, then navigate to services (not brand profile)
                          showBranchSelectionBottomSheet(
                            context: context,
                            favoriteCubit: getIt<FavoriteCubit>(),
                            brandId: brand.id,
                            isMultipleBooking: false,
                          );
                        },
                      );
                    }).toList(),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final CategoryRecommendation categoryRecommendation;
  final ValueChanged<RecommendedBrand> onBrandTap;

  const _CategorySection({
    required this.categoryRecommendation,
    required this.onBrandTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
          Container(
            padding: const EdgeInsets.all(20).r,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colorScheme.primaryContainer.withValues(alpha: 0.5),
                  context.colorScheme.secondaryContainer.withValues(alpha: 0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16).r,
                topRight: const Radius.circular(16).r,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      SolarIconsBold.list,
                      color: context.colorScheme.primary,
                      size: 20.r,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        categoryRecommendation.category.name,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ).r,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8).r,
                      ),
                      child: Text(
                        '${context.tr.percentage}: ${categoryRecommendation.weight}%',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ).r,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8).r,
                      ),
                      child: Text(
                        '${context.tr.allocatedBudget}: ${_formatNumber(categoryRecommendation.allocatedBudget)} ${context.tr.egp}',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     Text(
                    //       context.tr.allocatedBudget,
                    //       style: context.textTheme.bodySmall?.copyWith(
                    //         color: context.colorScheme.onSurfaceVariant,
                    //       ),
                    //       textAlign: TextAlign.end,
                    //     ),
                    //     SizedBox(height: 4.h),
                    //     Container(
                    //       padding: const EdgeInsets.symmetric(
                    //         horizontal: 10,
                    //         vertical: 8,
                    //       ).r,
                    //       decoration: BoxDecoration(
                    //         color: context.colorScheme.primary,
                    //         borderRadius: BorderRadius.circular(10).r,
                    //       ),
                    //       child: FittedBox(
                    //         fit: BoxFit.scaleDown,
                    //         child: Text(
                    //           '${_formatNumber(categoryRecommendation.allocatedBudget)} ${context.tr.egp}',
                    //           style: context.textTheme.titleSmall?.copyWith(
                    //             fontWeight: FontWeight.bold,
                    //             color: Colors.white,
                    //           ),
                    //           textAlign: TextAlign.end,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),

          // Brands List
          if (categoryRecommendation.brands.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16).r,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      SolarIconsOutline.wallet,
                      size: 40.r,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    context.tr.noBrandsFound,
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24).r,
                    child: Text(
                      context.tr.noBrandsFoundHint,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16).r,
              itemCount: categoryRecommendation.brands.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final brand = categoryRecommendation.brands[index];
                return BrandCard(
                  brand: brand.toBrandModel(),
                  onTap: () => onBrandTap(brand),
                  hasAvailability: brand.hasAvailability,
                  availabilityLabel: brand.hasAvailability
                      ? context.tr.brandAvailableAtSelectedTime
                      : null,
                );
              },
            ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }
}

