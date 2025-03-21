import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/logic/booking_cubit/booking_cubit.dart';
import 'package:dazzify/features/home/presentation/widgets/last_active_booking_item.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/section_widget.dart';

class LastActiveBookingComponent extends StatelessWidget {
  const LastActiveBookingComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        switch (state.lastActiveBookingState) {
          case UiState.initial:
          case UiState.loading:
            return SizedBox(
              height: 125.h,
              child: DazzifyLoadingShimmer(
                dazzifyLoadingType: DazzifyLoadingType.listView,
                scrollDirection: Axis.horizontal,
                listViewItemCount: 3,
                cardWidth: 250.w,
                cardHeight: 125.h,
                borderRadius: BorderRadius.circular(12).r,
              ),
            );
          case UiState.failure:
            return Center(child: DText(state.errorMessage));
          case UiState.success:
            if (state.lastActiveBookings.isEmpty) {
              return const SizedBox.shrink();
            } else {
              return Column(
                children: [
                  SectionWidget(sectionTitle: context.tr.bookingStatus),
                  SizedBox(height: 16.h),
                  SizedBox(
                    height: 125.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.lastActiveBookings.length,
                      itemBuilder: (context, index) {
                        final booking = state.lastActiveBookings[index];
                        return Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: 15.0.r,
                            end: 8.0.r,
                          ),
                          child: LastActiveBookingItem(booking: booking),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
        }
      },
    );
  }
}
