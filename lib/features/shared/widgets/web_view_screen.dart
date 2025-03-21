import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/widgets/glass_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage()
class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({super.key, required this.url});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            WebViewWidget(
              controller: controller,
            ),
            PositionedDirectional(
              top: 30,
              start: 16,
              child: GlassIconButton(
                icon: context.currentTextDirection == TextDirection.ltr
                    ? SolarIconsOutline.arrowLeft
                    : SolarIconsOutline.arrowRight,
                onPressed: () {
                  context.maybePop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
