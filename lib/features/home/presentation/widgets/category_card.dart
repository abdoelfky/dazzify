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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: DazzifyCachedNetworkImage(
              imageUrl: imageUrl,
              width: 45.r,
              height: 45.r,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 4.w),
          FittedBox(
            child: DText(
              title,
              textDirection: context.currentTextDirection,
              style: context.textTheme.labelMedium!
                  .copyWith(fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }
}
