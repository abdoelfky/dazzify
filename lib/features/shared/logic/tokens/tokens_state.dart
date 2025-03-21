part of 'tokens_cubit.dart';

abstract class TokensState extends Equatable {
  const TokensState();

  @override
  List<Object> get props => [];
}

class TokensInitialState extends TokensState {}

class TokensLoadingState extends TokensState {}

class TokensSuccessState extends TokensState {}

class AuthenticatedState extends TokensState {}

class UnAuthenticatedState extends TokensState {}

class LogoutState extends TokensState {}

class TokensErrorState extends TokensState {
  final String message;

  const TokensErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class SessionExpiredState extends TokensState {
  final String message;

  const SessionExpiredState({required this.message});

  @override
  List<Object> get props => [message];
}
