import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/repositories/category/i_category_repository.dart';
import 'package:billy/use_cases/category/list_categories_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../use_cases/category/create_category_use_case.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  TransactionCategory category = TransactionCategory.empty();
  final ICategoryRepository repository;
  late final ListCategoriesUseCase _listCategoriesUseCase;
  late final CreateCategoryUseCase _createCategoryUseCase;
  late List<TransactionCategory> categories;

  CategoryBloc(this.repository) : super(LoadingCategoriesState()) {

    _listCategoriesUseCase = ListCategoriesUseCase(repository: repository);
    _createCategoryUseCase = CreateCategoryUseCase(repository: repository);
    categories = <TransactionCategory>[];

    on<CategoryEvent>((event, emit) {});

    on<ResetCategoryEvent>((event, emit){
      category = TransactionCategory.empty();
      categories = [];
    });

    on<CategoryNameChangedEvent>((event, emit) {
      category.name = event.name;
      emit(CategoryNameChangedState(name: category.name));
    });

    on<CategoryColorChangedEvent>((event, emit) {
      category.color = event.color;
      emit(CategoryColorChangedState(color: category.color));
    });

    on<CategoryIconChangedEvent>((event, emit) {
      category.icon = event.icon;
      emit(CategoryIconChangedState(icon: category.icon));
    });

    on<SaveCategoryToDatabaseEvent>((event,emit)async{
      emit(SavingCategoryToDatabase());
      try {
        final createdCategory = await _createCategoryUseCase.execute(category);
        categories.add(createdCategory);
        emit(SavedCategoryToDatabase(category: createdCategory));
      }catch(e){
        emit(LoadingCategoriesErrorState());
        print(e);
      }
    });

    on<DeleteCategoryEvent>((event, emit){

    });

    on<ListCategoriesEvent>((event, emit)async{
      emit(LoadingCategoriesState());
      var listedCategories = await _listCategoriesUseCase.execute();
      categories = listedCategories;
      emit(LoadedCategoriesState(categories: categories));
    });
  }
}
