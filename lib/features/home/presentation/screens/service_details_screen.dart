import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/api/api_status_codes.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/dazzify_drop_down.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/functions.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource_impl.dart';
import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/home/logic/service_details/service_details_bloc.dart';
import 'package:dazzify/features/home/presentation/components/details_header_component.dart';
import 'package:dazzify/features/home/presentation/components/more_like_component.dart';
import 'package:dazzify/features/home/presentation/components/rating_and_reviews_component.dart';
import 'package:dazzify/features/home/presentation/widgets/includes_widget.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/bottom_sheets/report_bottom_sheet.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:dazzify/features/shared/logic/favorite/favorite_cubit.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/features/shared/widgets/glass_icon_button.dart';
import 'package:dazzify/features/shared/widgets/guest_mode_bottom_sheet.dart';
import 'package:dazzify/features/shared/widgets/widget_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';

@RoutePage()
class ServiceDetailsScreen extends StatefulWidget implements AutoRouteWrapper {
  final ServiceDetailsModel? service;
  final String? serviceId;
  final BrandBranchesModel? branch;
  final bool isBooking;

  const ServiceDetailsScreen({
    this.service,
    this.branch,
    super.key,
    this.serviceId,
    this.isBooking = false,
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<ServiceDetailsBloc>(
      create: (context) => getIt<ServiceDetailsBloc>()
        ..add(
          GetServiceReviewsEvent(
            serviceId: service != null ? service!.id : serviceId!,
          ),
        )
        ..add(
          GetMoreLikeThisEvent(
            serviceId: service != null ? service!.id : serviceId!,
          ),
        ),
      child: this,
    );
  }

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  late final ServiceDetailsBloc serviceDetailsBloc;
  late final FavoriteCubit favoriteCubit;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    serviceDetailsBloc = context.read<ServiceDetailsBloc>();
    favoriteCubit = context.read<FavoriteCubit>();
    if (widget.service != null) {
      serviceDetailsBloc.add(AddServiceEvent(service: widget.service!));
    } else {
      serviceDetailsBloc.add(GetServiceDetailsEvent(
        serviceId: widget.serviceId!,
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
        builder: (context, state) {
          if (state.blocState == UiState.loading) {
            return const Center(
              child: LoadingAnimation(),
            );
          } else if (state.blocState == UiState.failure ||
              state.serviceReviewState == UiState.failure ||
              state.moreLikeThisState == UiState.failure) {
            // Check if service is not found and we have brand info from "more like this"
            String? brandSlug;
            String errorMessage = state.errorMessage;
            // Check if service is not found by error code or error message
            final errorMessageLower = errorMessage.toLowerCase();
            final isServiceNotFound = state.errorCode == ApiStatusCodes.notFound ||
                errorMessageLower.contains('could not be found') ||
                errorMessageLower.contains('not found') ||
                errorMessageLower.contains('service could not be found') ||
                errorMessageLower.contains('requested service');
            
            if (isServiceNotFound &&
                state.moreLikeThisServices.isNotEmpty) {
              // Get brand slug from first "more like this" service
              brandSlug = state.moreLikeThisServices.first.brand.username;
              // Update error message to indicate service exists but not available
              errorMessage = context.tr.serviceExistsButNotAvailable;
            }

            return ErrorDataWidget(
              enableBackIcon: true,
              onTap: !isServiceNotFound &&
                      state.blocState == UiState.failure
                  ? () {
                      // Retry getting service details
                      if (widget.service != null) {
                        serviceDetailsBloc.add(AddServiceEvent(service: widget.service!));
                      } else {
                        serviceDetailsBloc.add(
                          GetServiceDetailsEvent(serviceId: widget.serviceId!),
                        );
                      }
                      serviceDetailsBloc.add(
                        GetServiceReviewsEvent(
                          serviceId: widget.service != null
                              ? widget.service!.id
                              : widget.serviceId!,
                        ),
                      );
                      serviceDetailsBloc.add(
                        GetMoreLikeThisEvent(
                          serviceId: widget.service != null
                              ? widget.service!.id
                              : widget.serviceId!,
                        ),
                      );
                    }
                  : null,
              secondaryAction: brandSlug != null
                  ? () {
                      context.pushRoute(
                        BrandProfileRoute(brandSlug: brandSlug!),
                      );
                    }
                  : null,
              secondaryActionTitle:
                  brandSlug != null ? context.tr.viewBrand : null,
              tertiaryAction: isServiceNotFound
                  ? () {
                      _logger.logEvent(
                          event: AppEvents.serviceDetailsClickBack);
                      context.navigateTo(const HomeRoute());
                    }
                  : null,
              tertiaryActionTitle: isServiceNotFound
                  ? context.tr.backHome
                  : null,
              errorDataType: DazzifyErrorDataType.screen,
              message: errorMessage,
            );
          } else {
            return Stack(
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DetailsHeaderComponent(
                      service: state.service,
                      branch: widget.branch,
                      isBooking: widget.isBooking,
                    ),
                    SizedBox(height: 8.h),
                    IncludesWidget(
                      include: state.service.includes,
                    ),
                    SizedBox(height: 8.h),
                    RatingAndReviewsComponent(service: state.service),
                    if (!widget.isBooking) const MoreLikeComponent(),
                  ],
                ),
                PositionedDirectional(
                  top: 50.r,
                  start: 15.r,
                  child: WidgetDirection(
                    child: GlassIconButton(
                      icon: SolarIconsOutline.arrowLeft,
                      onPressed: () {
                        _logger.logEvent(
                            event: AppEvents.serviceDetailsClickBack);
                        context.maybePop();
                      },
                    ),
                  ),
                ),
                PositionedDirectional(
                  top: 50.r,
                  end: 15.r,
                  child: DazzifyIconMenu(
                    options: [
                      MenuOption(
                        svgIcon: AssetsManager.shareIcon,
                        onTap: () {
                          _logger.logEvent(
                              event: AppEvents.serviceDetailsClickShare);
                          openUrlSheet(
                              url: AppConstants.shareService(
                                state.service.id,
                              ),
                              context: context);
                        },
                      ),
                      MenuOption(
                        icon: SolarIconsOutline.dangerCircle,
                        onTap: () {
                          _logger.logEvent(
                              event: AppEvents.serviceDetailsClickReport);
                          if (AuthLocalDatasourceImpl().checkGuestMode()) {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: false,
                              builder: (context) {
                                return GuestModeBottomSheet();
                              },
                            );
                          } else {
                            showReportBottomSheet(
                              context: context,
                              id: state.service.id,
                              type: "service",
                              eventType: 'service',
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
