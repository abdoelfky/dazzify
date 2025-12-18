import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/features/shared/enums/issue_status_enum.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/user/presentation/components/issue/issue_stepper.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class IssueStatusScreen extends StatefulWidget {
  final String status;
  final String? reply;

  const IssueStatusScreen(
      {super.key, required this.status, required this.reply});

  @override
  State<IssueStatusScreen> createState() => _IssueStatusScreenState();
}

class _IssueStatusScreenState extends State<IssueStatusScreen>
    with SingleTickerProviderStateMixin {
  late IssueStatus _issueStatus;
  late TabController _tabController;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    super.initState();
    _issueStatus = getIssueStatus(widget.status);
    _tabController = TabController(length: 3, vsync: this);
    _tabController.index = _issueStatus.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: DazzifyAppBar(
              isLeading: true,
              title: context.tr.issueStatus,
              onBackTap: () {
                _logger.logEvent(event: AppEvents.issueClickBack);
                context.maybePop();
              },
            ),
          ),
          IssueStepper(currentStep: _tabController.index),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                pendingTab(context),
                inProgressTab(context),
                replyTab(
                  reply: widget.reply,
                  context: context,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget pendingTab(BuildContext context) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          AssetsManager.issuePendingStep,
          height: 80.h,
          width: 80.w,
        ),
        SizedBox(height: 16.h),
        DText(
          context.tr.issuePending,
          style: context.textTheme.titleMedium,
        ),
        SizedBox(height: 8.h),
        DText(
          context.tr.yourIssuePending,
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

Widget inProgressTab(BuildContext context) {
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          AssetsManager.issueProgressStep,
          height: 150.h,
          width: 150.w,
        ),
        SizedBox(height: 16.h),
        DText(
          context.tr.issueProgress,
          style: context.textTheme.titleMedium,
        ),
        SizedBox(height: 8.h),
        DText(
          context.tr.yourIssueProgress,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium!.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

Widget replyTab({required String? reply, required BuildContext context}) {
  return Column(
    children: [
      SizedBox(height: 24.h),
      DText(
        textAlign: TextAlign.center,
        context.tr.issueChecked,
        style: context.textTheme.titleMedium!.copyWith(
          color: context.colorScheme.outline,
        ),
      ),
      SizedBox(height: 47.h),
      Stack(
        children: [
          Image.asset(
            context.isDarkTheme
                ? AssetsManager.issueReplyStepDark
                : AssetsManager.issueReplyStepLight,
          ),
          Padding(
            padding: const EdgeInsets.all(16).r,
            child: DText(
              reply ?? '',
              style: context.textTheme.titleMedium,
              maxLines: 5,
            ),
          ),
        ],
      )
    ],
  );
}
