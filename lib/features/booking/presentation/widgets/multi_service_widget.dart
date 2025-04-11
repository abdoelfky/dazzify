import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/features/booking/logic/service_invoice_cubit/service_invoice_cubit.dart';
import 'package:dazzify/features/brand/data/models/location_model.dart';
import 'package:dazzify/features/brand/logic/service_selection/service_selection_cubit.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_cached_network_image.dart';

class MultiServiceWidget extends StatelessWidget {
  final ServiceDetailsModel service;
  final LocationModel? branchLocation;
  final ServiceInvoiceCubit invoiceCubit;
  final int index;
  final Function(int) removeService; // Add removeService callback

  const MultiServiceWidget({
    required this.service,
    required this.index,
    required this.branchLocation,
    required this.invoiceCubit,
    required this.removeService, // Accept callback as parameter

    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
            color: context.colorScheme.inversePrimary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25).r),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 90,
                width: 90,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8).r,
                  child: DazzifyCachedNetworkImage(
                    imageUrl: service.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        DText(
                          service.title,
                          style: context.textTheme.bodyLarge!.copyWith(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Row(
                          children: [
                            DText(
                              '${service.price}',
                              style: context.textTheme.bodyLarge!.copyWith(
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DText(
                              ' ${context.tr.egp}',
                              style: context.textTheme.bodyLarge!.copyWith(
                                color: context.colorScheme.onSurfaceVariant,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            print(index);
                            removeService(index);
                          },
                          child: Icon(
                            SolarIconsOutline.trashBinTrash,
                            size: 25.r,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      service.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall!.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
