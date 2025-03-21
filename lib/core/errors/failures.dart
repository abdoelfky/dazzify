class Failure {
  final String message;
  int? errorCode;

  Failure({required this.message, this.errorCode});
}

class CacheFailure extends Failure {
  CacheFailure({required super.message, super.errorCode});
}

class ApiFailure extends Failure {
  ApiFailure({required super.message, super.errorCode});
}

class SessionFailure extends Failure {
  SessionFailure({required super.message, super.errorCode});
}
