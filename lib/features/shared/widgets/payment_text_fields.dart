import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/widgets/dazzify_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solar_icons/solar_icons.dart';

class CreditField extends StatelessWidget {
  const CreditField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return DazzifyTextFormField(
      controller: controller,
      suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8).r,
          child: Image.asset(AssetsManager.creditCardIconPng)
          //     SvgPicture.asset(
          //   //'assets/images/credit_card.svg',
          //   AssetsManager.creditCardIcon,
          // ),
          ),
      hintText: context.tr.creditCard,
      textInputType: TextInputType.number,
    );
  }
}

class AmountField extends StatelessWidget {
  const AmountField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return DazzifyTextFormField(
      controller: controller,
      suffixIcon: Padding(
        padding: const EdgeInsets.all(8.0).r,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(AssetsManager.dividerIcon),
            SizedBox(width: 8.r),
            SvgPicture.asset(AssetsManager.egpIcon),
          ],
        ),
      ),
      prefixIconData: SolarIconsOutline.banknote2,
      hintText: context.tr.amount,
      textInputType: TextInputType.number,
    );
  }
}

class HolderNameField extends StatelessWidget {
  const HolderNameField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return DazzifyTextFormField(
      controller: controller,
      prefixIconData: SolarIconsOutline.userRounded,
      hintText: context.tr.cardHolderName,
      textInputType: TextInputType.name,
    );
  }
}

class CVCField extends StatelessWidget {
  const CVCField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return DazzifyTextFormField(
      controller: controller,
      hintText: context.tr.cvc,
      textInputType: TextInputType.number,
    );
  }
}

class ExpireField extends StatelessWidget {
  const ExpireField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return DazzifyTextFormField(
      controller: controller,
      hintText: context.tr.expire,
      textInputType: TextInputType.number,
    );
  }
}

class PhoneField extends StatelessWidget {
  const PhoneField({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return DazzifyTextFormField(
        controller: controller,
        prefixIconData: SolarIconsOutline.phoneRounded,
        hintText: context.tr.phoneNumber,
        textInputType: TextInputType.phone);
  }
}
