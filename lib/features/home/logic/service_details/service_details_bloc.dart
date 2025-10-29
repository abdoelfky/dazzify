import 'package:bloc/bloc.dart';
import 'package:dazzify/core/services/tiktok_sdk_service.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/home/data/repositories/home_repository.dart';
import 'package:dazzify/features/home/data/requests/get_service_review_request.dart';
import 'package:dazzify/features/shared/data/models/reviews_model.dart';
import 'package:dazzify/features/shared/data/models/service_details_model.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'service_details_event.dart';
part 'service_details_state.dart';

@injectable
class ServiceDetailsBloc
    extends Bloc<ServiceDetailsEvent, ServiceDetailsState> {
  final HomeRepository _repository;

  int _reviewPage = 1;
  final int _reviewsLimit = 20;

  ServiceDetailsBloc(this._repository) : super(const ServiceDetailsState()) {
    on<GetBrandBranchesEvent>(_onGetBrandBranches);
    on<AddServiceEvent>(_addService);
    on<GetServiceDetailsEvent>(_getServiceDetails);
    on<GetServiceReviewsEvent>(_onGetServiceReviews);
    on<GetMoreLikeThisEvent>(_onGetMoreLikeThis);
  }

  Future<void> _onGetBrandBranches(
    GetBrandBranchesEvent event,
    Emitter<ServiceDetailsState> emit,
  ) async {
    emit(state.copyWith(blocState: UiState.loading));

    final results = await _repository.getBrandBranches(
      brandId: event.brandId,
    );

    results.fold(
      (failure) => emit(
        state.copyWith(
          blocState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (brandBranches) => emit(
        state.copyWith(
          blocState: UiState.success,
          brandBranches: brandBranches,
        ),
      ),
    );
  }

  Future<void> _getServiceDetails(
    GetServiceDetailsEvent event,
    Emitter<ServiceDetailsState> emit,
  ) async {
    emit(state.copyWith(blocState: UiState.loading));

    final results = await _repository.getSingleServiceDetails(
      serviceId: event.serviceId,
    );

    results.fold(
      (failure) => emit(
        state.copyWith(
          blocState: UiState.failure,
          errorMessage: failure.message,
          errorCode: failure.errorCode,
        ),
      ),
      (service) {
        // Track service view for TikTok
        TikTokSdkService.instance.logViewContent(
          contentId: service!.id,
          contentName: service.title,
          contentCategory: service.brand.name,
        );
        
        emit(
          state.copyWith(
            blocState: UiState.success,
            service: service,
          ),
        );
      },
    );
  }

  Future<void> _addService(
    AddServiceEvent event,
    Emitter<ServiceDetailsState> emit,
  ) async {
    emit(state.copyWith(service: event.service, blocState: UiState.success));
  }

  Future<void> _onGetServiceReviews(
    GetServiceReviewsEvent event,
    Emitter<ServiceDetailsState> emit,
  ) async {
    if (!state.hasReviewsReachedMax) {
      if (state.serviceReview.isEmpty) {
        emit(state.copyWith(serviceReviewState: UiState.loading));
      }

      final reviews = await _repository.getServiceReview(
        request: GetServiceReviewRequest(
          serviceId: event.serviceId,
          page: _reviewPage,
          limit: _reviewsLimit,
        ),
      );

      reviews.fold(
        (failure) => emit(
          state.copyWith(
            serviceReviewState: UiState.failure,
            errorMessage: failure.message,
          ),
        ),
        (reviews) {
          final hasReachedMax =
              reviews.isEmpty || reviews.length < _reviewsLimit;
          emit(
            state.copyWith(
              serviceReview: List.of(state.serviceReview)..addAll(reviews),
              hasReviewsReachedMax: hasReachedMax,
              serviceReviewState: UiState.success,
            ),
          );
          _reviewPage++;
        },
      );
    }
  }

  Future<void> _onGetMoreLikeThis(
    GetMoreLikeThisEvent event,
    Emitter<ServiceDetailsState> emit,
  ) async {
    emit(state.copyWith(moreLikeThisState: UiState.loading));

    final result = await _repository.getMoreLikeThisService(
      serviceId: event.serviceId,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage: failure.message,
          moreLikeThisState: UiState.failure,
        ),
      ),
      (moreLikeThisServices) => emit(
        state.copyWith(
          moreLikeThisServices: moreLikeThisServices,
          moreLikeThisState: UiState.success,
        ),
      ),
    );
  }
}
