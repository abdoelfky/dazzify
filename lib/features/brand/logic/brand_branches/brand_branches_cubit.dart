import 'package:bloc/bloc.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/brand/data/repositories/brand_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'brand_branches_state.dart';

@injectable
class BrandBranchesCubit extends Cubit<BrandBranchesState> {
  final BrandRepository _brandRepository;

  BrandBranchesCubit(this._brandRepository) : super(BrandBranchesState());

  Future<void> getBrandBranches({required String brandId}) async {
    emit(state.copyWith(brandBranchesState: UiState.loading));

    final results = await _brandRepository.getBrandBranches(
      brandId: brandId,
    );

    results.fold(
      (failure) => emit(
        state.copyWith(
          brandBranchesState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (brandBranches) => emit(
        state.copyWith(
          brandBranchesState: UiState.success,
          brandBranches: brandBranches,
        ),
      ),
    );
  }
}
