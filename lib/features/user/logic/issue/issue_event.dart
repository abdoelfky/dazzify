part of 'issue_bloc.dart';

class IssueEvent extends Equatable {
  const IssueEvent();

  @override
  List<Object?> get props => [];
}

class GetIssueEvent extends IssueEvent {
  const GetIssueEvent();

  @override
  List<Object> get props => [];
}

class CreateIssueEvent extends IssueEvent {
  final String bookingId;
  final String comment;

  const CreateIssueEvent({required this.bookingId, required this.comment});

  @override
  List<Object> get props => [bookingId, comment];
}
