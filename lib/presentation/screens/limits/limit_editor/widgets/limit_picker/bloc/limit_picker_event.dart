part of 'limit_picker_bloc.dart';

abstract class LimitPickerEvent extends Equatable {
  const LimitPickerEvent();
}

class ListCategoriesEvent extends LimitPickerEvent{
  @override
  List<Object?> get props => [];
}

class ListSubcategoriesEvent extends LimitPickerEvent{
  @override
  List<Object?> get props => [];
}

class ListTransactionTypesEvent extends LimitPickerEvent{
  @override
  List<Object?> get props => [];
}

class ListPaymentMethodsEvent extends LimitPickerEvent{
  @override
  List<Object?> get props => [];
}