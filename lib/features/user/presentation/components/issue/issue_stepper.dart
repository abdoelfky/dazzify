import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IssueStepper extends StatefulWidget {
  final int currentStep;

  const IssueStepper({super.key, required this.currentStep});

  @override
  State<IssueStepper> createState() => _IssueStepperState();
}

class _IssueStepperState extends State<IssueStepper> {
  @override
  Widget build(BuildContext context) {
    return buildSteps(widget.currentStep);
  }

  Widget buildSteps(int selected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24).r,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              stepTitle(
                text: context.tr.pending,
                isSelected: selected == 0,
              ),
              SizedBox(width: 65.w),
              stepTitle(
                text: context.tr.progress,
                isSelected: selected == 1,
              ),
              SizedBox(width: 65.w),
              stepTitle(
                text: context.tr.reply,
                isSelected: selected == 2,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45).r,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              stepItem(isSelected: selected >= 0),
              buildDivider(),
              stepItem(isSelected: selected >= 1),
              buildDivider(),
              stepItem(isSelected: selected >= 2),
            ],
          ),
        ),
      ],
    );
  }

  Expanded buildDivider() {
    return Expanded(
      child: Divider(
        color: context.colorScheme.primary,
        thickness: 1,
      ),
    );
  }

  Widget stepItem({
    required bool isSelected,
  }) {
    return isSelected ? stepCompleteIcon() : stepNotCompleteIcon();
  }

  Widget stepCompleteIcon() => Icon(
        SolarIconsBold.checkCircle,
        size: 32.r,
        color: context.colorScheme.primary,
      );

  Widget stepNotCompleteIcon() => SvgPicture.asset(
        AssetsManager.issueNotComplete,
        height: 29.r,
        colorFilter: ColorFilter.mode(
          context.colorScheme.primary,
          BlendMode.srcIn,
        ),
      );

  Widget stepTitle({required String text, required bool isSelected}) {
    return DText(
      text,
      style: TextStyle(
        color: isSelected
            ? context.colorScheme.primary
            : context.colorScheme.outline,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }
}
