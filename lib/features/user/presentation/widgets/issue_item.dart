import 'package:carousel_slider/carousel_slider.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/shared/enums/issue_status_enum.dart';
import 'package:dazzify/features/shared/logic/settings/settings_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/user/data/models/issue/issue_model.dart';
import 'package:dazzify/features/user/logic/issue/issue_bloc.dart';
import 'package:dazzify/features/user/presentation/bottom_sheets/issue_sheet.dart';

class IssueItem extends StatefulWidget {
  final IssueModel issue;

  const IssueItem({
    super.key,
    required this.issue,
  });

  @override
  State<IssueItem> createState() => _IssueItemState();
}

class _IssueItemState extends State<IssueItem> {
  late IssueBloc _issueBloc;

  @override
  void initState() {
    super.initState();
    _issueBloc = context.read<IssueBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCardTap(
          context: context,
          issueBloc: _issueBloc,
          issue: widget.issue,
        );
      },
      child: BlocBuilder<IssueBloc, IssueState>(
        builder: (context, state) {
          return SizedBox(
            width: context.screenWidth,
            child: Row(
              children: [
                if (widget.issue.services.length > 1)
                  SizedBox(
                    width: 80.w,
                    height: 110.h,
                    child: CarouselSlider.builder(
                      itemCount: widget.issue.services.length,
                      itemBuilder: (context, index, realIndex) =>
                          cardImage(widget.issue.services[index].image),
                      options: CarouselOptions(
                        autoPlay: true,
                        // Enable auto-play
                        autoPlayInterval: const Duration(seconds: 3),
                        // Set auto-play interval
                        enlargeCenterPage: true,
                        // Enlarge the center page for focus
                        enlargeFactor: 0.65.r,
                        // Increase the size of the central item
                        viewportFraction: 1.1
                            .r, // Set the portion of the screen occupied by the current item
                      ),
                    ),
                  ),
                if (widget.issue.services.length == 1)
                  cardImage(widget.issue.services.first.image),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    serviceInfo(
                      context: context,
                      title: widget.issue.services.first.title,
                      description: widget.issue.services.first.description,
                    ),
                    SizedBox(height: 16.h),
                    priceAndStatus(context: context, issue: widget.issue),
                  ],
                ),
                const Spacer(),
                if (widget.issue.status.isEmpty) cardIcon(context),
              ],
            ),
          );
        },
      ),
    );
  }
}

void onCardTap({
  required BuildContext context,
  required IssueBloc issueBloc,
  required IssueModel issue,
}) {
  if (issue.status.isEmpty) {
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        routeSettings: const RouteSettings(
          name: "IssueSheet",
        ),
        builder: (context) {
          return BlocProvider.value(
            value: issueBloc,
            child: IssueSheet(
              bookingId: issue.bookingId,
              serviceTitle: issue.services.first.title,
            ),
          );
        });
  } else {
    context.pushRoute(
      IssueStatusRoute(
        status: issue.status,
        reply: issue.reply,
      ),
    );
  }
}

Widget cardImage(String imageUrl) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(8).r,
    child: DazzifyCachedNetworkImage(
      imageUrl: imageUrl,
      width: 80.w,
      height: 110.h,
      fit: BoxFit.cover,
    ),
  );
}

Widget serviceInfo({
  required BuildContext context,
  required String title,
  required String description,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 200.w,
        child: DText(
          title,
          style: context.textTheme.bodyLarge,
        ),
      ),
      SizedBox(height: 2.h),
      SizedBox(
        width: 200.w,
        child: DText(
          description,
          style: context.textTheme.bodySmall!.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    ],
  );
}

Widget priceAndStatus({
  required BuildContext context,
  required IssueModel issue,
}) {
  return Row(
    children: [
      SizedBox(
        width: context.screenWidth * 0.47,
        child: DText("${issue.price} ${context.tr.currency}",
            style: context.textTheme.bodyMedium),
      ),
      if (issue.status.isNotEmpty)
        DText(
          getIssueStatus(issue.status).name,
          style: context.textTheme.bodySmall!.copyWith(
            color: context.colorScheme.error,
          ),
        ),
    ],
  );
}

Widget cardIcon(BuildContext context) {
  return Icon(
    context.read<SettingsCubit>().state.currentLanguageCode ==
            AppConstants.enCode
        ? SolarIconsOutline.altArrowRight
        : SolarIconsOutline.altArrowLeft,
    size: 24.r,
  );
}
