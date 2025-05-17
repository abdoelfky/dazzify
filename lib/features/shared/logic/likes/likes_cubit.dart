import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/user/data/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'likes_state.dart';

@injectable
class LikesCubit extends Cubit<LikesState> {
  final UserRepository _userRepository;
  String currentMediaId = "";

  LikesCubit(this._userRepository) : super(const LikesState());

  Future<void> getLikesIds() async {
    final result = await _userRepository.getLikesIds();

    result.fold(
      (failure) => emit(
        state.copyWith(
          idsState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (likesIds) => emit(state.copyWith(
        idsState: UiState.success,
        likesIds: likesIds.toSet(),
      )),
    );
  }

  Future<void> _addLike({required String mediaId}) async {
    currentMediaId = mediaId;
    emit(
      state.copyWith(
        likesIds: Set.from(state.likesIds)..add(mediaId),
        addLikeState: UiState.loading,
        removeLikeState: UiState.initial,
      ),
    );

    final results = await _userRepository.addLike(
      mediaId: mediaId,
    );

    results.fold(
      (failure) => emit(state.copyWith(
        addLikeState: UiState.failure,
        errorMessage: failure.message,
      )),
      (addLike) {
        emit(
          state.copyWith(
            addLikeState: UiState.success,
          ),
        );
      },
    );
  }

  Future<void> _removeLike({required String mediaId}) async {
    currentMediaId = mediaId;
    emit(
      state.copyWith(
        likesIds: Set.from(state.likesIds)..remove(mediaId),
        removeLikeState: UiState.loading,
        addLikeState: UiState.initial,
      ),
    );

    final results = await _userRepository.removeLike(
      mediaId: mediaId,
    );

    results.fold(
      (failure) => emit(state.copyWith(
        removeLikeState: UiState.failure,
        errorMessage: failure.message,
      )),
      (removeLike) {
        emit(
          state.copyWith(
            removeLikeState: UiState.success,
          ),
        );
      },
    );
  }

  // Future<void> addOrRemoveLike({
  //   required String mediaId,
  // }) async {
  //   if (state.likesIds.contains(mediaId)) {
  //     _removeLike(mediaId: mediaId);
  //   } else {
  //     _addLike(mediaId: mediaId);
  //   }
  // }
  final Set<String> _likeProcessing = {};

  Future<void> addOrRemoveLike({required String mediaId}) async {
    // Prevent multiple taps on the same media item
    if (_likeProcessing.contains(mediaId)) return;

    _likeProcessing.add(mediaId);

    try {
      if (state.likesIds.contains(mediaId)) {
        await _removeLike(mediaId: mediaId);
      } else {
        await _addLike(mediaId: mediaId);
      }
    } finally {
      _likeProcessing.remove(mediaId);
    }
  }

}
