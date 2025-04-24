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
        // Calculate total price if services are empty or not
        num totalPrice = 0;
        if (services.isEmpty) {
          totalPrice = service.price; // use service price if services is empty
        } else {
          totalPrice = services
              .map((service) => service.price)
              .toList()
              .fold<num>(0, (sum, item) => sum + item); // sum prices if services are not empty
        }

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
              suffixIcon: getSuffixIcon(
                context: context,
                price: totalPrice,
                couponValidationState: state.couponValidationState,
                service: services.isEmpty ? service : services.first, // select the first service if available or use the service data when empty
                textContorller: textContorller,
              ),
            ),
            SizedBox(
              height: 24.h,
            ),
            InvoiceLine(
              title:
              '${context.tr.servicePrice} (${services.isEmpty ? 1 : services.length} ${context.tr.services})', // Update services count accordingly
              amount: totalPrice.toString(),
            ),
            InvoiceLine(
              title: context.tr.couponDisc,
              amount: state.couponModel.discountAmount.toString(),
              isWithBraces: true,
            ),
            InvoiceLine(
              title: context.tr.deliferyFees,
              amount: state.deliveryInfo.selectedDeliveryFees.toString(),
            ),
            InvoiceLine(
              title: context.tr.appFees,
              amount: services
                  .map((service) => service.fees)
                  .toList()
                  .fold<num>(0, (sum, item) => sum + item)
                  .toString(),
            ),
            DottedLine(
              lineWidth: context.screenWidth,
              lineColor: context.colorScheme.onSurface,
            ),
            SizedBox(
              height: 24.h,
            ),
            InvoiceLine(
              title: context.tr.totalPrice,
              amount: state.invoice.totalPrice.toString(),
            ),
            SizedBox(
              height: 8.h,
            ),
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
      ? const BorderSide(color: Colors.transparent)
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
      ? null
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

        textContorller.clear();
      }
    },
    child: DText(
      context.tr.apply,
    ),
  );
}
