import 'package:auto_route/auto_route.dart';
import 'package:dazzify/core/constants/app_constants.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/core/util/extensions.dart';
import 'package:dazzify/features/booking/logic/service_invoice_cubit/service_invoice_cubit.dart';
import 'package:dazzify/features/booking/logic/view_location_cubit.dart/view_location_cubit.dart';
import 'package:dazzify/features/brand/data/models/location_model.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@RoutePage()
class ViewLocationScreen extends StatefulWidget implements AutoRouteWrapper {
  final LocationModel? locationModel;
  final ServiceInvoiceCubit invoiceCubit;
  final bool isDisplayOnly;

  const ViewLocationScreen({
    this.locationModel,
    required this.invoiceCubit,
    required this.isDisplayOnly,
    super.key,
  });

  @override
  State<ViewLocationScreen> createState() => _ViewLocationScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ViewLocationCubit>(),
        ),
        BlocProvider.value(value: invoiceCubit),
      ],
      child: this,
    );
  }
}

class _ViewLocationScreenState extends State<ViewLocationScreen> {
  late CameraPosition initialCameraPosition;
  String? _darkMapStyle;
  late LatLng _selectedLatLng;
  bool _isButtonActive = false;
  late String _buttonTitle;
  bool _isLoading = false;
  late ViewLocationCubit _viewLocationCubit;

  @override
  void initState() {
    _viewLocationCubit = context.read<ViewLocationCubit>();
    _initialization();
    _loadMapDarkTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<ViewLocationCubit, ViewLocationState>(
          listener: (context, state) {
            if (state.blocState == UiState.loading) {
              _isLoading = true;
            } else if (state.blocState == UiState.success) {
              LocationModel selectedLocation = LocationModel(
                longitude: _selectedLatLng.longitude,
                latitude: _selectedLatLng.latitude,
              );

              widget.invoiceCubit.updateSelectedLocation(
                selectedLocation: selectedLocation,
              );

              widget.invoiceCubit.updateSelectedLocationName(
                selectedLocationName: state.locationName,
              );

              _isLoading = false;

              context.maybePop();
            } else if (state.blocState == UiState.failure) {
              _isLoading = false;
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: initialCameraPosition,
                  markers: state.markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  style: context.isDarkTheme ? _darkMapStyle : '[]',
                  onMapCreated: (GoogleMapController controller) {
                    _viewLocationCubit.showButton();
                  },
                  onTap: _mapOnTap,
                ),
                PositionedDirectional(
                    top: 24.h,
                    start: 8.w,
                    child: DazzifyAppBar(
                        isLeading: true,
                        onBackTap: () {
                          context.maybePop();
                        })),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.only(
                        right: 16,
                        left: 16,
                        bottom: 140,
                      ).r,
                      child: state.showButton
                          ? CustomFadeAnimation(
                              duration: const Duration(milliseconds: 300),
                              child: PrimaryButton(
                                title: _buttonTitle,
                                width: context.screenWidth,
                                isLoading: _isLoading,
                                isActive: _isButtonActive,
                                onTap: _buttonOnTap,
                              ),
                            )
                          : Container()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _loadMapDarkTheme() async {
    _darkMapStyle = await rootBundle.loadString(AssetsManager.mapDarkThemeJson);
  }

  void _initialization() {
    if (widget.locationModel != null) {
      initialCameraPosition = CameraPosition(
        target: LatLng(
          widget.locationModel!.latitude,
          widget.locationModel!.longitude,
        ),
        zoom: 14,
      );

      _viewLocationCubit.addMarker(
        widget.locationModel!.latitude,
        widget.locationModel!.longitude,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.isDisplayOnly) {
          _isButtonActive = true;
          _buttonTitle = context.tr.ok;
        } else {
          _buttonTitle = context.tr.updateLocation;
        }
      });
    } else {
      initialCameraPosition = const CameraPosition(
        target: LatLng(
          AppConstants.cairoLatitude,
          AppConstants.cairoLongitude,
        ),
        zoom: 11,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _buttonTitle = context.tr.confirmLocation;
      });
    }
  }

  void _buttonOnTap() {
    if (widget.isDisplayOnly) {
      context.maybePop();
    } else {
      _viewLocationCubit.getLocationName(
        latitude: _selectedLatLng.latitude,
        longitude: _selectedLatLng.longitude,
      );
    }
  }

  void _mapOnTap(LatLng latLng) {
    if (!widget.isDisplayOnly) {
      _viewLocationCubit.addMarker(latLng.latitude, latLng.longitude);

      _isButtonActive = true;
      _selectedLatLng = latLng;
    }
  }
}
