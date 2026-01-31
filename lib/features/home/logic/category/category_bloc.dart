import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/home/data/repositories/home_repository.dart';
import 'package:dazzify/features/home/data/requests/get_brands_request.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'category_event.dart';
part 'category_state.dart';

@Injectable()
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final HomeRepository _homeRepository;

  int _page = 1;
  final int _limit = 20;

  CategoryBloc(
    this._homeRepository,
  ) : super(const CategoryState()) {
    on<GetCategoryBrandsEvent>(
      onGetCategoryBrandsEvent,
      transformer: droppable(),
    );
  }

  Future<void> onGetCategoryBrandsEvent(
    GetCategoryBrandsEvent event,
    Emitter<CategoryState> emit,
  ) async {
    if (!state.hasReachedMax) {
      // Check if this is initial load or pagination
      final isInitialLoad = state.brands.isEmpty;
      
      // Only emit loading state for initial load, use isLoadingMore for pagination
      if (isInitialLoad) {
        emit(state.copyWith(blocState: UiState.loading));
      } else {
        emit(state.copyWith(isLoadingMore: true));
      }

      final result = await _homeRepository.getTopRatedBrands(
        request: GetBrandsRequest(
          page: _page,
          limit: _limit,
          mainCategory: event.categoryId,
        ),
      );

      result.fold(
        (failure) => emit(
          state.copyWith(
            blocState: UiState.failure,
            errorMessage: failure.message,
            isLoadingMore: false,
          ),
        ),
        (brands) {
          final hasReachedMax = brands.isEmpty || brands.length < _limit;
          emit(
            state.copyWith(
              brands: List.of(state.brands)..addAll(brands),
              blocState: UiState.success,
              hasReachedMax: hasReachedMax,
              isLoadingMore: false,
            ),
          );
          _page++;
        },
      );
    }
  }
}
