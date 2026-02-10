import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/home/data/repositories/home_repository.dart';
import 'package:dazzify/features/home/data/requests/get_all_media_request.dart';
import 'package:dazzify/features/home/data/requests/search_request.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
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
  final int _servicesLimit = 20;
  int _mediaPage = 1;
  int _brandsPage = 1;
  int _servicesPage = 1;

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

    on<GetMoreServicesEvent>(
      onGetMoreServicesEvent,
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
    if (event.keyWord == null || event.keyWord!.isEmpty) {
      emit(state.copyWith(
        showMediaItems: true,
        brands: [],
        services: [],
      ));
    } else {
      emit(state.copyWith(blocState: UiState.loading));
      _brandsPage = 1;
      _servicesPage = 1;

      final searchType = event.searchType ?? 'brand';
      final result = await _homeRepository.search(
        request: SearchRequest(
          searchType: searchType,
          searchKeyWord: event.keyWord!,
          page: 1,
          limit: searchType == 'brand' ? _brandsLimit : _servicesLimit,
        ),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            blocState: UiState.failure,
            errorMessage: failure.message,
          ),
        ),
        (results) {
          if (searchType == 'brand') {
            final brands = results.cast<BrandModel>();
            final hasBrandsReachMax =
                brands.isEmpty || brands.length < _brandsLimit;

            emit(
              state.copyWith(
                brands: brands,
                services: [],
                blocState: UiState.success,
                showMediaItems: false,
                hasBrandsReachMax: hasBrandsReachMax,
                hasServicesReachMax: false,
              ),
            );
            _brandsPage++;
          } else {
            final services = results.cast<ServiceDetailsModel>();
            final hasServicesReachMax =
                services.isEmpty || services.length < _servicesLimit;

            emit(
              state.copyWith(
                services: services,
                brands: [],
                blocState: UiState.success,
                showMediaItems: false,
                hasServicesReachMax: hasServicesReachMax,
                hasBrandsReachMax: false,
              ),
            );
            _servicesPage++;
          }
        },
      );
    }
  }

  Future<void> onGetMoreBrandsEvent(
      GetMoreBrandsEvent event, Emitter<SearchState> emit) async {
    if (!state.hasBrandsReachMax) {
      final result = await _homeRepository.search(
        request: SearchRequest(
          searchType: 'brand',
          searchKeyWord: event.keyWord ?? '',
          page: _brandsPage,
          limit: _brandsLimit,
        ),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            blocState: UiState.failure,
            errorMessage: failure.message,
          ),
        ),
        (results) {
          final brands = results.cast<BrandModel>();
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

  Future<void> onGetMoreServicesEvent(
      GetMoreServicesEvent event, Emitter<SearchState> emit) async {
    if (!state.hasServicesReachMax) {
      final result = await _homeRepository.search(
        request: SearchRequest(
          searchType: 'service',
          searchKeyWord: event.keyWord ?? '',
          page: _servicesPage,
          limit: _servicesLimit,
        ),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            blocState: UiState.failure,
            errorMessage: failure.message,
          ),
        ),
        (results) {
          final services = results.cast<ServiceDetailsModel>();
          final hasServicesReachMax =
              services.isEmpty || services.length < _servicesLimit;
          emit(
            state.copyWith(
              services: List.of(state.services)..addAll(services),
              blocState: UiState.success,
              hasServicesReachMax: hasServicesReachMax,
            ),
          );
          _servicesPage++;
        },
      );
    }
  }

  Future<void> onRefreshEvent(RefreshEvent event, Emitter<SearchState> emit) async {
    _mediaPage = 1;
    _brandsPage = 1;
    _servicesPage = 1;
    emit(const SearchState());
    // Fetch media items after refresh
    add(GetMediaItemsEvent());
  }
}
