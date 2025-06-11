import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/brand/logic/service_selection/service_selection_cubit.dart';
import 'package:dazzify/features/brand/presentation/widgets/brand_category_item.dart';
import 'package:dazzify/features/brand/presentation/widgets/service_widget.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_loading_shimmer.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/empty_data_widget.dart';
import 'package:dazzify/features/shared/widgets/error_data_widget.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';

@RoutePage()
class BrandServiceBookingScreen extends StatefulWidget
    implements AutoRouteWrapper {
  final String brandId;
  final bool isMultipleBooking;
  final BrandBranchesModel branch;

  const BrandServiceBookingScreen({
    required this.brandId,
    super.key,
    required this.isMultipleBooking,
    required this.branch,
  });

  @override
  State<BrandServiceBookingScreen> createState() =>
      _BrandServiceBookingScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ServiceSelectionCubit>()..selectBranch(branch: branch),
      child: this,
    );
  }
}

class _BrandServiceBookingScreenState extends State<BrandServiceBookingScreen> {
  late final ServiceSelectionCubit _serviceSelectionCubit;

  @override
  void initState() {
    _serviceSelectionCubit = context.read<ServiceSelectionCubit>();
    _serviceSelectionCubit.getBrandCategories(
      brandId: widget.brandId,
    );
    super.initState();
  }

  @override
  void dispose() {
    if (!_serviceSelectionCubit.isClosed) {
      _serviceSelectionCubit.clearServices();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            DazzifyAppBar(
              isLeading: true,
              title: context.tr.services,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: buildCategoriesList(),
            ),
            buildServiceBookingList(),
            if (widget.isMultipleBooking) buildMultipleServiceBooking(),
          ],
        ),
      ),
    );
  }

  Widget buildCategoriesList() {
    return SizedBox(
      height: 50.h,
      child: BlocBuilder<ServiceSelectionCubit, ServiceSelectionState>(
        buildWhen: (previous, current) =>
            previous.brandCategoriesState != current.brandCategoriesState,
        builder: (context, state) {
          switch (state.brandCategoriesState) {
            case UiState.initial:
            case UiState.loading:
              return Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: DazzifyLoadingShimmer(
                  dazzifyLoadingType: DazzifyLoadingType.listView,
                  scrollDirection: Axis.horizontal,
                  borderRadius: BorderRadius.circular(8),
                  cardWidth: 122.w,
                  cardHeight: 40.h,
                ),
              );
            case UiState.failure:
              return SizedBox.shrink();
            case UiState.success:
              return ListView.separated(
                padding: EdgeInsetsDirectional.only(start: 16, bottom: 8),
                itemCount: state.brandCategories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return BlocBuilder<ServiceSelectionCubit,
                      ServiceSelectionState>(
                    buildWhen: (previous, current) =>
                        previous.selectedCategoryId !=
                        current.selectedCategoryId,
                    builder: (context, state) {
                      final category = state.brandCategories[index];
                      return BrandCategoryItem(
                        key: ValueKey(category.id),
                        image: category.image,
                        name: category.name,
                        isSelected: category.id == state.selectedCategoryId,
                        onTap: () {
                          print("category${category.id}");
                          print("category${state.selectedCategoryId}");

                          _serviceSelectionCubit.selectCategory(
                              brandCategory: category);
                        },
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
              );
          }
        },
      ),
    );
  }

  Widget buildServiceBookingList() {
    return BlocBuilder<ServiceSelectionCubit, ServiceSelectionState>(
      // buildWhen: (previous, current) =>
      //     previous.brandServicesState != current.brandServicesState,
      builder: (context, state) {
        switch (state.brandServicesState) {
          case UiState.initial:
          case UiState.loading:
            return Expanded(
              child: DazzifyLoadingShimmer(
                dazzifyLoadingType: DazzifyLoadingType.listView,
                borderRadius: BorderRadius.circular(8),
                cardWidth: context.screenWidth,
                cardHeight: 140.h,
              ),
            );
          case UiState.failure:
            return Expanded(
              child: ErrorDataWidget(
                errorDataType: DazzifyErrorDataType.sheet,
                message: state.errorMessage,
                onTap: () {
                  _serviceSelectionCubit.getBrandServices(
                    categoryId: state.selectedCategoryId,
                    branchId: state.selectedBranch.id,
                  );
                },
              ),
            );
          case UiState.success:
            if (state.brandServices.isEmpty) {
              return Expanded(
                child: Center(
                  child: EmptyDataWidget(
                    message: context.tr.noServices,
                  ),
                ),
              );
            } else {
              return Expanded(
                child: Builder(
                  builder: (context) {
                    if (state
                        .brandServices[state.selectedCategoryId]!.isNotEmpty) {
                      return ListView.separated(
                        itemCount: state
                            .brandServices[state.selectedCategoryId]!.length,
                        itemBuilder: (context, index) {
                          return BlocBuilder<ServiceSelectionCubit,
                              ServiceSelectionState>(
                            builder: (context, state) {
                              final service = state.brandServices[
                                  state.selectedCategoryId]![index];
                              return ServiceWidget(
                                isMultipleService: widget.isMultipleBooking,
                                isAllowMultipleServicesCount: service.allowMultipleServicesCount,
                                onSingleBookingTap: () {
                                  _goToBookingDateSelectionScreen(
                                    service: service,
                                    branch: state.selectedBranch,
                                  );
                                },
                                onCardTap: () {
                                  _goToServiceDetailsScreen(
                                    service: service,
                                    branch: state.selectedBranch,
                                  );
                                },
                                onBookingSelectTap: () {
                                  {
                                    _serviceSelectionCubit.selectBookingService(
                                      service: service,
                                    );
                                  }
                                },
                                isBooked: state.selectedBrandServicesIds
                                    .contains(service.id),
                                imageUrl: service.image,
                                title: service.title,
                                description: service.description,
                                price: service.price,
                                serviceStatus: ServiceStatus.booking,
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16.h),
                      );
                    } else {
                      return EmptyDataWidget(
                        message: context.tr.noServices,
                      );
                    }
                  },
                ),
              );
            }
        }
      },
    );
  }

  Widget buildMultipleServiceBooking() {
    return BlocBuilder<ServiceSelectionCubit, ServiceSelectionState>(
      // buildWhen: (previous, current) =>
      //     previous.selectedBrandServices.length !=
      //     current.selectedBrandServices.length,
      builder: (context, state) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: state.selectedBrandServices.isNotEmpty ? 58.h : 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: DText(
                  key: ValueKey(state.selectedBrandServices.length),
                  context.tr.countServiceSelected(
                    state.selectedBrandServices.length,
                  ),
                  style: context.textTheme.bodyMedium,
                ),
              ),
              SizedBox(width: 24),
              PrimaryButton(
                width: 120.w,
                height: 32.h,
                titleStyle: context.textTheme.labelSmall!.copyWith(
                  color: context.colorScheme.onPrimary,
                ),
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(38),
                  topStart: Radius.circular(8),
                  bottomEnd: Radius.circular(8),
                  bottomStart: Radius.circular(38),
                ),
                onTap: () {
                  // Get all service locations from the selected services
                  final selectedServiceLocations = state.selectedBrandServices
                      .map((service) => service.serviceLocation)
                      .toList();

                  // Check if both 'out' and 'in' are selected
                  if (selectedServiceLocations.contains('out') &&
                      selectedServiceLocations.contains('in')) {
                    // Show an error message
                    DazzifyToastBar.showError(
                      message: context.tr.chooseServiceLocationError,
                    );
                  } else {
                    // Proceed with the navigation to the multiple booking date selection screen
                    _goToMultipleBookingDateSelectionScreen(
                      services: state.selectedBrandServices,
                      branch: state.selectedBranch,
                    );
                  }
                },
                title: context.tr.selectDate,
              ),
            ],
          ),
        );
      },
    );
  }

  void _goToServiceDetailsScreen({
    required ServiceDetailsModel service,
    required BrandBranchesModel branch,
  }) {
    context.pushRoute(
      ServiceDetailsRoute(
        service: service,
        branch: branch,
        isBooking: true,
      ),
    );
  }

  void _goToBookingDateSelectionScreen({
    required ServiceDetailsModel service,
    required BrandBranchesModel branch,
  }) {
    context.pushRoute(
      ServiceAvailabilityRoute(
        service: service,
        branchId: branch.id,
        branchName: branch.name,
        location: branch.location,
      ),
    );
  }

  void _goToMultipleBookingDateSelectionScreen({
    required List<ServiceDetailsModel> services,
    required BrandBranchesModel branch,
  }) {
    context.pushRoute(
      MultipleServiceAvailabilityRoute(
        services: services,
        serviceSelectionCubit: _serviceSelectionCubit,
        branchId: branch.id,
        branchName: branch.name,
        location: branch.location,
        brandId: widget.brandId,
      ),
    );
  }
}
