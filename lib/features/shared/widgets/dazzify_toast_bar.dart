import 'package:dazzify/core/framework/export.dart';
import 'package:flash/flash.dart';

class DazzifyToastBar {
  static void showError({
    required String message,
  }) {
    _showCustomToast(
      context: DazzifyApp.mainContext,
      message: message,
      boxColor: DazzifyApp.mainContext.colorScheme.error,
    );
  }

  static void showSuccess({
    required String message,
  }) {
    _showCustomToast(
        context: DazzifyApp.mainContext,
        message: message,
        boxColor: ColorsManager.successColor);
  }

  static void showCoupon() {
    _showCustomToast(
      context: DazzifyApp.mainContext,
      message: DazzifyApp.mainContext.tr.couponCopied,
      boxColor: DazzifyApp.mainContext.colorScheme.primary,
    );
  }

  static Future<Object?> _showCustomToast({
    required BuildContext context,
    required String message,
    required Color boxColor,
  }) {
    return showFlash(
      barrierDismissible: false,
      context: context,
      persistent: true,
      transitionDuration: const Duration(milliseconds: 400),
      duration: const Duration(seconds: 4),
      builder: (context, controller) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flash(
                position: FlashPosition.bottom,
                dismissDirections: const [FlashDismissDirection.endToStart],
                controller: controller,
                child: Container(
                  // height: 40.0.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: boxColor,
                    borderRadius: BorderRadius.circular(8.0).r,
                  ),
                  padding: EdgeInsetsDirectional.only(
                    start: 12.0.r,
                    end: 8.0.r,
                    top: 10.0.r,
                    bottom: 10.0.r,
                  ),
                  margin: EdgeInsetsDirectional.all(21.0.r),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 42.0.r,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DText(
                          message,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyMedium!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0.w),
                      GestureDetector(
                        onTap: () {
                          controller.dismiss();
                        },
                        child: const Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: 16.0,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
