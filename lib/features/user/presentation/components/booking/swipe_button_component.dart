import 'package:dazzify/core/constants/app_events.dart';
import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/services/app_events_logger.dart';
import 'package:dazzify/features/booking/logic/booking_cubit/booking_cubit.dart';
import 'package:dazzify/features/shared/enums/booking_status_enum.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/permission_dialog.dart';
import 'package:dazzify/features/shared/widgets/swipe_button/dazzify_swipe_button.dart';
import 'package:dazzify/features/shared/widgets/swipe_button/dazzify_swipe_button_controller.dart';

class SwipeButtonComponent extends StatefulWidget {
  final BookingStatus status;
  final bool isFinished;
  final bool isArrived;
  final String startTime;

  const SwipeButtonComponent({
    super.key,
    required this.status,
    required this.isFinished,
    required this.isArrived,
    required this.startTime,
  });

  @override
  State<SwipeButtonComponent> createState() => _SwipeButtonComponentState();
}

class _SwipeButtonComponentState extends State<SwipeButtonComponent> {
  late final BookingCubit bookingCubit;
  late BookingStatus bookingStatus;
  Key swipeButtonKey = UniqueKey();
  late final DazzifySwipeButtonController dazzifySwipeButtonController;
  final AppEventsLogger _logger = getIt<AppEventsLogger>();

  @override
  void initState() {
    super.initState();
    dazzifySwipeButtonController = DazzifySwipeButtonController();
    bookingCubit = context.read<BookingCubit>();
    // bookingStatus = getBookingStatus(widget.status);
  }

  @override
  void dispose() {
    dazzifySwipeButtonController.dispose();
    super.dispose();
  }

  int getTimeInMinute() {
    final DateTime timeNow = DateTime.now();
    final DateTime targetTime = DateTime.parse(widget.startTime).toLocal();
    final int minutesDifference = targetTime.difference(timeNow).inMinutes;

    return minutesDifference;
  }

  @override
  Widget build(BuildContext context) {
    if (getTimeInMinute() <= 60 &&
        // getTimeInMinute() < 0 &&
        widget.status == BookingStatus.confirmed &&
        !widget.isArrived) {
      return swipeButton();
    } else {
      if (widget.status == BookingStatus.pending) {
        return normalButton(
          context.tr.bookingPending,
          false,
        );
      } else if (widget.status == BookingStatus.cancelled) {
        return normalButton(
          context.tr.bookingCanceled,
          false,
        );
      } else if (widget.status == BookingStatus.confirmed &&
          getTimeInMinute() > 60) {
        return normalButton(
          context.tr.bookingConfirmed,
          false,
        );
      } else if (widget.isFinished == false && widget.isArrived) {
        return normalButton(
          context.tr.hereWeGo,
          widget.isArrived,
        );
      } else if (widget.isFinished == false) {
        return normalButton(
          context.tr.readyForService,
          false,
        );
      } else {
        return normalButton(
          context.tr.serviceDone,
          false,
        );
      }
    }
  }

  Widget normalButton(String title, bool isArrived) {
    return Container(
      height: 52.h,
      width: context.screenWidth,
      decoration: BoxDecoration(
        color: context.colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(5).r,
      ),
      child: Center(
        child: isArrived
            ? Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isArrived)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        SolarIconsOutline.checkCircle,
                        size: 18.r,
                        color: ColorsManager.successColor,
                      ),
                    ),
                  SizedBox(width: 2.w),
                  DText(
                    // textAlign: TextAlign.center,
                    title,
                    // maxLines: 3,
                    style: context.textTheme.titleMedium!.copyWith(
                      color: context.colorScheme.outlineVariant,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isArrived)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        SolarIconsOutline.checkCircle,
                        size: 18.r,
                        color: ColorsManager.successColor,
                      ),
                    ),
                  // SizedBox(width: 5.w),
                  Expanded(
                    child: DText(
                      textAlign: TextAlign.center,
                      title,
                      maxLines: 3,
                      style: context.textTheme.titleMedium!.copyWith(
                        color: context.colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget swipeButton() {
    return BlocListener<BookingCubit, BookingState>(
      listener: (BuildContext context, BookingState state) {
        if (state.userArrivedState == UiState.failure) {
          dazzifySwipeButtonController.resetSwipeState();
          DazzifyToastBar.showError(
            message: state.errorMessage,
          );
        }
        if (state.locationPermissionsState ==
            PermissionsState.permanentlyDenied) {
          dazzifySwipeButtonController.resetSwipeState();
          showPermissionDialog(
            context,
            icon: Icons.location_on_outlined,
            description: context.tr.locationPermissionDialog,
          );
        }
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: DazzifySwipeButton(
          onSwipe: () {
            _logger.logEvent(event: AppEvents.bookingStatusSwipeArrive);
            bookingCubit.userArrived();
          },
          title: context.tr.swipe,
          swipedTitle: context.tr.arrived,
          dazzifySwipeButtonController: dazzifySwipeButtonController,
        ),
      ),
    );
  }
}
