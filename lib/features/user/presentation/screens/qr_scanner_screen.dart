import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

@RoutePage()
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _hasScanned = false;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    super.initState();
    // Reset the scan flag when screen loads
    _hasScanned = false;
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset scan flag when returning to this screen
    _hasScanned = false;
  }

  void _handleQrCode(String qrCode) {
    if (_hasScanned) return;

    _hasScanned = true;
    _logger.logEvent(event: AppEvents.qrCodeScan);

    // Check if the QR code matches the tiered coupon rewards URL
    if (qrCode == 'https://www.dazzifyapp.com/tiered-coupon-rewards') {
      // Navigate to tiered coupon rewards screen
      context.pushRoute(const TieredCouponRewardsWrapperRoute());
    } else {
      // Show invalid QR code message
      DazzifyToastBar.showError(
        message: context.tr.invalidQrCode,
      );

      // Reset after a delay to allow scanning again
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _hasScanned = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          _logger.logEvent(event: AppEvents.qrCodeClickBack);
        }
      },
      child: Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: DazzifyAppBar(
              isLeading: true,
              title: context.tr.qrCodeScanner,
              onBackTap: () {
                _logger.logEvent(event: AppEvents.qrCodeClickBack);
                context.maybePop();
              },
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                // Camera view
                MobileScanner(
                  controller: cameraController,
                  onDetect: (capture) {
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (barcode.rawValue != null && !_hasScanned) {
                        _handleQrCode(barcode.rawValue!);
                      }
                    }
                  },
                ),
                // Scanning frame overlay
                Center(
                  child: Container(
                    width: 250.w,
                    height: 250.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: context.colorScheme.primary,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                // Instructions text
                Positioned(
                  bottom: 100.h,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 32.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      context.tr.pointCameraAtQr,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Flash toggle button
                Positioned(
                  bottom: 30.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: IconButton(
                      icon: ValueListenableBuilder(
                        valueListenable: cameraController,
                        builder: (context, state, child) {
                          return Icon(
                            state.torchState == TorchState.on
                                ? Icons.flash_on
                                : Icons.flash_off,
                            color: Colors.white,
                            size: 32.r,
                          );
                        },
                      ),
                      onPressed: () => cameraController.toggleTorch(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
