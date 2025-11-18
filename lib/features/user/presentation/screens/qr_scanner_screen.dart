import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
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

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            DazzifyAppBar(
              isLeading: true,
              title: context.tr.qrCodeScanner,
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
                        if (barcode.rawValue != null) {
                          // Show the scanned QR code
                          DazzifyToastBar.showSuccess(
                            message:
                                '${context.tr.qrCodeDetected}: ${barcode.rawValue}',
                          );
                          // You can handle the QR code data here
                          // For example, navigate to another screen or process the data
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
