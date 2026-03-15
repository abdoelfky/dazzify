import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/home/data/models/brand_recommendation_history_model.dart';
import 'package:dazzify/features/home/logic/brand_recommendation_history/brand_recommendation_history_cubit.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:solar_icons/solar_icons.dart';

@RoutePage()
class BrandRecommendationHistoryScreen extends StatefulWidget
    implements AutoRouteWrapper {
  const BrandRecommendationHistoryScreen({super.key});

  @override
  State<BrandRecommendationHistoryScreen> createState() =>
      _BrandRecommendationHistoryScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<BrandRecommendationHistoryCubit>()
        ..getHistory(refresh: true),
      child: this,
    );
  }
}

class _BrandRecommendationHistoryScreenState
    extends State<BrandRecommendationHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<BrandRecommendationHistoryCubit>().getHistory();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            DazzifyAppBar(
              title: context.tr.recommendationsHistory,
              isLeading: true,
              onBackTap: () {
                _logger.logEvent(
                    event: AppEvents.brandRecommendationHistoryBack);
                context.maybePop();
              },
            ),
            Expanded(
              child: BlocBuilder<BrandRecommendationHistoryCubit,
                  BrandRecommendationHistoryState>(
                builder: (context, state) {
                  if (state.historyState == UiState.loading &&
                      state.history.isEmpty) {
                    return const LoadingAnimation();
                  }

                  if (state.historyState == UiState.failure) {
                    return ErrorDataWidget(
                      errorDataType: DazzifyErrorDataType.screen,
                      message: state.errorMessage,
                      onTap: () {
                        context
                            .read<BrandRecommendationHistoryCubit>()
                            .getHistory(refresh: true);
                      },
                    );
                  }

                  if (state.history.isEmpty) {
                    return EmptyDataWidget(
                      message: context.tr.noRecommendationsYet,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<BrandRecommendationHistoryCubit>()
                          .getHistory(refresh: true);
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16).r,
                      itemCount: state.history.length + 1,
                      separatorBuilder: (context, index) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        if (index >= state.history.length) {
                          if (state.historyState == UiState.loading) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: LoadingAnimation(),
                            );
                          }
                          return const SizedBox.shrink();
                        }

                        final historyItem = state.history[index];
                        return _HistoryCard(
                          historyItem: historyItem,
                          isLoading: false,
                          onTap: () {
                            _logger.logEvent(
                              event: AppEvents.brandRecommendationHistoryClickItem,
                            );
                            context.pushRoute(
                              BrandRecommendationDetailsRoute(brId: historyItem.id),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final BrandRecommendationHistoryModel historyItem;
  final VoidCallback? onTap;
  final bool isLoading;

  const _HistoryCard({
    required this.historyItem,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = context.isRtl;
    return Card(
      elevation: 2,
      color: context.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16).r,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16).r,
        child: Padding(
          padding: const EdgeInsets.all(16).r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10).r,
                    decoration: BoxDecoration(
                      color: context.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12).r,
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 24.r,
                            height: 24.r,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.colorScheme.primary,
                            ),
                          )
                        : Icon(
                            SolarIconsBold.chart,
                            color: context.colorScheme.primary,
                            size: 24.r,
                          ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(historyItem.date),
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                  Icon(
                    isRtl ? SolarIconsOutline.arrowLeft : SolarIconsOutline.arrowRight,
                    color: context.colorScheme.primary,
                    size: 20.r,
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _InfoChip(
                      icon: SolarIconsOutline.wallet,
                      label: context.tr.totalBudget,
                      value: '${_formatNumber(historyItem.totalBudget)} ${context.tr.egp}',
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _InfoChip(
                      icon: SolarIconsOutline.list,
                      label: context.tr.categories,
                      value: '${historyItem.categoriesCount}',
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _InfoChip(
                      icon: SolarIconsOutline.star,
                      label: context.tr.brands,
                      value: '${historyItem.totalBrandsRecommended}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  String _formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6).r,
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8).r,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14.r,
                color: context.colorScheme.primary,
              ),
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  label,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

