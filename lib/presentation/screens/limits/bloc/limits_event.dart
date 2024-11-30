part of 'limits_bloc.dart';

abstract class LimitsEvent extends Equatable {
  const LimitsEvent();
}

class CreateLimitEvent extends LimitsEvent {
  final LimitModel limit;

  const CreateLimitEvent({required this.limit});

  @override
  List<Object?> get props => [limit];

}

class ListLimitsEvent extends LimitsEvent {
  @override
  List<Object?> get props => [];

}
