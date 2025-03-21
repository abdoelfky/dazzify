import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/home/data/repositories/home_repository.dart';
import 'package:dazzify/features/home/data/requests/get_all_media_request.dart';
import 'package:dazzify/features/home/data/requests/get_brands_request.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/transformers.dart';

part 'search_event.dart';
part 'search_state.dart';

@Injectable()
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final HomeRepository _homeRepository;
  final int _mediaLimit = 20;
  final int _brandsLimit = 20;
  int _mediaPage = 1;
  int _brandsPage = 1;

  SearchBloc(
    this._homeRepository,
  ) : super(const SearchState()) {
    on<GetMediaItemsEvent>(onGetMediaItemsEvent, transformer: droppable());
    on<SwitchScreenViewEvent>(onSwitchScreenViewEvent);
    on<RefreshEvent>(onRefreshEvent);
    on<GetSearchResultsEvent>(onGetSearchResultsEvent,
        transformer: (events, mapper) => events
            .distinct()
            .debounceTime(const Duration(milliseconds: 700))
            .switchMap(mapper));

    on<GetMoreBrandsEvent>(
      onGetMoreBrandsEvent,
      transformer: droppable(),
    );
  }

  void onSwitchScreenViewEvent(
    SwitchScreenViewEvent event,
    Emitter<SearchState> emit,
  ) {
    bool showMedia = false;
    if (event.showMedia) {
      showMedia = true;
    }
    emit(state.copyWith(showMediaItems: showMedia));
  }

  Future<void> onGetMediaItemsEvent(
    GetMediaItemsEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (!state.hasMediaReachMax && state.showMediaItems) {
      if (state.media.isEmpty) {
        emit(state.copyWith(blocState: UiState.loading));
      }

      final result = await _homeRepository.getAllMedia(
        request: GetAllMediaRequest(
          page: _mediaPage,
          limit: _mediaLimit,
        ),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            blocState: UiState.failure,
            errorMessage: failure.message,
          ),
        ),
        (media) {
          final hasReachedMax = media.isEmpty || media.length < _mediaLimit;
          emit(state.copyWith(
            media: List.of(state.media)..addAll(media),
            blocState: UiState.success,
            hasMediaReachMax: hasReachedMax,
          ));
          _mediaPage++;
        },
      );
    }
  }

  Future<void> onGetSearchResultsEvent(
      GetSearchResultsEvent event, Emitter<SearchState> emit) async {
    if (event.keyWord!.isEmpty) {
      emit(state.copyWith(
        showMediaItems: true,
        brands: [],
      ));
    } else {
      emit(state.copyWith(blocState: UiState.loading));

      final result = await _homeRepository.getPopularBrands(
        request: GetBrandsRequest(
          page: 1,
          limit: _brandsLimit,
          keyword: event.keyWord,
        ),
      );

      result.fold(
          (failure) => emit(
                state.copyWith(
                  blocState: UiState.failure,
                  errorMessage: failure.message,
                ),
              ), (brands) {
        final hasBrandsReachMax =
            brands.isEmpty || brands.length < _brandsLimit;

        emit(
          state.copyWith(
            brands: brands,
            blocState: UiState.success,
            showMediaItems: false,
            hasBrandsReachMax: hasBrandsReachMax,
          ),
        );
        _brandsPage++;
      });
    }
  }

  Future<void> onGetMoreBrandsEvent(
      GetMoreBrandsEvent event, Emitter<SearchState> emit) async {
    if (!state.hasBrandsReachMax) {
      if (state.media.isEmpty) {
        emit(state.copyWith(blocState: UiState.loading));
      }
      final result = await _homeRepository.getPopularBrands(
        request: GetBrandsRequest(
          page: _brandsPage,
          limit: _brandsLimit,
          keyword: event.keyWord,
        ),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            blocState: UiState.failure,
            errorMessage: failure.message,
          ),
        ),
        (brands) {
          final hasBrandsReachMax =
              brands.isEmpty || brands.length < _brandsLimit;
          emit(
            state.copyWith(
              brands: List.of(state.brands)..addAll(brands),
              blocState: UiState.success,
              hasBrandsReachMax: hasBrandsReachMax,
            ),
          );
          _brandsPage++;
        },
      );
    }
  }

  void onRefreshEvent(RefreshEvent event, Emitter<SearchState> emit) {
    _mediaPage = 1;
    _brandsPage = 1;
    emit(const SearchState());
  }
}
