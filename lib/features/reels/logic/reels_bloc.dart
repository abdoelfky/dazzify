import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/reels/data/repositories/reels_repository.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'reels_event.dart';
part 'reels_state.dart';

@injectable
class ReelsBloc extends Bloc<ReelsEvent, ReelsState> {
  final ReelsRepository _reelsRepository;
  String? selectedMainCategory;

  ReelsBloc(
    this._reelsRepository,
  ) : super(const ReelsState()) {
    on<GetReelsEvent>(_onGetReels, transformer: droppable());
    on<AddViewForReelEvent>(
      _onAddViewForReel,
      transformer: droppable(),
    );
    on<FilterReelsByCategories>(_filterReelsByCategories);
  }

  Future<void> _onGetReels(
    GetReelsEvent event,
    Emitter<ReelsState> emit,
  ) async {
    if (!state.hasReelsReachedMax) {
      if (state.reels.isEmpty) {
        emit(state.copyWith(reelsState: UiState.loading));
      }
      final results = await _reelsRepository.getReels(
        mainCategoryId: selectedMainCategory,
      );
      results.fold(
        (failure) => emit(
          state.copyWith(
            reelsState: UiState.failure,
          ),
        ),
        (reels) {
          final hasReachedMax = reels.isEmpty;
          emit(
            state.copyWith(
              reels: List.of(state.reels)..addAll(reels),
              reelsState: UiState.success,
              hasReelsReachedMax: hasReachedMax,
            ),
          );
        },
      );
    }
  }

  void _filterReelsByCategories(
    FilterReelsByCategories event,
    Emitter<ReelsState> emit,
  ) {
    emit(state.copyWith(
      hasReelsReachedMax: false,
      reels: [],
      reelsState: UiState.loading,
    ));
    if (selectedMainCategory != event.mainCategoryId) {
      selectedMainCategory = event.mainCategoryId;
    } else {
      selectedMainCategory = null;
    }
    add(const GetReelsEvent());
  }

  Future<void> _onAddViewForReel(
    AddViewForReelEvent event,
    Emitter<ReelsState> emit,
  ) async {
    emit(state.copyWith(addViewState: UiState.loading));
    final results = await _reelsRepository.addViewForMedia(
      mediaId: event.reelId,
    );
    results.fold(
      (failure) => emit(
        state.copyWith(
          addViewState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (addView) => emit(
        state.copyWith(
          addViewState: UiState.success,
        ),
      ),
    );
  }
}
