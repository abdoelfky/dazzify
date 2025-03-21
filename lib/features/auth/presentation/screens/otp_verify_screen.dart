import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/auth/logic/auth_cubit.dart';
import 'package:dazzify/features/auth/presentation/widgets/auth_header.dart';
import 'package:dazzify/features/auth/presentation/widgets/otp_timer.dart';
import 'package:dazzify/features/shared/widgets/dazzify_pin_input.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';

@RoutePage()
class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({
    super.key,
  });

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  late final AuthCubit _authCubit;
  late GlobalKey<FormState> formKey;
  bool isLoading = false;
  DazzifyPinState dazzifyPinState = DazzifyPinState.normal;
  late String otpCode;

  @override
  void initState() {
    _authCubit = context.read<AuthCubit>();
    isLoading = false;
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthVerifyOtpLoadingState) {
            isLoading = true;
            dazzifyPinState = DazzifyPinState.normal;
          } else if (state is AuthValidateNewUserOtpSuccess) {
            isLoading = false;
            dazzifyPinState = DazzifyPinState.success;
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                context.replaceRoute(const UserInfoRoute());
              }
            });
          } else if (state is AuthValidateExistUserOtpSuccess) {
            isLoading = false;
            dazzifyPinState = DazzifyPinState.success;
            Future.delayed(const Duration(milliseconds: 500), () {
              if (context.mounted) {
                context.replaceRoute(const AuthenticatedRoute());
              }
            });
          } else if (state is AuthValidateUserOtpFailure) {
            isLoading = false;
            dazzifyPinState = DazzifyPinState.error;
            DazzifyToastBar.showError(message: state.error);
          }
        },
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Column(
              children: [
                const AuthHeader(),
                const Spacer(flex: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 8,
                  ).r,
                  child: DText(
                    context.tr.otpScreenTitle,
                    style: context.textTheme.titleLarge,
                  ),
                ),
                const Spacer(flex: 3),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 8,
                  ).r,
                  child: DazzifyPinInput(
                    dazzifyPinState: dazzifyPinState,
                    onPinEntered: (pin) {
                      otpCode = pin;
                      _authCubit.validateOtp(otpCode: otpCode);
                    },
                  ),
                ),
                const Spacer(flex: 2),
                OtpTimer(
                  onResendPress: _authCubit.sendOtp,
                ),
                const Spacer(flex: 2),
                PrimaryButton(
                  isLoading: isLoading,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      _authCubit.validateOtp(otpCode: otpCode);
                    }
                  },
                  title: context.tr.otpVerifyButtonTitle,
                ),
                const Spacer(flex: 4),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }
}
