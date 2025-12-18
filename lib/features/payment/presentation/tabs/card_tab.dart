import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
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

class CardTab extends StatefulWidget {
  final String transactionId;

  const CardTab({super.key, required this.transactionId});

  @override
  State<CardTab> createState() => _CardTabState();
}

class _CardTabState extends State<CardTab> {
  late final TransactionBloc transactionBloc;
  late final PaymentMethodsCubit paymentMethodsCubit;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    super.initState();
    transactionBloc = context.read<TransactionBloc>();
    paymentMethodsCubit = context.read<PaymentMethodsCubit>();
    paymentMethodsCubit.getCardMethods();
  }

  void cardMethod({required String paymentMethod}) {
    transactionBloc.add(
      AddPaymentMethodEvent(
        transactionId: widget.transactionId,
        paymentMethodId: paymentMethod,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
      buildWhen: (previous, current) =>
          previous.cardMethodsState != current.cardMethodsState,
      builder: (context, state) {
        switch (state.cardMethodsState) {
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
            if (state.cardMethods.isEmpty) {
              return EmptyDataWidget(message: context.tr.noData);
            }
            return ListView.builder(
              itemCount: state.cardMethods.length,
              itemBuilder: (context, index) {
                final method = state.cardMethods[index];
                return InstallmentTile(
                  image: method.image,
                  imageFit: BoxFit.contain,
                  title: method.name,
                  onPressed: () {
                    _logger.logEvent(
                      event: AppEvents.paymentMethodsClickPaymentMethod,
                      paymentMethodId: method.id,
                    );
                    cardMethod(paymentMethod: method.id);
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
