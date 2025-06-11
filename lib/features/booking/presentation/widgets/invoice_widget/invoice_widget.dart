import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/logic/service_invoice_cubit/service_invoice_cubit.dart';
import 'package:dazzify/features/booking/presentation/widgets/invoice_widget/dotted_line.dart';
import 'package:dazzify/features/booking/presentation/widgets/invoice_widget/invoice_line.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_text_form_field.dart';

class InvoiceWidget extends StatelessWidget {
  final TextEditingController textContorller;
  final List<ServiceDetailsModel> services;
  final ServiceDetailsModel service;

  const InvoiceWidget({
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
            ? service.price
            : services.map((s) => s.price).fold<num>(0, (sum, item) => sum + item);

        final deliveryFees = state.deliveryInfo.selectedDeliveryFees;
        final appFees = state.invoice.totalPrice - totalPrice - deliveryFees + state.couponModel.discountAmount;

        return Column(
          children: [
            DazzifyTextFormField(
              controller: textContorller,
              fillColor: context.colorScheme.inversePrimary.withValues(alpha: 0.1),
              textStyle: context.textTheme.bodyMedium,
              textInputType: TextInputType.text,
              borderSide: getBorderSide(
                context: context,
                couponValidationState: state.couponValidationState,
              ),
              prefixIconData: SolarIconsOutline.ticketSale,
              validator: (value) => null,
              suffixIcon: getSuffixIcon(
                context: context,
                price: totalPrice,
                couponValidationState: state.couponValidationState,
                service: services.isEmpty ? service : services.first,
                textContorller: textContorller,
              ),
            ),
            SizedBox(height: 24.h),
            InvoiceLine(
              title: '${context.tr.servicePrice} (${services.isEmpty ? 1 : services.length} ${context.tr.services})',
              amount: totalPrice,
            ),
            InvoiceLine(
              title: context.tr.couponDisc,
              amount: state.couponModel.discountAmount,
              isWithBraces: true,
            ),
            InvoiceLine(
              title: context.tr.deliferyFees,
              amount: deliveryFees,
            ),
            InvoiceLine(
              title: context.tr.appFees,
              amount: double.parse(appFees.toStringAsFixed(2)),
            ),
            DottedLine(
              lineWidth: context.screenWidth,
              lineColor: context.colorScheme.onSurface,
            ),
            SizedBox(height: 24.h),
            InvoiceLine(
              title: context.tr.totalPrice,
              amount: state.invoice.totalPrice,
            ),
            SizedBox(height: 8.h),
          ],
        );
      },
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
  required num price,
}) {
  return couponValidationState == UiState.success
      ? Icon(
    SolarIconsOutline.checkCircle,
    color: Colors.green,
  )
      : TextButton(
    onPressed: () {
      if (textContorller.text.isNotEmpty) {
        FocusManager.instance.primaryFocus?.unfocus();
        context
            .read<ServiceInvoiceCubit>()
            .validateCouponAndUpdateInvoice(
          service: service,
          price: price,
          code: textContorller.text,
        );
      }
    },
    child: DText(
      context.tr.apply,
    ),
  );
}
