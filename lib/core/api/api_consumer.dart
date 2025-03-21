abstract class ApiConsumer {
  Future<dynamic> get<T>(
    String endPointPath, {
    String? userAccessToken,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? primitiveKey,
    required ResponseReturnType responseReturnType,
    T Function(Map<String, dynamic>)? fromJsonMethod,
  });

  Future<dynamic> post<T>(
    String endPointPath, {
    dynamic body,
    String? userAccessToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String? primitiveKey,
    required ResponseReturnType responseReturnType,
    T Function(Map<String, dynamic>)? fromJsonMethod,
  });

  Future<dynamic> put<T>(
    String endPointPath, {
    dynamic body,
    String? userAccessToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String? primitiveKey,
    required ResponseReturnType responseReturnType,
    T Function(Map<String, dynamic>)? fromJsonMethod,
  });

  Future<dynamic> patch<T>(
    String endPointPath, {
    Map<String, dynamic>? body,
    String? userAccessToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String? primitiveKey,
    required ResponseReturnType responseReturnType,
    T Function(Map<String, dynamic>)? fromJsonMethod,
  });

  Future<dynamic> delete<T>(
    String endPointPath, {
    Map<String, dynamic>? body,
    String? userAccessToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    String? primitiveKey,
    required ResponseReturnType responseReturnType,
    T Function(Map<String, dynamic>)? fromJsonMethod,
  });
}

enum ResponseReturnType {
  fromJsonList,
  fromJson,
  unit,
  primitive,
  primitiveList,
  primitiveWithKey,
  primitiveListWithKey,
}
