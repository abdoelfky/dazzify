import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/validation_manager.dart';
import 'package:dazzify/features/shared/widgets/dazzify_text_form_field.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';

class UpdateNumberBody extends StatefulWidget {
  final PageController pageController;

  const UpdateNumberBody({super.key, required this.pageController});

  @override
  State<UpdateNumberBody> createState() => _UpdateNumberBodyState();
}

class _UpdateNumberBodyState extends State<UpdateNumberBody> {
  late final GlobalKey<FormState> _formKey;
  late final ValueNotifier<bool> _isFieldValid;
  late final TextEditingController _textEditingController;
  late UserCubit _profileCubit;
  late String phoneNumber;
  bool isLoading = false;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _isFieldValid = ValueNotifier(false);
    _textEditingController = TextEditingController();
    _profileCubit = context.read<UserCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state.updatePhoneNumberState == UiState.loading) {
          isLoading = true;
        } else if (state.updatePhoneNumberState == UiState.success) {
          DazzifyToastBar.showSuccess(
            message: context.tr.sendOtpSuccess,
          );
          widget.pageController.animateToPage(
            1,
            duration: const Duration(
              milliseconds: 300,
            ),
            curve: Curves.easeIn,
          );
          isLoading = false;
        } else if (state.updatePhoneNumberState == UiState.failure) {
          isLoading = false;
          DazzifyToastBar.showError(
            message: state.errorMessage,
          );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, bottom: 40).r,
          child: Form(
            key: _formKey,
            child: Center(
              child: ListView(
                children: [
                  Center(
                    child: DText(
                      context.tr.changePhoneNumber,
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(height: 65.h),
                  ValueListenableBuilder(
                    valueListenable: _isFieldValid,
                    builder: (context, value, child) => DazzifyTextFormField(
                      controller: _textEditingController,
                      textInputType: TextInputType.number,
                      hintText: context.tr.enterNewPhoneNumber,
                      maxLength: AppConstants.phoneNumberLength,
                      prefixIconData: SolarIconsOutline.phone,
                      isFieldValid: value,
                      validator: ValidationManager.changePhoneNumberValidator(
                        context: context,
                        currentNumber: state.userModel.phoneNumber,
                      ),
                      onChanged: (value) {
                        _isFieldValid.value = _formKey.currentState!.validate();
                      },
                      onSaved: (value) {
                        if (value != null) {
                          phoneNumber = value;
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 65.h),
                  PrimaryButton(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();
                        FocusManager.instance.primaryFocus?.unfocus();
                        await _profileCubit.updatePhoneNumber(
                          newPhoneNumber: phoneNumber,
                        );
                      }
                    },
                    title: context.tr.changePhoneNumber,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _textEditingController.dispose();
    super.dispose();
  }
}
