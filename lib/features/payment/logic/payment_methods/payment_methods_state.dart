part of 'payment_methods_cubit.dart';

class PaymentMethodsState extends Equatable {
  final List<PaymentMethodModel> eWalletMethods;
  final UiState eWalletMethodsState;
  final String eWalletErrorMessage;

  final List<PaymentMethodModel> cardMethods;
  final UiState cardMethodsState;
  final String cardErrorMessage;

  final List<PaymentMethodModel> installmentsMethods;
  final UiState installmentsMethodsState;
  final String installmentsErrorMessage;

  const PaymentMethodsState({
    this.eWalletMethods = const [],
    this.eWalletMethodsState = UiState.initial,
    this.eWalletErrorMessage = '',
    this.cardMethods = const [],
    this.cardMethodsState = UiState.initial,
    this.cardErrorMessage = '',
    this.installmentsMethods = const [],
    this.installmentsMethodsState = UiState.initial,
    this.installmentsErrorMessage = '',
  });

  @override
  List<Object?> get props => [
        eWalletMethodsState,
        eWalletMethods,
        eWalletErrorMessage,
        cardMethods,
        cardMethodsState,
        cardErrorMessage,
        installmentsMethods,
        installmentsMethodsState,
        installmentsErrorMessage,
      ];

  PaymentMethodsState copyWith({
    List<PaymentMethodModel>? eWalletMethods,
    UiState? eWalletMethodsState,
    String? eWalletErrorMessage,
    List<PaymentMethodModel>? cardMethods,
    UiState? cardMethodsState,
    String? cardErrorMessage,
    List<PaymentMethodModel>? installmentsMethods,
    UiState? installmentsMethodsState,
    String? installmentsErrorMessage,
  }) {
    return PaymentMethodsState(
      eWalletMethods: eWalletMethods ?? this.eWalletMethods,
      eWalletMethodsState: eWalletMethodsState ?? this.eWalletMethodsState,
      eWalletErrorMessage: eWalletErrorMessage ?? this.eWalletErrorMessage,
      cardMethods: cardMethods ?? this.cardMethods,
      cardMethodsState: cardMethodsState ?? this.cardMethodsState,
      cardErrorMessage: cardErrorMessage ?? this.cardErrorMessage,
      installmentsMethods: installmentsMethods ?? this.installmentsMethods,
      installmentsMethodsState:
          installmentsMethodsState ?? this.installmentsMethodsState,
      installmentsErrorMessage:
          installmentsErrorMessage ?? this.installmentsErrorMessage,
    );
  }
}
