import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/features/payment/data/models/payment_method_model.dart';
import 'package:dazzify/features/payment/data/models/transaction_model.dart';
import 'package:dazzify/features/payment/data/requests/get_transactions_request.dart';
import 'package:dazzify/features/payment/data/requests/pay_with_request.dart';

abstract class PaymentRepository {
  Future<Either<Failure, List<TransactionModel>>> getTransactions({
    required GetTransactionsRequest request,
  });

  Future<Either<Failure, String>> payWith({
    required PayWithRequest request,
  });

  Future<Either<Failure, List<PaymentMethodModel>>> getPaymentMethods({
    required String type,
  });
}
