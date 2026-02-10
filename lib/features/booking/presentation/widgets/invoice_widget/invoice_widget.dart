import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/app_config_manager.dart';
import 'package:dazzify/features/booking/logic/service_invoice_cubit/service_invoice_cubit.dart';
import 'package:dazzify/features/booking/presentation/widgets/invoice_widget/dotted_line.dart';
import 'package:dazzify/features/booking/presentation/widgets/invoice_widget/invoice_line.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_text_form_field.dart';

class InvoiceWidget extends StatelessWidget {
  final TextEditingController textContorller;
  final List<ServiceDetailsModel> services;
  final ServiceDetailsModel service;
  final bool hasFees = (AppConfigManager.appFeesMax != 0 &&
      AppConfigManager.appFeesMin != 0 &&
      AppConfigManager.appFeesPercentage != 0);

  InvoiceWidget({
    super.key,
    required this.textContorller,
    required this.services,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceInvoiceCubit, ServiceInvoiceState>(
      builder: (context, state) {
        num totalPrice = services.isEmpty
            ? service.price * service.quantity
            : services.fold<num>(
                0,
                (sum, s) => sum + (s.price * s.quantity),
              );

        final totalCount = services.isEmpty
            ? service.quantity
            : services.fold<int>(0, (sum, s) => sum + s.quantity);
        final deliveryFees = state.deliveryInfo.selectedDeliveryFees;
        final isRangeType = state.deliveryInfo.isRangeType;

        final appFees = hasFees
            ? state.invoice.totalPrice -
                totalPrice -
                deliveryFees +
                state.invoice.discountAmount
            : 0.0;

        return Column(
          children: [
            DazzifyTextFormField(
              controller: textContorller,
              fillColor:
                  context.colorScheme.inversePrimary.withValues(alpha: 0.1),
              textStyle: context.textTheme.bodyMedium,
              textInputType: TextInputType.text,
              borderSide: getBorderSide(
                context: context,
                couponValidationState: state.couponValidationState,
              ),
              prefixIconData: SolarIconsOutline.ticketSale,
              validator: (value) => null,
              readOnly: state.couponValidationState == UiState.success,
              onChanged: (value) {
                // Reset coupon validation state if user changes or deletes text
                // Only allow changes if coupon is not successfully applied
                if (state.couponValidationState == UiState.failure) {
                  // Reset state to allow new validation or clear
                  context.read<ServiceInvoiceCubit>().clearCoupon();
                }
              },
              suffixIcon: getSuffixIcon(
                context: context,
                price: totalPrice,
                couponValidationState: state.couponValidationState,
                service: services.isEmpty ? service : services.first,
                services: services,
                textContorller: textContorller,
              ),
            ),
            // Display message from backend (success or error)
            if (state.couponValidationState == UiState.success ||
                (state.couponValidationState == UiState.failure &&
                    state.errorMessage.isNotEmpty))
              Padding(
                padding: EdgeInsets.only(top: 8.h, left: 4.w),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: DText(
                    state.couponValidationState == UiState.failure
                        ? (state.errorMessage.isNotEmpty
                            ? state.errorMessage
                            : context.tr.couponNotValidated)
                        : (state.couponModel.message.isNotEmpty
                            ? state.couponModel.message
                            : context.tr.couponValidated),
                    style: context.textTheme.bodySmall!.copyWith(
                      color: state.couponValidationState == UiState.success
                          ? Colors.green
                          : state.couponValidationState == UiState.failure
                              ? Colors.red
                              : context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 24.h),
            InvoiceLine(
              title:
                  '${context.tr.servicePrice} ($totalCount ${context.tr.services})',
              amount: totalPrice,
            ),
            InvoiceLine(
              title: context.tr.couponDisc,
              amount: state.invoice.discountAmount,
              isWithBraces: true,
            ),
            if (!isRangeType) ...[
              InvoiceLine(
                title: context.tr.deliferyFees,
                amount: deliveryFees,
              ),
            ],
            if (isRangeType) ...[
              _buildRangeTransportationLine(context, state),
            ],
            if (isRangeType) SizedBox(height: 12.h),
            if (hasFees && !isRangeType)
              InvoiceLine(
                title: context.tr.appFees,
                amount: double.parse(appFees.toStringAsFixed(2)),
              ),
            if (hasFees && isRangeType) _buildPendingAppFeesLine(context),
            SizedBox(height: 12.h),
            DottedLine(
              lineWidth: context.screenWidth,
              lineColor: context.colorScheme.onSurface,
            ),
            SizedBox(height: 24.h),
            if (!isRangeType)
              InvoiceLine(
                title: context.tr.totalPrice,
                amount: state.invoice.totalPrice,
              ),
            if (isRangeType) _buildPendingTotalLine(context, state),
            if (isRangeType) ...[
              SizedBox(height: 8.h),
              _buildPendingNote(context),
            ],
            SizedBox(height: 8.h),
          ],
        );
      },
    );
  }

  Widget _buildRangeTransportationLine(
      BuildContext context, ServiceInvoiceState state) {
    final min = state.deliveryInfo.minDeliveryFees ?? 0;
    final max = state.deliveryInfo.maxDeliveryFees ?? 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DText(
          context.tr.deliferyFees,
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
        DText(
          "${context.tr.from} ${reformatPriceWithCommas(min)} ${context.tr.to} ${reformatPriceWithCommas(max)} (${context.tr.egp})",
          style: context.textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildPendingAppFeesLine(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DText(
          context.tr.appFees,
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
        DText(
          context.tr.willBeCalculated,
          style: context.textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildPendingTotalLine(
      BuildContext context, ServiceInvoiceState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DText(
            context.tr.totalPrice,
            style: context.textTheme.titleMedium,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DText(
                "${reformatPriceWithCommas(state.invoice.totalPrice)} ${context.tr.egp}",
                style: context.textTheme.titleMedium,
              ),
              SizedBox(height: 4.h),
              if (hasFees)
                DText(
                  context.tr.plusTransportationAndFees,
                  style: context.textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              if (!hasFees)
                DText(
                  context.tr.plusTransportation,
                  style: context.textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingNote(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12).r,
      decoration: BoxDecoration(
        color: context.colorScheme.inversePrimary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8).r,
      ),
      child: Row(
        children: [
          Icon(
            SolarIconsOutline.infoCircle,
            size: 16.r,
            color: context.colorScheme.primary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: DText(
              context.tr.finalPriceAfterProviderAccepts,
              style: context.textTheme.bodySmall!.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

BorderSide getBorderSide({
  required BuildContext context,
  required UiState couponValidationState,
}) {
  return couponValidationState == UiState.success
      ? const BorderSide(color: Colors.green)
      : couponValidationState == UiState.failure
          ? const BorderSide(color: Colors.red)
          : BorderSide(color: context.colorScheme.primary);
}

Widget? getSuffixIcon({
  required BuildContext context,
  required UiState couponValidationState,
  required TextEditingController textContorller,
  required ServiceDetailsModel service,
  required List<ServiceDetailsModel> services,
  required num price,
}) {
  if (couponValidationState == UiState.success) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextButton(
        onPressed: () {
          getIt<AppEventsLogger>()
              .logEvent(event: AppEvents.confirmationBookingRemoveCoupon);
          textContorller.clear();
          context.read<ServiceInvoiceCubit>().clearCoupon();
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: DText(
          context.tr.delete,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.error,
          ),
        ),
      ),
    );
  } else if (couponValidationState == UiState.failure) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextButton(
        onPressed: () {
          getIt<AppEventsLogger>()
              .logEvent(event: AppEvents.confirmationBookingRemoveCoupon);
          textContorller.clear();
          context.read<ServiceInvoiceCubit>().clearCoupon();
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: DText(
          context.tr.cancel,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colorScheme.error,
          ),
        ),
      ),
    );
  } else {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: TextButton(
        onPressed: () {
          if (textContorller.text.isNotEmpty) {
            getIt<AppEventsLogger>()
                .logEvent(event: AppEvents.confirmationBookingAddCoupon);
            FocusManager.instance.primaryFocus?.unfocus();
            context
                .read<ServiceInvoiceCubit>()
                .validateCouponAndUpdateInvoice(
                  service: service,
                  services: services,
                  price: price,
                  code: textContorller.text,
                );
          }
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: DText(
          context.tr.apply,
        ),
      ),
    );
  }
}
