import 'package:dazzify/core/api/api_consumer.dart';
import 'package:dazzify/core/api/dio_consumer.dart';
import 'package:dazzify/core/api/dio_log_interceptor.dart';
import 'package:dazzify/core/api/dio_tokens_interceptor.dart';
import 'package:dazzify/core/config/build_config.dart';
import 'package:dazzify/core/config/build_config_dev.dart';
import 'package:dazzify/core/config/build_config_prod.dart';
import 'package:dazzify/core/config/build_config_stg.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource_impl.dart';
import 'package:dazzify/features/auth/data/data_sources/remote/auth_remote_datasource.dart';
import 'package:dazzify/features/auth/data/data_sources/remote/auth_remote_datasource_impl.dart';
import 'package:dazzify/features/auth/data/repositories/auth_repository.dart';
import 'package:dazzify/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dazzify/features/notifications/data/data_sources/notifications_remote_datasource.dart';
import 'package:dazzify/features/notifications/data/data_sources/notifications_remote_datasource_impl.dart';
import 'package:dazzify/features/notifications/data/repositories/notifications_repository.dart';
import 'package:dazzify/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:dazzify/features/notifications/logic/app_notifications/app_notifications_cubit.dart';
import 'package:dazzify/features/shared/logic/tokens/tokens_cubit.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

@module
abstract class AppCoreModule {
  @Injectable(as: BuildConfig, env: [CustomEnv.prod], order: -4)
  BuildConfigProd get buildConfigProd => BuildConfigProd();

  @Injectable(as: BuildConfig, env: [CustomEnv.stg], order: -3)
  BuildConfigStg get buildConfigStg => BuildConfigStg();

  @Injectable(as: BuildConfig, env: [CustomEnv.dev], order: -2)
  BuildConfigDev get buildConfigDev => BuildConfigDev();

  @Singleton(order: -1)
  AppRouter get appRouter => AppRouter();
}

@module
abstract class FeaturesModule {
  @injectable
  GlobalKey<NavigatorState> get nav => getIt<AppRouter>().navigatorKey;

  @Injectable()
  TextEditingController get textController => TextEditingController();

  @injectable
  GlobalKey<FormState> get globalKey => GlobalKey<FormState>();

  @LazySingleton(as: AuthLocalDatasource)
  AuthLocalDatasourceImpl get authLocalDatasource => AuthLocalDatasourceImpl();

  @Singleton(order: -5)
  DioTokenInterceptor get tokenInterceptor => DioTokenInterceptor();

  @Singleton(order: -6)
  DioLogInterceptor get dioLogInterceptor => DioLogInterceptor();

  @factory
  Dio get dioClient => Dio();

  @LazySingleton(as: ApiConsumer)
  DioApiConsumer get dioConsumer => DioApiConsumer(dioClient: dioClient);

  /// App-wide events logger for `/api/v1/log/event`
  @LazySingleton()
  AppEventsLogger get appEventsLogger => AppEventsLogger(dioConsumer);

  @LazySingleton(as: AuthRemoteDatasource)
  AuthRemoteDatasourceImpl get authRemoteDatasource =>
      AuthRemoteDatasourceImpl(dioConsumer);

  @LazySingleton(as: AuthRepository)
  AuthRepositoryImpl get authRepository => AuthRepositoryImpl(
    authRemoteDatasource,
    authLocalDatasource,
  );

  @LazySingleton(as: NotificationsRemoteDatasource)
  NotificationsRemoteDatasourceImpl get notificationsRemoteDataSource =>
      NotificationsRemoteDatasourceImpl(dioConsumer);

  @LazySingleton(as: NotificationsRepository)
  NotificationsRepositoryImpl get notificationsRepository =>
      NotificationsRepositoryImpl(
        notificationsRemoteDataSource,
      );

  @singleton
  AppNotificationsCubit get appNotificationsCubit => AppNotificationsCubit(
    notificationsRepository,
    authRepository,
  );

  @singleton
  TokensCubit get tokensCubit => TokensCubit(
    authRepository,
    appNotificationsCubit,
  );

  @lazySingleton
  InternetConnection get internetConnection => InternetConnection();

  @factory
  ImagePicker get imagePicker => ImagePicker();

  @factory
  ImageCropper get imageCropper => ImageCropper();
}