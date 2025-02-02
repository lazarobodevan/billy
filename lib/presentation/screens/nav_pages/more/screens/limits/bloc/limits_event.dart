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

class UpdateLimitEvent extends LimitsEvent{
  final LimitModel limit;

  const UpdateLimitEvent({required this.limit});

  @override
  List<Object?> get props => [limit];
}

class DeleteLimitEvent extends LimitsEvent{
  final int id;

  const DeleteLimitEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
