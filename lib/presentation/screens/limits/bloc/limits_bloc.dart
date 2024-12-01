import 'dart:async';

import 'package:billy/models/limit/limit_model.dart';
import 'package:billy/repositories/limit/i_limit_repository.dart';
import 'package:billy/use_cases/limit/create_limit_use_case.dart';
import 'package:billy/use_cases/limit/delete_limit_use_case.dart';
import 'package:billy/use_cases/limit/list_limits_use_case.dart';
import 'package:billy/use_cases/limit/update_limit_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'limits_event.dart';

part 'limits_state.dart';

class LimitsBloc extends Bloc<LimitsEvent, LimitsState> {

  final ILimitRepository limitRepository;

  late final CreateLimitUseCase createLimitUseCase;
  late final ListLimitsUseCase listLimitsUseCase;
  late final UpdateLimitUseCase updateLimitUseCase;
  late final DeleteLimitUseCase deleteLimitUseCase;

  LimitsBloc({required this.limitRepository}) : super(LimitsInitial()) {

    createLimitUseCase = CreateLimitUseCase(limitRepository: limitRepository);
    listLimitsUseCase = ListLimitsUseCase(limitRepository: limitRepository);
    updateLimitUseCase = UpdateLimitUseCase(limitRepository: limitRepository);
    deleteLimitUseCase = DeleteLimitUseCase(limitRepository: limitRepository);

    on<LimitsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<CreateLimitEvent>((event, emit) async {
      try {
        emit(CreatingLimitState());
        var created = await createLimitUseCase.execute(event.limit);
        emit(CreatedLimitState(limit: created));
      } catch (e) {
        emit(CreateLimitErrorState(message: e.toString()));
      }
    });

    on<ListLimitsEvent>((event, emit) async {
      try {
        emit(ListingLimitsState());
        var limits = await listLimitsUseCase.execute();
        emit(ListedLimitsState(limits: limits));
      } catch (e) {
        emit(ListLimitsErrorState(message: e.toString()));
      }
    });

    on<UpdateLimitEvent>((event, emit) async {
      try {
        emit(UpdatingLimitState());
        var limit = await updateLimitUseCase.execute(event.limit);
        emit(UpdatedLimitState(limit: limit));
      }catch(e){
        emit(UpdateLimitErrorState(message: e.toString()));
      }
    });

    on<DeleteLimitEvent>((event, emit) async {
      try {
        emit(DeletingLimitState());
        var limit = await deleteLimitUseCase.execute(event.id);
        emit(DeletedLimitState());
      }catch(e){
        emit(DeleteLimitErrorState(message: e.toString()));
      }
    });
  }
}
