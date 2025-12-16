import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/home/data/repositories/home_repository.dart';
import 'package:dazzify/features/home/data/requests/get_brands_request.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'home_brands_event.dart';
part 'home_brands_state.dart';

@Injectable()
class HomeBrandsBloc extends Bloc<HomeBrandsEvent, HomeBrandsState> {
  final HomeRepository _homeRepository;

  int _popularBrandsPage = 1;
  int _topRatedBrandsPage = 1;

  final int _popularBrandsLimit = 20;
  final int _topRatedBrandsLimit = 20;
  String? selectedPopularMainCategory;
  String? selectedTopRatedMainCategory;

  HomeBrandsBloc(
    this._homeRepository,
  ) : super(const HomeBrandsState()) {
    on<GetPopularBrandsEvent>(_onGetPopularBrands, transformer: droppable());
    on<GetTopRatedBrandsEvent>(_onGetTopRatedBrands, transformer: droppable());
    on<FilterTopRatedBrandsByCategory>(_filterTopRatedBrandsByCategory);
    on<FilterPopularBrandsByCategory>(_filterPopularBrandsByCategory);
  }

  Future<void> _onGetPopularBrands(
      GetPopularBrandsEvent event, Emitter<HomeBrandsState> emit) async {
    if (!state.hasPopularReachedMax) {
      if (state.popularBrands.isEmpty) {
        emit(state.copyWith(popularBrandsState: UiState.loading));
      }

      final result = await _homeRepository.getPopularBrands(
        request: GetBrandsRequest(
          page: _popularBrandsPage,
          limit: _popularBrandsLimit,
          mainCategory: selectedPopularMainCategory,
        ),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            popularBrandsState: UiState.failure,
            errorMessage: failure.message,
          ),
        ),
        (popularBrands) {
          final hasReachedMax = popularBrands.isEmpty ||
              popularBrands.length < _popularBrandsLimit;
          emit(
            state.copyWith(
              popularBrands: List.of(state.popularBrands)
                ..addAll(popularBrands),
              popularBrandsState: UiState.success,
              hasPopularReachedMax: hasReachedMax,
            ),
          );
          _popularBrandsPage++;
        },
      );
    }
  }

  Future<void> _onGetTopRatedBrands(
    GetTopRatedBrandsEvent event,
    Emitter<HomeBrandsState> emit,
  ) async {
    if (!state.hasTopRatedReachedMax) {
      if (state.topRatedBrands.isEmpty) {
        emit(state.copyWith(topRatedBrandsState: UiState.loading));
      }

      final topRated = await _homeRepository.getTopRatedBrands(
        request: GetBrandsRequest(
          page: _topRatedBrandsPage,
          limit: _topRatedBrandsLimit,
          mainCategory: selectedTopRatedMainCategory,
        ),
      );

      topRated.fold(
        (failure) => emit(
          state.copyWith(
            topRatedBrandsState: UiState.failure,
            errorMessage: failure.message,
          ),
        ),
        (topRatedBrands) {
          final hasReachedMax = topRatedBrands.isEmpty ||
              topRatedBrands.length < _topRatedBrandsLimit;
          emit(
            state.copyWith(
              topRatedBrands: List.of(state.topRatedBrands)
                ..addAll(topRatedBrands),
              topRatedBrandsState: UiState.success,
              hasTopRatedReachedMax: hasReachedMax,
            ),
          );
          _topRatedBrandsPage++;
        },
      );
    }
  }

  void _filterTopRatedBrandsByCategory(
    FilterTopRatedBrandsByCategory event,
    Emitter<HomeBrandsState> emit,
  ) {
    emit(state.copyWith(
      hasTopRatedReachedMax: false,
      topRatedBrands: [],
      topRatedBrandsState: UiState.loading,
    ));
    if (selectedTopRatedMainCategory != event.mainCategoryId) {
      selectedTopRatedMainCategory = event.mainCategoryId;
    } else {
      selectedTopRatedMainCategory = null;
    }
    _topRatedBrandsPage = 1;
    add(const GetTopRatedBrandsEvent());
  }

  void _filterPopularBrandsByCategory(
    FilterPopularBrandsByCategory event,
    Emitter<HomeBrandsState> emit,
  ) {
    emit(state.copyWith(
      hasPopularReachedMax: false,
      popularBrands: [],
      popularBrandsState: UiState.loading,
    ));
    if (selectedPopularMainCategory != event.mainCategoryId) {
      selectedPopularMainCategory = event.mainCategoryId;
    } else {
      selectedPopularMainCategory = null;
    }
    _popularBrandsPage = 1;
    add(const GetPopularBrandsEvent());
  }
}
