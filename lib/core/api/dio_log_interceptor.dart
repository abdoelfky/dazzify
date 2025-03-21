import 'package:dio/dio.dart';

class DioLogInterceptor extends LogInterceptor {
  @override
  bool get request => true;

  @override
  bool get requestBody => true;

  @override
  bool get requestHeader => true;

  @override
  bool get responseBody => true;
}
