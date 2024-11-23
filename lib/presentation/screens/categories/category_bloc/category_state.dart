part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
}

class CategoryInitial extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryNameChangedState extends CategoryState{
  final String name;

  const CategoryNameChangedState({required this.name});
  @override
  List<Object?> get props => [name];

}

class CategoryColorChangedState extends CategoryState{
  final Color color;

  const CategoryColorChangedState({required this.color});
  @override
  List<Object?> get props => [color];

}

class CategoryIconChangedState extends CategoryState{
  final IconData icon;

  const CategoryIconChangedState({required this.icon});
  @override
  List<Object?> get props => [icon];
}

class SavingCategoryToDatabase extends CategoryState{
  @override
  List<Object?> get props => [];
}

class SaveCategoryToDatabaseErrorState extends CategoryState{
  final String message;

  const SaveCategoryToDatabaseErrorState({required this.message});

  @override
  List<Object?> get props => [message];

}

class SavedCategoryToDatabase extends CategoryState{
  final TransactionCategory category;

  const SavedCategoryToDatabase({required this.category});
  @override
  List<Object?> get props => [category];
}

class LoadingCategoriesState extends CategoryState{
  @override
  List<Object?> get props => [];

}

class LoadedCategoriesState extends CategoryState{
  final List<TransactionCategory> categories;

  const LoadedCategoriesState({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class LoadingCategoriesErrorState extends CategoryState{
  @override
  List<Object?> get props => [];

}