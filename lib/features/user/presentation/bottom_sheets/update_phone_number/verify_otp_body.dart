import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/features/shared/widgets/dazzify_pin_input.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';

class VerifyOtpBody extends StatefulWidget {
  final PageController pageController;

  const VerifyOtpBody({super.key, required this.pageController});

  @override
  State<VerifyOtpBody> createState() => _VerifyOtpBodyState();
}

class _VerifyOtpBodyState extends State<VerifyOtpBody> {
  late String otpCode;
  late UserCubit _profileCubit;
  DazzifyPinState dazzifyPinState = DazzifyPinState.normal;
  bool isLoading = false;
  late GlobalKey<FormState> _formKey;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _profileCubit = context.read<UserCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state.verifyOtpState == UiState.loading) {
          isLoading = true;
          dazzifyPinState = DazzifyPinState.normal;
        } else if (state.verifyOtpState == UiState.success) {
          dazzifyPinState = DazzifyPinState.success;
          isLoading = false;
          DazzifyToastBar.showSuccess(
            message: context.tr.phoneNumberChangedSuccessfully,
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) {
              context.maybePop();
            }
          });
        } else if (state.verifyOtpState == UiState.failure) {
          isLoading = false;
          dazzifyPinState = DazzifyPinState.error;
        }
      },
      builder: (context, state) {
        if (state.verifyOtpState == UiState.failure) {
          return ErrorDataWidget(
            errorDataType: DazzifyErrorDataType.sheet,
            message: state.errorMessage,
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                FocusManager.instance.primaryFocus?.unfocus();
                await _profileCubit.verifyUpdatePhoneNumber(
                  otp: otpCode,
                );
              }
            },
          );
        } else {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0).r,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => widget.pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut),
                        icon: Icon(
                          context.currentTextDirection == TextDirection.ltr
                              ? SolarIconsOutline.arrowLeft
                              : SolarIconsOutline.arrowRight,
                          size: 20.r,
                          color: context.colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(flex: 1),
                      DText(
                        context.tr.verifyPhoneNumber,
                        style: context.textTheme.titleLarge,
                      ),
                      const Spacer(flex: 2)
                    ],
                  ),
                ),
                SizedBox(height: 65.h),
                DazzifyPinInput(
                  dazzifyPinState: dazzifyPinState,
                  onPinEntered: (pin) {
                    otpCode = pin;
                  },
                ),
                SizedBox(height: 65.h),
                PrimaryButton(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      _logger.logEvent(event: AppEvents.profileSubmitEditPhone);
                      FocusManager.instance.primaryFocus?.unfocus();
                      await _profileCubit.verifyUpdatePhoneNumber(
                        otp: otpCode,
                      );
                    }
                  },
                  title: context.tr.updatePhoneNumber,
                  isLoading: isLoading,
                ),
                SizedBox(height: 40.h),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }
}
