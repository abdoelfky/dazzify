part of 'in_app_notifications_bloc.dart';

class InAppNotificationsState extends Equatable {
  final List<NotificationModel> notifications;
  final UiState notificationsState;
  final String notificationsFailMessage;
  final bool isSubscribedToNotifications;
  final UiState subscriptionState;
  final PermissionsState permissionsState;
  final bool hasNotificationsReachedMax;

  const InAppNotificationsState({
    this.notifications = const [],
    this.notificationsState = UiState.initial,
    this.notificationsFailMessage = '',
    this.isSubscribedToNotifications = false,
    this.subscriptionState = UiState.initial,
    this.permissionsState = PermissionsState.initial,
    this.hasNotificationsReachedMax = false,
  });

  @override
  List<Object?> get props => [
        notifications,
        notificationsState,
        notificationsFailMessage,
        isSubscribedToNotifications,
        subscriptionState,
        permissionsState,
        hasNotificationsReachedMax,
      ];

  InAppNotificationsState copyWith({
    List<NotificationModel>? notifications,
    UiState? notificationsState,
    String? notificationsFailMessage,
    bool? isSubscribedToNotifications,
    UiState? subscriptionState,
    PermissionsState? permissionsState,
    bool? hasNotificationsReachedMax,
  }) {
    return InAppNotificationsState(
      notifications: notifications ?? this.notifications,
      notificationsState: notificationsState ?? this.notificationsState,
      notificationsFailMessage:
          notificationsFailMessage ?? this.notificationsFailMessage,
      isSubscribedToNotifications:
          isSubscribedToNotifications ?? this.isSubscribedToNotifications,
      subscriptionState: subscriptionState ?? this.subscriptionState,
      permissionsState: permissionsState ?? this.permissionsState,
      hasNotificationsReachedMax:
          hasNotificationsReachedMax ?? this.hasNotificationsReachedMax,
    );
  }
}
