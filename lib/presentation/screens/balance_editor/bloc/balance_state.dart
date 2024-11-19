part of 'balance_bloc.dart';

abstract class BalanceState extends Equatable {
  const BalanceState();
}

class BalanceInitial extends BalanceState {
  @override
  List<Object> get props => [];
}

class LoadingBalanceState extends BalanceState{
  @override
  List<Object?> get props => [];

}

class LoadedBalanceState extends BalanceState{
  final Balance balance;

  const LoadedBalanceState({required this.balance});

  @override
  List<Object?> get props => [balance];
}

class UpdatingBalanceState extends BalanceState{
  @override
  List<Object?> get props => [];

}

class UpdatedBalanceState extends BalanceState{
  @override
  List<Object?> get props => [];

}

class UpdateBalanceErrorState extends BalanceState{
  final String message;

  const UpdateBalanceErrorState({required this.message});

  @override
  List<Object?> get props => [];

}