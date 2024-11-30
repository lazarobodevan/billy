part of 'limit_picker_bloc.dart';

abstract class LimitPickerState extends Equatable {
  const LimitPickerState();
}

class LimitPickerInitial extends LimitPickerState {
  @override
  List<Object> get props => [];
}

class ListingState extends LimitPickerState{
  @override
  List<Object?> get props => [];
}

class ListedCategoriesState extends LimitPickerState{
  final List<TransactionCategory> categories;

  const ListedCategoriesState({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class ListedSubcategoriesState extends LimitPickerState{
  final List<Subcategory> subcategories;

  const ListedSubcategoriesState({required this.subcategories});

  @override
  List<Object?> get props => [subcategories];
}