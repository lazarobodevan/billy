import 'package:billy/models/subcategory/subcategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/category/transaction_category.dart';
import '../../screens/categories/category_bloc/category_bloc.dart';
import '../../screens/categories/subcategory_bloc/subcategory_bloc.dart';
import 'color_picker_button.dart';
import 'icon_picker_button.dart';
import '../../theme/typography.dart';

class CategoryEditorDialog {
  static void showCategoryEditorDialog(
    BuildContext context, {
    bool? isCategory = true,
    TransactionCategory? category,
    int? parentId = -1,
  }) {
    final isUpdate = category != null && category.id != null;

    TextEditingController _nameController = TextEditingController(
      text: isUpdate ? category.name : "",
    );

    Color _selectedColor =
        isUpdate ? category.color : Colors.grey; // Default color
    IconData _selectedIcon =
        isUpdate ? category.icon : Icons.category; // Default icon

    var categoryBloc = BlocProvider.of<CategoryBloc>(context);
    var subcategoryBloc = BlocProvider.of<SubcategoryBloc>(context);

    void onChangedColor(Color color) {
      _selectedColor = color;
    }

    void onChangedIcon(IconData icon) {
      _selectedIcon = icon;
    }

    void onSaveCategoryToDatabase() {
      categoryBloc.add(CategoryNameChangedEvent(name: _nameController.text));
      categoryBloc.add(CategoryColorChangedEvent(color: _selectedColor));
      categoryBloc.add(CategoryIconChangedEvent(icon: _selectedIcon));
      categoryBloc.add(SaveCategoryToDatabaseEvent());
    }

    void onUpdateCategoryToDatabase() {
      TransactionCategory categoryToUpdate = TransactionCategory(
        id: category!.id!,
        name: _nameController.text,
        color: _selectedColor,
        icon: _selectedIcon,
      );
      categoryBloc.add(UpdateCategoryEvent(category: categoryToUpdate));
    }

    void onSaveSubcategoryToDatabase() {
      Subcategory subcategory = Subcategory(
          parentId: parentId ?? -1,
          name: _nameController.text,
          color: _selectedColor,
          icon: _selectedIcon);

      subcategoryBloc
          .add(SaveSubcategoryToDatabaseEvent(subcategory: subcategory));
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              return AlertDialog(
                title: isCategory == true
                    ? Text(
                        "Categoria",
                        style: TypographyStyles.label1(),
                      )
                    : Text(
                        "Subcategoria",
                        style: TypographyStyles.label1(),
                      ),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(hintText: "Nome"),
                        maxLengthEnforcement:
                            MaxLengthEnforcement.truncateAfterCompositionEnds,
                        maxLength: 20,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      ColorPickerButton(
                        initalColor: isUpdate ? category.color : null,
                        onColorChanged: onChangedColor,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      IconPickerButton(
                        initialIcon: isUpdate ? category.icon : null,
                        onChangedIcon: onChangedIcon,
                      ),
                    ],
                  ),
                ),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancelar")),
                  TextButton(
                      onPressed: () {
                        if (isCategory == true) {
                          if (!isUpdate) {
                            onSaveCategoryToDatabase();
                            Navigator.of(context).pop();
                          } else {
                            onUpdateCategoryToDatabase();
                            Navigator.of(context).pop();
                          }
                        } else {
                          if (!isUpdate) {
                            onSaveSubcategoryToDatabase();
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      child: Text(isUpdate ? "Atualizar" : "Confirmar")),
                ],
              );
            },
          );
        });
  }
}
