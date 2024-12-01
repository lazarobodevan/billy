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
  final Balance balance;
  final List<LimitModel> limits;

  const LoadedHomeState({required this.balance, required this.limits});

  @override
  List<Object?> get props => [limits, balance];

}
