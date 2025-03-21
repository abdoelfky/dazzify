part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class GetTransactionsEvent extends TransactionEvent {
  const GetTransactionsEvent();

  @override
  List<Object> get props => [];
}

class FilterTransactionsByStatusEvent extends TransactionEvent {
  final String? selectedStatus;

  const FilterTransactionsByStatusEvent({this.selectedStatus});

  @override
  List<Object?> get props => [selectedStatus];
}

class AddPaymentMethodEvent extends TransactionEvent {
  final String transactionId;
  final String paymentMethodId;

  const AddPaymentMethodEvent({
    required this.transactionId,
    required this.paymentMethodId,
  });

  @override
  List<Object> get props => [transactionId, paymentMethodId];
}

class ResetTransactionsEvent extends TransactionEvent {
  const ResetTransactionsEvent();

  @override
  List<Object> get props => [];
}
