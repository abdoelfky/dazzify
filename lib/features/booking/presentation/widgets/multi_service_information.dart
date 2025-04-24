import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/logic/service_invoice_cubit/service_invoice_cubit.dart';
import 'package:dazzify/features/brand/data/models/location_model.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';

class MultiServiceInformation extends StatelessWidget {
  final List<ServiceDetailsModel> services;  // Assuming services is a List
  final LocationModel? branchLocation;
  final ServiceInvoiceCubit invoiceCubit;
  final String selectedButton;
  final String selectedDate;
  final String fromTime;
  final String toTime;
  final Function onSelectLocationTap; // Define a variable to hold the method

  const MultiServiceInformation({
    required this.services,
    required this.branchLocation,
    required this.onSelectLocationTap,
    required this.invoiceCubit,
    required this.selectedButton,
    required this.selectedDate,
    required this.fromTime,
    required this.toTime,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total duration by summing up the duration of all services
    final totalDuration = services.fold<int>(
      0,
          (sum, service) => sum + service.duration, // Assuming `duration` is in minutes
    );

    return Column(
      children: [
        BlocBuilder<ServiceInvoiceCubit, ServiceInvoiceState>(
          builder: (context, state) {
            return Column(
              children: [
                Row(
                  children: [
                    Icon(
                      SolarIconsOutline.map,
                      size: 18.r,
                      color: context.colorScheme.onSurface,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    DText(
                      context.tr.location,
                      style: context.textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: ()
                      {
                        onSelectLocationTap();
                      }
                      //     () {
                      //   LocationModel? locationModel =
                      //   selectedButton == ServiceLocationOptions.inBranch
                      //       ? branchLocation
                      //       : state.selectedLocationName ==
                      //       context.tr.NotSelectedYet
                      //       ? null
                      //       : state.selectedLocation;
                      //
                      //   context.pushRoute(
                      //     ViewLocationRoute(
                      //       invoiceCubit: invoiceCubit,
                      //       locationModel: locationModel,
                      //       isDisplayOnly: selectedButton ==
                      //           ServiceLocationOptions.inBranch,
                      //     ),
                      //   );
                      // }
                      ,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0).r,
                        child: Row(
                          children: [
                            Icon(
                              SolarIconsOutline.mapPoint,
                              size: 14.r,
                            ),
                            SizedBox(width: 3.w),
                            DText(
                              selectedButton == ServiceLocationOptions.outBranch
                                  ? context.tr.selectLocation
                                  : context.tr.viewLocation,
                              style: context.textTheme.bodyMedium!.copyWith(
                                color: context.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 26.w,
                    ),
                    SizedBox(
                      width: context.screenWidth * 0.75,
                      child: DText(
                        state.selectedLocationName,
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 26.w,
                    )
                  ],
                )
              ],
            );
          },
        ),
        SizedBox(
          height: 16.r,
        ),
        Column(
          children: [
            Row(
              children: [
                Icon(
                  SolarIconsOutline.alarm,
                  size: 18.r,
                  color: context.colorScheme.onSurface,
                ),
                SizedBox(
                  width: 8.w,
                ),
                DText(
                  context.tr.duration,
                  style: context.textTheme.bodyLarge,
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 26.w,
                ),
                SizedBox(
                  width: 250.w,
                  child: DText(
                    '${totalDuration.toString()} ${context.tr.minutes}, ${context.tr.serviceSelectionConfirmation(
                      fromTime,
                      toTime,
                      selectedDate,
                    )}',
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
        SizedBox(
          height: 16.h,
        ),
      ],
    );
  }
}
