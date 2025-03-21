import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/widgets/dazzify_rounded_picture.dart';

class CategorySelectableButton extends StatelessWidget {
  final String imagePath;
  final String title;
  final void Function() onTap;
  final bool isAnimated;
  final bool isSelected;

  const CategorySelectableButton({
    super.key,
    required this.imagePath,
    required this.title,
    required this.onTap,
    this.isAnimated = false,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: isAnimated ? 65.r : 0,
        height: isAnimated ? 65.r : 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: isAnimated ? 46.r : 0,
              height: isAnimated ? 46.r : 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                child: isSelected
                    ? ClipOval(
                        key: ValueKey<bool>(isSelected),
                        child: Container(
                          width: 42.r,
                          height: 42.h,
                          color: context.colorScheme.primary,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0).r,
                            child: DazzifyRoundedPicture(
                              key: ValueKey<bool>(isSelected),
                              width: 40.r,
                              height: 40.r,
                              imageUrl: imagePath,
                            ),
                          ),
                        ),
                      )
                    : ClipOval(
                        key: ValueKey<bool>(isSelected),
                        child: DazzifyRoundedPicture(
                          width: 40.r,
                          height: 40.r,
                          imageUrl: imagePath,
                        ),
                      ),
              ),
            ),
            Flexible(
              child: DText(
                title,
                textAlign: TextAlign.center,
                style: context.textTheme.labelSmall!.copyWith(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
