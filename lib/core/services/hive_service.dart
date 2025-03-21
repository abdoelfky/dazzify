import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/features/auth/data/models/tokens_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter<TokensModel>(TokensModelAdapter());
    await Hive.openBox(AppConstants.appSettingsDatabase);
  }
}
