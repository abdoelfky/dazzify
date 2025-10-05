import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dazzify/core/util/enums.dart';
import 'package:dazzify/features/brand/data/models/brand_branches_model.dart';
import 'package:dazzify/features/brand/data/repositories/brand_repository.dart';
import 'package:dazzify/features/brand/data/requests/get_brand_media_request.dart';
import 'package:dazzify/features/brand/data/requests/get_brand_reviews_request.dart';
import 'package:dazzify/features/shared/data/models/brand_model.dart';
import 'package:dazzify/features/shared/data/models/media_model.dart';
import 'package:dazzify/features/shared/data/models/reviews_model.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'brand_event.dart';
part 'brand_state.dart';

@injectable
class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository _brandRepository;
  int _brandImagesPage = 1;
  int _brandReelsPage = 1;
  int _brandReviewPage = 1;
  final int _brandImagesLimit = 20;
  final int _brandReelsLimit = 20;
  final int _brandReviewLimit = 20;
  String username = "";

  BrandBloc(
    this._brandRepository,
  ) : super(const BrandState()) {
    on<GetBrandBranchesEvent>(_onGetBrandBranchesEvent);
    on<GetBrandImagesEvent>(_onGetBrandImagesEvent, transformer: droppable());
    on<GetBrandReelsEvent>(_onGetBrandReelsEvent, transformer: droppable());
    on<GetBrandReviewsEvent>(_onGetBrandReviewsEvent, transformer: droppable());
    on<AddBrandViewEvent>(_onAddBrandViewEvent);
    on<RefreshEvent>(_onRefreshEvent);
    on<GetSingleBrandDetailsEvent>(_getSingleBrandDetailsEvent);
    on<SetSingleBrandDetailsEvent>(_setSingleBrandDetailsEvent);
  }

  Future<void> _onGetBrandBranchesEvent(
      GetBrandBranchesEvent event, Emitter<BrandState> emit) async {
    emit(state.copyWith(branchesState: UiState.loading));

    final results = await _brandRepository.getBrandBranches(
      brandId: event.brandId,
    );

    results.fold(
      (failure) => emit(
        state.copyWith(
          branchesState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (brandBranches) => emit(
        state.copyWith(
          branchesState: UiState.success,
          brandBranches: brandBranches,
        ),
      ),
    );
  }

  Future<void> _getSingleBrandDetailsEvent(
      GetSingleBrandDetailsEvent event, Emitter<BrandState> emit) async {
    emit(state.copyWith(brandDetailsState: UiState.loading));
    username = event.username;
    final results = await _brandRepository.getSingleBrandDetails(
      username: event.username,
    );

    results.fold(
      (failure) => emit(
        state.copyWith(
          brandDetailsState: UiState.failure,
          errorMessage: failure.message,
          errorCode: failure.errorCode,
        ),
      ),
      (brandDetails) {
        emit(
          state.copyWith(
            brandDetailsState: UiState.success,
            brandDetails: brandDetails,
          ),
        );
        add(GetBrandImagesEvent(brandDetails.id));
        add(GetBrandReelsEvent(brandDetails.id));
        add(AddBrandViewEvent(brandDetails.id));
      },
    );
  }

  Future<void> _setSingleBrandDetailsEvent(
      SetSingleBrandDetailsEvent event, Emitter<BrandState> emit) async {
    emit(
      state.copyWith(
        brandDetails: event.brandDetails,
        brandDetailsState: UiState.success,
      ),
    );
    add(GetBrandImagesEvent(event.brandDetails.id));
    add(AddBrandViewEvent(event.brandDetails.id));
  }

  Future<void> _onGetBrandImagesEvent(
      GetBrandImagesEvent event, Emitter<BrandState> emit) async {
    if (!state.hasPhotosReachedMax) {
      if (state.photos.isEmpty) {
        emit(state.copyWith(photosState: UiState.loading));
      }

      final request = GetBrandMediaRequest(
        page: _brandImagesPage,
        limit: _brandImagesLimit,
        brandId: event.brandId,
        type: "photo-album",
      );

      final results = await _brandRepository.getBrandImages(
        request: request,
      );

      results.fold(
        (failure) => emit(
          state.copyWith(
            photosState: UiState.failure,
            errorMessage: failure.message,
          ),
        ),
        (brandImages) {
          final hasPhotosReachedMax =
              brandImages.isEmpty || brandImages.length < _brandImagesLimit;
          emit(
            state.copyWith(
              photosState: UiState.success,
              photos: List.of(state.photos)..addAll(brandImages),
              hasPhotosReachedMax: hasPhotosReachedMax,
            ),
          );
          _brandImagesPage++;
        },
      );
    }
  }

  Future<void> _onGetBrandReelsEvent(
      GetBrandReelsEvent event, Emitter<BrandState> emit) async {
    if (!state.hasReelsReachedMax) {
      if (state.reels.isEmpty) {
        emit(state.copyWith(reelsState: UiState.loading));
      }

      final request = GetBrandMediaRequest(
        page: _brandReelsPage,
        limit: _brandReelsLimit,
        brandId: event.brandId,
        type: "video",
      );

      final results = await _brandRepository.getBrandReels(
        request: request,
      );

      results.fold(
        (failure) => emit(
          state.copyWith(
            reelsState: UiState.failure,
            errorMessage: failure.message,
          ),
        ),
        (brandReels) {
          final hasReelsReachedMax =
              brandReels.isEmpty || brandReels.length < _brandReelsLimit;
          emit(
            state.copyWith(
              reelsState: UiState.success,
              reels: List.of(state.reels)..addAll(brandReels),
              hasReelsReachedMax: hasReelsReachedMax,
            ),
          );
          _brandReelsPage++;
        },
      );
    }
  }

  Future<void> _onGetBrandReviewsEvent(
      GetBrandReviewsEvent event, Emitter<BrandState> emit) async {
    if (!state.hasReviewsReachedMax) {
      if (state.reviews.isEmpty) {
        emit(state.copyWith(reviewsState: UiState.loading));
      }

      final request = GetBrandReviewsRequest(
        page: _brandReviewPage,
        limit: _brandReviewLimit,
      );

      final results = await _brandRepository.getBrandReviews(
        brandId: event.brandId,
        request: request,
      );

      results.fold(
        (failure) => emit(
          state.copyWith(
            reviewsState: UiState.failure,
            errorMessage: failure.message,
          ),
        ),
        (brandReviews) {
          final bool hasReachedMax =
              brandReviews.isEmpty || brandReviews.length < _brandReviewLimit;
          emit(
            state.copyWith(
              reviews: List.of(state.reviews)..addAll(brandReviews),
              hasReviewsReachedMax: hasReachedMax,
              reviewsState: UiState.success,
            ),
          );
          _brandReviewPage++;
        },
      );
    }
  }

  Future<void> _onAddBrandViewEvent(
      AddBrandViewEvent event, Emitter<BrandState> emit) async {
    emit(state.copyWith(
      addingBrandViewState: UiState.loading,
    ));

    final results = await _brandRepository.addBrandView(
      brandId: event.brandId,
    );

    results.fold(
      (failure) => emit(
        state.copyWith(
          addingBrandViewState: UiState.failure,
          errorMessage: failure.message,
        ),
      ),
      (unit) => emit(
        state.copyWith(
          addingBrandViewState: UiState.success,
        ),
      ),
    );
  }

  Future<void> _onRefreshEvent(
    RefreshEvent event,
    Emitter<BrandState> emit,
  ) async {
    if (event.getBrandDetails) add(GetSingleBrandDetailsEvent(username));
    _brandImagesPage = 1;
    _brandReelsPage = 1;
    _brandReviewPage = 1;
    emit(state.copyWith(
      photos: [],
      reels: [],
      reviews: [],
      hasPhotosReachedMax: false,
      hasReelsReachedMax: false,
      hasReviewsReachedMax: false,
    ));
    add(GetBrandImagesEvent(state.brandDetails.id));
    add(GetBrandReelsEvent(state.brandDetails.id));
    add(GetBrandReviewsEvent(state.brandDetails.id));
  }
}
