import 'package:dazzify/core/framework/export.dart';

class SectionWidget extends StatelessWidget {
  final String sectionTitle;
  final String? sectionButtonTitle;
  final void Function()? onTextButtonTap;
  final SectionType sectionType;
  final EdgeInsets? padding;
  final Color? fontColor;

  const SectionWidget({
    super.key,
    required this.sectionTitle,
    this.sectionButtonTitle,
    this.onTextButtonTap,
    this.sectionType = SectionType.normal,
    this.fontColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0).r,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DText(
            sectionTitle,
            style: context.textTheme.bodyMedium!
                .copyWith(fontWeight: FontWeight.w500, color: fontColor),
          ),
          Visibility(
            visible: sectionType == SectionType.withTextButton,
            child: TextButton(
              onPressed: onTextButtonTap,
              child: DText(
                sectionButtonTitle ?? context.tr.more,
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

enum SectionType {
  normal,
  withTextButton;
}
