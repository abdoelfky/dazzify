import 'package:dazzify/core/api/api_consumer.dart';
import 'package:dazzify/core/config/build_config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:dazzify/core/services/app_events_logger.dart';

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

  // Manually register AppEventsLogger without needing codegen regeneration.
  if (!getIt.isRegistered<AppEventsLogger>()) {
    getIt.registerLazySingleton<AppEventsLogger>(
          () => AppEventsLogger(getIt<ApiConsumer>()),
    );
  }
}