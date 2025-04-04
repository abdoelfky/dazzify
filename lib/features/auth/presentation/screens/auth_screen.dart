import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/framework/dazzify_text.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/core/util/validation_manager.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource.dart';
import 'package:dazzify/features/auth/data/data_sources/local/auth_local_datasource_impl.dart';
import 'package:dazzify/features/auth/logic/auth_cubit.dart';
import 'package:dazzify/features/auth/presentation/widgets/auth_header.dart';
import 'package:dazzify/features/shared/widgets/dazzify_text_form_field.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:solar_icons/solar_icons.dart';

@RoutePage()
class AuthScreen extends StatefulWidget {

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController phoneController;

  late final ValueNotifier<bool> isFieldValid;
  bool isLoading = false;
  bool isGuestLoading = false;
  late final AuthCubit authCubit;
  late String phoneNumber;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    isFieldValid = ValueNotifier(false);
    phoneController = TextEditingController();
    authCubit = context.read<AuthCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: formKey,
        child: Column(
          children: [
            const AuthHeader(isLogoAnimated: true),
            const Spacer(flex: 1),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14.0,
                vertical: 4,
              ).r,
              child: Column(
                children: [
                  DText(
                    context.tr.authScreenTitle,
                    style: context.textTheme.titleLarge,
                  ),
                  SizedBox(height: 60.h),
                  ValueListenableBuilder(
                    valueListenable: isFieldValid,
                    builder: (context, value, child) => DazzifyTextFormField(
                      controller: phoneController,
                      textInputType: TextInputType.number,
                      label: context.tr.phoneNumber,
                      maxLength: AppConstants.phoneNumberLength,
                      prefixIconData: SolarIconsOutline.phone,
                      isFieldValid: value,
                      validator: ValidationManager.phoneNumberValidator(
                          context: context),
                      onChanged: (value) {
                        isFieldValid.value = formKey.currentState!.validate();
                      },
                      onSaved: (value) {
                        if (value != null) {
                          phoneNumber = value;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(flex: 3),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthLoadingState) {
                  isLoading = true;
                }else if (state is GuestModeLoadingState) {
                  isGuestLoading = true;
                } else if (state is AuthVerifyNumberSuccessState) {
                  DazzifyToastBar.showSuccess(
                    message: context.tr.sendOtpSuccess,
                  );
                  if (!state.isResend) {
                    context.pushRoute(const OtpVerifyRoute());
                  }
                  isLoading = false;
                } else if (state is GuestModeSuccessState) {
                  context.pushRoute(const AuthenticatedRoute());

                  isGuestLoading = false;
                }else if (state is AuthVerifyNumberFailureState) {
                  DazzifyToastBar.showError(
                    message: context.tr.sendOtpError,
                  );
                  isLoading = false;
                }
              },
              builder: (context, state) {

                return Column(
                  children: [
                    PrimaryButton(
                      isLoading: isLoading,
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState?.save();
                          FocusManager.instance.primaryFocus?.unfocus();
                          await authCubit.sendOtp(phoneNumber: phoneNumber);
                        }
                      },
                      title: context.tr.authVerifyButtonTitle,
                    ),
                    const SizedBox(height: 10,),
                    if (AuthLocalDatasourceImpl().checkGuestModeSession())
                    PrimaryButton(
                      isLoading: isGuestLoading,
                      onTap: () async {
                        // if (formKey.currentState!.validate()) {
                        //   formKey.currentState?.save();
                          // FocusManager.instance.primaryFocus?.unfocus();
                        // context.pushRoute(const BottomNavBarRoute());
                          await authCubit.guestMode(isClicked:true);
                        // }
                      },
                      title: context.tr.guestMode,
                    ),
                  ],
                );
              },
            ),
            const Spacer(flex: 4),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    phoneController.dispose();
    isFieldValid.dispose();
    super.dispose();
  }
}
