import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/logic/booking_cubit/booking_cubit.dart';
import 'package:dazzify/features/payment/data/models/transaction_model.dart';
import 'package:dazzify/features/payment/presentation/widgets/transaction_bar.dart';
import 'package:dazzify/features/payment/presentation/widgets/transaction_button.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/enums/booking_status_enum.dart';
import 'package:dazzify/features/shared/enums/transaction_enum.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';
import 'package:dazzify/features/shared/widgets/dazzify_overlay_loading.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/features/user/presentation/components/booking/booking_status_header_component.dart';
import 'package:dazzify/features/user/presentation/components/booking/swipe_button_component.dart';
import 'package:dazzify/features/user/presentation/widgets/booking_badge.dart';
import 'package:dazzify/features/user/presentation/widgets/booking_info_item.dart';
import 'package:dazzify/features/user/presentation/widgets/multi_booking_widget.dart';
import 'package:dazzify/features/user/presentation/widgets/price_info_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
  late PageController _pageController;
  int _currentPageIndex = 0; // Track current page

  @override
  void initState() {
    bookingCubit = context.read<BookingCubit>();
    bookingCubit.checkLocationPermission();
    bookingCubit.getSingleBooking(widget.bookingId);
    _pageController = PageController();

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                final startTime =
                    DateTime.parse(state.singleBooking.startTime).toLocal();
                final now = DateTime.now();
                return DazzifyOverlayLoading(
                  isLoading: isLoading,
                  child: Column(
                    children: [
                      BookingStatusHeaderComponent(
                        startTime: state.singleBooking.startTime,
                        refundConditions:
                            state.singleBooking.brand.refundConditions,
                        isBookingFinished: state.singleBooking.isFinished,
                        isArrived: state.singleBooking.isArrived,
                        isRate: state.singleBooking.isRate,
                        status: bookingStatus,
                      ),
                      Expanded(
                        child: CustomFadeAnimation(
                          duration: const Duration(milliseconds: 500),
                          child: ListView(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16).r,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0)
                                        .r,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (bookingCubit.state.singleBooking
                                            .services.length >
                                        1)
                                      SizedBox(
                                        height: 140,
                                        child: PageView.builder(
                                          controller: _pageController,
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: bookingCubit.state
                                              .singleBooking.services.length,
                                          onPageChanged: (index) {
                                            setState(() {
                                              _currentPageIndex = index;
                                            });
                                          },
                                          itemBuilder: (context, index) =>
                                              MultiBookingWidget(
                                            service: bookingCubit.state
                                                .singleBooking.services[index],
                                            booking: bookingCubit,
                                          ),
                                        ),
                                      ),
                                    if (bookingCubit.state.singleBooking
                                            .services.length >
                                        1)
                                      Center(
                                        child: SmoothPageIndicator(
                                          controller: _pageController,
                                          count: bookingCubit.state
                                              .singleBooking.services.length,
                                          effect: ScrollingDotsEffect(
                                            activeDotColor:
                                                context.colorScheme.primary,
                                            dotColor: Colors.grey,
                                            dotHeight: 4.0.h,
                                            dotWidth: 20.0.h,
                                            spacing: 8.0.w,
                                          ),
                                        ),
                                      ),
                                    if (bookingCubit.state.singleBooking
                                            .services.length ==
                                        1)
                                      serviceInfo(context, bookingCubit),
                                    SizedBox(height: 16.h),
                                    bookingInfo(
                                        bookingCubit, _currentPageIndex),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                              vertical: 16.0)
                                          .r,
                                      child: const Divider(),
                                    ),

                                    priceInfo(
                                        context,
                                        bookingCubit,
                                        bookingCubit.state.singleBooking
                                            .services.length),
                                    SizedBox(height: 35.h),
                                    // if(state.singleBooking.payments.isNotEmpty)
                                    // Row(
                                    //   children: [
                                    //     TransactionBar(
                                    //       transaction: TransactionModel(
                                    //           id: state.singleBooking.payments
                                    //               .first.transactionId,
                                    //           bookingId: state.singleBooking.id,
                                    //           status: "not paid",
                                    //           amount: 22,
                                    //           refundAmount: 22,
                                    //           expiredAt: state.singleBooking
                                    //               .payments.first.expAt,
                                    //           createdAt: state.singleBooking
                                    //               .payments.first.createdAt,
                                    //           type: state.singleBooking.payments
                                    //               .first.type,
                                    //           services: []),
                                    //       onTimerFinish: () {
                                    //         // setState(() {
                                    //         //   widget.transaction.status =
                                    //         //       "cancelled";
                                    //         // });
                                    //       },
                                    //     ),
                                    //     const Spacer(),
                                    //     TransactionButton(
                                    //       status: "not paid",
                                    //       serviceName: state
                                    //           .singleBooking.services[0].title,
                                    //       transactionId: state.singleBooking
                                    //           .payments.first.transactionId,
                                    //     ),
                                    //   ],
                                    // ),

                                    DText(
                                      context.tr.readyForService,
                                      style: context.textTheme.titleMedium,
                                    ),
                                    SizedBox(height: 8.h),
                                    SwipeButtonComponent(
                                      status: bookingStatus,
                                      isFinished:
                                          state.singleBooking.isFinished,
                                      isArrived: state.singleBooking.isArrived,
                                      startTime: state.singleBooking.startTime,
                                    ),
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
        Stack(
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
            // if (service.quantity > 1)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.r, vertical: 2.r),
                decoration: BoxDecoration(
                  color: context.colorScheme.inversePrimary,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: DText('X${serviceInfo.services.first.quantity}',
                    style: context.textTheme.bodyMedium!
                        .copyWith(color: context.colorScheme.onSecondary)),
              ),
            ),
          ],
        ),
        SizedBox(width: 15.w),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 120.w,
                  child: DText(
                    maxLines: 2,
                    serviceInfo.services.first.title,
                    style: context.textTheme.bodyLarge,
                  ),
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

Widget bookingInfo(BookingCubit booking, int currentServiceIndex) {
  final bookingInfo = booking.state.singleBooking;
  final services = bookingInfo.services;
  final notes = bookingInfo.notes;

  final subtitle =
      (services.isNotEmpty && currentServiceIndex < services.length)
          ? TimeManager.bookingDurationForService(
              bookingStartTime: bookingInfo.startTime,
              serviceIndex: currentServiceIndex,
              services: services,
            )
          : "";

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
        subtitle: subtitle,
        isImage: false,
      ),
      if (notes != "") SizedBox(height: 16.h),
      if (notes != "")
        BookingInfoItem(
          icon: SolarIconsOutline.notes,
          title: DazzifyApp.tr.notes,
          subtitle: notes,
          isImage: false,
        ),
    ],
  );
}

Widget priceInfo(BuildContext context, BookingCubit booking, int length) {
  final priceInfo = booking.state.singleBooking;

  return Column(
    children: [
      if (length > 1)
        PriceInfoItem(
          title:
              '${DazzifyApp.tr.servicePrice} ( $length ${context.tr.services} )',
          price:
              "${reformatPriceWithCommas(priceInfo.price)} ${DazzifyApp.tr.egp}",
        ),
      if (length == 1)
        PriceInfoItem(
          title: DazzifyApp.tr.servicePrice,
          price:
              "${reformatPriceWithCommas(priceInfo.price)} ${DazzifyApp.tr.egp}",
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
        price:
            "${reformatPriceWithCommas(priceInfo.totalPrice)} ${DazzifyApp.tr.egp}",
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

int getTimeInMinute(String startTime) {
  final DateTime timeNow = DateTime.now();
  final DateTime targetTime = DateTime.parse(startTime).toLocal();
  final int minutesDifference = targetTime.difference(timeNow).inMinutes;

  return minutesDifference;
}
