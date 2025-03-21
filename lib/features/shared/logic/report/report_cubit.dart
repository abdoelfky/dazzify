import 'package:bloc/bloc.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/shared/data/requests/report_request.dart';
import 'package:dazzify/features/user/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

part 'report_state.dart';

@injectable
class ReportCubit extends Cubit<ReportState> {
  final TextEditingController reportController;
  final GlobalKey<FormState> formKey;
  final UserRepository userRepository;
  ReportRequest request = ReportRequest();

  ReportCubit(
    this.reportController,
    this.formKey,
    this.userRepository,
  ) : super(ReportState());

  void setUp(String type, String id) {
    request.type = type;
    request.id = id;
  }

  Future<void> execute() async {
    if (formKey.currentState!.validate()) {
      request.description = reportController.text;
      final res = await userRepository.report(request: request);
      res.fold(
        (failure) {
          emit(
            state.copyWith(
              uiState: UiState.failure,
              message: failure.message,
            ),
          );
        },
        (bookingReviewRequest) {
          emit(state.copyWith(uiState: UiState.success));
        },
      );
    }
  }

  @override
  Future<void> close() {
    reportController.dispose();
    return super.close();
  }
}
