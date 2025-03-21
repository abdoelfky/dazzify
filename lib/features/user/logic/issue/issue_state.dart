part of 'issue_bloc.dart';

class IssueState extends Equatable {
  // States
  final UiState getIssueState;
  final UiState createIssueState;

  // Data
  final List<IssueModel> issueList;

  final String errorMessage;
  final bool hasIssuesReachedMax;

  const IssueState({
    this.getIssueState = UiState.initial,
    this.createIssueState = UiState.initial,
    this.issueList = const [],
    this.errorMessage = "",
    this.hasIssuesReachedMax = false,
  });

  IssueState copyWith({
    UiState? getIssueState,
    UiState? createIssueState,
    List<IssueModel>? issueList,
    String? errorMessage,
    bool? hasIssuesReachedMax,
  }) {
    return IssueState(
      getIssueState: getIssueState ?? this.getIssueState,
      createIssueState: createIssueState ?? this.createIssueState,
      issueList: issueList ?? this.issueList,
      errorMessage: errorMessage ?? this.errorMessage,
      hasIssuesReachedMax: hasIssuesReachedMax ?? this.hasIssuesReachedMax,
    );
  }

  @override
  List<Object> get props => [
        getIssueState,
        createIssueState,
        issueList,
        errorMessage,
        hasIssuesReachedMax,
      ];
}
