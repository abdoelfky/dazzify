import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/features/payment/logic/transactions/transaction_bloc.dart';
import 'package:dazzify/features/payment/presentation/widgets/transaction_item.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/enums/transaction_enum.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';

@RoutePage()
class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  late final TransactionBloc transactionBloc;
  final ScrollController _controller = ScrollController();
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  void _onScroll() async {
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      transactionBloc.add(const GetTransactionsEvent());
    }
  }

  @override
  void initState() {
    super.initState();
    transactionBloc = context.read<TransactionBloc>();
    transactionBloc.add(const ResetTransactionsEvent());
    _controller.addListener(_onScroll);
  }

  void filterTransactions(String? status) {
    transactionBloc.add(FilterTransactionsByStatusEvent(
      selectedStatus: status,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50.0).h,
                child: DazzifyAppBar(
                  isLeading: true,
                  title: context.tr.transaction,
                  onBackTap: () {
                    _logger.logEvent(event: AppEvents.paymentsClickBack);
                    context.maybePop();
                  },
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(top: 50.0).h,
                child: IconButton(
                  onPressed: () async {
                    final selectedStatus = await onTapFilter();
                    if (selectedStatus != null) {
                      _logger.logEvent(
                        event: AppEvents.paymentsClickFilter,
                        filterStatus: selectedStatus,
                      );
                    }
                  },
                  icon: Icon(
                    SolarIconsOutline.sort,
                    size: 24.r,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _handleTransactionBody(),
        ],
      ),
    );
  }

  Widget _handleTransactionBody() {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (BuildContext context, TransactionState state) {
        switch (state.transactionsState) {
          case UiState.initial:
          case UiState.loading:
            return const Expanded(
              child: Center(
                child: LoadingAnimation(),
              ),
            );
          case UiState.failure:
            return Expanded(
              child: ErrorDataWidget(
                errorDataType: DazzifyErrorDataType.screen,
                message: state.errorMessage,
                onTap: () {
                  transactionBloc.add(const GetTransactionsEvent());
                },
              ),
            );
          case UiState.success:
            return Expanded(
              child: state.transactions.isEmpty
                  ? EmptyDataWidget(message: DazzifyApp.tr.noTransactions)
                  : RefreshIndicator(
                      onRefresh: () async {
                        // Trigger refresh event
                        transactionBloc.add(const ResetTransactionsEvent());
                        // Wait for loading state to complete
                        await transactionBloc.stream.firstWhere(
                          (state) => state.transactionsState != UiState.loading,
                        );
                      },
                      child: CustomFadeAnimation(
                        duration: const Duration(milliseconds: 300),
                        child: ListView.separated(
                          controller: _controller,
                          itemCount: state.transactions.length + 1,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 8.h),
                          itemBuilder: (context, index) {
                            if (index >= state.transactions.length) {
                              if (state.hasTransactionsReachedMax) {
                                return const SizedBox.shrink();
                              } else {
                                return SizedBox(
                                  height: 30.h,
                                  width: context.screenWidth,
                                  child: const LoadingAnimation(),
                                );
                              }
                            } else {
                              return TransactionItem(
                                transaction: state.transactions[index],
                              );
                            }
                          },
                        ),
                      ),
                    ),
            );
        }
      },
    );
  }

  Future<String?> onTapFilter() async {
    String? selectedStatus;
    await showMenu(
      context: context,
      position: context.currentTextDirection == TextDirection.ltr
          ? const RelativeRect.fromLTRB(double.infinity, 0, 0, 0)
          : const RelativeRect.fromLTRB(0, 0, double.infinity, 0),
      items: [
        PopupMenuItem(
          onTap: () {
            selectedStatus = null;
            filterTransactions(null);
          },
          child: DText(context.tr.all),
        ),
        PopupMenuItem(
          onTap: () {
            selectedStatus = PaymentStatus.notPaid.name;
            filterTransactions(PaymentStatus.notPaid.name);
          },
          child: DText(context.tr.notPaid),
        ),
        PopupMenuItem(
          onTap: () {
            selectedStatus = PaymentStatus.paid.name;
            filterTransactions(PaymentStatus.paid.name);
          },
          child: DText(context.tr.paid),
        ),
        PopupMenuItem(
          onTap: () {
            selectedStatus = PaymentStatus.refunded.name;
            filterTransactions(PaymentStatus.refunded.name);
          },
          child: DText(context.tr.refunded),
        ),
        PopupMenuItem(
          onTap: () {
            selectedStatus = PaymentStatus.cancelled.name;
            filterTransactions(PaymentStatus.cancelled.name);
          },
          child: DText(context.tr.cancelled),
        ),
        PopupMenuItem(
          onTap: () {
            selectedStatus = PaymentStatus.pendingRefund.name;
            filterTransactions(PaymentStatus.pendingRefund.name);
          },
          child: DText(context.tr.pendingRefund),
        ),
        PopupMenuItem(
          onTap: () {
            selectedStatus = PaymentStatus.refundInReview.name;
            filterTransactions(PaymentStatus.refundInReview.name);
          },
          child: DText(context.tr.refundInReview),
        ),
      ],
    );
    return selectedStatus;
  }
}
