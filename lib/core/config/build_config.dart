abstract class CustomEnv {
  static const String dev = 'dev';
  static const String stg = 'stg';
  static const String prod = 'prod';
}

abstract class BuildConfig {
  String get env;

  String get baseUrl;

  String get baseApiUrl;
}
