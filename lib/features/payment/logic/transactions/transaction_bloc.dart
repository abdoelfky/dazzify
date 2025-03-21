import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/payment/data/models/transaction_model.dart';
import 'package:dazzify/features/payment/data/repositories/payment_repository.dart';
import 'package:dazzify/features/payment/data/requests/get_transactions_request.dart';
import 'package:dazzify/features/payment/data/requests/pay_with_request.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

@Injectable()
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final PaymentRepository _repository;

  int _transactionsPage = 1;
  final int _transactionsLimit = 10;
  String? selectedStatus;

  TransactionBloc(this._repository) : super(const TransactionState()) {
    on<GetTransactionsEvent>(_onGetTransactions, transformer: droppable());
    on<FilterTransactionsByStatusEvent>(_filterTransactionsByStatus);
    on<AddPaymentMethodEvent>(_onAddPaymentMethod);
    on<ResetTransactionsEvent>(_resetTransactionsEvent);
  }

  Future<void> _onGetTransactions(
      GetTransactionsEvent event, Emitter<TransactionState> emit) async {
    if (!state.hasTransactionsReachedMax) {
      if (state.transactions.isEmpty) {
        emit(state.copyWith(transactionsState: UiState.loading));
      }

      final transactions = await _repository.getTransactions(
        request: GetTransactionsRequest(
          page: _transactionsPage,
          limit: _transactionsLimit,
          status: selectedStatus,
        ),
      );

      transactions.fold(
        (failure) => emit(
          state.copyWith(
            transactionsState: UiState.failure,
            errorMessage: failure.message,
          ),
        ),
        (transactions) {
          final hasReachedMax =
              transactions.isEmpty || transactions.length < _transactionsLimit;

          emit(
            state.copyWith(
              transactionsState: UiState.success,
              transactions: List.of(state.transactions)..addAll(transactions),
              hasTransactionsReachedMax: hasReachedMax,
            ),
          );
          _transactionsPage++;
        },
      );
    }
  }

  void _filterTransactionsByStatus(
    FilterTransactionsByStatusEvent event,
    Emitter<TransactionState> emit,
  ) {
    _transactionsPage = 1;
    emit(state.copyWith(
      hasTransactionsReachedMax: false,
      transactions: [],
      transactionsState: UiState.initial,
    ));
    if (selectedStatus != event.selectedStatus) {
      selectedStatus = event.selectedStatus;
    }
    add(const GetTransactionsEvent());
  }

  Future<void> _onAddPaymentMethod(
      AddPaymentMethodEvent event, Emitter<TransactionState> emit) async {
    emit(state.copyWith(addPaymentState: UiState.loading));

    final payment = await _repository.payWith(
      request: PayWithRequest(
        transactionId: event.transactionId,
        paymentMethod: event.paymentMethodId,
      ),
    );

    payment.fold(
      (failure) => emit(state.copyWith(
        addPaymentState: UiState.failure,
        errorMessage: failure.message,
      )),
      (paymobUrl) {
        emit(state.copyWith(
          addPaymentState: UiState.success,
          paymobUrl: paymobUrl,
        ));
      },
    );
  }

  void _resetTransactionsEvent(
    ResetTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) {
    _transactionsPage = 1;
    emit(state.copyWith(
      hasTransactionsReachedMax: false,
      transactions: [],
      transactionsState: UiState.initial,
    ));
    add(const GetTransactionsEvent());
  }
}
