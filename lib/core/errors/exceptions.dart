import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final String? message;
  final int? errorCode;

  const ServerException([this.errorCode, this.message]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return '$message';
  }
}

class DataException extends ServerException {
  const DataException([errorCode, message])
      : super(
            errorCode ?? 0, message ?? "There was an error, try again later.");
}

class BadRequestException extends ServerException {
  const BadRequestException([errorCode, message])
      : super(message ?? "Bad Request");
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException([errorCode, message])
      : super(errorCode ?? 0, message ?? "Unauthorized");
}

class NotFoundException extends ServerException {
  const NotFoundException([errorCode, message])
      : super(errorCode ?? 0, message ?? "Requested Info Not Found");
}

class ConflictException extends ServerException {
  const ConflictException([errorCode, message])
      : super(errorCode ?? 0, message ?? "Conflict Occurred");
}

class InternalServerErrorException extends ServerException {
  const InternalServerErrorException([errorCode, message])
      : super(errorCode ?? 0, message ?? "Internal Server Error");
}

class NoInternetConnectionException extends ServerException {
  const NoInternetConnectionException([errorCode, message])
      : super(
            errorCode ?? 0, message ?? "Please Check Your Internet Connection");
}

class LaunchUrlException extends ServerException {
  const LaunchUrlException([errorCode, message])
      : super(errorCode ?? 0, message ?? "No Internet Connection");
}

class CacheException extends Equatable implements Exception {
  final String? message;

  const CacheException([this.message]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return '$message';
  }
}

class AccessTokenException extends Equatable implements Exception {
  final String? message;

  const AccessTokenException([this.message]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return '$message';
  }
}

class RefreshTokenException extends Equatable implements Exception {
  final String? message;

  const RefreshTokenException([this.message]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return '$message';
  }
}

class SessionCancelledException extends ServerException {
  const SessionCancelledException([errorCode, message])
      : super(errorCode ?? 0, message ?? "Session cancelled");
}
