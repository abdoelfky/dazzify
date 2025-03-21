import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:flutter_svg/svg.dart';

class InitialView extends StatelessWidget {
  const InitialView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      width: 280.r,
      child: Column(
        children: [
          SizedBox(
            height: 81.r,
          ),
          SvgPicture.asset(
            AssetsManager.pointsCard,
            height: 180.r,
          ),
          SizedBox(
            height: 24.r,
          ),
          DText(
            context.tr.pointsStatement,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium!.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          )
        ],
      ),
    ));
  }
}
