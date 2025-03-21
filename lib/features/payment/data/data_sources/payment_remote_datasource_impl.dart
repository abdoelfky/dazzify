import 'package:dazzify/core/api/api_consumer.dart';
import 'package:dazzify/core/constants/api_constants.dart';
import 'package:dazzify/features/payment/data/data_sources/payment_remote_datasource.dart';
import 'package:dazzify/features/payment/data/models/payment_method_model.dart';
import 'package:dazzify/features/payment/data/models/transaction_model.dart';
import 'package:dazzify/features/payment/data/requests/get_transactions_request.dart';
import 'package:dazzify/features/payment/data/requests/pay_with_request.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: PaymentRemoteDataSource)
class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final ApiConsumer apiConsumer;

  PaymentRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<TransactionModel>> getTransactions({
    required GetTransactionsRequest request,
  }) async {
    return await apiConsumer.get<TransactionModel>(
      ApiConstants.getTransactions,
      queryParameters: request.toJson(),
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: TransactionModel.fromJson,
    );
  }

  @override
  Future<String> payWith({
    required PayWithRequest request,
  }) async {
    return await apiConsumer.post<String>(
      ApiConstants.addPaymentMethod(transactionId: request.transactionId),
      body: {"paymentMethodId": request.paymentMethod},
      responseReturnType: ResponseReturnType.primitive,
    );
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods(
      {required String type}) async {
    return await apiConsumer.get<PaymentMethodModel>(
      ApiConstants.getPaymentMethods,
      queryParameters: {"type": type},
      responseReturnType: ResponseReturnType.fromJsonList,
      fromJsonMethod: PaymentMethodModel.fromJson,
    );
  }
}
