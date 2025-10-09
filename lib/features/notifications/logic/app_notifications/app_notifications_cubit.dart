import 'package:bloc/bloc.dart';
import 'package:dazzify/core/services/device_info.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/auth/data/repositories/auth_repository.dart';
import 'package:dazzify/features/notifications/data/repositories/notifications_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
part 'app_notifications_state.dart';


class AppNotificationsCubit extends Cubit<AppNotificationsState> {
  final NotificationsRepository _notificationsRepository;
  final AuthRepository _authRepository;

  AppNotificationsCubit(
    this._notificationsRepository,
    this._authRepository,
  ) : super(const AppNotificationsState()) {
    checkForNotificationsPermission();
  }

  Future<void> subscribeToNotifications() async {
    // Check if user is authenticated before subscribing
    final isUserLoggedIn = _authRepository.isUserAuthenticated();
    if (!isUserLoggedIn) {
      // Guest users don't need to subscribe to notifications
      emit(state.copyWith(
        isSubscribedToNotifications: false,
        subscriptionState: UiState.success,
      ));
      return;
    }

    await checkForNotificationsPermission();
    if (state.permissionsState == PermissionsState.granted) {
      emit(state.copyWith(
        subscriptionState: UiState.loading,
      ));
      final device = await DeviceInfo.getInfo();

      // final String? deviceToken = await NotificationsService.getDeviceToken();
      // if (deviceToken == null) {
      //   emit(
      //     state.copyWith(
      //       subscriptionState: UiState.failure,
      //       isSubscribedToNotifications: false,
      //     ),
      //   );
      //   return;
      // }
      final results = await _notificationsRepository.subscribeToNotifications(
        deviceToken: device.fcmToken,
      );

      results.fold(
        (failure) => emit(
          state.copyWith(
            subscriptionState: UiState.failure,
          ),
        ),
        (success) => emit(
          state.copyWith(
            isSubscribedToNotifications: true,
            subscriptionState: UiState.success,
          ),
        ),
      );
    }
  }

  Future<void> unSubscribeFromNotifications() async {
    // Check if user is authenticated before unsubscribing
    final isUserLoggedIn = _authRepository.isUserAuthenticated();
    if (!isUserLoggedIn) {
      // Guest users are not subscribed, so nothing to unsubscribe
      emit(state.copyWith(
        isSubscribedToNotifications: false,
        subscriptionState: UiState.success,
      ));
      return;
    }

    final device = await DeviceInfo.getInfo();
    // final String? deviceToken = await NotificationsService.getDeviceToken();
    // if (deviceToken != null) {
    emit(state.copyWith(subscriptionState: UiState.loading));
    final results = await _notificationsRepository.unSubscribeFromNotifications(
      deviceToken: device.fcmToken,
    );
    results.fold(
      (failure) => emit(
        state.copyWith(
          subscriptionState: UiState.failure,
        ),
      ),
      (success) => emit(
        state.copyWith(
          isSubscribedToNotifications: false,
          subscriptionState: UiState.success,
        ),
      ),
    );
    // }
  }

  Future<void> getNotificationsState() async {
    await checkForNotificationsPermission();
    final isUserLoggedIn = _authRepository.isUserAuthenticated();
    if (isUserLoggedIn) {
      emit(
        state.copyWith(
          isSubscribedToNotifications:
              state.permissionsState == PermissionsState.granted,
          subscriptionState: UiState.success,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isSubscribedToNotifications: false,
        ),
      );
    }
  }

  Future<void> checkForNotificationsPermission() async {
    if (!state.isSubscribedToNotifications &&
        state.permissionsState != PermissionsState.granted) {
      emit(state.copyWith(
        permissionsState: PermissionsState.initial,
      ));
      final bool isNotificationsPermissionsGranted =
          await Permission.notification.isGranted;
      if (isNotificationsPermissionsGranted) {
        emit(
          state.copyWith(
            permissionsState: PermissionsState.granted,
          ),
        );
      } else {
        await unSubscribeFromNotifications();
        emit(
          state.copyWith(
            permissionsState: PermissionsState.denied,
          ),
        );
      }
    }
  }

  Future<void> requestNotificationsPermissions() async {
    emit(state.copyWith(permissionsState: PermissionsState.initial));
    final PermissionStatus notificationsPermissions =
        await Permission.notification.status;
    debugPrint("PERMISSIONS : $notificationsPermissions");
    switch (notificationsPermissions) {
      case PermissionStatus.granted:
        emit(
          state.copyWith(permissionsState: PermissionsState.granted),
        );
      case PermissionStatus.denied:
        emit(
          state.copyWith(permissionsState: PermissionsState.denied),
        );
        await Permission.notification.request();
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
      case PermissionStatus.restricted:
        emit(
          state.copyWith(permissionsState: PermissionsState.permanentlyDenied),
        );
    }
  }
}
