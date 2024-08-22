part of 'subcategory_bloc.dart';

abstract class SubcategoryEvent extends Equatable {
  const SubcategoryEvent();
}

class ResetSubcategoryEvent extends SubcategoryEvent {
  @override
  List<Object?> get props => [];
}

class SubcategoryNameChangedEvent extends SubcategoryEvent {
  final String name;

  const SubcategoryNameChangedEvent({required this.name});

  @override
  List<Object?> get props => [name];
}

class SubcategoryColorChangedEvent extends SubcategoryEvent {
  final Color color;

  const SubcategoryColorChangedEvent({required this.color});

  @override
  List<Object?> get props => [color];
}

class SubcategoryIconChangedEvent extends SubcategoryEvent {
  final IconData icon;

  const SubcategoryIconChangedEvent({required this.icon});

  @override
  List<Object?> get props => [icon];
}

class SaveSubcategoryToDatabaseEvent extends SubcategoryEvent {
  final Subcategory subcategory;

  const SaveSubcategoryToDatabaseEvent({required this.subcategory});

  @override
  List<Object?> get props => [subcategory];
}
