import 'package:dazzify/core/config/build_config.dart';

class BuildConfigProd extends BuildConfig {
  @override
  String get env => CustomEnv.prod;

  @override
  String get baseUrl => 'https://api.dazzifyapp.com';

  @override
  String get baseApiUrl => 'https://api.dazzifyapp.com/api/v1';
}
