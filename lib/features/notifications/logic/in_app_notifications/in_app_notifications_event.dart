part of 'in_app_notifications_bloc.dart';

sealed class InAppNotificationsEvent extends Equatable {
  const InAppNotificationsEvent();

  @override
  List<Object> get props => [];
}

class GetNotificationsList extends InAppNotificationsEvent {}
