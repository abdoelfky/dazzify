import 'package:dazzify/core/config/build_config.dart';

class BuildConfigStg extends BuildConfig {
  @override
  String get env => CustomEnv.stg;

  @override
  String get baseUrl => 'https://stg.dazzifyapp.com';

  @override
  String get baseApiUrl => 'https://stg.dazzifyapp.com/api/v1';
}
