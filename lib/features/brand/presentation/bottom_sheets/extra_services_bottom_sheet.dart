import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/brand/logic/extra_services/extra_services_cubit.dart';
import 'package:dazzify/features/brand/logic/service_selection/service_selection_cubit.dart';
import 'package:dazzify/features/brand/presentation/widgets/service_widget.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExtraServicesBottomSheet extends StatelessWidget {
  final String brandId;
  final ServiceSelectionCubit serviceSelectionCubit;
  final BrandBranchesModel branch;
  final bool isMultipleBooking;
  final AppEventsLogger logger;

  const ExtraServicesBottomSheet({
    super.key,
    required this.brandId,
    required this.serviceSelectionCubit,
    required this.branch,
    required this.isMultipleBooking,
    required this.logger,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ExtraServicesCubit>()
        ..getBrandExtraServices(brandId: brandId),
        child: BlocProvider.value(
        value: serviceSelectionCubit,
        child: DazzifySheetBody(
          title: context.tr.extras,
          children: [
            Expanded(
              child: BlocBuilder<ExtraServicesCubit, ExtraServicesState>(
                builder: (context, extraState) {
                  switch (extraState.extraServicesState) {
                    case UiState.initial:
                    case UiState.loading:
                      return DazzifyLoadingShimmer(
                        dazzifyLoadingType: DazzifyLoadingType.listView,
                        borderRadius: BorderRadius.circular(8),
                        cardWidth: context.screenWidth,
                        cardHeight: 140.h,
                      );
                    case UiState.failure:
                      return ErrorDataWidget(
                        errorDataType: DazzifyErrorDataType.sheet,
                        message: extraState.errorMessage,
                        onTap: () {
                          context
                              .read<ExtraServicesCubit>()
                              .getBrandExtraServices(brandId: brandId);
                        },
                      );
                  case UiState.success:
                    if (extraState.extraServices.isEmpty) {
                      return EmptyDataWidget(
                        message: context.tr.noExtraServices,
                      );
                      } else {
                        return BlocBuilder<ServiceSelectionCubit,
                            ServiceSelectionState>(
                          builder: (context, selectionState) {
                            return ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ).r,
                              itemCount: extraState.extraServices.length,
                              itemBuilder: (context, index) {
                                // نحدد الخدمات الإضافية بـ type = 'extra' حتى نقدر نمنع حجزها لوحدها لاحقاً
                                final service = extraState.extraServices[index]
                                    .copyWith(type: 'extra');

                                return ServiceWidget(
                                  isMultipleService: isMultipleBooking,
                                  isAllowMultipleServicesCount:
                                      service.allowMultipleServicesCount,
                                  // لا نسمح بحجز خدمة إضافية بمفردها
                                  onSingleBookingTap: () {
                                    DazzifyToastBar.showError(
                                      message: context.tr.cantBookExtraAlone,
                                    );
                                  },
                                  quantity: service.quantity,
                                  onQuantityChanged: (newQuantity) {
                                    serviceSelectionCubit
                                        .updateServiceQuantity(
                                      serviceId: service.id,
                                      quantity: newQuantity,
                                    );
                                  },
                                  onCardTap: () {
                                    logger.logEvent(
                                      event: AppEvents.servicesClickService,
                                      serviceId: service.id,
                                    );
                                    context.pushRoute(
                                      ServiceDetailsRoute(
                                        service: service,
                                        branch: branch,
                                        isBooking: true,
                                      ),
                                    );
                                  },
                                  onBookingSelectTap: () {
                                    logger.logEvent(
                                      event: AppEvents.servicesClickBook,
                                      serviceId: service.id,
                                    );
                                    serviceSelectionCubit.selectBookingService(
                                      service: service,
                                    );
                                  },
                                  isBooked: selectionState
                                      .selectedBrandServicesIds
                                      .contains(service.id),
                                  imageUrl: service.image,
                                  title: service.title,
                                  description: service.description,
                                  price: service.price,
                                  serviceStatus: ServiceStatus.booking,
                                  // لا نريد زر Extras داخل قائمة الـ Extras نفسها
                                  brandId: null,
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 16.h),
                            );
                          },
                        );
                      }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showExtraServicesBottomSheet({
  required BuildContext context,
  required String brandId,
  required ServiceSelectionCubit serviceSelectionCubit,
  required BrandBranchesModel branch,
  required bool isMultipleBooking,
}) {
  final logger = getIt<AppEventsLogger>();
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    routeSettings: const RouteSettings(
      name: "ExtraServicesBottomSheet",
    ),
    builder: (context) => ExtraServicesBottomSheet(
      brandId: brandId,
      serviceSelectionCubit: serviceSelectionCubit,
      branch: branch,
      isMultipleBooking: isMultipleBooking,
      logger: logger,
    ),
  );
}

