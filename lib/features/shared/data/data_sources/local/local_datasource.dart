import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/errors/exceptions.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class LocalDataSource {
  bool checkAppTheme();

  Future<bool> changeAppTheme({required bool isDarkTheme});

  String checkAppLocale();

  Future<String> changeAppLocale({required String languageCode});

  String getSearchType();

  Future<String> saveSearchType({required String searchType});
}

@LazySingleton(as: LocalDataSource)
class LocalDataSourceImpl extends LocalDataSource {
  final Box<dynamic> settingsDataBase =
      Hive.box(AppConstants.appSettingsDatabase);

  @override
  bool checkAppTheme() {
    if (settingsDataBase.containsKey(AppConstants.appThemeKey)) {
      final bool isDarkTheme = settingsDataBase.get(AppConstants.appThemeKey);
      return isDarkTheme;
    } else {
      settingsDataBase.put(AppConstants.appThemeKey, false);
      return false;
    }
  }

  @override
  Future<bool> changeAppTheme({required bool isDarkTheme}) async {
    if (settingsDataBase.containsKey(AppConstants.appThemeKey)) {
      await settingsDataBase.put(AppConstants.appThemeKey, isDarkTheme);
      return checkAppTheme();
    } else {
      throw const CacheException('There Was an error');
    }
  }

  @override
  String checkAppLocale() {
    if (settingsDataBase.containsKey(AppConstants.localeKey)) {
      final String currentLocale = settingsDataBase.get(AppConstants.localeKey);
      return currentLocale;
    } else {
      settingsDataBase.put(AppConstants.localeKey, AppConstants.enCode);
      return AppConstants.enCode;
    }
  }

  @override
  Future<String> changeAppLocale({required String languageCode}) async {
    if (settingsDataBase.containsKey(AppConstants.localeKey)) {
      await settingsDataBase.put(AppConstants.localeKey, languageCode);
      return checkAppLocale();
    } else {
      throw const CacheException('There Was an error');
    }
  }

  @override
  String getSearchType() {
    if (settingsDataBase.containsKey(AppConstants.searchTypeKey)) {
      final String searchType = settingsDataBase.get(AppConstants.searchTypeKey);
      return searchType;
    } else {
      settingsDataBase.put(AppConstants.searchTypeKey, 'brand');
      return 'brand';
    }
  }

  @override
  Future<String> saveSearchType({required String searchType}) async {
    await settingsDataBase.put(AppConstants.searchTypeKey, searchType);
    return getSearchType();
  }
}
