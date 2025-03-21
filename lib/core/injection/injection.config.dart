// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dazzify/core/api/api_consumer.dart' as _i373;
import 'package:dazzify/core/api/dio_log_interceptor.dart' as _i203;
import 'package:dazzify/core/api/dio_tokens_interceptor.dart' as _i391;
import 'package:dazzify/core/config/build_config.dart' as _i530;
import 'package:dazzify/core/framework/export.dart' as _i510;
import 'package:dazzify/core/injection/injection_module.dart' as _i1008;
import 'package:dazzify/core/services/fcm_notifications.dart' as _i764;
import 'package:dazzify/core/services/image_picking_service.dart' as _i359;
import 'package:dazzify/core/services/network_info.dart' as _i645;
import 'package:dazzify/core/web_socket/data_sources/web_socket_service.dart'
    as _i107;
import 'package:dazzify/core/web_socket/data_sources/web_socket_service_impl.dart'
    as _i924;
import 'package:dazzify/core/web_socket/repositories/web_socket_repository.dart'
    as _i160;
import 'package:dazzify/core/web_socket/repositories/web_socket_repository_impl.dart'
    as _i125;
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource.dart'
    as _i26;
import 'package:dazzify/features/auth/data/data_sources/remote/auth_remote_datasource.dart'
    as _i993;
import 'package:dazzify/features/auth/data/repositories/auth_repository.dart'
    as _i694;
import 'package:dazzify/features/auth/logic/auth_cubit.dart' as _i879;
import 'package:dazzify/features/booking/data/data_sources/remote/booking_remote_datasource.dart'
    as _i716;
import 'package:dazzify/features/booking/data/data_sources/remote/booking_remote_datasource_impl.dart'
    as _i210;
import 'package:dazzify/features/booking/data/repositories/booking_repository.dart'
    as _i626;
import 'package:dazzify/features/booking/data/repositories/booking_repository_impl.dart'
    as _i10;
import 'package:dazzify/features/booking/logic/booking_cubit/booking_cubit.dart'
    as _i291;
import 'package:dazzify/features/booking/logic/booking_review/booking_review_cubit.dart'
    as _i966;
import 'package:dazzify/features/booking/logic/brand_terms_cubit/brand_terms_cubit.dart'
    as _i585;
import 'package:dazzify/features/booking/logic/multiple_service_availability_cubit/multiple_service_availability_cubit.dart'
    as _i847;
import 'package:dazzify/features/booking/logic/service_availability_cubit/service_availability_cubit.dart'
    as _i410;
import 'package:dazzify/features/booking/logic/service_invoice_cubit/service_invoice_cubit.dart'
    as _i872;
import 'package:dazzify/features/booking/logic/view_location_cubit.dart/view_location_cubit.dart'
    as _i766;
import 'package:dazzify/features/brand/data/data_sources/brand_remote_datasource.dart'
    as _i307;
import 'package:dazzify/features/brand/data/data_sources/brand_remote_datasource_impl.dart'
    as _i650;
import 'package:dazzify/features/brand/data/repositories/brand_repository.dart'
    as _i447;
import 'package:dazzify/features/brand/data/repositories/brand_repository_impl.dart'
    as _i741;
import 'package:dazzify/features/brand/logic/booking_from_media/booking_from_media_cubit.dart'
    as _i180;
import 'package:dazzify/features/brand/logic/brand/brand_bloc.dart' as _i798;
import 'package:dazzify/features/brand/logic/brand_branches/brand_branches_cubit.dart'
    as _i299;
import 'package:dazzify/features/brand/logic/service_selection/service_selection_cubit.dart'
    as _i968;
import 'package:dazzify/features/chat/data/data_sources/remote/chat_remote_datasource.dart'
    as _i425;
import 'package:dazzify/features/chat/data/data_sources/remote/chat_remote_datasource_impl.dart'
    as _i957;
import 'package:dazzify/features/chat/data/repositories/chat_repository.dart'
    as _i775;
import 'package:dazzify/features/chat/data/repositories/chat_repository_impl.dart'
    as _i1048;
import 'package:dazzify/features/chat/logic/chat_cubit.dart' as _i846;
import 'package:dazzify/features/chat/logic/conversations_cubit.dart' as _i856;
import 'package:dazzify/features/home/data/data_sources/remote/home_remote_datasource.dart'
    as _i873;
import 'package:dazzify/features/home/data/data_sources/remote/home_remote_datasource_impl.dart'
    as _i180;
import 'package:dazzify/features/home/data/repositories/home_repository.dart'
    as _i660;
import 'package:dazzify/features/home/data/repositories/home_repository_impl.dart'
    as _i981;
import 'package:dazzify/features/home/logic/category/category_bloc.dart'
    as _i256;
import 'package:dazzify/features/home/logic/home_brands/home_brands_bloc.dart'
    as _i222;
import 'package:dazzify/features/home/logic/home_screen/home_cubit.dart'
    as _i218;
import 'package:dazzify/features/home/logic/search/search_bloc.dart' as _i316;
import 'package:dazzify/features/home/logic/service_details/service_details_bloc.dart'
    as _i199;
import 'package:dazzify/features/home/logic/services/services_bloc.dart'
    as _i852;
import 'package:dazzify/features/notifications/data/data_sources/notifications_remote_datasource.dart'
    as _i427;
import 'package:dazzify/features/notifications/data/repositories/notifications_repository.dart'
    as _i865;
import 'package:dazzify/features/notifications/logic/app_notifications/app_notifications_cubit.dart'
    as _i162;
import 'package:dazzify/features/notifications/logic/in_app_notifications/in_app_notifications_bloc.dart'
    as _i205;
import 'package:dazzify/features/payment/data/data_sources/payment_remote_datasource.dart'
    as _i46;
import 'package:dazzify/features/payment/data/data_sources/payment_remote_datasource_impl.dart'
    as _i246;
import 'package:dazzify/features/payment/data/repositories/payment_repository.dart'
    as _i119;
import 'package:dazzify/features/payment/data/repositories/payment_repository_impl.dart'
    as _i786;
import 'package:dazzify/features/payment/logic/payment_methods/payment_methods_cubit.dart'
    as _i96;
import 'package:dazzify/features/payment/logic/transactions/transaction_bloc.dart'
    as _i627;
import 'package:dazzify/features/reels/data/data_sources/remote/reels_remote_data_source.dart'
    as _i927;
import 'package:dazzify/features/reels/data/data_sources/remote/reels_remote_data_source_impl.dart'
    as _i496;
import 'package:dazzify/features/reels/data/repositories/reels_repository.dart'
    as _i720;
import 'package:dazzify/features/reels/data/repositories/reels_repository_impl.dart'
    as _i255;
import 'package:dazzify/features/reels/logic/reels_bloc.dart' as _i468;
import 'package:dazzify/features/shared/data/data_sources/local/local_datasource.dart'
    as _i422;
import 'package:dazzify/features/shared/data/repositories/local_repository/local_repository.dart'
    as _i917;
import 'package:dazzify/features/shared/data/repositories/local_repository/local_repository_impl.dart'
    as _i338;
import 'package:dazzify/features/shared/logic/comments/comments_bloc.dart'
    as _i435;
import 'package:dazzify/features/shared/logic/favorite/favorite_cubit.dart'
    as _i593;
import 'package:dazzify/features/shared/logic/likes/likes_cubit.dart' as _i108;
import 'package:dazzify/features/shared/logic/report/report_cubit.dart'
    as _i454;
import 'package:dazzify/features/shared/logic/settings/settings_cubit.dart'
    as _i110;
import 'package:dazzify/features/shared/logic/socket/socket_cubit.dart'
    as _i380;
import 'package:dazzify/features/shared/logic/tokens/tokens_cubit.dart'
    as _i462;
import 'package:dazzify/features/shared/widgets/dazzify_image_cropper.dart'
    as _i457;
import 'package:dazzify/features/user/data/data_sources/user_remote_datasource.dart'
    as _i868;
import 'package:dazzify/features/user/data/data_sources/user_remote_datasource_impl.dart'
    as _i152;
import 'package:dazzify/features/user/data/repositories/user_repository.dart'
    as _i499;
import 'package:dazzify/features/user/data/repositories/user_repository_impl.dart'
    as _i825;
import 'package:dazzify/features/user/logic/booking_history/booking_history_bloc.dart'
    as _i149;
import 'package:dazzify/features/user/logic/issue/issue_bloc.dart' as _i303;
import 'package:dazzify/features/user/logic/location/location_cubit.dart'
    as _i683;
import 'package:dazzify/features/user/logic/user/user_cubit.dart' as _i968;
import 'package:dazzify/settings/router/app_router.dart' as _i892;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter/cupertino.dart' as _i719;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_cropper/image_cropper.dart' as _i183;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart'
    as _i161;

const String _prod = 'prod';
const String _stg = 'stg';
const String _dev = 'dev';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final featuresModule = _$FeaturesModule();
    final appCoreModule = _$AppCoreModule();
    gh.singleton<_i203.DioLogInterceptor>(
        () => featuresModule.dioLogInterceptor);
    gh.singleton<_i391.DioTokenInterceptor>(
        () => featuresModule.tokenInterceptor);
    gh.factory<_i530.BuildConfig>(
      () => appCoreModule.buildConfigProd,
      registerFor: {_prod},
    );
    gh.factory<_i530.BuildConfig>(
      () => appCoreModule.buildConfigStg,
      registerFor: {_stg},
    );
    gh.factory<_i530.BuildConfig>(
      () => appCoreModule.buildConfigDev,
      registerFor: {_dev},
    );
    gh.singleton<_i892.AppRouter>(() => appCoreModule.appRouter);
    gh.factory<_i719.GlobalKey<_i719.NavigatorState>>(() => featuresModule.nav);
    gh.factory<_i719.TextEditingController>(
        () => featuresModule.textController);
    gh.factory<_i719.GlobalKey<_i719.FormState>>(
        () => featuresModule.globalKey);
    gh.factory<_i361.Dio>(() => featuresModule.dioClient);
    gh.factory<_i183.ImagePicker>(() => featuresModule.imagePicker);
    gh.factory<_i183.ImageCropper>(() => featuresModule.imageCropper);
    gh.singleton<_i462.TokensCubit>(() => featuresModule.tokensCubit);
    gh.singleton<_i162.AppNotificationsCubit>(
        () => featuresModule.appNotificationsCubit);
    gh.lazySingleton<_i161.InternetConnection>(
        () => featuresModule.internetConnection);
    gh.lazySingleton<_i694.AuthRepository>(() => featuresModule.authRepository);
    gh.lazySingleton<_i865.NotificationsRepository>(
        () => featuresModule.notificationsRepository);
    gh.lazySingleton<_i359.ImagePickingService>(
        () => _i359.ImagePickingServiceImpl());
    gh.lazySingleton<_i26.AuthLocalDatasource>(
        () => featuresModule.authLocalDatasource);
    gh.lazySingleton<_i373.ApiConsumer>(() => featuresModule.dioConsumer);
    gh.factory<_i205.InAppNotificationsBloc>(() =>
        _i205.InAppNotificationsBloc(gh<_i865.NotificationsRepository>()));
    gh.lazySingleton<_i422.LocalDataSource>(() => _i422.LocalDataSourceImpl());
    gh.lazySingleton<_i917.LocalRepository>(
        () => _i338.LocalRepositoryImpl(gh<_i422.LocalDataSource>()));
    gh.singleton<_i110.SettingsCubit>(
        () => _i110.SettingsCubit(gh<_i917.LocalRepository>()));
    gh.lazySingleton<_i427.NotificationsRemoteDatasource>(
        () => featuresModule.notificationsRemoteDataSource);
    gh.lazySingleton<_i107.WebSocketService>(
        () => _i924.WebSocketServiceImpl());
    gh.lazySingleton<_i993.AuthRemoteDatasource>(
        () => featuresModule.authRemoteDatasource);
    gh.lazySingleton<_i46.PaymentRemoteDataSource>(() =>
        _i246.PaymentRemoteDataSourceImpl(
            apiConsumer: gh<_i373.ApiConsumer>()));
    gh.lazySingleton<_i764.FCMNotification>(
        () => _i764.FCMNotificationImpl(gh<_i510.AppRouter>()));
    gh.lazySingleton<_i457.DazzifyPickAndCropImage>(
        () => _i457.DazzifyPickAndCropImageImpl(
              imageCropper: gh<_i183.ImageCropper>(),
              imagePicker: gh<_i183.ImagePicker>(),
              settingsCubit: gh<_i110.SettingsCubit>(),
            ));
    gh.lazySingleton<_i873.HomeRemoteDatasource>(
        () => _i180.HomeRemoteDatasourceImpl(gh<_i373.ApiConsumer>()));
    gh.lazySingleton<_i307.BrandRemoteDataSources>(
        () => _i650.BrandRemoteDataSourcesImpl(gh<_i373.ApiConsumer>()));
    gh.lazySingleton<_i645.NetworkInfo>(() => _i645.NetworkInfoImpl(
        internetConnection: gh<_i161.InternetConnection>()));
    gh.lazySingleton<_i160.WebSocketRepository>(
        () => _i125.WebSocketRepositoryImpl(
              authLocalDatasource: gh<_i26.AuthLocalDatasource>(),
              authRemoteDatasource: gh<_i993.AuthRemoteDatasource>(),
              webSocketService: gh<_i107.WebSocketService>(),
            ));
    gh.lazySingleton<_i425.ChatRemoteDatasource>(
        () => _i957.ChatRemoteDatasourceImpl(gh<_i373.ApiConsumer>()));
    gh.lazySingleton<_i868.UserRemoteDataSource>(
        () => _i152.UserRemoteDataSourceImpl(gh<_i373.ApiConsumer>()));
    gh.lazySingleton<_i927.ReelsRemoteDataSource>(
        () => _i496.ReelsRemoteDataSourceImpl(gh<_i373.ApiConsumer>()));
    gh.lazySingleton<_i119.PaymentRepository>(
        () => _i786.PaymentRepositoryImpl(gh<_i46.PaymentRemoteDataSource>()));
    gh.lazySingleton<_i775.ChatRepository>(
        () => _i1048.ChatRepositoryImpl(gh<_i425.ChatRemoteDatasource>()));
    gh.lazySingleton<_i716.BookingRemoteDatasource>(
        () => _i210.BookingRemoteDatasourceImpl(gh<_i373.ApiConsumer>()));
    gh.lazySingleton<_i447.BrandRepository>(
        () => _i741.BrandRepositoryImpl(gh<_i307.BrandRemoteDataSources>()));
    gh.factory<_i96.PaymentMethodsCubit>(
        () => _i96.PaymentMethodsCubit(gh<_i119.PaymentRepository>()));
    gh.lazySingleton<_i626.BookingRepository>(
        () => _i10.BookingRepositoryImpl(gh<_i716.BookingRemoteDatasource>()));
    gh.factory<_i879.AuthCubit>(() => _i879.AuthCubit(
          gh<_i694.AuthRepository>(),
          gh<_i162.AppNotificationsCubit>(),
          gh<_i110.SettingsCubit>(),
        ));
    gh.factory<_i966.BookingReviewCubit>(() => _i966.BookingReviewCubit(
          gh<_i626.BookingRepository>(),
          gh<_i160.WebSocketRepository>(),
        ));
    gh.factory<_i180.BookingFromMediaCubit>(
        () => _i180.BookingFromMediaCubit(gh<_i447.BrandRepository>()));
    gh.factory<_i798.BrandBloc>(
        () => _i798.BrandBloc(gh<_i447.BrandRepository>()));
    gh.factory<_i968.ServiceSelectionCubit>(
        () => _i968.ServiceSelectionCubit(gh<_i447.BrandRepository>()));
    gh.factory<_i299.BrandBranchesCubit>(
        () => _i299.BrandBranchesCubit(gh<_i447.BrandRepository>()));
    gh.lazySingleton<_i380.SocketCubit>(() => _i380.SocketCubit(
          gh<_i160.WebSocketRepository>(),
          gh<_i462.TokensCubit>(),
        ));
    gh.factory<_i410.ServiceAvailabilityCubit>(
        () => _i410.ServiceAvailabilityCubit(gh<_i626.BookingRepository>()));
    gh.factory<_i585.BrandTermsCubit>(
        () => _i585.BrandTermsCubit(gh<_i626.BookingRepository>()));
    gh.factory<_i872.ServiceInvoiceCubit>(
        () => _i872.ServiceInvoiceCubit(gh<_i626.BookingRepository>()));
    gh.factory<_i847.MultipleServiceAvailabilityCubit>(() =>
        _i847.MultipleServiceAvailabilityCubit(gh<_i626.BookingRepository>()));
    gh.factory<_i766.ViewLocationCubit>(
        () => _i766.ViewLocationCubit(gh<_i626.BookingRepository>()));
    gh.lazySingleton<_i660.HomeRepository>(
        () => _i981.HomeRepositoryImpl(gh<_i873.HomeRemoteDatasource>()));
    gh.factory<_i627.TransactionBloc>(
        () => _i627.TransactionBloc(gh<_i119.PaymentRepository>()));
    gh.lazySingleton<_i720.ReelsRepository>(
        () => _i255.ReelsRepositoryImpl(gh<_i927.ReelsRemoteDataSource>()));
    gh.factory<_i846.ChatCubit>(() => _i846.ChatCubit(
          gh<_i775.ChatRepository>(),
          gh<_i359.ImagePickingService>(),
          gh<_i160.WebSocketRepository>(),
        ));
    gh.factory<_i499.UserRepository>(
        () => _i825.UserRepositoryImpl(gh<_i868.UserRemoteDataSource>()));
    gh.factory<_i454.ReportCubit>(() => _i454.ReportCubit(
          gh<_i719.TextEditingController>(),
          gh<_i719.GlobalKey<_i719.FormState>>(),
          gh<_i499.UserRepository>(),
        ));
    gh.factory<_i222.HomeBrandsBloc>(
        () => _i222.HomeBrandsBloc(gh<_i660.HomeRepository>()));
    gh.factory<_i256.CategoryBloc>(
        () => _i256.CategoryBloc(gh<_i660.HomeRepository>()));
    gh.factory<_i316.SearchBloc>(
        () => _i316.SearchBloc(gh<_i660.HomeRepository>()));
    gh.factory<_i852.ServicesBloc>(
        () => _i852.ServicesBloc(gh<_i660.HomeRepository>()));
    gh.factory<_i968.UserCubit>(() => _i968.UserCubit(
          gh<_i499.UserRepository>(),
          gh<_i457.DazzifyPickAndCropImage>(),
        ));
    gh.factory<_i856.ConversationsCubit>(() => _i856.ConversationsCubit(
          gh<_i775.ChatRepository>(),
          gh<_i160.WebSocketRepository>(),
        ));
    gh.factory<_i435.CommentsBloc>(
        () => _i435.CommentsBloc(gh<_i499.UserRepository>()));
    gh.factory<_i108.LikesCubit>(
        () => _i108.LikesCubit(gh<_i499.UserRepository>()));
    gh.factory<_i593.FavoriteCubit>(
        () => _i593.FavoriteCubit(gh<_i499.UserRepository>()));
    gh.factory<_i149.BookingHistoryBloc>(
        () => _i149.BookingHistoryBloc(gh<_i626.BookingRepository>()));
    gh.factory<_i303.IssueBloc>(
        () => _i303.IssueBloc(gh<_i499.UserRepository>()));
    gh.factory<_i199.ServiceDetailsBloc>(
        () => _i199.ServiceDetailsBloc(gh<_i660.HomeRepository>()));
    gh.factory<_i218.HomeCubit>(
        () => _i218.HomeCubit(gh<_i660.HomeRepository>()));
    gh.factory<_i291.BookingCubit>(() => _i291.BookingCubit(
          gh<_i626.BookingRepository>(),
          gh<_i160.WebSocketRepository>(),
        ));
    gh.factory<_i683.LocationCubit>(
        () => _i683.LocationCubit(gh<_i499.UserRepository>()));
    gh.factory<_i468.ReelsBloc>(
        () => _i468.ReelsBloc(gh<_i720.ReelsRepository>()));
    return this;
  }
}

class _$FeaturesModule extends _i1008.FeaturesModule {}

class _$AppCoreModule extends _i1008.AppCoreModule {}
