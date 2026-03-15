import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';

class CategoryCard extends StatelessWidget {
  final void Function() onTap;
  final String imageUrl;
  final String title;

  const CategoryCard({
    super.key,
    required this.onTap,
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        return GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12).r,
                child: SizedBox(
                  width: size,
                  height: size,
                  child: DazzifyCachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: DText(
                  title,
                  textDirection: context.currentTextDirection,
                  style: context.textTheme.labelMedium!
                      .copyWith(fontWeight: FontWeight.w400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
