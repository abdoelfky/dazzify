import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class ServiceBookingConfirmationScreen extends StatefulWidget {
  const ServiceBookingConfirmationScreen({
    super.key,
  });

  @override
  State<ServiceBookingConfirmationScreen> createState() =>
      _ServiceBookingConfirmationScreenState();
}

class _ServiceBookingConfirmationScreenState
    extends State<ServiceBookingConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 283.w,
                      height: 240.h,
                      child: Center(
                        child: SvgPicture.asset(
                          AssetsManager.clockSvg,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    SizedBox(
                      width: 283.r,
                      child: DText(
                        context.tr.bookingSuccess,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                PrimaryButton(
                  onTap: () {
                    context.navigateTo(const HomeRoute());
                  },
                  title: DazzifyApp.tr.backHome,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
