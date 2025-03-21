import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';

class RedeemPointsView extends StatelessWidget {
  const RedeemPointsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16).r,
      child: Center(
        child: ListView.separated(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              height: 141.r,
              width: context.screenWidth,
              decoration: BoxDecoration(
                color: context.colorScheme.onInverseSurface,
                borderRadius: BorderRadius.circular(16).r,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.only(top: 8.r, start: 8.r),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16).r,
                              child: DazzifyCachedNetworkImage(
                                imageUrl: "https://via.placeholder.com/150x150",
                                height: 90.r,
                                width: 80.r,
                              ),
                            ),
                            SizedBox(width: 16.r),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                DText(
                                  "Service ${index + 1}",
                                  style: context.textTheme.bodyLarge,
                                ),
                                SizedBox(height: 6.r),
                                SizedBox(
                                  width: 250.r,
                                  child: DText(
                                    "Lorem ipsum dolor sit amet consec.neque ncustur. Elit neque",
                                    style:
                                        context.textTheme.bodySmall!.copyWith(
                                      color:
                                          context.colorScheme.onSurfaceVariant,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: 10.r),
                                SizedBox(
                                  width: 220.r,
                                  child: DText(
                                    "Reach 4000 points and treat yourself to this amazing service!",
                                    style:
                                        context.textTheme.labelSmall!.copyWith(
                                      color: context.colorScheme.outlineVariant,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DText(
                        '1200 Points',
                        style: context.textTheme.labelMedium!.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                      SizedBox(
                        width: 160.r,
                        height: 8.r,
                        child: LinearProgressIndicator(
                          value: 0.25,
                          borderRadius: BorderRadius.circular(16.r),
                          color: context.colorScheme.primary,
                          backgroundColor: context.colorScheme.outlineVariant,
                        ),
                      ),
                      DText(
                        context.tr.redeemIt,
                        style: context.textTheme.labelMedium!.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(height: 8.r),
        ),
      ),
    );
  }
}
