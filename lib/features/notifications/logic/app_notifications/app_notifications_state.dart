part of 'app_notifications_cubit.dart';

class AppNotificationsState extends Equatable {
  final UiState notificationsState;
  final String notificationsFailMessage;
  final bool isSubscribedToNotifications;
  final UiState subscriptionState;
  final PermissionsState permissionsState;

  const AppNotificationsState({
    this.notificationsState = UiState.initial,
    this.notificationsFailMessage = '',
    this.isSubscribedToNotifications = false,
    this.subscriptionState = UiState.initial,
    this.permissionsState = PermissionsState.initial,
  });

  @override
  List<Object?> get props => [
        notificationsState,
        notificationsFailMessage,
        isSubscribedToNotifications,
        subscriptionState,
        permissionsState,
      ];

  AppNotificationsState copyWith({
    UiState? notificationsState,
    String? notificationsFailMessage,
    bool? isSubscribedToNotifications,
    UiState? subscriptionState,
    PermissionsState? permissionsState,
  }) {
    return AppNotificationsState(
      notificationsState: notificationsState ?? this.notificationsState,
      notificationsFailMessage:
          notificationsFailMessage ?? this.notificationsFailMessage,
      isSubscribedToNotifications:
          isSubscribedToNotifications ?? this.isSubscribedToNotifications,
      subscriptionState: subscriptionState ?? this.subscriptionState,
      permissionsState: permissionsState ?? this.permissionsState,
    );
  }
}
