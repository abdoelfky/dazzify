import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/util/colors_manager.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/brand/presentation/widgets/branches_bottom_sheet_item.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingBranchesSheet extends StatelessWidget {
  final ServiceDetailsModel service;

  const BookingBranchesSheet({
    required this.service,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DazzifySheetBody(
      title: context.tr.branches,
      titleBottomPadding: 8.r,
      textStyle: context.textTheme.bodyLarge,
      height: AppConstants.bottomSheetHeight,
      handlerHeight: 4.h,
      handlerWidth: 120.w,
      children: [
        SizedBox(
          height: 8.h,
        ),
        Divider(
          color: ColorsManager.bottomSheetDivider,
          height: 1.h,
          indent: 16.w,
          endIndent: 16.w,
        ),
        Expanded(
          child: service.inBranches.isEmpty
              ? EmptyDataWidget(
                  message: context.tr.noBranches,
                )
              : ListView.separated(
                  itemCount: service.inBranches.length,
                  itemBuilder: (context, index) {
                    return BranchesBottomSheetItem(
                      branchName: service.inBranches[index].name,
                      onTap: () async {
                        context.maybePop();

                        context.pushRoute(ServiceAvailabilityRoute(
                          service: service,
                          branchId: service.inBranches[index].id,
                          branchName: service.inBranches[index].name,
                          location: service.inBranches[index].location,
                        ));
                      },
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 15.r),
                ),
        ),
      ],
    );
  }
}
