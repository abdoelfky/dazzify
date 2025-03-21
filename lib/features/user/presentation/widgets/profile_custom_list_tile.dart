import 'package:dazzify/core/framework/export.dart';

class ProfileCustomListTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Widget? suffixWidget;
  final bool disableOnTap;
  final void Function()? onTap;

  const ProfileCustomListTile({
    super.key,
    required this.iconData,
    required this.title,
    this.suffixWidget,
    this.onTap,
    this.disableOnTap = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disableOnTap ? null : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16).r,
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Icon(
                iconData,
                size: 18.r,
                color: context.colorScheme.onSurface,
              ),
              const Spacer(),
              DText(
                title,
                style: context.textTheme.bodyMedium,
              ),
              const Spacer(flex: 7),
              suffixWidget ??
                  Icon(
                    context.currentTextDirection == TextDirection.ltr
                        ? SolarIconsOutline.altArrowRight
                        : SolarIconsOutline.altArrowLeft,
                    size: 18.r,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
