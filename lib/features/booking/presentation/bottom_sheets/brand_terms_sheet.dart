import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/framework/dazzify_text.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/colors_manager.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/booking/logic/brand_terms_cubit/brand_terms_cubit.dart';
import 'package:dazzify/features/brand/data/models/location_model.dart';
import 'package:dazzify/features/brand/data/repositories/brand_repository.dart';
import 'package:dazzify/features/brand/logic/service_selection/service_selection_cubit.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandTermsSheet extends StatefulWidget {
  final ServiceDetailsModel service;
  final List<ServiceDetailsModel> services;
  final String branchId;
  final String branchName;
  final String selectedDate;
  final String selectedToTime;
  final String selectedFromTime;
  final String selectedStartTimeStamp;
  final LocationModel? branchLocation;
  final ServiceSelectionCubit? serviceSelectionCubit;

  const BrandTermsSheet({
    required this.service,
    this.serviceSelectionCubit,
    required this.services,
    required this.branchId,
    required this.branchName,
    required this.selectedDate,
    required this.selectedFromTime,
    required this.selectedToTime,
    required this.selectedStartTimeStamp,
    this.branchLocation,
    super.key,
  });

  @override
  State<BrandTermsSheet> createState() => _BrandTermsSheetState();
}

class _BrandTermsSheetState extends State<BrandTermsSheet> {
  late final ScrollController _scrollController;
  late final ValueNotifier<bool> _hasReachedTheEnd;
  late final BrandTermsCubit _brandTermsCubit = getIt<BrandTermsCubit>();
  late final ServiceSelectionCubit _serviceSelectionCubit =
      getIt<ServiceSelectionCubit>();

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      _hasReachedTheEnd.value = true;
    }
  }

  void _checkIfScrollable() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent == 0) {
        _hasReachedTheEnd.value = true;
      }
    });
  }

  @override
  void initState() {
    // _serviceSelectionCubit = context.read<ServiceSelectionCubit>();

    _brandTermsCubit.getBrandTerms(brandId: widget.service.brand.id);
    _scrollController = ScrollController()..addListener(_scrollListener);
    _hasReachedTheEnd = ValueNotifier(false);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _brandTermsCubit,
      child: DazzifySheetBody(
        title: context.tr.brandTermsSheetTitle,
        titleBottomPadding: 8.h,
        textStyle: context.textTheme.bodyLarge,
        height: AppConstants.bottomSheetHeight,
        handlerHeight: 4.h,
        handlerWidth: 120.w,
        children: [
          SizedBox(
            height: 8.h,
          ),
          Divider(
            color: ColorsManager.bottomSheetDivider,
            height: 1.h,
            indent: 16.w,
            endIndent: 16.w,
          ),
          Expanded(
            child: BlocBuilder<BrandTermsCubit, BrandTermsState>(
              builder: (context, state) {
                switch (state.termsState) {
                  case UiState.initial:
                  case UiState.loading:
                    return const LoadingAnimation();
                  case UiState.failure:
                    return ErrorDataWidget(
                      onTap: () {
                        _brandTermsCubit.getBrandTerms(
                          brandId: widget.service.brand.id,
                        );
                      },
                      errorDataType: DazzifyErrorDataType.sheet,
                      message: state.errorMessage,
                    );
                  case UiState.success:
                    if (state.brandTerms.isEmpty) {
                      return Center(
                        child: EmptyDataWidget(
                          message: context.tr.noBrandTerms,
                        ),
                      );
                    } else {
                      _checkIfScrollable();
                      return Column(
                        children: [
                          Expanded(
                            child: Scrollbar(
                              child: ListView.builder(
                                controller: _scrollController,
                                itemCount: state.brandTerms.length,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ).r,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 24.0,
                                      left: 16.0,
                                      right: 16.0,
                                    ).r,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4.0,
                                            // left: 16.0,
                                            // right: 16.0,
                                          ).r,
                                          child: Container(
                                            width: 8.r,
                                            height: 8.r,
                                            decoration: BoxDecoration(
                                              color:
                                                  context.colorScheme.onSurface,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 3.w),
                                        Flexible(
                                          child: DText(
                                            state.brandTerms[index],
                                            softWrap: true,
                                            maxLines: 8,
                                            style: context.textTheme.bodySmall!
                                                .copyWith(
                                              color: context
                                                  .colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40).r,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                            horizontal: 10)
                                        .r,
                                    child: PrimaryButton(
                                      textColor: context.colorScheme.primary,
                                      color: context.colorScheme.primary,
                                      isOutLined: true,
                                      width: 155.w,
                                      onTap: () {
                                        context.maybePop();
                                      },
                                      title: context.tr.cancel,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                            horizontal: 10)
                                        .r,
                                    child: ValueListenableBuilder(
                                      valueListenable: _hasReachedTheEnd,
                                      builder: (context, value, child) =>
                                          PrimaryButton(
                                        isActive: value,
                                        title: context.tr.agree,
                                        width: 155.w,
                                        height: 42.h,
                                        onTap: () {
                                          context.maybePop();
                                          context.pushRoute(ServiceInvoiceRoute(
                                            service: widget.service,
                                            serviceSelectionCubit:
                                                widget.serviceSelectionCubit ??
                                                    _serviceSelectionCubit,
                                            services: widget.services,
                                            branchId: widget.branchId,
                                            branchName: widget.branchName,
                                            branchLocation:
                                                widget.branchLocation,
                                            selectedDate: widget.selectedDate,
                                            selectedStartTimeStamp:
                                                widget.selectedStartTimeStamp,
                                            selectedFromTime:
                                                widget.selectedFromTime,
                                            selectedToTime:
                                                widget.selectedToTime,
                                          ));
                                          context.maybePop();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
