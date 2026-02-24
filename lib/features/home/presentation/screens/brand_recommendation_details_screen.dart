import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/home/logic/recommendation_details/recommendation_details_cubit.dart';
import 'package:dazzify/features/home/presentation/screens/brand_recommendation_results_screen.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class BrandRecommendationDetailsScreen extends StatefulWidget
    implements AutoRouteWrapper {
  const BrandRecommendationDetailsScreen({
    super.key,
    required this.brId,
  });

  final String brId;

  @override
  State<BrandRecommendationDetailsScreen> createState() =>
      _BrandRecommendationDetailsScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RecommendationDetailsCubit>()..load(brId),
      child: this,
    );
  }
}

class _BrandRecommendationDetailsScreenState
    extends State<BrandRecommendationDetailsScreen> {
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  Widget build(BuildContext context) {
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
              child: BlocBuilder<RecommendationDetailsCubit,
                  RecommendationDetailsState>(
                builder: (context, state) {
                  if (state.state == UiState.loading) {
                    return const Center(child: LoadingAnimation());
                  }
                  if (state.state == UiState.failure) {
                    return ErrorDataWidget(
                      errorDataType: DazzifyErrorDataType.screen,
                      message: state.errorMessage,
                      onTap: () {
                        context
                            .read<RecommendationDetailsCubit>()
                            .load(widget.brId);
                      },
                    );
                  }
                  if (state.state == UiState.success &&
                      state.recommendation != null) {
                    return RecommendationResultsBody(
                      recommendation: state.recommendation!,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
