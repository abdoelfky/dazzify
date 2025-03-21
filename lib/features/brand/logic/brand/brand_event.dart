part of 'brand_bloc.dart';

sealed class BrandEvent extends Equatable {
  const BrandEvent();
}

class GetBrandBranchesEvent extends BrandEvent {
  final String brandId;

  const GetBrandBranchesEvent(this.brandId);

  @override
  List<Object?> get props => [brandId];
}

class GetBrandImagesEvent extends BrandEvent {
  final String brandId;

  const GetBrandImagesEvent(this.brandId);

  @override
  List<Object?> get props => [brandId];
}

class GetBrandReelsEvent extends BrandEvent {
  final String brandId;

  const GetBrandReelsEvent(this.brandId);

  @override
  List<Object> get props => [brandId];
}

class GetBrandReviewsEvent extends BrandEvent {
  final String brandId;

  const GetBrandReviewsEvent(this.brandId);

  @override
  List<Object> get props => [brandId];
}

class AddBrandViewEvent extends BrandEvent {
  final String brandId;

  const AddBrandViewEvent(this.brandId);

  @override
  List<Object> get props => [brandId];
}

class RefreshEvent extends BrandEvent {
  final bool getBrandDetails;

  const RefreshEvent({this.getBrandDetails = false});

  @override
  List<Object> get props => [getBrandDetails];
}

class GetSingleBrandDetailsEvent extends BrandEvent {
  final String username;

  const GetSingleBrandDetailsEvent(this.username);

  @override
  List<Object> get props => [username];
}

class SetSingleBrandDetailsEvent extends BrandEvent {
  final BrandModel brandDetails;

  const SetSingleBrandDetailsEvent(this.brandDetails);

  @override
  List<Object> get props => [brandDetails];
}
