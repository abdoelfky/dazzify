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
    on<EmitSearchLoadingEvent>(onEmitSearchLoadingEvent);
    on<ClearSearchEvent>(onClearSearchEvent);
    on<GetSearchResultsEvent>(onGetSearchResultsEvent,
        transformer: (events, mapper) => events
            .distinct()
            .debounceTime(const Duration(seconds: 2))
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

  void onClearSearchEvent(
    ClearSearchEvent event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(
      blocState: UiState.success,
      errorMessage: '',
      showMediaItems: true,
      brands: [],
      services: [],
    ));
  }

  void onEmitSearchLoadingEvent(
    EmitSearchLoadingEvent event,
    Emitter<SearchState> emit,
  ) {
    // Only clear the list we're about to fetch so the other tab keeps its results
    final type = event.searchType ?? 'brand';
    if (type == 'brand') {
      emit(state.copyWith(
        blocState: UiState.loading,
        errorMessage: '',
        brands: [],
        showMediaItems: false,
      ));
    } else {
      emit(state.copyWith(
        blocState: UiState.loading,
        errorMessage: '',
        services: [],
        showMediaItems: false,
      ));
    }
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
        blocState: UiState.success,
        errorMessage: '',
        showMediaItems: true,
        brands: [],
        services: [],
      ));
    } else {
      final searchType = event.searchType ?? 'brand';
      // Only clear the list we're about to fetch so the other tab keeps its results
      if (searchType == 'brand') {
        _brandsPage = 1;
        emit(state.copyWith(
          blocState: UiState.loading,
          errorMessage: '',
          brands: [],
        ));
      } else {
        _servicesPage = 1;
        emit(state.copyWith(
          blocState: UiState.loading,
          errorMessage: '',
          services: [],
        ));
      }

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
                blocState: UiState.success,
                showMediaItems: false,
                hasBrandsReachMax: hasBrandsReachMax,
                isLoadingBrandsMore: false,
                lastBrandsKeyword: event.keyWord ?? '',
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
                blocState: UiState.success,
                showMediaItems: false,
                hasServicesReachMax: hasServicesReachMax,
                isLoadingServicesMore: false,
                lastServicesKeyword: event.keyWord ?? '',
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
    if (state.blocState == UiState.loading ||
        state.hasBrandsReachMax ||
        state.isLoadingBrandsMore) return;

    emit(state.copyWith(isLoadingBrandsMore: true));

    final pageToFetch = _brandsPage;
    final result = await _homeRepository.search(
      request: SearchRequest(
        searchType: 'brand',
        searchKeyWord: event.keyWord ?? '',
        page: pageToFetch,
        limit: _brandsLimit,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          blocState: UiState.failure,
          errorMessage: failure.message,
          isLoadingBrandsMore: false,
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
            isLoadingBrandsMore: false,
          ),
        );
        _brandsPage++;
      },
    );
  }

  Future<void> onGetMoreServicesEvent(
      GetMoreServicesEvent event, Emitter<SearchState> emit) async {
    if (state.blocState == UiState.loading ||
        state.hasServicesReachMax ||
        state.isLoadingServicesMore) return;

    emit(state.copyWith(isLoadingServicesMore: true));

    final pageToFetch = _servicesPage;
    final result = await _homeRepository.search(
      request: SearchRequest(
        searchType: 'service',
        searchKeyWord: event.keyWord ?? '',
        page: pageToFetch,
        limit: _servicesLimit,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          blocState: UiState.failure,
          errorMessage: failure.message,
          isLoadingServicesMore: false,
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
            isLoadingServicesMore: false,
          ),
        );
        _servicesPage++;
      },
    );
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
