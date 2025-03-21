import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/logic/booking_cubit/booking_cubit.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/enums/booking_status_enum.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/dazzify_overlay_loading.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/features/user/presentation/components/booking/booking_status_header_component.dart';
import 'package:dazzify/features/user/presentation/components/booking/swipe_button_component.dart';
import 'package:dazzify/features/user/presentation/widgets/booking_badge.dart';
import 'package:dazzify/features/user/presentation/widgets/booking_info_item.dart';
import 'package:dazzify/features/user/presentation/widgets/price_info_item.dart';

@RoutePage()
class BookingStatusScreen extends StatefulWidget {
  final String bookingId;

  const BookingStatusScreen({super.key, required this.bookingId});

  @override
  State<BookingStatusScreen> createState() => _BookingStatusScreenState();
}

class _BookingStatusScreenState extends State<BookingStatusScreen> {
  late final BookingCubit bookingCubit;
  bool isButtonDisabled = false;
  final DateTime timeNow = DateTime.now();
  late BookingStatus bookingStatus;
  bool isLoading = false;

  @override
  void initState() {
    bookingCubit = context.read<BookingCubit>();
    bookingCubit.checkLocationPermission();
    bookingCubit.getSingleBooking(widget.bookingId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await bookingCubit.getSingleBooking(widget.bookingId);
      },
      child: SafeArea(
        child: BlocConsumer<BookingCubit, BookingState>(
          listener: (context, state) {
            if (state.cancelBookingState == UiState.loading) {
              isLoading = true;
            } else {
              isLoading = false;
            }
          },
          builder: (context, state) {
            switch (state.singleBookingState) {
              case UiState.initial:
              case UiState.loading:
                return const LoadingAnimation();
              case UiState.failure:
                return ErrorDataWidget(
                    errorDataType: DazzifyErrorDataType.screen,
                    message: state.errorMessage,
                    onTap: () {
                      bookingCubit.getSingleBooking(widget.bookingId);
                    });
              case UiState.success:
                bookingStatus = getBookingStatus(state.singleBooking.status);
                return DazzifyOverlayLoading(
                  isLoading: isLoading,
                  child: Column(
                    children: [
                      BookingStatusHeaderComponent(
                        isBookingFinished: state.singleBooking.isFinished,
                        isRate: state.singleBooking.isRate,
                        status: state.singleBooking.status,
                      ),
                      Expanded(
                        child: CustomFadeAnimation(
                          duration: const Duration(milliseconds: 500),
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0).r,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    serviceInfo(context, bookingCubit),
                                    SizedBox(height: 16.h),
                                    bookingInfo(bookingCubit),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16.0,
                                      ).r,
                                      child: const Divider(),
                                    ),
                                    priceInfo(context, bookingCubit),
                                    SizedBox(height: 35.h),
                                    DText(
                                      context.tr.readyForService,
                                      style: context.textTheme.titleMedium,
                                    ),
                                    SizedBox(height: 8.h),
                                    SwipeButtonComponent(
                                      status: state.singleBooking.status,
                                      isFinished:
                                          state.singleBooking.isFinished,
                                      isArrived: state.singleBooking.isArrived,
                                      startTime: state.singleBooking.startTime,
                                    ),
                                    SizedBox(height: 16.h),
                                    if (bookingStatus == BookingStatus.pending)
                                      Center(
                                        child: DText(
                                          context.tr.getReadyForService,
                                          style: context.textTheme.bodySmall!
                                              .copyWith(
                                            color: context.colorScheme.outline,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

Widget serviceInfo(BuildContext context, BookingCubit booking) {
  final serviceInfo = booking.state.singleBooking;
  return SizedBox(
    height: 120.h,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8).r,
          child: DazzifyCachedNetworkImage(
            imageUrl: serviceInfo.services.first.image,
            fit: BoxFit.cover,
            width: 80.w,
            height: 100.h,
          ),
        ),
        SizedBox(width: 15.w),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DText(
                  serviceInfo.services.first.title,
                  style: context.textTheme.bodyLarge,
                ),
                SizedBox(width: 10.w),
                BookingBadge(
                  bookingStatus: getBookingStatus(serviceInfo.status),
                )
              ],
            ),
            SizedBox(height: 8.h),
            SizedBox(
              width: 180.w,
              child: DText(
                serviceInfo.services.first.description,
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget bookingInfo(BookingCubit booking) {
  final bookingInfo = booking.state.singleBooking;

  return Column(
    children: [
      BookingInfoItem(
        imageUrl: bookingInfo.brand.logo,
        title: bookingInfo.brand.name,
        subtitle: bookingInfo.branch.name,
        isImage: true,
        isVerified: bookingInfo.brand.verified,
      ),
      SizedBox(height: 16.h),
      BookingInfoItem(
        icon: SolarIconsOutline.mapPoint,
        title: DazzifyApp.tr.location,
        subtitle: bookingInfo.bookingLocation.name,
        isImage: false,
        hasLocationData: true,
        lat: bookingInfo.bookingLocation.latitude,
        long: bookingInfo.bookingLocation.longitude,
      ),
      SizedBox(height: 16.h),
      BookingInfoItem(
        icon: SolarIconsOutline.alarm,
        title: DazzifyApp.tr.duration,
        subtitle: TimeManager.bookingDuration(booking),
        isImage: false,
      ),
    ],
  );
}

Widget priceInfo(BuildContext context, BookingCubit booking) {
  final priceInfo = booking.state.singleBooking;

  return Column(
    children: [
      PriceInfoItem(
        title: DazzifyApp.tr.servicePrice,
        price: "${priceInfo.price} ${DazzifyApp.tr.egp}",
      ),
      SizedBox(height: 16.h),
      PriceInfoItem(
        title: DazzifyApp.tr.couponDisc,
        price: "(${priceInfo.couponDis} ${DazzifyApp.tr.egp})",
      ),
      SizedBox(height: 16.h),
      PriceInfoItem(
        title: DazzifyApp.tr.deliferyFees,
        price: "${priceInfo.deliveryFees} ${DazzifyApp.tr.egp}",
      ),
      SizedBox(height: 16.h),
      PriceInfoItem(
        title: DazzifyApp.tr.appFees,
        price: "${priceInfo.fees} ${DazzifyApp.tr.egp}",
      ),
      SizedBox(height: 16.h),
      customDivider(context),
      SizedBox(height: 24.h),
      PriceInfoItem(
        title: DazzifyApp.tr.totalPrice,
        price: "${priceInfo.totalPrice} ${DazzifyApp.tr.egp}",
      ),
    ],
  );
}

Widget customDivider(BuildContext context) {
  return Row(
    children: List.generate(
      500 ~/ 10,
      (index) => Expanded(
        child: Container(
          color: index % 2 == 0
              ? Colors.transparent
              : context.colorScheme.onSurfaceVariant,
          height: 1.h,
        ),
      ),
    ),
  );
}
