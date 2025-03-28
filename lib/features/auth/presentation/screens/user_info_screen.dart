import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/core/util/validation_manager.dart';
import 'package:dazzify/features/auth/logic/auth_cubit.dart';
import 'package:dazzify/features/auth/presentation/bottom_sheets/app_terms_bottom_sheet.dart';
import 'package:dazzify/features/auth/presentation/widgets/auth_header.dart';
import 'package:dazzify/features/shared/widgets/dazzify_birthdate_picker.dart';
import 'package:dazzify/features/shared/widgets/dazzify_drop_down_button_field.dart';
import 'package:dazzify/features/shared/widgets/dazzify_svg_icon.dart';
import 'package:dazzify/features/shared/widgets/dazzify_text_form_field.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';

@RoutePage()
class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late final GlobalKey<FormState> formKey;
  late String userName;
  late String emailAddress;
  late String gender;
  // late int age;
  late String birthDay;

  late AuthCubit authCubit;
  bool isLoading = false;

  @override
  void initState() {
    formKey = GlobalKey<FormState>();
    authCubit = context.read<AuthCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoadingState) {
            isLoading = true;
          } else if (state is AuthAddUserInfoSuccessState) {
            context.replaceRoute(const AuthenticatedRoute());
            isLoading = false;
          }
          if (state is AuthAddUserInfoFailureState) {
            DazzifyToastBar.showError(message: state.error);
            isLoading = false;
          }
        },
        child: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const AuthHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14.0,
                  vertical: 36.0,
                ).r,
                child: Column(
                  children: [
                    DText(
                      context.tr.userInfoScreenTitle,
                      style: context.textTheme.titleLarge,
                    ),
                    SizedBox(height: 24.h),
                    DazzifyTextFormField(
                      textInputType: TextInputType.text,
                      label: context.tr.name,
                      prefixIconData: SolarIconsOutline.user,
                      onSaved: (value) {
                        if (value != null) {
                          userName = value;
                        }
                      },
                    ),
                    SizedBox(height: 8.h),
                    DazzifyTextFormField(
                      textInputType: TextInputType.emailAddress,
                      label: context.tr.email,
                      prefixIconData: SolarIconsOutline.letter,
                      validator: ValidationManager.emailValidator(context),
                      onSaved: (value) {
                        if (value != null) {
                          emailAddress = value;
                        }
                      },
                    ),
                    SizedBox(height: 8.h),

                    // DazzifyTextFormField(
                    //   textInputType: TextInputType.number,
                    //   label: context.tr.age,
                    //   maxLength: 2,
                    //   prefixIconData: SolarIconsOutline.confetti,
                    //   validator: ValidationManager.ageValidator(
                    //     context: context,
                    //     label: context.tr.age,
                    //   ),
                    //   onSaved: (value) {
                    //     if (value != null) {
                    //       age = int.parse(value);
                    //     }
                    //   },
                    // ),
                    DazzifyBirthdatePicker(
                      hintText: context.tr.birthDate,
                      prefixIconData: SolarIconsOutline.confetti,

                      validator: ValidationManager.ageValidator(
                        context: context,
                        label: context.tr.birthDate,
                      ),

                      onSaved: (value) {

                        if (value != null) {
                          birthDay = value;

                          // age = int.parse(value);
                        }
                      },
                    ),
                    SizedBox(height: 8.h),
                    DazzifyDropDownButtonField(
                      hintText: context.tr.gender,
                      prefixIcon: DazzifySvgIcon(
                        svgIconPath: AssetsManager.genderIcon,
                        color: context.colorScheme.outline,
                      ),
                      validator: ValidationManager.dropDownValidator(
                        context: context,
                        label: context.tr.gender,
                      ),
                      dropDownItems: [
                        DropdownMenuItem(
                          value: AppConstants.male,
                          child: DText(
                            context.tr.male,
                          ),
                        ),
                        DropdownMenuItem(
                          value: AppConstants.female,
                          child: DText(
                            context.tr.female,
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          gender = value;
                        }
                      },
                    ),
                    SizedBox(height: 50.h),
                    PrimaryButton(
                      isLoading: isLoading,
                      title: context.tr.continueButton,
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          FocusManager.instance.primaryFocus?.unfocus();
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return AppTermsBottomSheet(
                                onAgreeTap: (hasAgreed) {
                                  if (hasAgreed) {
                                    authCubit.addUserInfo(
                                      fullName: userName,
                                      gender: gender,
                                      birthDay: TimeManager.reformatDateToDDMMYYYY(birthDay),
                                      email: emailAddress,
                                    );
                                  }
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }
}
