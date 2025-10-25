import 'dart:io';

import 'package:dazzify/core/framework/export.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/core/util/assets_manager.dart';
import 'package:dazzify/features/brand/data/models/location_model.dart';
import 'package:dazzify/features/shared/animations/custom_fade_animation.dart';
import 'package:dazzify/features/shared/widgets/dazzify_app_bar.dart';
import 'package:dazzify/features/shared/widgets/dazzify_toast_bar.dart';
import 'package:dazzify/features/shared/widgets/primary_button.dart';
import 'package:dazzify/features/user/logic/location/location_cubit.dart';
import 'package:dazzify/features/user/logic/user/user_cubit.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@RoutePage()
class UserLocationScreen extends StatefulWidget implements AutoRouteWrapper {
  final LocationModel? locationModel;
  final UserCubit userCubit;

  const UserLocationScreen({
    this.locationModel,
    required this.userCubit,
    super.key,
  });

  @override
  State<UserLocationScreen> createState() => _UserLocationScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<LocationCubit>(
        create: (context) => getIt<LocationCubit>(),
      ),
      BlocProvider.value(value: userCubit),
    ], child: this);
  }
}

class _UserLocationScreenState extends State<UserLocationScreen> {
  late LatLng selectedLatLng;
  late CameraPosition initialCameraPosition;
  late String buttonTitle;
  bool isLoading = false;
  bool isButtonActive = false;
  String? darkMapStyle;

  @override
  void initState() {
    super.initState();
    initialization();
    loadMapDarkTheme();
  }

  Future<void> initialization() async {
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: Platform.isAndroid
          ? AndroidSettings(accuracy: LocationAccuracy.high)
          : AppleSettings(accuracy: LocationAccuracy.high),
    );

    setState(() {
      selectedLatLng = LatLng(position.latitude, position.longitude);
      initialCameraPosition = CameraPosition(
        target: selectedLatLng,
        zoom: 14,
      );

      context.read<LocationCubit>().addMarker(
            selectedLatLng.latitude,
            selectedLatLng.longitude,
          );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      buttonTitle = widget.locationModel != null
          ? context.tr.updateLocation
          : context.tr.confirmLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LocationCubit, LocationState>(
        listener: (context, state) {
          if (state.blocState == UiState.loading) {
            isLoading = true;
          } else {
            isLoading = false;
            if (state.blocState == UiState.success) {
              context.maybePop();
              DazzifyToastBar.showSuccess(
                message: context.tr.locationUpdated,
              );
            }
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: initialCameraPosition,
                markers: state.markers,
                myLocationEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                tiltGesturesEnabled: true,
                rotateGesturesEnabled: true,
                style: context.isDarkTheme ? darkMapStyle : '[]',
                onMapCreated: (GoogleMapController controller) {
                  context.read<LocationCubit>().showButton();
                },
                onTap: (LatLng latLng) {
                  context
                      .read<LocationCubit>()
                      .addMarker(latLng.latitude, latLng.longitude);
                  isButtonActive = true;
                  selectedLatLng = latLng;
                },
              ),
              PositionedDirectional(
                top: 24.h,
                start: 8.w,
                child: DazzifyAppBar(
                    isLeading: true,
                    onBackTap: () {
                      context.maybePop();
                    }),
              ),
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
                            title: buttonTitle,
                            width: context.screenWidth,
                            isLoading: isLoading,
                            isActive: isButtonActive,
                            onTap: () {
                              widget.userCubit.updateUserLocation(
                                locationModel: LocationModel(
                                  longitude: selectedLatLng.longitude,
                                  latitude: selectedLatLng.latitude,
                                ),
                              );

                              context
                                  .read<LocationCubit>()
                                  .updateProfileLocation(
                                    longitude: selectedLatLng.longitude,
                                    latitude: selectedLatLng.latitude,
                                  );
                            },
                          ),
                        )
                      : SizedBox.shrink(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> loadMapDarkTheme() async {
    darkMapStyle = await rootBundle.loadString(AssetsManager.mapDarkThemeJson);
  }
}
