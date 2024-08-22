part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class ResetCategoryEvent extends CategoryEvent {
  @override
  List<Object?> get props => [];
}

class CategoryNameChangedEvent extends CategoryEvent {
  final String name;

  const CategoryNameChangedEvent({required this.name});

  @override
  List<Object?> get props => [name];
}

class CategoryColorChangedEvent extends CategoryEvent {
  final Color color;

  const CategoryColorChangedEvent({required this.color});

  @override
  List<Object?> get props => [color];
}

class CategoryIconChangedEvent extends CategoryEvent {
  final IconData icon;

  const CategoryIconChangedEvent({required this.icon});

  @override
  List<Object?> get props => [icon];
}

class SaveCategoryToDatabaseEvent extends CategoryEvent {
  @override
  List<Object?> get props => [];
}

class ListCategoriesEvent extends CategoryEvent{
  @override
  List<Object?> get props => [];

}

class DeleteCategoryEvent extends CategoryEvent{
  final int id;

  const DeleteCategoryEvent({required this.id});

  @override
  List<Object?> get props => [];
}

class UpdateCategoryEvent extends CategoryEvent{
  final TransactionCategory category;

  const UpdateCategoryEvent({required this.category});

  @override
  List<Object?> get props => [category];
}

class UpdateCategoryWithSubcategoryEvent extends CategoryEvent{
  final Subcategory subcategory;

  const UpdateCategoryWithSubcategoryEvent({required this.subcategory});

  @override
  List<Object?> get props => [subcategory];

}