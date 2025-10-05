import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/features/shared/logic/settings/settings_cubit.dart';
import 'package:dio/dio.dart';

class DioLanguageInterceptor extends Interceptor {
  DioLanguageInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      // Get current language from SettingsCubit
      final currentLanguage = getIt<SettingsCubit>().currentLanguageCode;
      
      // Add Accept-Language header
      options.headers['Accept-Language'] = currentLanguage;
    } catch (e) {
      // If we can't get the language, continue without it
      // This shouldn't break the request
    }
    
    handler.next(options);
  }
}
