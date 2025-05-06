import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart'; // Custom sheet body widget

class CommentsClosedBottomSheet extends StatefulWidget {
  const CommentsClosedBottomSheet({super.key});

  @override
  State<CommentsClosedBottomSheet> createState() => _CommentsClosedBottomSheetState();
}

class _CommentsClosedBottomSheetState extends State<CommentsClosedBottomSheet> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

  }
  @override
  Widget build(BuildContext context) {
    return DazzifySheetBody(
      title: '',
      height: context.isKeyboardClosed
          ? context.screenHeight * 0.35
          : context.screenHeight * 0.50,
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
                  mainAxisAlignment: MainAxisAlignment.start,
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
                      context.tr.commentsClosedByProvider, // Localization key for the text
                      style: TextStyle(
                        fontSize: 15.0.sp,
                        fontWeight: FontWeight.w600,
                      ),
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
