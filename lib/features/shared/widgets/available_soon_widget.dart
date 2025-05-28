import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:flutter_svg/flutter_svg.dart'; // For your context extensions and DText

class AvailableSoonWidget extends StatelessWidget {
  final String? message;

  const AvailableSoonWidget({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final displayMessage = message ?? context.tr.availableSoon;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SvgPicture.asset(
          //   AssetsManager.error,
          // ),
          // SizedBox(height: 20.h),
          DText(
            displayMessage,
            style: context.textTheme.headlineSmall!.copyWith(
              color: context.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
