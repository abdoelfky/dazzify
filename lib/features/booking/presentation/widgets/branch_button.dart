import 'package:dazzify/core/framework/export.dart';

class BranchButton extends StatelessWidget {
  final bool isActive;
  final void Function() onTap;
  final double height;
  final double width;
  final bool isSelected;
  final String title;

  const BranchButton({
    required this.isActive,
    required this.onTap,
    required this.height,
    required this.width,
    required this.isSelected,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: isActive ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: isActive && isSelected
                  ? context.colorScheme.primary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10).r,
              border: Border.all(
                color: isActive
                    ? isSelected
                        ? context.colorScheme.primary
                        : context.colorScheme.outline
                    : context.colorScheme.outlineVariant,
              )),
          child: Center(
              child: DText(
            title,
            style: context.textTheme.labelMedium!.copyWith(
                color: isActive
                    ? isSelected
                        ? context.colorScheme.onPrimary
                        : context.colorScheme.outline
                    : context.colorScheme.outlineVariant),
          )),
        ));
  }
}
