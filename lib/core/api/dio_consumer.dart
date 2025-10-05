import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dazzify/core/api/api_consumer.dart';
import 'package:dazzify/core/api/api_status_codes.dart';
import 'package:dazzify/core/api/base_response.dart';
import 'package:dazzify/core/api/dio_language_interceptor.dart';
import 'package:dazzify/core/api/dio_tokens_interceptor.dart';
import 'package:dazzify/core/config/build_config.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/errors/exceptions.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/functions.dart';
import 'package:dazzify/features/shared/logic/tokens/tokens_cubit.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioApiConsumer extends ApiConsumer {
  final Dio dioClient;

  DioApiConsumer({required this.dioClient}) {
    // Fix for dio handshake error
    (dioClient.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final dioClient = HttpClient();
      dioClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return dioClient;
    };

    // Dio setup
    dioClient.options
      ..baseUrl = getIt<BuildConfig>().baseApiUrl
      ..responseType = ResponseType.plain
      ..followRedirects = false
      ..validateStatus =
          (status) => status! < ApiStatusCodes.internalServerError;

    dioClient.interceptors.add(DioLanguageInterceptor());
    dioClient.interceptors.add(getIt<DioTokenInterceptor>());

    dioClient.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
      ),
    );
  }

  @override
  Future get<T>(
    String endPointPath, {
    String? userAccessToken,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? primitiveKey,
    required ResponseReturnType responseReturnType,
    T Function(Map<String, dynamic>)? fromJsonMethod,
  }) async {
    return _request<T>(
      method: 'GET',
      endPointPath: endPointPath,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      userAccessToken: userAccessToken,
      primitiveKey: primitiveKey,
      responseReturnType: responseReturnType,
      fromJsonMethod: fromJsonMethod,
    );
  }

  @override
  Future post<T>(
    String endPointPath, {
    dynamic body,
    String? userAccessToken,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? primitiveKey,
    ResponseReturnType responseReturnType = ResponseReturnType.fromJson,
    T Function(Map<String, dynamic>)? fromJsonMethod,
  }) async {
    return _request<T>(
      method: 'POST',
      endPointPath: endPointPath,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      userAccessToken: userAccessToken,
      primitiveKey: primitiveKey,
      responseReturnType: responseReturnType,
      fromJsonMethod: fromJsonMethod,
    );
  }

  @override
  Future put<T>(
    String endPointPath, {
    dynamic body,
    bool formDataIsEnabled = false,
    String? userAccessToken,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? primitiveKey,
    required ResponseReturnType responseReturnType,
    T Function(Map<String, dynamic>)? fromJsonMethod,
  }) async {
    return _request<T>(
      method: 'PUT',
      endPointPath: endPointPath,
      body: formDataIsEnabled ? FormData.fromMap(body!) : body,
      queryParameters: queryParameters,
      headers: headers,
      userAccessToken: userAccessToken,
      primitiveKey: primitiveKey,
      responseReturnType: responseReturnType,
      fromJsonMethod: fromJsonMethod,
    );
  }

  @override
  Future patch<T>(
    String endPointPath, {
    Map<String, dynamic>? body,
    bool formDataIsEnabled = false,
    String? userAccessToken,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? primitiveKey,
    required ResponseReturnType responseReturnType,
    T Function(Map<String, dynamic>)? fromJsonMethod,
  }) async {
    return _request<T>(
      method: 'PATCH',
      endPointPath: endPointPath,
      body: formDataIsEnabled ? FormData.fromMap(body!) : body,
      queryParameters: queryParameters,
      headers: headers,
      userAccessToken: userAccessToken,
      primitiveKey: primitiveKey,
      responseReturnType: responseReturnType,
      fromJsonMethod: fromJsonMethod,
    );
  }

  @override
  Future delete<T>(
    String endPointPath, {
    Map<String, dynamic>? body,
    String? userAccessToken,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? primitiveKey,
    required ResponseReturnType responseReturnType,
    T Function(Map<String, dynamic>)? fromJsonMethod,
  }) async {
    return _request<T>(
      method: 'DELETE',
      endPointPath: endPointPath,
      body: body,
      queryParameters: queryParameters,
      headers: headers,
      userAccessToken: userAccessToken,
      primitiveKey: primitiveKey,
      responseReturnType: responseReturnType,
      fromJsonMethod: fromJsonMethod,
    );
  }

  Future _request<T>({
    required String method,
    required String endPointPath,
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? userAccessToken,
    String? primitiveKey,
    required ResponseReturnType responseReturnType,
    T Function(Map<String, dynamic>)? fromJsonMethod,
  }) async {
    headers ??= {};
    if (userAccessToken != null) {
      headers["Authorization"] = "Bearer $userAccessToken";
    }

    try {
      final Response response = await dioClient.request(
        endPointPath,
        data: body,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          headers: headers,
        ),
      );
      return await _handleResponseAsJson(
        response: response,
        primitiveKey: primitiveKey,
        responseReturnType: responseReturnType,
        fromJson: fromJsonMethod,
      );
    } on DioException catch (error) {
      _handelDioError(error);
    }
  }

  dynamic _handleResponseAsJson<T>({
    required Response<dynamic> response,
    String? primitiveKey,
    required ResponseReturnType responseReturnType,
    required T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final responseJson = jsonDecode(response.data.toString());
    final baseResponse = BaseResponse.fromJson(responseJson);
    if (baseResponse.isSuccess) {
      switch (responseReturnType) {
        case ResponseReturnType.fromJson:
          return fromJson!(baseResponse.data);
        case ResponseReturnType.fromJsonList:
          return toModelList<T>(baseResponse.data, fromJson!);
        case ResponseReturnType.primitive:
          return baseResponse.data;
        case ResponseReturnType.primitiveWithKey:
          return baseResponse.data[primitiveKey!];
        case ResponseReturnType.primitiveList:
          return List<T>.from(baseResponse.data);
        case ResponseReturnType.primitiveListWithKey:
          return List<T>.from(baseResponse.data[primitiveKey!]);
        case ResponseReturnType.unit:
          return unit;
      }
    } else {
      if (baseResponse.error!.code == 401 &&
          (baseResponse.error!.message == AppConstants.bannedUserTokenMessage ||
           baseResponse.error!.message == AppConstants.invalidUserAccessTokenMessage ||
           baseResponse.error!.message == AppConstants.invalidUserRefreshTokenMessage)) {
        getIt<TokensCubit>().emitSessionExpired();
      } else {
        throw ServerException(
          baseResponse.error!.code,
          baseResponse.error!.message,
        );
      }
    }
  }

  dynamic _handelDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.sendTimeout:
        throw const NoInternetConnectionException();
      case DioExceptionType.receiveTimeout:
        throw const DataException();
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case ApiStatusCodes.badRequest:
            throw BadRequestException();
          case ApiStatusCodes.unauthorized:
          case ApiStatusCodes.forbidden:
            throw const UnauthorizedException();
          case ApiStatusCodes.notFound:
            throw const NotFoundException();
          case ApiStatusCodes.conflict:
            throw const ConflictException();
          case ApiStatusCodes.internalServerError:
            throw const InternalServerErrorException();
        }
        break;
      case DioExceptionType.badCertificate:
        break;
      case DioExceptionType.cancel:
        // Check if this is a session expired cancellation
        if (error.error is String && 
            (error.error.toString().contains('session expired') || 
             error.error.toString().contains('Invalid RefreshToken'))) {
          // Session expired, user will be redirected to login
          // Don't throw an exception that would show an error message
          return;
        }
        break;
      case DioExceptionType.unknown:
        throw const NoInternetConnectionException();
    }
  }
}
