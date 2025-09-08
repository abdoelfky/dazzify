import 'package:bloc/bloc.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/payment/data/models/payment_method_model.dart';
import 'package:dazzify/features/payment/data/repositories/payment_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'payment_methods_state.dart';

@injectable
class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  final PaymentRepository _paymentRepository;

  PaymentMethodsCubit(this._paymentRepository) : super(PaymentMethodsState());

  Future<void> getEWalletMethods() async {
    emit(state.copyWith(eWalletMethodsState: UiState.loading));
    final result = await _paymentRepository.getPaymentMethods(type: 'e-wallet');
    result.fold(
      (failure) => emit(
        state.copyWith(
          eWalletMethodsState: UiState.failure,
          eWalletErrorMessage: failure.message,
        ),
      ),
      (methods) => emit(
        state.copyWith(
          eWalletMethods: methods,
          eWalletMethodsState: UiState.success,
        ),
      ),
    );
  }

  Future<void> getCardMethods() async {
    emit(state.copyWith(cardMethodsState: UiState.loading));
    final result = await _paymentRepository.getPaymentMethods(type: 'card');

    result.fold(
      (failure) => emit(
        state.copyWith(
          cardMethodsState: UiState.failure,
          cardErrorMessage: failure.message,
        ),
      ),
      (methods) => emit(
        state.copyWith(
          cardMethods: methods,
          cardMethodsState: UiState.success,
        ),
      ),
    );
  }

  Future<void> getInstallmentsMethods() async {
    emit(state.copyWith(installmentsMethodsState: UiState.loading));
    final result =
        await _paymentRepository.getPaymentMethods(type: 'installment');

    result.fold(
      (failure) => emit(
        state.copyWith(
          installmentsMethodsState: UiState.failure,
          installmentsErrorMessage: failure.message,
        ),
      ),
      (methods) => emit(
        state.copyWith(
          installmentsMethods: methods,
          installmentsMethodsState: UiState.success,
        ),
      ),
    );
  }
}
