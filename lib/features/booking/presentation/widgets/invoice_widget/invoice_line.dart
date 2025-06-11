import 'package:dazzify/core/framework/export.dart';

class InvoiceLine extends StatelessWidget {
  final String title;
  final num amount;
  final bool isWithBraces;

  const InvoiceLine({
    required this.title,
    required this.amount,
    this.isWithBraces = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16).r,
      child: Row(
        children: [
          DText(
            title,
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.outline,
            ),
          ),
          const Spacer(),
          DText(
            isWithBraces
                ? '(${reformatPriceWithCommas(amount)} ${context.tr.egp})'
                : '${reformatPriceWithCommas(amount)} ${context.tr.egp}',
            style: context.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
