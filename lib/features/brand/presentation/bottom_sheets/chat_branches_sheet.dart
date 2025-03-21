import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/brand/logic/brand/brand_bloc.dart';
import 'package:dazzify/features/brand/presentation/widgets/branches_bottom_sheet_item.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/helper/map_helper.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBranchesSheet extends StatelessWidget {
  final String? serviceId;
  final BrandModel brand;
  final BranchesSheetType sheetType;

  const ChatBranchesSheet({
    this.serviceId,
    required this.brand,
    required this.sheetType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DazzifySheetBody(
      title: context.tr.branches,
      height: AppConstants.bottomSheetHeight,
      children: [
        Expanded(
          child: BlocBuilder<BrandBloc, BrandState>(
            builder: (context, state) {
              switch (state.branchesState) {
                case UiState.initial:
                case UiState.loading:
                  return const LoadingAnimation();
                case UiState.failure:
                  return ErrorDataWidget(
                    errorDataType: DazzifyErrorDataType.sheet,
                    message: state.errorMessage,
                    onTap: () {
                      final BrandBloc brandBloc = context.read<BrandBloc>();
                      brandBloc.add(GetBrandBranchesEvent(
                        brand.id,
                      ));
                    },
                  );
                case UiState.success:
                  if (state.brandBranches.isEmpty) {
                    return Center(
                      child: EmptyDataWidget(
                        message: context.tr.noBranches,
                      ),
                    );
                  } else {
                    return ListView.separated(
                      itemCount: state.brandBranches.length,
                      itemBuilder: (context, index) {
                        if (state.brandBranches.isEmpty) {}
                        return BranchesBottomSheetItem(
                          branchName: state.brandBranches[index].name,
                          onTap: () async {
                            if (sheetType == BranchesSheetType.chat) {
                              context.maybePop();
                              context.navigateTo(
                                ChatRoute(
                                  brand: brand,
                                  branchId: state.brandBranches[index].id,
                                  branchName: state.brandBranches[index].name,
                                  serviceToBeSent: serviceId,
                                ),
                              );
                            } else if (sheetType ==
                                BranchesSheetType.mapLocations) {
                              context.maybePop();
                              double lat =
                                  state.brandBranches[index].location.latitude;
                              double long =
                                  state.brandBranches[index].location.longitude;

                              MapHelper.openLocation(lat: lat, long: long);
                            }
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15.h),
                    );
                  }
              }
            },
          ),
        ),
      ],
    );
  }
}
