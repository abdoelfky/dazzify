import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/logic/service_invoice_cubit/service_invoice_cubit.dart';
import 'package:dazzify/features/brand/data/models/location_model.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';

class ServiceInformation extends StatelessWidget {
  final ServiceDetailsModel service;
  final LocationModel? branchLocation;
  final ServiceInvoiceCubit invoiceCubit;
  final String selectedButton;
  final String selectedDate;
  final String fromTime;
  final String toTime;
  final Function onSelectLocationTap; // Define a variable to hold the method

  const ServiceInformation({
    required this.service,
    required this.onSelectLocationTap,
    required this.branchLocation,
    required this.invoiceCubit,
    required this.selectedButton,
    required this.selectedDate,
    required this.fromTime,
    required this.toTime,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 80.h,
                  width: 80.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8).r,
                    child: DazzifyCachedNetworkImage(
                      imageUrl: service.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // if (service.quantity > 1)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 6.r, vertical: 2.r),
                    decoration: BoxDecoration(
                      color: context.colorScheme.inversePrimary,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: DText(
                      'X${service.quantity}',
                        style: context.textTheme.bodyMedium!.copyWith(
                            color: context.colorScheme.onSecondary
                        )
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(
              width: 16.w,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DText(
                  service.title,
                  style: context.textTheme.bodyLarge!.copyWith(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                DText(
                  service.description,
                  style: context.textTheme.bodySmall!.copyWith(
                    color: context.colorScheme.onSurfaceVariant,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ))
          ],
        ),
        SizedBox(
          height: 24.h,
        ),
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
                      onTap: () {
                        if (selectedButton != ServiceLocationOptions.inBranch.toString()) {
                          onSelectLocationTap();
                        } else {
                          // print(branchLocation!.latitude);
                          LocationModel? locationModel =
                              selectedButton == ServiceLocationOptions.inBranch
                                  ? branchLocation
                                  : state.selectedLocationName ==
                                          context.tr.NotSelectedYet
                                      ? null
                                      : state.selectedLocation;

                          context.pushRoute(
                            ViewLocationRoute(
                              invoiceCubit: invoiceCubit,
                              locationModel: locationModel,
                              isDisplayOnly: selectedButton ==
                                  ServiceLocationOptions.inBranch,
                            ),
                          );
                        }
                      }

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
                )
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
                    maxLines: 2,
                    '${service.duration.toString()} ${context.tr.minutes}, ${context.tr.serviceSelectionConfirmation(
                      fromTime,
                      toTime,
                      selectedDate,
                    )}',

                    //from $fromTime to $toTime on $selectedDate.',
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
