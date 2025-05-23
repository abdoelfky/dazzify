import 'package:dazzify/features/auth/data/models/app_config_model.dart';

abstract class AppConfigStore {
  Future<void> saveAppConfig(AppConfigModel config);

  Future<AppConfigModel?> loadAppConfig();

  Future<void> clearAppConfig();
}
