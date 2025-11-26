import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/util/app_config_manager.dart';
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
        top: false,
        child: Scaffold(
          body: BlocConsumer<BookingCubit, BookingState>(
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
                  TransactionType? transactionType;
                  final now = DateTime.now();
                  if (state.singleBooking.payments.isNotEmpty) {
                    transactionType = getTransactionType(
                        state.singleBooking.payments.first.type);
                  }
                  return DazzifyOverlayLoading(
                    isLoading: isLoading,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 60.0),
                          child: BookingStatusHeaderComponent(
                            startTime: state.singleBooking.startTime,
                            refundConditions:
                                state.singleBooking.brand.refundConditions,
                            isBookingFinished: state.singleBooking.isFinished,
                            isArrived: state.singleBooking.isArrived &&
                                state.singleBooking.isInBranch,
                            isRate: state.singleBooking.isRate,
                            status: bookingStatus,
                          ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (bookingCubit.state.singleBooking
                                              .services.length >
                                          1)
                                        SizedBox(
                                          height: 140.h,
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
                                              service: bookingCubit
                                                  .state
                                                  .singleBooking
                                                  .services[index],
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
                                      if (state.singleBooking.payments
                                              .isNotEmpty &&
                                          bookingStatus !=
                                              BookingStatus.cancelled)
                                        Container(
                                          padding: EdgeInsetsGeometry.symmetric(
                                              vertical: 10.h, horizontal: 10.w),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: context
                                                  .colorScheme.onTertiary),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .data_usage_outlined,
                                                        color: context
                                                            .colorScheme
                                                            .primary,
                                                        size: 16.r,
                                                      ),
                                                      SizedBox(width: 8.w),
                                                      DText(
                                                        transactionType!.name,
                                                        style: context.textTheme
                                                            .bodyMedium,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10.h),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    flex: 9,
                                                    child: TransactionBar(
                                                      transaction: TransactionModel(
                                                          id: state
                                                              .singleBooking
                                                              .payments
                                                              .first
                                                              .transactionId,
                                                          bookingId: state
                                                              .singleBooking.id,
                                                          status: "not paid",
                                                          amount: state
                                                              .singleBooking
                                                              .payments
                                                              .first
                                                              .amount,
                                                          refundAmount: 0,
                                                          expiredAt: state
                                                              .singleBooking
                                                              .payments
                                                              .first
                                                              .expAt,
                                                          createdAt: state
                                                              .singleBooking
                                                              .payments
                                                              .first
                                                              .createdAt,
                                                          type: state
                                                              .singleBooking
                                                              .payments
                                                              .first
                                                              .type,
                                                          services: []),
                                                      onTimerFinish: () {
                                                        bookingCubit
                                                            .getSingleBooking(
                                                                widget
                                                                    .bookingId);
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 4,
                                                    child: TransactionButton(
                                                      status: "not paid",
                                                      serviceName: state
                                                          .singleBooking
                                                          .services[0]
                                                          .title,
                                                      transactionId: state
                                                          .singleBooking
                                                          .payments
                                                          .first
                                                          .transactionId,
                                                      amount: state
                                                          .singleBooking
                                                          .payments
                                                          .first
                                                          .amount,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      DText(
                                        context.tr.readyForService,
                                        style: context.textTheme.titleMedium,
                                      ),
                                      SizedBox(height: 8.h),
                                      SwipeButtonComponent(
                                        status: bookingStatus,
                                        isFinished:
                                            state.singleBooking.isFinished,
                                        isArrived:
                                            state.singleBooking.isArrived,
                                        startTime:
                                            state.singleBooking.startTime,
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
                    serviceInfo.services.first.title,
                    softWrap: true,
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
                softWrap: true,
                style: context.textTheme.bodySmall!.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
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
  final deliveryRange = priceInfo.deliveryFeesRange;
  final hasDeliveryFees = priceInfo.deliveryFees != null;
  final bool hasFees = (AppConfigManager.appFeesMax != 0 &&
      AppConfigManager.appFeesMin != 0 &&
      AppConfigManager.appFeesPercentage != 0);
  final appFees = hasFees ? priceInfo.fees : 0.0;
  final hasTotalPrice = priceInfo.totalPrice != null;

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
      // Delivery Fees - Show value if available, otherwise show range
      if (hasDeliveryFees)
        PriceInfoItem(
          title: DazzifyApp.tr.deliferyFees,
          price: "${priceInfo.deliveryFees} ${DazzifyApp.tr.egp}",
        ),
      if (!hasDeliveryFees && deliveryRange != null)
        PriceInfoItem(
          title: DazzifyApp.tr.deliferyFees,
          price:
              "${DazzifyApp.tr.from} (${reformatPriceWithCommas(deliveryRange.from)}) ${DazzifyApp.tr.to} (${reformatPriceWithCommas(deliveryRange.to)}) ${DazzifyApp.tr.egp}",
        ),
      SizedBox(height: 16.h),
      // App Fees - Show value if available, otherwise show "will be calculated"
      PriceInfoItem(
        title: DazzifyApp.tr.appFees,
        price: !hasFees
            ? "$appFees ${DazzifyApp.tr.egp}"
            : DazzifyApp.tr.willBeCalculated,
      ),
      SizedBox(height: 16.h),
      customDivider(context),
      SizedBox(height: 24.h),
      // Total Price - Show value if available, otherwise show partial calculation with message
      if (hasTotalPrice)
        PriceInfoItem(
          title: DazzifyApp.tr.totalPrice,
          price:
              "${reformatPriceWithCommas(priceInfo.totalPrice!)} ${DazzifyApp.tr.egp}",
        ),
      if (!hasTotalPrice)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PriceInfoItem(
              title: DazzifyApp.tr.totalPrice,
              price:
                  "${reformatPriceWithCommas(priceInfo.price - priceInfo.couponDis)} ${DazzifyApp.tr.egp}",
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DText(
                  hasFees
                      ? DazzifyApp.tr.pleaseLoginToFreelyAccessAppFeatures
                      : DazzifyApp.tr.plusTransportation,
                  style: context.textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: const EdgeInsets.all(12).r,
              decoration: BoxDecoration(
                color:
                    context.colorScheme.inversePrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8).r,
              ),
              child: Row(
                children: [
                  Icon(
                    SolarIconsOutline.infoCircle,
                    size: 16.r,
                    color: context.colorScheme.primary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: DText(
                      DazzifyApp.tr.finalPriceAfterProviderAccepts,
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
