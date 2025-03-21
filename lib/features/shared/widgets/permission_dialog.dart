import 'package:dazzify/core/framework/export.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsDialog extends StatelessWidget {
  final IconData icon;
  final String description;

  const PermissionsDialog({
    super.key,
    required this.icon,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 250, horizontal: 0).r,
      child: SizedBox(
        width: 300.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: context.colorScheme.primary,
              size: 24.r,
            ),
            SizedBox(height: 20.h),
            DText(
              description,
              textAlign: TextAlign.center,
              style: context.textTheme.labelMedium,
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () {
                context.maybePop();
                openAppSettings();
              },
              child: Container(
                width: 240.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ).r,
                ),
                child: Center(
                  child: DText(
                    context.tr.openSettings,
                    style: context.textTheme.labelMedium!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            GestureDetector(
              onTap: () {
                context.maybePop();
              },
              child: Container(
                width: 240.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: context.colorScheme.error,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ).r,
                ),
                child: Center(
                  child: DText(
                    context.tr.close,
                    style: context.textTheme.labelMedium!.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showPermissionDialog(
  BuildContext context, {
  required IconData icon,
  required String description,
}) {
  showDialog(
    routeSettings: const RouteSettings(
      name: 'PermissionsDialogRoute',
    ),
    context: context,
    builder: (context) {
      return PermissionsDialog(
        icon: Icons.photo_outlined,
        description: context.tr.galleryPermissionDialog,
      );
    },
  );
}
