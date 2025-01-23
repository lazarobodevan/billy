import 'dart:async';

import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/models/subcategory/subcategory.dart';
import 'package:billy/repositories/category/i_category_repository.dart';
import 'package:billy/repositories/subcategory/i_subcategory_repository.dart';
import 'package:billy/use_cases/category/list_categories_use_case.dart';
import 'package:billy/use_cases/subcategory/get_all_subcategories_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'limit_picker_event.dart';

part 'limit_picker_state.dart';

class LimitPickerBloc extends Bloc<LimitPickerEvent, LimitPickerState> {

  final ICategoryRepository categoryRepository;
  final ISubcategoryRepository subcategoryRepository;

  late final ListCategoriesUseCase listCategoriesUseCase;
  late final GetAllSubcategoriesUseCase getAllSubcategoriesUseCase;

  LimitPickerBloc(
      {required this.categoryRepository, required this.subcategoryRepository})
      : super(LimitPickerInitial()) {

    listCategoriesUseCase = ListCategoriesUseCase(repository: categoryRepository);
    getAllSubcategoriesUseCase = GetAllSubcategoriesUseCase(subcategoryRepository: subcategoryRepository);

    on<LimitPickerEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<ListCategoriesEvent>((event, emit) async {
      try {
        emit(ListingState());
        var categories = await listCategoriesUseCase.execute();
        emit(ListedCategoriesState(categories: categories));
      } catch (e) {
        debugPrint(e.toString());
      }
    });

    on<ListSubcategoriesEvent>((event, emit) async {
      try {
        emit(ListingState());
        var subcategories = await getAllSubcategoriesUseCase.execute();
        emit(ListedSubcategoriesState(subcategories: subcategories));
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }
}
