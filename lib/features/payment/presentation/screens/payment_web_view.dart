import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/payment/logic/transactions/transaction_bloc.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:dazzify/settings/theme/colors_scheme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mwidgets/mwidgets.dart';

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

          // context.replaceRoute(const TransactionRoute());
          context.router.replaceAll([
            const AuthenticatedRoute(
              children: [
                BottomNavBarRoute(
                  children: [
                    ProfileTabRoute(
                      children: [
                        PaymentRoutes(
                          children: [
                            TransactionRoute(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ]);

          // context.navigateTo(const TransactionRoute());
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: widget.transactionBloc,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: context.colorScheme.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.pop();
              },
            ),
            title: Text(context.tr.payment),
          ),
          body: WebViewWidget(
            controller: controller,
          ),
        ));
  }
}
