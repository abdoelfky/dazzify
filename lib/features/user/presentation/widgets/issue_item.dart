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
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _issueBloc = context.read<IssueBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final services = widget.issue.services;
    final currentService = services[_currentIndex];

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
                SizedBox(
                  width: 80.w,
                  height: 110.h,
                  child: services.length > 1
                      ? CarouselSlider.builder(
                    itemCount: services.length,
                    itemBuilder: (context, index, realIndex) =>
                        cardImage(services[index].image),
                    options: CarouselOptions(
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      enlargeCenterPage: true,
                      enlargeFactor: 0.65.r,
                      viewportFraction: 1.1.r,
                      onPageChanged: (index, _) {
                        setState(() => _currentIndex = index);
                      },
                    ),
                  )
                      : cardImage(currentService.image),
                ),
                SizedBox(width: 16.w),

                // 🔄 Now synced with current carousel image
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    serviceInfo(
                      context: context,
                      title: currentService.title,
                      description: currentService.description,
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

        child: DText("${reformatPriceWithCommas(issue.price)} ${context.tr.egp}",
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
