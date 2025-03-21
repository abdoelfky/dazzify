import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/features/user/presentation/tabs/dazzify_points/custom_tab.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BodyTaps extends StatelessWidget {
  final bool isSelected;

  const BodyTaps({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16).r,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    AssetsManager.pointsIcon,
                    height: 18.r,
                    width: 18.r,
                    colorFilter: ColorFilter.mode(
                      context.colorScheme.outline,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 2.5.r),
                  DText(
                    context.tr.yourPoints,
                    style: context.textTheme.bodyLarge!.copyWith(
                      color: context.colorScheme.outline,
                    ),
                  ),
                ],
              ),
              DText(
                "2000",
                style: context.textTheme.titleLarge,
              ),
            ],
          ),
          const Spacer(),
          CustomTab(
              isSelected: isSelected,
              icon: SolarIconsOutline.handMoney,
              title: context.tr.earnPoints),
          SizedBox(width: 16.r),
          CustomTab(
              isSelected: isSelected,
              icon: SolarIconsOutline.gift,
              title: context.tr.redeemPoints),
        ],
      ),
    );
  }
}
