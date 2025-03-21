import 'package:dazzify/features/shared/data/data_sources/local/local_datasource.dart';
import 'package:dazzify/features/shared/data/repositories/local_repository/local_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: LocalRepository)
class LocalRepositoryImpl extends LocalRepository {
  final LocalDataSource _localDataSource;

  const LocalRepositoryImpl(this._localDataSource);

  @override
  bool checkAppTheme() {
    return _localDataSource.checkAppTheme();
  }

  @override
  Future<bool> changeAppTheme({required bool isDarkTheme}) async {
    return await _localDataSource.changeAppTheme(isDarkTheme: isDarkTheme);
  }

  @override
  String checkAppLocale() {
    return _localDataSource.checkAppLocale();
  }

  @override
  Future<String> changeAppLocale({required String languageCode}) async {
    return await _localDataSource.changeAppLocale(languageCode: languageCode);
  }
}
