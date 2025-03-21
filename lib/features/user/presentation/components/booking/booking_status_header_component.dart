import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/booking/logic/booking_cubit/booking_cubit.dart';
import 'package:dazzify/features/shared/enums/booking_status_enum.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_dialog.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:dazzify/features/user/presentation/bottom_sheets/add_review_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class BookingStatusHeaderComponent extends StatefulWidget {
  final bool isBookingFinished;
  final bool isRate;
  final String status;

  const BookingStatusHeaderComponent({
    super.key,
    required this.isBookingFinished,
    required this.isRate,
    required this.status,
  });

  @override
  State<BookingStatusHeaderComponent> createState() =>
      _BookingStatusHeaderComponentState();
}

class _BookingStatusHeaderComponentState
    extends State<BookingStatusHeaderComponent> {
  late final BookingCubit bookingCubit;
  bool isButtonActive = true;
  bool isCanceled = false;
  late BookingStatus bookingStatus;

  @override
  void initState() {
    super.initState();
    bookingCubit = context.read<BookingCubit>();
    bookingStatus = getBookingStatus(widget.status);
  }

  void changeButtonActivity() {
    final startTime = DateFormat()
        .parse(bookingCubit.state.singleBooking.startTime)
        .toLocal();
    final endTime =
        DateFormat().parse(bookingCubit.state.singleBooking.endTime).toLocal();
    if (DateTime.now().isAfter(startTime) && DateTime.now().isBefore(endTime)) {
      isButtonActive = false;
    } else {
      isButtonActive = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DazzifyAppBar(
          isLeading: true,
          title: context.tr.bookingStatus,
          textStyle: context.textTheme.bodyLarge,
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsetsDirectional.only(end: 12.r),
          child: buildStatusButton(),
        ),
      ],
    );
  }

  Widget buildStatusButton() {
    if (widget.isBookingFinished) {
      return rateBookingButton();
    } else if (bookingStatus != BookingStatus.cancelled) {
      return cancelBookingButton();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget rateBookingButton() {
    return PrimaryButton(
      width: 130.w,
      height: 35.h,
      onTap: () {
        widget.isRate
            ? null
            : showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                isScrollControlled: true,
                routeSettings: const RouteSettings(
                  name: "ReviewSheet",
                ),
                builder: (context) {
                  return BlocProvider.value(
                    value: bookingCubit,
                    child: const AddReviewSheet(),
                  );
                },
              );
      },
      title: widget.isRate
          ? bookingCubit.state.singleBooking.rating.rate.toString()
          : context.tr.rateService,
      prefixWidget: widget.isRate
          ? SvgPicture.asset(
              AssetsManager.rateStarBold,
              height: 16.h,
              width: 16.w,
              colorFilter: ColorFilter.mode(
                context.colorScheme.primary,
                BlendMode.srcIn,
              ),
            )
          : SvgPicture.asset(
              AssetsManager.rateStarOutline,
              height: 16.h,
              width: 16.w,
              colorFilter: ColorFilter.mode(
                context.colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
      isOutLined: true,
    );
  }

  Widget cancelBookingButton() {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state.cancelBookingState == UiState.success) {
          isCanceled = true;
        } else if (state.cancelBookingState == UiState.failure) {
          DazzifyToastBar.showError(message: state.errorMessage);
        }
      },
      child: PrimaryButton(
        width: 130.w,
        height: 35.h,
        onTap: () {
          if (!isCanceled) {
            showDialog(
              context: context,
              builder: (context) {
                return BlocProvider.value(
                  value: bookingCubit,
                  child: DazzifyDialog(
                    message: context.tr.cancelBookingValidation,
                    buttonTitle: context.tr.yes,
                    onTap: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      bookingCubit.cancelBooking();
                      context.maybePop();
                    },
                  ),
                );
              },
            );
          }
        },
        title: isCanceled ? context.tr.canceled : context.tr.cancelBooking,
        color: isCanceled ? Colors.red : null,
        textColor: isCanceled ? Colors.red : null,
        isOutLined: true,
        isActive: isButtonActive,
      ),
    );
  }
}
