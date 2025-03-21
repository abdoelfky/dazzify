import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/widgets/dazzify_pin_input.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart';
import 'package:dazzify/features/user/presentation/bottom_sheets/update_phone_number/update_number_body.dart';
import 'package:dazzify/features/user/presentation/bottom_sheets/update_phone_number/verify_otp_body.dart';
import 'package:flutter/material.dart';

class UpdatePhoneNumberSheet extends StatefulWidget {
  const UpdatePhoneNumberSheet({super.key});

  @override
  State<UpdatePhoneNumberSheet> createState() => _UpdatePhoneNumberSheetState();
}

class _UpdatePhoneNumberSheetState extends State<UpdatePhoneNumberSheet> {
  late final PageController _pageController;

  late String phoneNumber;
  late String otpCode;
  bool isLoading = false;
  DazzifyPinState dazzifyPinState = DazzifyPinState.normal;

  @override
  void initState() {
    _pageController = PageController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DazzifySheetBody(
      title: '',
      height: context.isKeyboardClosed
          ? context.screenHeight * 0.50
          : context.screenHeight * 0.85,
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              UpdateNumberBody(pageController: _pageController),
              VerifyOtpBody(pageController: _pageController),
            ],
          ),
        ),
      ],
    );
  }
}
