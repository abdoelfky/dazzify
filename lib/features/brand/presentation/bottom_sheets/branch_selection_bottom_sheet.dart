import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/brand/logic/brand_branches/brand_branches_cubit.dart';
import 'package:dazzify/features/brand/presentation/widgets/branches_bottom_sheet_item.dart';
import 'package:dazzify/features/shared/animations/loading_animation.dart';
import 'package:dazzify/features/shared/logic/favorite/favorite_cubit.dart';
import 'package:dazzify/features/shared/widgets/dazzify_sheet_body.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BranchSelectionBottomSheet extends StatefulWidget {
  final String brandId;
  final bool isMultipleBooking;

  const BranchSelectionBottomSheet({
    required this.brandId,
    super.key,
    required this.isMultipleBooking,
  });

  @override
  State<BranchSelectionBottomSheet> createState() =>
      _BranchSelectionBottomSheetState();
}

class _BranchSelectionBottomSheetState
    extends State<BranchSelectionBottomSheet> {
  late final BrandBranchesCubit _brandBranchesCubit;

  @override
  void initState() {
    _brandBranchesCubit = context.read<BrandBranchesCubit>();
    _brandBranchesCubit.getBrandBranches(brandId: widget.brandId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DazzifySheetBody(
      title: context.tr.branches,
      height: AppConstants.bottomSheetHeight,
      children: [
        BlocBuilder<BrandBranchesCubit, BrandBranchesState>(
          builder: (context, state) {
            switch (state.brandBranchesState) {
              case UiState.initial:
              case UiState.loading:
                return Expanded(
                  child: const Center(
                    child: LoadingAnimation(),
                  ),
                );
              case UiState.failure:
                return ErrorDataWidget(
                  errorDataType: DazzifyErrorDataType.sheet,
                  message: state.errorMessage,
                  onTap: () {
                    _brandBranchesCubit.getBrandBranches(
                      brandId: widget.brandId,
                    );
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
                  return Expanded(
                    child: ListView.separated(
                      itemCount: state.brandBranches.length,
                      itemBuilder: (context, index) {
                        return BranchesBottomSheetItem(
                          branchName: state.brandBranches[index].name,
                          onTap: () async {
                            context.maybePop();
                            context.pushRoute(
                              BrandServiceBookingRoute(
                                brandId: widget.brandId,
                                isMultipleBooking: widget.isMultipleBooking,
                                branch: state.brandBranches[index],
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15.h),
                    ),
                  );
                }
            }
          },
        ),
      ],
    );
  }
}

Future<void> showBranchSelectionBottomSheet({
  required BuildContext context,
  required FavoriteCubit favoriteCubit,
  required String brandId,
  required bool isMultipleBooking,
}) {
  return showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    routeSettings: const RouteSettings(
      name: "ServiceSelectionBottomSheet",
    ),
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<BrandBranchesCubit>(),
        ),
        BlocProvider.value(
          value: favoriteCubit,
        ),
      ],
      child: BranchSelectionBottomSheet(
        brandId: brandId,
        isMultipleBooking: isMultipleBooking,
      ),
    ),
  );
}
