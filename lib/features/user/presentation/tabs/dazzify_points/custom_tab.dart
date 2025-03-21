import 'package:dazzify/core/framework/export.dart';

class CustomTab extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? iconColor;
  final Color? titleColor;
  final bool isSelected;

  const CustomTab({
    super.key,
    required this.icon,
    required this.title,
    this.iconColor,
    this.titleColor,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isSelected
            ? Container(
                padding: const EdgeInsets.all(6).r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  color: context.colorScheme.primary,
                ),
                child: Icon(
                  icon,
                  size: 24.r,
                  color: iconColor ?? context.colorScheme.onPrimary,
                ),
              )
            : Container(
                padding: const EdgeInsets.all(6).r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  color: context.colorScheme.surface,
                ),
                child: Icon(
                  icon,
                  size: 24.r,
                  color: iconColor ?? context.colorScheme.outline,
                ),
              ),
        SizedBox(height: 10.r),
        isSelected
            ? DText(
                title,
                style: context.textTheme.bodySmall!.copyWith(
                  color: titleColor ?? context.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              )
            : DText(
                title,
                style: context.textTheme.bodySmall!.copyWith(
                  color: titleColor ?? context.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
      ],
    );
  }
}
