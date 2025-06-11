import 'package:dazzify/core/framework/export.dart';

class PriceInfoItem extends StatelessWidget {
  final String title;
  final String price;

  const PriceInfoItem({super.key, required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DText(
          title,
          style: context.textTheme.bodyMedium,
        ),
        const Spacer(),
        DText(

          price,
          style: context.textTheme.bodySmall!.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
      ],
    );
  }
}
