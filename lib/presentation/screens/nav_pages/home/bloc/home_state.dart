part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class LoadingHomeState extends HomeState{
  @override
  List<Object?> get props => [];

}

class LoadedHomeState extends HomeState{
  final List<Transaction> transactions;
  final Balance balance;

  const LoadedHomeState({required this.transactions, required this.balance});

  @override
  List<Object?> get props => [transactions, balance];

}
