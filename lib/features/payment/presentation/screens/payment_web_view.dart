import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/features/payment/logic/transactions/transaction_bloc.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage()
class PaymentWebViewScreen extends StatefulWidget {
  final String url;
  final TransactionBloc transactionBloc;

  const PaymentWebViewScreen(
      {super.key, required this.url, required this.transactionBloc});

  @override
  State<PaymentWebViewScreen> createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url))
      ..addJavaScriptChannel(
        AppConstants.paymentChannel,
        onMessageReceived: (message) {
          widget.transactionBloc.add(const ResetTransactionsEvent());
          context.navigateTo(const TransactionRoute());
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.transactionBloc,
      child: SafeArea(
        child: Scaffold(
          body: WebViewWidget(
            controller: controller,
          ),
        ),
      ),
    );
  }
}
