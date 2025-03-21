import 'dart:async';

import 'package:dazzify/core/api/base_response.dart';
import 'package:dazzify/core/constants/api_constants.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/errors/exceptions.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource.dart';
import 'package:dazzify/features/auth/data/data_sources/remote/auth_remote_datasource.dart';
import 'package:dazzify/features/shared/logic/tokens/tokens_cubit.dart';
import 'package:dio/dio.dart';

class DioTokenInterceptor extends Interceptor {
  DioTokenInterceptor();

  bool _isRefreshing = false;
  String? _accessToken;
  Completer<void>? _refreshCompleter;

  void logoutReset() {
    _isRefreshing = false;
    _accessToken = null;
    _refreshCompleter = null;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isExemptPath(options.path)) {
      return handler.next(options);
    }

    if (_isRefreshing) {
      await _refreshCompleter?.future;
    }

    try {
      _accessToken ??= getIt<AuthLocalDatasource>().getAccessToken();
      options.headers['Authorization'] = 'Bearer $_accessToken';
    } catch (exception) {
      if (exception is AccessTokenException) {
        await _refreshToken();
        options.headers['Authorization'] = 'Bearer $_accessToken';
      } else {
        rethrow;
      }
    }

    handler.next(options);
  }

  Future<void> _refreshToken() async {
    if (_isRefreshing) {
      await _refreshCompleter?.future;
      return;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<void>();

    try {
      final String refreshToken =
          await getIt<AuthLocalDatasource>().getRefreshToken();
      final newTokens = await getIt<AuthRemoteDatasource>()
          .refreshUserAccessToken(refreshToken);
      await getIt<AuthLocalDatasource>().updateAccessToken(newTokens);
      _accessToken = newTokens.accessToken;
    } catch (exception) {
      if (exception is RefreshTokenException) {
        getIt<TokensCubit>().emitSessionExpired();
      }
      rethrow;
    } finally {
      _isRefreshing = false;
      _refreshCompleter?.complete();
      _refreshCompleter = null;
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_isTokenExpired(err)) {
      final requestOptions = err.requestOptions;
      try {
        await _refreshToken();
        final response = await _retry(requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }
    return handler.next(err);
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    options.headers?['Authorization'] = 'Bearer $_accessToken';
    return getIt<Dio>().request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  bool _isTokenExpired(DioException err) {
    if (err.response?.statusCode == 401) {
      final errorData = err.response?.data;

      if (errorData is Map<String, dynamic>) {
        final baseResponse = BaseResponse.fromJson(errorData);
        if (baseResponse.error != null) {
          final errorMessage = baseResponse.error!.message;
          if (errorMessage == AppConstants.invalidUserAccessTokenMessage ||
              errorMessage == AppConstants.invalidUserRefreshTokenMessage) {
            return true;
          }
        }
      }
    }

    return false;
  }

  bool _isExemptPath(String path) {
    return path == ApiConstants.sendOtpPath ||
        path == ApiConstants.validateNonExistUserOtpPath ||
        path == ApiConstants.validateExistUserOtpPath ||
        path == ApiConstants.addInformationPath ||
        path == ApiConstants.refreshUserAccessTokenPath ||
        path == ApiConstants.appTerms;
  }
}
