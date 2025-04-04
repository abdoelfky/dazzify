import 'package:dazzify/core/api/dio_tokens_interceptor.dart';
import 'package:dazzify/core/errors/failures.dart';
import 'package:dazzify/core/injection/injection.dart';
import 'package:dazzify/features/auth/data/repositories/auth_repository.dart';
import 'package:dazzify/settings/router/app_router.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mwidgets/mwidgets.dart';

part 'tokens_state.dart';

class TokensCubit extends Cubit<TokensState> {
  final AuthRepository _authRepository;
  String _userAccessToken = '';

  TokensCubit(this._authRepository) : super(TokensInitialState());

  Future<void> isUserAuthenticated() async {
    emit(TokensLoadingState());

    debugPrint(state.toString());
    final isAuthenticated = _authRepository.isUserAuthenticated();
    if (isAuthenticated) {
      emit(AuthenticatedState());
    } else {
      emit(UnAuthenticatedState());
    }
  }

  Future<String> getUserAccessToken() async {
    emit(TokensLoadingState());
    debugPrint(state.toString());
    final result = await _authRepository.getUserAccessToken();
    result.fold(
      (failure) {
        if (failure is SessionFailure) {
          emit(SessionExpiredState(message: failure.message));
        } else {
          emit(TokensErrorState(message: failure.message));
        }
      },
      (accessToken) {
        _userAccessToken = accessToken;
        emit(TokensSuccessState());
      },
    );
    return _userAccessToken;
  }
  Future<void> deleteUserTokens() async {
    emit(TokensLoadingState());
    debugPrint(state.toString());
    await _authRepository.deleteUserTokens();
    getIt<DioTokenInterceptor>().logoutReset();
    emit(LogoutState());
  }

  Future<void> emitSessionExpired() async {
    emit(TokensLoadingState());
    emit(const SessionExpiredState(message: ""));
  }

  @override
  void onChange(Change<TokensState> change) {
    if (change.currentState is TokensLoadingState &&
        change.nextState is AuthenticatedState) {
      Future.delayed(const Duration(seconds: 4), () {
        getIt<AppRouter>().replace(const AuthenticatedRoute());
      });
    } else if (change.currentState is TokensLoadingState &&
        change.nextState is UnAuthenticatedState) {
      Future.delayed(const Duration(seconds: 4), () {
        getIt<AppRouter>().replace(const AuthRoute());
      });
    } else if (change.currentState is TokensLoadingState &&
        change.nextState is SessionExpiredState) {
      getIt<AppRouter>().replace(const AuthRoute());
    } else if (change.currentState is TokensLoadingState &&
        change.nextState is LogoutState) {
      getIt<AppRouter>().replace(const AuthRoute());
    }

    super.onChange(change);
  }
}
