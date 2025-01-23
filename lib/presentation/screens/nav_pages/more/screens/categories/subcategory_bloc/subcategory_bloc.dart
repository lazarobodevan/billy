import 'dart:async';

import 'package:billy/models/subcategory/subcategory.dart';
import 'package:billy/repositories/subcategory/i_subcategory_repository.dart';
import 'package:billy/use_cases/subcategory/create_subcategory_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../category_bloc/category_bloc.dart';

part 'subcategory_event.dart';

part 'subcategory_state.dart';

class SubcategoryBloc extends Bloc<SubcategoryEvent, SubcategoryState> {
  final CategoryBloc categoryBloc;
  final ISubcategoryRepository repository;

  late final CreateSubcategoryUseCase _createSubcategoryUseCase;

  SubcategoryBloc({required this.categoryBloc, required this.repository})
      : super(SubcategoryInitial()) {

    _createSubcategoryUseCase = CreateSubcategoryUseCase(repository: repository);

    on<SubcategoryEvent>((event, emit) {});

    on<SaveSubcategoryToDatabaseEvent>((event, emit) async{
      emit(SavingCategoryToDatabaseState());
      final createdSubcategory = await _createSubcategoryUseCase.execute(event.subcategory);
      emit(SavedSubcategoryToDatabaseState(subcategory: createdSubcategory));
      categoryBloc.add(UpdateCategoryWithSubcategoryEvent(subcategory: createdSubcategory));
    });
  }
}
