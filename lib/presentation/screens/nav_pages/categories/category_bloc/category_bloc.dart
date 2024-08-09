import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/models/subcategory/subcategory.dart';
import 'package:billy/repositories/category/i_category_repository.dart';
import 'package:billy/use_cases/category/delete_category_use_case.dart';
import 'package:billy/use_cases/category/list_categories_use_case.dart';
import 'package:billy/use_cases/category/update_category_use_case.dart';
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
  late final DeleteCategoryUseCase _deleteCategoryUseCase;
  late final UpdateCategoryUseCase _updateCategoryUseCase;


  late List<TransactionCategory> categories;

  CategoryBloc(this.repository) : super(LoadingCategoriesState()) {

    _listCategoriesUseCase = ListCategoriesUseCase(repository: repository);
    _createCategoryUseCase = CreateCategoryUseCase(repository: repository);
    _deleteCategoryUseCase = DeleteCategoryUseCase(repository: repository);
    _updateCategoryUseCase = UpdateCategoryUseCase(repository: repository);

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

    on<DeleteCategoryEvent>((event, emit)async{
      emit(LoadingCategoriesState());
      await _deleteCategoryUseCase.execute(event.id);
      categories.removeWhere((cat)=>cat.id == event.id);
      emit(LoadedCategoriesState(categories: categories));
    });

    on<ListCategoriesEvent>((event, emit)async{
      emit(LoadingCategoriesState());
      var listedCategories = await _listCategoriesUseCase.execute();
      categories = listedCategories;
      emit(LoadedCategoriesState(categories: categories));
    });
    
    on<UpdateCategoryEvent>((event,emit)async{
      emit(LoadingCategoriesState());
      var updatedCategory = await _updateCategoryUseCase.execute(event.category);
      categories[categories.indexWhere((cat)=> cat.id == event.category.id)] = updatedCategory;
      emit(LoadedCategoriesState(categories: categories));
    });

    on<UpdateCategoryWithSubcategoryEvent>((event, emit){
      categories[categories.indexWhere((cat)=>cat.id == event.subcategory.parentId)].subcategories!.add(event.subcategory);
      emit(LoadedCategoriesState(categories: categories));
    });


  }
}
