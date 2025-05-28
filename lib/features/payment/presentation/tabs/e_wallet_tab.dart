import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/payment/logic/payment_methods/payment_methods_cubit.dart';
import 'package:dazzify/features/payment/logic/transactions/transaction_bloc.dart';
import 'package:dazzify/features/payment/presentation/widgets/installment_item.dart';
import 'package:dazzify/features/shared/widgets/available_soon_widget.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EWalletTab extends StatefulWidget {
  final String transactionId;

  const EWalletTab({super.key, required this.transactionId});

  @override
  State<EWalletTab> createState() => _EWalletTabState();
}

class _EWalletTabState extends State<EWalletTab> {
  late final TransactionBloc transactionBloc;
  late final PaymentMethodsCubit paymentMethodsCubit;

  @override
  void initState() {
    super.initState();
    transactionBloc = context.read<TransactionBloc>();
    paymentMethodsCubit = context.read<PaymentMethodsCubit>();
    paymentMethodsCubit.getEWalletMethods();
  }

  void eWalletMethod(String paymentMethodId) {
    transactionBloc.add(
      AddPaymentMethodEvent(
        transactionId: widget.transactionId,
        paymentMethodId: paymentMethodId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
      buildWhen: (previous, current) =>
          previous.eWalletMethodsState != current.eWalletMethodsState,
      builder: (context, state) {
        switch (state.eWalletMethodsState) {
          case UiState.initial:
          case UiState.loading:
            return DazzifyLoadingShimmer(
              dazzifyLoadingType: DazzifyLoadingType.listView,
              listViewItemCount: 6,
              cardWidth: context.screenWidth,
              cardHeight: 60.h,
              widgetPadding: const EdgeInsets.only(
                bottom: 90,
                right: 16,
                left: 16,
              ).r,
              borderRadius: BorderRadius.circular(12).r,
            );
          case UiState.success:
            if (state.eWalletMethods.isEmpty) {
              return EmptyDataWidget(message: context.tr.noData);
            }
            return ListView.builder(
              itemCount: state.eWalletMethods.length,
              itemBuilder: (context, index) {
                final method = state.eWalletMethods[index];
                return InstallmentTile(
                  image: method.image,
                  imageFit: BoxFit.contain,
                  title: method.name,
                  onPressed: () {
                    eWalletMethod(method.id);
                  },
                );
              },
            );
          case UiState.failure:
            return AvailableSoonWidget();

        // return ErrorDataWidget(
            //   errorDataType: DazzifyErrorDataType.screen,
            //   message: state.cardErrorMessage,
            //   onTap: () {
            //     paymentMethodsCubit.getCardMethods();
            //   },
            // );
        }
      },
    );
  }
}
