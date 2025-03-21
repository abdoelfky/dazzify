import 'package:bloc/bloc.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/booking/data/repositories/booking_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'brand_terms_state.dart';

@Injectable()
class BrandTermsCubit extends Cubit<BrandTermsState> {
  final BookingRepository _repository;

  BrandTermsCubit(
    this._repository,
  ) : super(const BrandTermsState());

  Future<void> getBrandTerms({required String brandId}) async {
    emit(state.copyWith(termsState: UiState.loading));

    final result = await _repository.getBrandTerms(
      brandId: brandId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          termsState: UiState.failure,
        ),
      ),
      (brandTerms) {
        List<bool> brandTermsCheckList = List.generate(
          brandTerms.length,
          (index) => false,
        );

        emit(
          state.copyWith(
            brandTerms: brandTerms,
            brandTermsCheckList: brandTermsCheckList,
            termsState: UiState.success,
          ),
        );
      },
    );
  }
}
