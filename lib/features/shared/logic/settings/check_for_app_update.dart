import 'dart:io';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/util/app_config_manager.dart';
import 'package:dazzify/dazzify_app.dart';
import 'package:dazzify/features/shared/widgets/dazzify_update_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePostponeManager {
  static const _key = AppConstants.updatePostponeTime;

  static Future<void> markPostponedNow() async {
    final box = Hive.box(AppConstants.appSettingsDatabase);
    await box.put(_key, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<bool> shouldShowUpdate() async {
    final box = Hive.box(AppConstants.appSettingsDatabase);
    final millis = box.get(_key);
    if (millis == null) return true;

    final last = DateTime.fromMillisecondsSinceEpoch(millis);
    return DateTime.now().difference(last) > const Duration(hours: 24);
  }
}

Future<void> checkForAppUpdate() async {
  final info = await PackageInfo.fromPlatform();
  final currentVersion = info.version;
  final isForceUpdate = AppConfigManager.forceUpdate;
  final remoteVersion = Platform.isIOS
      ? AppConfigManager.iosVersion
      : AppConfigManager.androidVersion;

  final shouldShow = isForceUpdate || await UpdatePostponeManager.shouldShowUpdate();
  if (!shouldShow) return;

  if (currentVersion != remoteVersion) {
    showDialog(
      context: DazzifyApp.mainContext,
      barrierDismissible: !isForceUpdate,
      builder: (_) => PopScope(
        canPop: !isForceUpdate,
        child: DazzifyUpdateDialog(
          message: DazzifyApp.tr.update_required_message,
          buttonTitle: DazzifyApp.tr.update,
          isCancelable: !isForceUpdate,
          onTap: () async {
            final updateUrl = Platform.isIOS
                ? AppConfigManager.iosDownloadLink
                : AppConfigManager.androidDownloadLink;
            if (await canLaunchUrl(Uri.parse(updateUrl))) {
              await launchUrl(Uri.parse(updateUrl), mode: LaunchMode.externalApplication);
            }
          },
        ),
      ),
    );
  }
}
