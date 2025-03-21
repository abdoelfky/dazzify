import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/presentation/widgets/governorate_bottom_sheet/get_localized_governorate.dart';

class GovernorateItem extends StatelessWidget {
  final int index;
  final int governorateIndex;
  final void Function() onPressed;

  const GovernorateItem({
    required this.index,
    required this.governorateIndex,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 38.h,
        padding: const EdgeInsets.symmetric(horizontal: 16).r,
        decoration: BoxDecoration(
          color: context.colorScheme.inversePrimary.withValues(alpha: 0.1),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ).r,
        ),
        child: Row(
          children: [
            DText(
              '${index + 1} - ${getLocalizedGovernorate(context, governorateIndex)}',
              style: context.textTheme.titleSmall,
            ),
            const Spacer(),
            Icon(
              size: 24.r,
              context.currentTextDirection == TextDirection.ltr
                  ? SolarIconsOutline.altArrowRight
                  : SolarIconsOutline.altArrowLeft,
            ),
          ],
        ),
      ),
    );
  }
}
