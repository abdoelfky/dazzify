import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/dazzify_app.dart';
import 'package:dazzify/features/booking/data/models/delivery_info_model.dart';
import 'package:dazzify/features/booking/logic/service_invoice_cubit/service_invoice_cubit.dart';
import 'package:dazzify/features/booking/presentation/bottom_sheets/governorate_bottom_sheet.dart';
import 'package:dazzify/features/booking/presentation/widgets/branch_button.dart';
import 'package:dazzify/features/booking/presentation/widgets/invoice_widget/invoice_widget.dart';
import 'package:dazzify/features/booking/presentation/widgets/multi_service_widget.dart';
import 'package:dazzify/features/booking/presentation/widgets/service_information.dart';
import 'package:dazzify/features/brand/data/models/location_model.dart';
import 'package:dazzify/features/brand/logic/service_selection/service_selection_cubit.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_multiline_text_field.dart';
import 'package:dazzify/features/shared/widgets/dazzify_overlay_loading.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../widgets/multi_service_information.dart';

@RoutePage()
class ServiceInvoiceScreen extends StatefulWidget implements AutoRouteWrapper {
  final ServiceDetailsModel service;
  final List<ServiceDetailsModel> services;
  final String branchId;
  final String branchName;
  final String selectedDate;
  String? selectedFromTime;
  String? selectedToTime;
  final String selectedStartTimeStamp;
  final LocationModel? branchLocation;
  final ServiceSelectionCubit serviceSelectionCubit;

  ServiceInvoiceScreen({
    required this.service,
    required this.serviceSelectionCubit,
    required this.services,
    required this.branchId,
    required this.branchName,
    required this.selectedDate,
    required this.selectedStartTimeStamp,
    this.selectedFromTime,
    this.selectedToTime,
    this.branchLocation,
    super.key,
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Ensure that ServiceSelectionCubit is provided here
        // BlocProvider<ServiceSelectionCubit>(create: (context) => getIt<ServiceSelectionCubit>()),
        BlocProvider(
          create: (context) => getIt<ServiceInvoiceCubit>()
            ..updateInvoice(
              price: services
                  .map((service) => service.price * service.quantity)
                  .toList(),
              appFees:
                  services.map((service) => service.fees.toDouble()).toList(),
            ),
        ),
        if (services.isEmpty)
          BlocProvider(
            create: (context) => getIt<ServiceInvoiceCubit>()
              ..updateInvoice(
                price: [service.price * service.quantity],
                appFees: [service.fees.toDouble()],
              ),
          ),
      ],
      child: this, // The widget itself
    );
  }

  @override
  State<ServiceInvoiceScreen> createState() => _ServiceInvoiceScreenState();
}

class _ServiceInvoiceScreenState extends State<ServiceInvoiceScreen> {
  bool _isBookingLoading = false;
  late final ValueNotifier<String> _selectedButton;
  late ServiceInvoiceCubit _invoiceCubit;
  late PageController _pageController;
  late TextEditingController _notesController;

  final ValueNotifier<bool> _isCodeValidatingLoading = ValueNotifier(false);
  final TextEditingController _textController = TextEditingController();

  // late ServiceSelectionCubit _serviceSelectionCubit;
  @override
  void initState() {
    _invoiceCubit = context.read<ServiceInvoiceCubit>();

    _initialization();
    _pageController = PageController();
    _notesController = TextEditingController();

    // _services= widget.services;
    // print(_services.length);
    // _serviceSelectionCubit = context.read<ServiceSelectionCubit>();
    final Set<String> allLocations = widget.services.isNotEmpty
        ? widget.services.map((s) => s.serviceLocation).toSet()
        : {widget.service.serviceLocation};

    final bool hasOut = allLocations.contains(ServiceLocationOptions.outBranch);
    if (hasOut) {
      _openGovernoratesSheet();
    }
    super.initState();
  }

  String _calculateToTimeFromSelectedFromTime(
      String fromTime, int totalMinutes) {
    final timeParts = fromTime.split(' ');
    final hourMinute = timeParts[0].split(':');
    int hour = int.parse(hourMinute[0]);
    int minute = int.parse(hourMinute[1]);
    final isPM = timeParts[1].toUpperCase() == 'PM';

    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    final fromDateTime = DateTime(0, 1, 1, hour, minute);
    final toDateTime = fromDateTime.add(Duration(minutes: totalMinutes));

    final newHour = toDateTime.hour > 12
        ? toDateTime.hour - 12
        : (toDateTime.hour == 0 ? 12 : toDateTime.hour);
    final newMinute = toDateTime.minute.toString().padLeft(2, '0');
    final newPeriod = toDateTime.hour >= 12 ? 'PM' : 'AM';

    return '$newHour:$newMinute $newPeriod';
  }

  // Method to remove service by index
  void removeService(int index) {
    // widget.serviceSelectionCubit.selectBookingService(service: widget.services[index]);
    widget.serviceSelectionCubit.removeServicesSelected(index: index);
    setState(() {
      widget.services.removeAt(index);

      int totalDuration =
          widget.services.fold(0, (sum, service) => sum + service.duration);

      widget.selectedToTime = _calculateToTimeFromSelectedFromTime(
          widget.selectedFromTime!, totalDuration);
    });
    _invoiceCubit.updateInvoice(
      price: widget.services
          .map((service) => service.price * service.quantity)
          .toList(),
      appFees:
          widget.services.map((service) => service.fees.toDouble()).toList(),
    );
    //Coupon Code reset
    if (_textController.text.isNotEmpty) {
      // Calculate total price if services are empty or not
      num totalPrice = widget.services.isEmpty
          ? widget.service.price * widget.service.quantity
          : widget.services.fold<num>(
        0,
            (sum, s) => sum + (s.price * s.quantity),
      );
      // if (widget.services.isEmpty) {
      //   totalPrice =
      //       widget.service.price; // use service price if services is empty
      // } else {
      //   totalPrice = widget.services
      //       .map((service) => service.price)
      //       .toList()
      //       .fold<num>(
      //           0,
      //           (sum, item) =>
      //               sum + item); // sum prices if services are not empty
      // }
      FocusManager.instance.primaryFocus?.unfocus();
      context.read<ServiceInvoiceCubit>().validateCouponAndUpdateInvoice(
            service: widget.services.first,
            price: totalPrice,
            code: _textController.text,
          );

      // textContorller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ValueListenableBuilder(
          valueListenable: _isCodeValidatingLoading,
          builder: (context, isCodeValidatingLoading, child) =>
              DazzifyOverlayLoading(
                  isLoading: isCodeValidatingLoading,
                  child: ValueListenableBuilder(
                    valueListenable: _selectedButton,
                    builder: (context, selectedButton, child) {
                      return serviceInvoiceSuccess(
                        context,
                        selectedButton,
                        widget.selectedDate,
                        widget.selectedFromTime!,
                        widget.selectedToTime!,
                      );
                    },
                  )),
        ),
      ),
    );
  }

  Column serviceInvoiceSuccess(BuildContext context, String selectedButton,
      String selectedDate, String fromTime, String toTime) {
    return Column(
      children: [
        DazzifyAppBar(
          isLeading: true,
          title: context.tr.confirmation,
          verticalPadding: 10.h,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16).w,
            children: [
              branchesButtons(selectedButton, context),
              SizedBox(
                height: 24.h,
              ),
              if (widget.services.length > 1)
                // This ensures the carousel with the dot indicator is only shown when there are more than 1 item
                SizedBox(
                  height: 140.h,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.services.length,
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) => MultiServiceWidget(
                      service: widget.services[index],
                      index: index,
                      branchLocation: widget.branchLocation,
                      invoiceCubit: _invoiceCubit,
                      removeService: removeService, // Pass the remove callback
                    ),
                  ),
                ),
              if (widget.services.length > 1)
                Center(
                  child: SmoothPageIndicator(
                    controller: _pageController, // Connect the page controller
                    count: widget.services.length, // The number of dots
                    effect: ScrollingDotsEffect(
                      // You can customize the dot effect here
                      activeDotColor: context.colorScheme.primary,
                      // Active dot color
                      dotColor: Colors.grey,
                      // Inactive dot color
                      dotHeight: 4.0.h,
                      // Height of the dot
                      dotWidth: 20.0.h,
                      // Width of the dot
                      spacing: 8.0.w, // Space between dots
                    ),
                  ),
                ),
              if (widget.services.length > 1)
                MultiServiceInformation(
                  onSelectLocationTap: () {
                    _openGovernoratesSheet();
                  },
                  services: widget.services,
                  branchLocation: widget.branchLocation,
                  invoiceCubit: _invoiceCubit,
                  selectedButton: selectedButton,
                  selectedDate: selectedDate,
                  fromTime: fromTime,
                  toTime: toTime,
                ),
              if (widget.services.isEmpty || widget.services.length == 1)
                ServiceInformation(
                  onSelectLocationTap: () {
                    _openGovernoratesSheet();
                  },
                  service: widget.services.isEmpty
                      ? widget.service
                      : widget.services.first,
                  branchLocation: widget.branchLocation,
                  invoiceCubit: _invoiceCubit,
                  selectedButton: selectedButton,
                  selectedDate: selectedDate,
                  fromTime: fromTime,
                  toTime: toTime,
                ),
              Divider(
                color: context.colorScheme.outlineVariant,
                endIndent: 16.w,
                indent: 16.w,
              ),
              SizedBox(
                height: 24.h,
              ),
              BlocListener<ServiceInvoiceCubit, ServiceInvoiceState>(
                listenWhen: (previous, current) =>
                    previous.couponValidationState !=
                    current.couponValidationState,
                listener: (context, state) {
                  if (state.couponValidationState == UiState.loading) {
                    _isCodeValidatingLoading.value = true;
                  } else if (state.couponValidationState == UiState.failure) {
                    _isCodeValidatingLoading.value = false;
                    DazzifyToastBar.showError(
                      message: context.tr.couponNotValidated,
                    );
                  } else if (state.couponValidationState == UiState.success) {
                    DazzifyToastBar.showSuccess(
                      message: context.tr.couponValidated,
                    );

                    _isCodeValidatingLoading.value = false;
                  }
                },
                child: InvoiceWidget(
                  textContorller: _textController,
                  services: widget.services,
                  service: widget.services.isEmpty
                      ? widget.service
                      : widget.services.first,
                ),
              ),
              DazzifyMultilineTextField(
                controller: _notesController,
                maxLength: 300,
                hintText: DazzifyApp.tr.writeNotes,
              ),
            ],
          ),
        ),
        bookingButton(selectedButton),
        SizedBox(
          height: 50.h,
        ),
      ],
    );
  }

  BlocConsumer<ServiceInvoiceCubit, ServiceInvoiceState> bookingButton(
      String selectedButton) {
    return BlocConsumer<ServiceInvoiceCubit, ServiceInvoiceState>(
      listenWhen: (previous, current) =>
          previous.creatingBookingState != current.creatingBookingState,
      listener: (context, state) {
        if (state.creatingBookingState == UiState.loading) {
          _isBookingLoading = true;
        } else if (state.creatingBookingState == UiState.success) {
          _isBookingLoading = false;
          context.replaceRoute(const ServiceBookingConfirmationRoute());
        } else if (state.creatingBookingState == UiState.failure) {
          _isBookingLoading = false;
          DazzifyToastBar.showError(
            message: state.errorMessage,
          );
        }
      },
      builder: (context, state) {
        return PrimaryButton(
          title: context.tr.confirm,
          isLoading: _isBookingLoading,
          onTap: () {
            _onConfirmTap(
                selectedButton: selectedButton,
                selectedLocation: state.selectedLocation,
                selectedGovernorate: state.deliveryInfo.selectedGov,
                selectedLocationName: state.selectedLocationName,
                code: state.couponValidationState != UiState.success?'':_textController.text,
                notes: _notesController.text);
          },
        );
      },
    );
  }

  // Row branchesButtons(String selectedButton, BuildContext context) {
  //   return Row(
  //     children: [
  //       BranchButton(
  //         isActive: widget.service.serviceLocation !=
  //             ServiceLocationOptions.outBranch,
  //         onTap: () {
  //           _selectButton(ServiceLocationOptions.inBranch);
  //         },
  //         height: 42.h,
  //         width: 160.w,
  //         isSelected: selectedButton == ServiceLocationOptions.inBranch,
  //         title: context.tr.inBranch,
  //       ),
  //       const Spacer(),
  //       BranchButton(
  //         isActive:
  //             widget.service.serviceLocation != ServiceLocationOptions.inBranch,
  //         onTap: () {
  //           _selectButton(ServiceLocationOptions.outBranch);
  //           _openGovernoratesSheet();
  //         },
  //         height: 42.h,
  //         width: 160.w,
  //         isSelected: selectedButton == ServiceLocationOptions.outBranch,
  //         title: context.tr.outBranch,
  //       ),
  //     ],
  //   );
  // }
  Row branchesButtons(String selectedButton, BuildContext context) {
    final Set<String> allLocations = widget.services.isNotEmpty
        ? widget.services.map((s) => s.serviceLocation).toSet()
        : {widget.service.serviceLocation};

    final bool hasAny = allLocations.contains(ServiceLocationOptions.any);
    final bool hasIn = allLocations.contains(ServiceLocationOptions.inBranch);
    final bool hasOut = allLocations.contains(ServiceLocationOptions.outBranch);

    // Determine if buttons should be enabled
    final bool enableIn = (hasAny && !hasOut) || (hasIn && !hasOut && !hasAny);
    final bool enableOut = (hasAny && !hasIn) || (hasOut && !hasIn && !hasAny);
    final bool enableBoth = hasAny && !hasIn && !hasOut;

    return Row(
      children: [
        BranchButton(
          isActive: enableIn || enableBoth,
          onTap: () {
            if (enableIn || enableBoth) {
              _selectButton(ServiceLocationOptions.inBranch);
            }
          },
          height: 42.h,
          width: 160.w,
          isSelected: selectedButton == ServiceLocationOptions.inBranch,
          title: context.tr.inBranch,
        ),
        const Spacer(),
        BranchButton(
          isActive: enableOut || enableBoth,
          onTap: () {
            if (enableOut || enableBoth) {
              _selectButton(ServiceLocationOptions.outBranch);
              _openGovernoratesSheet();
            }
          },
          height: 42.h,
          width: 160.w,
          isSelected: selectedButton == ServiceLocationOptions.outBranch,
          title: context.tr.outBranch,
        ),
      ],
    );
  }

  void _openGovernoratesSheet() {
    _invoiceCubit.getBrandDeliveryFeesList(
      brandId: widget.service.brand.id,
    );
    // widget.service.type != ServiceLocationOptions.inBranch
    if (_selectedButton.value != ServiceLocationOptions.inBranch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showModalBottomSheet(
          context: context,
          isDismissible: false,
          useRootNavigator: true,
          builder: (context) {
            return BlocProvider.value(
              value: _invoiceCubit,
              child: GovernoratesBottomSheet(
                brandId: widget.service.brand.id,
                price: widget.service.price,
              ),
            );
          },
        );
      });
    }
  }

  void _selectButton(String type) {
    _selectedButton.value = type;

    if (type == ServiceLocationOptions.outBranch) {
      _invoiceCubit.updateSelectedLocationName(
        selectedLocationName: context.tr.NotSelectedYet,
      );
    } else {
      _invoiceCubit.updateInvoice(deliveryFees: 0);

      _invoiceCubit.updateDeliveryInfo(
        deliveryInfo: const DeliveryInfoModel.empty(),
      );
      _invoiceCubit
        ..updateSelectedLocation(
          selectedLocation: widget.branchLocation!,
        )
        ..updateSelectedLocationName(
          selectedLocationName: widget.branchName,
        );
    }
  }

  void _initialization() {
    final Set<String> allLocations = widget.services.isNotEmpty
        ? widget.services.map((s) => s.serviceLocation).toSet()
        : {widget.service.serviceLocation};

    final bool hasAny = allLocations.contains(ServiceLocationOptions.any);
    final bool hasIn = allLocations.contains(ServiceLocationOptions.inBranch);
    final bool hasOut = allLocations.contains(ServiceLocationOptions.outBranch);

    if ((hasAny && !hasOut) || (hasIn && !hasOut && !hasAny)) {
      // Default to in-branch
      _selectedButton = ValueNotifier(ServiceLocationOptions.inBranch);

      _invoiceCubit
        ..updateSelectedLocation(
          selectedLocation: widget.branchLocation!,
        )
        ..updateSelectedLocationName(
          selectedLocationName: widget.branchName,
        );
    } else {
      // Default to out-branch
      _selectedButton = ValueNotifier(ServiceLocationOptions.outBranch);

      _invoiceCubit.updateSelectedLocationName(
        selectedLocationName: DazzifyApp.tr.NotSelectedYet,
      );
    }
  }

  void _onConfirmTap({
    required String selectedButton,
    LocationModel? selectedLocation,
    required int selectedGovernorate,
    required String selectedLocationName,
    required String code,
    required String notes,
  }) {
    LocationModel? bookingLocationModel =
        selectedButton == ServiceLocationOptions.outBranch
            ? selectedLocation
            : null;

    int? selectedGov = selectedButton == ServiceLocationOptions.outBranch
        ? selectedGovernorate
        : null;

    bool? isInBranch =
        selectedButton == ServiceLocationOptions.outBranch ? false : true;

    if (isInBranch == false &&
        selectedLocationName == context.tr.NotSelectedYet) {
      _openGovernoratesSheet();
      DazzifyToastBar.showError(
        message: context.tr.selectYourLocation,
      );
    } else if (_textController.text.isNotEmpty && 
               _invoiceCubit.state.couponValidationState != UiState.success) {
      // Check if coupon code is entered but not applied
      DazzifyToastBar.showError(
        message: context.tr.pleaseApplyCoupon,
      );
    } else {
      // Build servicesWithQuantity payload
      final servicesWithQuantity =
          (widget.services.isEmpty ? [widget.service] : widget.services)
              .map((service) => {
                    "serviceId": service.id,
                    "quantity": service.quantity,
                  })
              .toList();

      _invoiceCubit.bookService(
        brandId: widget.service.brand.id,
        branchId: widget.branchId,
        servicesWithQuantity: servicesWithQuantity,
        services: widget.services.isEmpty
            ? [widget.service.id]
            : widget.services.map((service) => service.id).toList(),
        date: widget.selectedDate,
        startTimeStamp: widget.selectedStartTimeStamp,
        isHasCoupon: code == '' ? false : true,
        bookingLocationModel: bookingLocationModel,
        code: code == '' ? null : code,
        notes: notes == '' ? null : notes,
        gov: selectedGov,
        isInBranch: isInBranch,
      );
    }
  }
}
