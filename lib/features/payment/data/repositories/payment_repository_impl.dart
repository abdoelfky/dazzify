import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/exceptions.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/features/payment/data/data_sources/payment_remote_datasource.dart';
import 'package:dazzify/features/payment/data/models/payment_method_model.dart';
import 'package:dazzify/features/payment/data/models/transaction_model.dart';
import 'package:dazzify/features/payment/data/repositories/payment_repository.dart';
import 'package:dazzify/features/payment/data/requests/get_transactions_request.dart';
import 'package:dazzify/features/payment/data/requests/pay_with_request.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PaymentRepository)
class PaymentRepositoryImpl extends PaymentRepository {
  final PaymentRemoteDataSource _remoteDataSource;

  PaymentRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<TransactionModel>>> getTransactions({
    required GetTransactionsRequest request,
  }) async {
    try {
      final transactions =
          await _remoteDataSource.getTransactions(request: request);
      return Right(transactions);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, String>> payWith({
    required PayWithRequest request,
  }) async {
    try {
      final url = await _remoteDataSource.payWith(request: request);
      return Right(url);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, List<PaymentMethodModel>>> getPaymentMethods({
    required String type,
  }) async {
    try {
      final paymentMethods =
          await _remoteDataSource.getPaymentMethods(type: type);
      return Right(paymentMethods);
    } on ServerException catch (e) {
      return Left(ApiFailure(message: e.message!));
    }
  }
}
