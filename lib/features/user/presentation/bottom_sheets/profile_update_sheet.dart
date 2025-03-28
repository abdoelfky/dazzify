import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/core/util/validation_manager.dart';
import 'package:dazzify/features/shared/widgets/dazzify_birthdate_picker.dart';
import 'package:dazzify/features/shared/widgets/dazzify_drop_down_button_field.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart';
import 'package:dazzify/features/shared/widgets/dazzify_svg_icon.dart';
import 'package:dazzify/features/shared/widgets/dazzify_text_form_field.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';

class ProfileUpdateSheet extends StatefulWidget {
  const ProfileUpdateSheet({super.key});

  @override
  State<ProfileUpdateSheet> createState() => _ProfileUpdateSheetState();
}

class _ProfileUpdateSheetState extends State<ProfileUpdateSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  // final TextEditingController ageController = TextEditingController();
  final TextEditingController birthDayController = TextEditingController();
  late String selectedGender;
  late String birthDay;
  // late int age;

  bool isLoading = false;
  late final profileCubit = context.read<UserCubit>();
  late ValueNotifier isActive;
  bool hasDropDownOpened = false;

  @override
  void initState() {
    fullNameController.text = profileCubit.state.userModel.fullName;
    emailController.text = profileCubit.state.userModel.profile.email;
    selectedGender = profileCubit.state.userModel.profile.gender;
    birthDayController.text = profileCubit.state.userModel.profile.birthDay;
    isActive = ValueNotifier(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: DazzifySheetBody(
        title: context.tr.infoUpdate,
        height: context.isKeyboardClosed || hasDropDownOpened
            ? context.screenHeight * 0.65
            : context.screenHeight * 0.96,
        children: [
          SizedBox(height: 8.r),
          Divider(color: context.colorScheme.surface),
          SizedBox(height: 16.r),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(
                left: 14.0,
                right: 14.0,
                bottom: 36.0,
              ).r,
              children: [
                DazzifyTextFormField(
                  textInputType: TextInputType.text,
                  label: context.tr.fullName,
                  prefixIconData: SolarIconsOutline.user,
                  maxLength: 55,
                  controller: fullNameController,
                  onSaved: (value) {},
                  onChanged: (value) {
                    checkActivity();
                  },
                ),
                SizedBox(height: 8.h),
                DazzifyTextFormField(
                  textInputType: TextInputType.emailAddress,
                  label: context.tr.email,
                  prefixIconData: SolarIconsOutline.letter,
                  controller: emailController,
                  validator: ValidationManager.emailValidator(context),
                  onSaved: (value) {},
                  onChanged: (value) {
                    checkActivity();
                  },
                ),
                SizedBox(height: 8.h),
                // DazzifyTextFormField(
                //   textInputType: TextInputType.number,
                //   maxLength: 2,
                //   prefixIconData: SolarIconsOutline.confetti,
                //   controller: ageController,
                //   validator: ValidationManager.ageValidator(
                //     context: context,
                //     label: context.tr.age,
                //   ),
                //   onSaved: (value) {
                //     if (value != null) {
                //       age = int.parse(value);
                //     }
                //   },
                //   onChanged: (value) {
                //     age = int.parse(value);
                //     checkActivity();
                //   },
                // ),
                DazzifyBirthdatePicker(
                  hintText: context.tr.birthDate,
                  // label: context.localizedText.birthDate,
                  prefixIconData: SolarIconsOutline.confetti,

                  validator: ValidationManager.ageValidator(
                    context: context,
                    label: context.tr.birthDate,
                  ),

                  // onSaved: (value) {
                  //
                  //   if (value != null) {
                  //     birthDay = value;
                  //     checkActivity();
                  //
                  //     // age = int.parse(value);
                  //   }
                  // },
                  onChanged: (value) {

                  if (value != null) {
                    birthDay = value;
                    checkActivity();
                  }
                },
                ),

                SizedBox(height: 8.r),
                DazzifyDropDownButtonField(
                  hintText: selectedGender == AppConstants.male
                      ? context.tr.male
                      : context.tr.female,
                  prefixIcon: DazzifySvgIcon(
                    svgIconPath: AssetsManager.genderIcon,
                    color: context.colorScheme.outline,
                  ),
                  dropDownItems: [
                    DropdownMenuItem(
                      value: AppConstants.male,
                      child: DText(context.tr.male),
                    ),
                    DropdownMenuItem(
                      value: AppConstants.female,
                      child: DText(context.tr.female),
                    ),
                  ],
                  onChanged: (value) {
                    selectedGender = value;
                    checkActivity();
                  },
                  onMenuOpen: (isOpened) {
                    setState(() {
                      hasDropDownOpened = isOpened;
                    });
                  },
                  onSaved: (value) {
                    if (value != null) {
                      selectedGender = value;
                    }
                  },
                ),
                SizedBox(height: 50.r),
                BlocConsumer<UserCubit, UserState>(
                  listener: (context, state) {
                    if (state.updateProfileState == UiState.loading) {
                      isLoading = true;
                    } else if (state.updateProfileState == UiState.success) {
                      context.maybePop();
                      DazzifyToastBar.showSuccess(
                        message: context.tr.dataUpdated,
                      );
                      isLoading = false;
                    } else if (state.updateProfileState == UiState.failure) {
                      DazzifyToastBar.showError(
                        message: state.errorMessage,
                      );
                      isLoading = false;
                    } else {
                      isLoading = false;
                    }
                  },
                  builder: (context, state) {
                    return ValueListenableBuilder(
                      valueListenable: isActive,
                      builder: (context, value, child) => PrimaryButton(
                        isLoading: isLoading,
                        title: context.tr.update,
                        isActive: isActive.value,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            if (nameChanged()) {
                              profileCubit.updateProfileName(
                                fullName: fullNameController.text,
                              );
                            }
                            if (emailChanged() ||
                                genderChanged() ||
                                birthDayChanged()) {
                              profileCubit.updateProfileInfo(
                                email: emailController.text,

                                birthDay: TimeManager.reformatDateToDDMMYYYY(birthDay),
                                // age: age,
                                gender: selectedGender,
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool nameChanged() {
    return profileCubit.state.userModel.fullName != fullNameController.text;
  }

  bool emailChanged() {
    return profileCubit.state.userModel.profile.email != emailController.text;
  }

  bool genderChanged() {
    return profileCubit.state.userModel.profile.gender.toLowerCase() !=
        selectedGender.toLowerCase();
  }

  // bool ageChanged() {
  //   return profileCubit.state.userModel.profile.age != age;
  // }
  bool birthDayChanged() {
    return profileCubit.state.userModel.profile.birthDay != birthDay;
  }

  void checkActivity() {
    isActive.value =
        nameChanged() || emailChanged() || genderChanged() || birthDayChanged();
  }
}
