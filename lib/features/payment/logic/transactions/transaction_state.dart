part of 'transaction_bloc.dart';

class TransactionState extends Equatable {
  final UiState transactionsState;
  final UiState addPaymentState;
  final List<TransactionModel> transactions;
  final String paymobUrl;
  final String errorMessage;
  final bool hasTransactionsReachedMax;

  const TransactionState({
    this.transactionsState = UiState.initial,
    this.addPaymentState = UiState.initial,
    this.transactions = const [],
    this.paymobUrl = "",
    this.errorMessage = "",
    this.hasTransactionsReachedMax = false,
  });

  TransactionState copyWith({
    UiState? transactionsState,
    UiState? addPaymentState,
    List<TransactionModel>? transactions,
    String? paymobUrl,
    String? errorMessage,
    bool? hasTransactionsReachedMax,
  }) {
    return TransactionState(
      transactionsState: transactionsState ?? this.transactionsState,
      addPaymentState: addPaymentState ?? this.addPaymentState,
      transactions: transactions ?? this.transactions,
      paymobUrl: paymobUrl ?? this.paymobUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      hasTransactionsReachedMax:
          hasTransactionsReachedMax ?? this.hasTransactionsReachedMax,
    );
  }

  @override
  List<Object> get props => [
        transactionsState,
        addPaymentState,
        transactions,
        paymobUrl,
        errorMessage,
        hasTransactionsReachedMax,
      ];
}
