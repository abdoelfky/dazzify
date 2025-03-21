part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

final class GetCategoryBrandsEvent extends CategoryEvent {
  final String categoryId;

  const GetCategoryBrandsEvent({
    required this.categoryId,
  });

  @override
  List<Object> get props => [categoryId];
}
