import 'package:dazzify/core/config/build_config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  getIt.init(
    environment: const String.fromEnvironment(
      'env',
      defaultValue: CustomEnv.dev,
    ),
  );
}
