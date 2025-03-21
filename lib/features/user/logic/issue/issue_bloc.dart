import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dartz/dartz.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/user/data/models/issue/issue_model.dart';
import 'package:dazzify/features/user/data/repositories/user_repository.dart';
import 'package:dazzify/features/user/data/requests/create_issue_request.dart';
import 'package:dazzify/features/user/data/requests/get_issues_request.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'issue_event.dart';
part 'issue_state.dart';

@injectable
class IssueBloc extends Bloc<IssueEvent, IssueState> {
  final UserRepository _repository;
  int _issuePage = 1;
  final int _issueLimit = 20;

  IssueBloc(this._repository) : super(const IssueState()) {
    on<GetIssueEvent>(_onGetIssues, transformer: droppable());
    on<CreateIssueEvent>(_onCreateIssues);
  }

  Future<void> _onGetIssues(
      GetIssueEvent event, Emitter<IssueState> emit) async {
    if (!state.hasIssuesReachedMax) {
      if (state.issueList.isEmpty) {
        emit(state.copyWith(getIssueState: UiState.loading));
      }
      final Either<Failure, List<IssueModel>> issues =
          await _repository.getIssues(
        request: GetIssuesRequest(
          page: _issuePage,
          limit: _issueLimit,
        ),
      );

      issues.fold(
        (failure) => emit(
          state.copyWith(
            getIssueState: UiState.failure,
            errorMessage: failure.message,
          ),
        ),
        (issues) {
          final bool hasReachedMax =
              issues.isEmpty || issues.length < _issueLimit;
          emit(
            state.copyWith(
              getIssueState: UiState.success,
              issueList: List.of(state.issueList)..addAll(issues),
              hasIssuesReachedMax: hasReachedMax,
            ),
          );
          _issuePage++;
        },
      );
    }
  }

  Future<void> _onCreateIssues(
    CreateIssueEvent event,
    Emitter<IssueState> emit,
  ) async {
    emit(state.copyWith(createIssueState: UiState.loading));
    Either<Failure, Unit> result = await _repository.createIssues(
      request: CreateIssueRequest(
        bookingId: event.bookingId,
        comment: event.comment,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          createIssueState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (issue) {
        emit(
          state.copyWith(
            createIssueState: UiState.success,
          ),
        );
        final issueIndex = state.issueList
            .indexWhere((issue) => issue.bookingId == event.bookingId);
        state.issueList[issueIndex].status = "PENDING";
      },
    );
  }
}
