part of 'subcategory_bloc.dart';

abstract class SubcategoryState extends Equatable {
  const SubcategoryState();
}

class SubcategoryInitial extends SubcategoryState {
  @override
  List<Object> get props => [];
}

class SavingCategoryToDatabaseState extends SubcategoryState{
  @override
  List<Object?> get props => [];
}

class SaveCategoryToDatabaseErrorState extends SubcategoryState{
  @override
  List<Object?> get props => [];

}

class SavedSubcategoryToDatabaseState extends SubcategoryState{
  final Subcategory subcategory;

  const SavedSubcategoryToDatabaseState({required this.subcategory});
  @override
  List<Object?> get props => [subcategory];
}
