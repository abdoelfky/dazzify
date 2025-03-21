import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/notifications/data/models/notification_model.dart';
import 'package:dazzify/features/notifications/data/repositories/notifications_repository.dart';
import 'package:dazzify/features/notifications/data/requests/get_notifications_list_request.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'in_app_notifications_event.dart';
part 'in_app_notifications_state.dart';

@injectable
class InAppNotificationsBloc
    extends Bloc<InAppNotificationsEvent, InAppNotificationsState> {
  final NotificationsRepository _notificationsRepository;
  int _page = 1;
  final int _limit = 20;

  InAppNotificationsBloc(
    this._notificationsRepository,
  ) : super(const InAppNotificationsState()) {
    on<GetNotificationsList>(
      onGetNotificationsList,
      transformer: droppable(),
    );
  }

  Future<void> onGetNotificationsList(event, emit) async {
    if (!state.hasNotificationsReachedMax) {
      if (state.notifications.isEmpty) {
        emit(state.copyWith(notificationsState: UiState.loading));
      }

      final result = await _notificationsRepository.getNotificationsList(
        request: GetNotificationsListRequest(
          page: _page,
          limit: _limit,
        ),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            notificationsState: UiState.failure,
            notificationsFailMessage: failure.message,
          ),
        ),
        (notifications) {
          final hasNotificationsReachedMax =
              notifications.isEmpty || notifications.length < _limit;
          emit(
            state.copyWith(
              notifications: List.of(state.notifications)
                ..addAll(notifications),
              notificationsState: UiState.success,
              hasNotificationsReachedMax: hasNotificationsReachedMax,
            ),
          );
          _page++;
        },
      );
    }
  }
}
