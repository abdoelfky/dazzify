import 'package:dazzify/features/payment/data/models/payment_method_model.dart';
import 'package:dazzify/features/payment/data/models/transaction_model.dart';
import 'package:dazzify/features/payment/data/requests/get_transactions_request.dart';
import 'package:dazzify/features/payment/data/requests/pay_with_request.dart';

abstract class PaymentRemoteDataSource {
  Future<List<TransactionModel>> getTransactions({
    required GetTransactionsRequest request,
  });

  Future<String> payWith({
    required PayWithRequest request,
  });

  Future<List<PaymentMethodModel>> getPaymentMethods({
    required String type,
  });
}
