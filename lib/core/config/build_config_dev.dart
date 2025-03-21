import 'package:dazzify/core/config/build_config.dart';

class BuildConfigDev extends BuildConfig {
  @override
  String get env => CustomEnv.dev;

  @override
  String get baseUrl => 'https://testing.api.dazzifyapp.com';

  @override
  String get baseApiUrl => 'https://testing.api.dazzifyapp.com/api/v1';
// String get baseUrl => 'https://dev.api.dazzifyapp.com/';
}
