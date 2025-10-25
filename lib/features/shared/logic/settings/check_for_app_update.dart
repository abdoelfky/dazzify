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

/// Compares two semantic version strings.
/// Returns:
/// - negative value if version1 < version2
/// - 0 if version1 == version2
/// - positive value if version1 > version2
int compareVersions(String version1, String version2) {
  final v1Parts = version1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  final v2Parts = version2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

  final maxLength = v1Parts.length > v2Parts.length ? v1Parts.length : v2Parts.length;

  for (int i = 0; i < maxLength; i++) {
    final v1 = i < v1Parts.length ? v1Parts[i] : 0;
    final v2 = i < v2Parts.length ? v2Parts[i] : 0;

    if (v1 != v2) {
      return v1 - v2;
    }
  }

  return 0;
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

  // Only show update popup if current version is older than remote version
  if (compareVersions(currentVersion, remoteVersion) < 0) {
    await showDialog(
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
