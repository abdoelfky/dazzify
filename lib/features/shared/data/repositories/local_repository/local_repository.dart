abstract class LocalRepository {
  const LocalRepository();

  bool checkAppTheme();

  Future<bool> changeAppTheme({required bool isDarkTheme});

  String checkAppLocale();

  Future<String> changeAppLocale({required String languageCode});
}
