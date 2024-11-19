part of 'balance_bloc.dart';

abstract class BalanceEvent extends Equatable {
  const BalanceEvent();
}

class LoadBalanceEvent extends BalanceEvent{
  @override
  List<Object?> get props => [];

}

class UpdateBalanceEvent extends BalanceEvent{
  final Balance balance;

  const UpdateBalanceEvent({required this.balance});

  @override
  List<Object?> get props => [balance];
}
