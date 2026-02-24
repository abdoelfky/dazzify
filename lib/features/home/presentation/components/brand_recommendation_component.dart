import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/widgets/section_widget.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';

class BrandRecommendationComponent extends StatelessWidget {
  const BrandRecommendationComponent({super.key});

  AppEventsLogger get _logger => getIt<AppEventsLogger>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionWidget(
          sectionTitle: context.tr.brandRecommendations,
          sectionType: SectionType.withTextButton,
          sectionButtonTitle: context.tr.recommendationsHistory,
          onTextButtonTap: () {
            _logger.logEvent(
              event: AppEvents.profileClickBrandRecommendationsHistory,
            );
            context.pushRoute(const BrandRecommendationHistoryRoute());
          },
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16).r,
          child: Material(
            color: context.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16).r,
            child: InkWell(
              onTap: () {
                _logger.logEvent(
                  event: AppEvents.profileClickBrandRecommendations,
                );
                context.pushRoute(const BrandRecommendationInputRoute());
              },
              borderRadius: BorderRadius.circular(16).r,
              child: Padding(
                padding: const EdgeInsets.all(16).r,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12).r,
                      decoration: BoxDecoration(
                        color: context.colorScheme.primaryContainer
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12).r,
                      ),
                      child: Icon(
                        SolarIconsOutline.star,
                        size: 28.r,
                        color: context.colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.tr.getBrandRecommendations,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            context.tr.selectCategories,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      context.isRtl
                          ? SolarIconsOutline.arrowLeft
                          : SolarIconsOutline.arrowRight,
                      size: 20.r,
                      color: context.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
