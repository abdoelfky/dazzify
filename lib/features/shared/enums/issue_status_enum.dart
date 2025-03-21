import 'package:dazzify/dazzify_app.dart';

enum IssueStatus { initial, pending, progress, accepted, rejected }

extension IssueStatusExtension on IssueStatus {
  int get value {
    switch (this) {
      case IssueStatus.initial:
      case IssueStatus.pending:
        return 0;
      case IssueStatus.progress:
        return 1;
      case IssueStatus.accepted:
      case IssueStatus.rejected:
        return 2;
    }
  }

  String get key {
    switch (this) {
      case IssueStatus.initial:
        return "";
      case IssueStatus.pending:
        return "PENDING";
      case IssueStatus.progress:
        return "PROGRESS";
      case IssueStatus.accepted:
        return "ACCEPTED";
      case IssueStatus.rejected:
        return "REJECTED";
    }
  }

  String get name {
    switch (this) {
      case IssueStatus.initial:
        return "";
      case IssueStatus.pending:
        return DazzifyApp.tr.pending.toUpperCase();
      case IssueStatus.progress:
        return DazzifyApp.tr.progress.toUpperCase();
      case IssueStatus.accepted:
        return DazzifyApp.tr.accepted.toUpperCase();
      case IssueStatus.rejected:
        return DazzifyApp.tr.rejected.toUpperCase();
    }
  }
}

IssueStatus getIssueStatus(String? value) {
  switch (value) {
    case '':
      return IssueStatus.initial;
    case 'PENDING':
      return IssueStatus.pending;
    case 'PROGRESS':
      return IssueStatus.progress;
    case 'ACCEPTED':
      return IssueStatus.accepted;
    case 'REJECTED':
      return IssueStatus.rejected;
    default:
      return IssueStatus.initial;
  }
}
