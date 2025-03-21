import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HistoryItem extends StatelessWidget {
  final String dateTime;
  final String pointsCount;
  final bool isSpent;

  const HistoryItem({
    super.key,
    required this.dateTime,
    required this.pointsCount,
    required this.isSpent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(8).r,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7).r,
        child: Row(
          children: [
            isSpent
                ? Icon(
                    SolarIconsOutline.sale,
                    color: context.colorScheme.primary,
                    size: 24.r,
                  )
                : Container(
                    padding: EdgeInsets.all(5.r),
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: SvgPicture.asset(
                      AssetsManager.smilingFace,
                      height: 24.r,
                      width: 24.r,
                      colorFilter: ColorFilter.mode(
                        context.colorScheme.secondary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
            SizedBox(width: 8.r),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DText(
                  context.tr.dazzifyPoints,
                  style: context.textTheme.bodyLarge,
                ),
                DText(
                  dateTime,
                  style: context.textTheme.bodyMedium!.copyWith(
                    color: context.colorScheme.outline,
                  ),
                ),
              ],
            ),
            const Spacer(),
            DText(
              pointsCount,
              style: context.textTheme.bodyLarge!.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
