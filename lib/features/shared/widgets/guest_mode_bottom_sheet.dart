import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/logic/tokens/tokens_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart'; // Custom sheet body widget
import 'package:dazzify/features/shared/widgets/primary_button.dart'; // Custom button widget

class GuestModeBottomSheet extends StatefulWidget {
  const GuestModeBottomSheet({super.key});

  @override
  State<GuestModeBottomSheet> createState() => _GuestModeBottomSheetState();
}

class _GuestModeBottomSheetState extends State<GuestModeBottomSheet> {
  late final PageController _pageController;
  late TokensCubit _tokensCubit;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tokensCubit = context.read<TokensCubit>();

  }
  @override
  Widget build(BuildContext context) {
    return DazzifySheetBody(
      title: '',
      height: context.isKeyboardClosed
          ? context.screenHeight * 0.50
          : context.screenHeight * 0.85,
      children: [
        // Expanded widget to allow for PageView
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // Lock Icon and "Login" Text
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock,
                      size: 40.0, // Lock icon size
                      color: context.colorScheme.primary, // Lock icon color from theme
                    ),
                    SizedBox(height: 20.0),
                    DText(
                      textAlign: TextAlign.center,
                      context.tr.pleaseLoginToFreelyAccessAppFeatures, // Localization key for the text
                      style: TextStyle(
                        fontSize: 15.0.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    // Button to Navigate to Sign-in Screen
                    PrimaryButton(
                      onTap: () => _tokensCubit.deleteUserTokens(), // Correctly passing context
                      title: context.tr.goToLogin, // Localization key for button
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
