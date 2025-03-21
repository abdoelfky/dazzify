import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/booking/data/models/brand_delivery_fees_model.dart';
import 'package:dazzify/features/booking/data/models/delivery_info_model.dart';
import 'package:dazzify/features/booking/logic/service_invoice_cubit/service_invoice_cubit.dart';
import 'package:dazzify/features/booking/presentation/widgets/governorate_bottom_sheet/governorate_item.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GovernoratesBottomSheet extends StatefulWidget {
  final num price;
  final String brandId;

  const GovernoratesBottomSheet({
    required this.price,
    required this.brandId,
    super.key,
  });

  @override
  State<GovernoratesBottomSheet> createState() =>
      _GovernorateBottomSheetState();
}

class _GovernorateBottomSheetState extends State<GovernoratesBottomSheet> {
  late final ServiceInvoiceCubit _invoiceCubit;

  @override
  void initState() {
    _invoiceCubit = context.read<ServiceInvoiceCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DazzifySheetBody(
      title: context.tr.selectGovernorate,
      textStyle: context.textTheme.titleMedium,
      height: AppConstants.bottomSheetHeight,
      handlerWidth: 120.w,
      children: [
        Expanded(
          child: BlocBuilder<ServiceInvoiceCubit, ServiceInvoiceState>(
            builder: (context, state) {
              switch (state.deliveryFeesState) {
                case UiState.initial:
                case UiState.loading:
                  return DazzifyLoadingShimmer(
                    dazzifyLoadingType: DazzifyLoadingType.listView,
                    listViewItemCount: 6,
                    widgetPadding: const EdgeInsets.symmetric(horizontal: 16).r,
                    cardWidth: context.screenWidth,
                    cardHeight: 38.h,
                    borderRadius: BorderRadius.circular(12).r,
                  );
                case UiState.failure:
                  return ErrorDataWidget(
                    onTap: () {
                      _invoiceCubit.getBrandDeliveryFeesList(
                        brandId: widget.brandId,
                      );
                    },
                    errorDataType: DazzifyErrorDataType.sheet,
                    message: state.errorMessage,
                  );
                case UiState.success:
                  return ListView.separated(
                    itemCount: state.deliveryFeesList.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16).r,
                    itemBuilder: (context, index) {
                      return GovernorateItem(
                          index: index,
                          governorateIndex: state.deliveryFeesList[index].gov,
                          onPressed: () {
                            _onPressed(state.deliveryFeesList[index], context);
                          });
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 16.h,
                      );
                    },
                  );
              }
            },
          ),
        )
      ],
    );
  }

  void _onPressed(BrandDeliveryFeesModel deliveryModel, BuildContext context) {
    _invoiceCubit.updateDeliveryInfo(
        deliveryInfo: DeliveryInfoModel(
      selectedDeliveryFees: deliveryModel.deliveryFees,
      selectedGov: deliveryModel.gov,
    ));

    _invoiceCubit.updateInvoice(deliveryFees: deliveryModel.deliveryFees);

    context.maybePop();

    context.pushRoute(
      ViewLocationRoute(
        invoiceCubit: _invoiceCubit,
        isDisplayOnly: false,
      ),
    );
  }
}
