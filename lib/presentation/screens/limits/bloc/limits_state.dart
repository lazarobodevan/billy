part of 'limits_bloc.dart';

abstract class LimitsState extends Equatable {
  const LimitsState();
}

class LimitsInitial extends LimitsState {
  @override
  List<Object> get props => [];
}

class CreatingLimitState extends LimitsState{
  @override
  List<Object?> get props => [];

}

class CreatedLimitState extends LimitsState{
  final LimitModel limit;

  const CreatedLimitState({required this.limit});

  @override
  List<Object?> get props => [limit];

}

class CreateLimitErrorState extends LimitsState{

  final String message;

  const CreateLimitErrorState({required this.message});

  @override
  List<Object?> get props => [message];

}


class ListingLimitsState extends LimitsState{
  @override
  List<Object?> get props => [];
}

class ListedLimitsState extends LimitsState{
  final List<LimitModel> limits;

  const ListedLimitsState({required this.limits});

  @override
  List<Object?> get props => [limits];

}

class ListLimitsErrorState extends LimitsState{

  final String message;

  const ListLimitsErrorState({required this.message});

  @override
  List<Object?> get props => [message];

}