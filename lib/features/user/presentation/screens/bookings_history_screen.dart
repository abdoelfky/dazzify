import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/features/user/logic/booking_history/booking_history_bloc.dart';
import 'package:dazzify/features/user/presentation/widgets/booking_card.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class BookingsHistoryScreen extends StatefulWidget implements AutoRouteWrapper {
  const BookingsHistoryScreen({super.key});

  @override
  State<BookingsHistoryScreen> createState() => _BookingsHistoryScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<BookingHistoryBloc>(
      create: (context) => getIt<BookingHistoryBloc>()
        ..add(
          const GetBookingHistoryEvent(),
        ),
      child: this,
    );
  }
}

class _BookingsHistoryScreenState extends State<BookingsHistoryScreen> {
  late final BookingHistoryBloc _bookingHistoryBloc;
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: false,
    );
    _bookingHistoryBloc = context.read<BookingHistoryBloc>();
    _controller.addListener(_onScroll);
  }

  void _onScroll() async {
    final maxScroll = _controller.position.maxScrollExtent;
    final currentScroll = _controller.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      _bookingHistoryBloc.add(
        const GetBookingHistoryEvent(),
      );
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          DazzifyAppBar(
            isLeading: true,
            title: context.tr.bookingsHistory,
          ),
          Expanded(
            child: BlocBuilder<BookingHistoryBloc, BookingHistoryState>(
              builder: (context, state) {
                switch (state.bookingsHistoryState) {
                  case UiState.initial:
                  case UiState.loading:
                    return const LoadingAnimation();
                  case UiState.failure:
                    return ErrorDataWidget(
                        errorDataType: DazzifyErrorDataType.screen,
                        message: state.errorMessage,
                        onTap: () {
                          _bookingHistoryBloc
                              .add(const GetBookingHistoryEvent());
                        });
                  case UiState.success:
                    if (state.bookingsHistory.isEmpty) {
                      return EmptyDataWidget(
                        message: context.tr.noBookingsYet,
                      );
                    } else {
                      return RepaintBoundary(
                        child: ListView.separated(
                          controller: _controller,
                          physics: const BouncingScrollPhysics(),
                          cacheExtent: 500.0,
                          itemCount: state.bookingsHistory.length + 1,
                          padding: const EdgeInsets.only(
                            top: 24,
                            bottom: 16,
                            right: 16,
                            left: 16,
                          ).r,
                        itemBuilder: (context, index) {
                          if (index >= state.bookingsHistory.length) {
                            if (state.hasReachedMax) {
                              return const SizedBox.shrink();
                            } else {
                              return SizedBox(
                                height: 30.h,
                                width: context.screenWidth,
                                child: const LoadingAnimation(),
                              );
                            }
                          } else {
                            final booking = state.bookingsHistory[index];
                            return RepaintBoundary(
                              child: GestureDetector(
                                onTap: () {
                                  context.pushRoute(
                                    BookingStatusRoute(bookingId: booking.id),
                                  );
                                },
                                child: BookingCard(
                                  services: booking.services,
                                  imageUrl: booking.services.first.image,
                                  title: booking.services.first.title,
                                  price: booking.services.first.price,
                                  startTime: booking.startTime,
                                ),
                              ),
                            );
                          }
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 16.h,
                          );
                        },
                        ),
                      );
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
