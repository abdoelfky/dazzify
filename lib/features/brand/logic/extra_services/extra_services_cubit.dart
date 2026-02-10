import 'package:bloc/bloc.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/brand/data/repositories/brand_repository.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'extra_services_state.dart';

@injectable
class ExtraServicesCubit extends Cubit<ExtraServicesState> {
  final BrandRepository _brandRepository;

  ExtraServicesCubit(this._brandRepository) : super(ExtraServicesState());

  Future<void> getBrandExtraServices({required String brandId}) async {
    emit(state.copyWith(extraServicesState: UiState.loading));

    final results = await _brandRepository.getBrandExtraServices(
      brandId: brandId,
    );

    results.fold(
      (failure) => emit(
        state.copyWith(
          extraServicesState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (extraServices) => emit(
        state.copyWith(
          extraServicesState: UiState.success,
          extraServices: extraServices,
        ),
      ),
    );
  }
}

