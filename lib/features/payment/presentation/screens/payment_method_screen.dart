import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/payment/logic/transactions/transaction_bloc.dart';
import 'package:dazzify/features/payment/presentation/tabs/card_tab.dart';
import 'package:dazzify/features/payment/presentation/tabs/e_wallet_tab.dart';
import 'package:dazzify/features/payment/presentation/tabs/installment_tab.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_overlay_loading.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';

@RoutePage()
class PaymentMethodScreen extends StatefulWidget {
  final String serviceName;
  final String transactionId;

  const PaymentMethodScreen({
    super.key,
    required this.serviceName,
    required this.transactionId,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final TabController _tabController;
  bool isLoading = false;
  late final TransactionBloc transactionBloc;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    transactionBloc = context.read<TransactionBloc>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state.addPaymentState == UiState.loading) {
          isLoading = true;
        } else if (state.addPaymentState == UiState.success) {
          if (isLoading) {
            context.pushRoute(
              PaymentWebViewRoute(
                transactionBloc: transactionBloc,
                url: state.paymobUrl,
              ),
            );
            isLoading = false;
          }
        } else {
          isLoading = false;
          DazzifyToastBar.showError(
            message: state.errorMessage,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: DazzifyOverlayLoading(
            isLoading: isLoading,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 45),
                  child: DazzifyAppBar(
                      isLeading: true,
                      title: "${widget.serviceName} - ${context.tr.pay}",
                      onBackTap: () {
                        _logger.logEvent(
                            event: AppEvents.paymentMethodsClickBack);
                        context.maybePop();
                      }),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TabBar(
                  onTap: (index) {
                    if (index == 0) {
                      _logger.logEvent(
                          event: AppEvents.paymentMethodsClickWallet);
                    } else if (index == 1) {
                      _logger.logEvent(
                          event: AppEvents.paymentMethodsClickCard);
                    } else if (index == 2) {
                      _logger.logEvent(
                          event: AppEvents.paymentMethodsClickInstallment);
                    }
                  },
                  controller: _tabController,
                  unselectedLabelColor: context.colorScheme.outline,
                  labelColor: context.colorScheme.primary,
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  padding: const EdgeInsets.only(bottom: 24).r,
                  tabs: [
                    Tab(
                      icon: Icon(SolarIconsOutline.wallet, size: 22.sp),
                      height: 50.h,
                      text: context.tr.eWallet,
                    ),
                    Tab(
                      icon: Icon(SolarIconsOutline.card, size: 22.sp),
                      height: 50.h,
                      text: context.tr.card,
                    ),
                    Tab(
                      icon: Icon(SolarIconsOutline.banknote2, size: 22.sp),
                      height: 50.h,
                      text: context.tr.installment,
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      EWalletTab(
                        key: const PageStorageKey(AppConstants.eWalletTab),
                        transactionId: widget.transactionId,
                      ),
                      CardTab(
                        key: const PageStorageKey(AppConstants.visaCardTab),
                        transactionId: widget.transactionId,
                      ),
                      InstallmentTab(
                        key: const PageStorageKey(AppConstants.installmentTab),
                        transactionId: widget.transactionId,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
