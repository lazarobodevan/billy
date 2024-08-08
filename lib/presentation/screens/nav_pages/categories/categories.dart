import 'package:billy/presentation/shared/components/category_tile.dart';
import 'package:billy/presentation/shared/components/color_picker_button.dart';
import 'package:billy/presentation/shared/components/icon_picker_button.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/category_bloc.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.primary2,
        title: Text(
          "Categorias",
          style: TypographyStyles.headline3(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () {
                _showCategoryEditorDialog(context);
              },
              borderRadius: BorderRadius.circular(50),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Center(
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.green,
                    size: 28,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      backgroundColor: ThemeColors.primary2,
      body: BlocBuilder<CategoryBloc, CategoryState>(
        bloc: BlocProvider.of<CategoryBloc>(context)
          ..add(ListCategoriesEvent()),
        builder: (context, state) {
          var bloc = BlocProvider.of<CategoryBloc>(context);

          if (state is LoadingCategoriesState) {
            return Center(
              child: SizedBox(
                  width: 60, height: 60, child: CircularProgressIndicator()),
            );
          }

          if (state is LoadingCategoriesErrorState ||
              state is SaveCategoryToDatabaseErrorState) {
            return Center(
              child: Text(
                "Houve um erro ao carergar as categorias.",
                style: TypographyStyles.paragraph3(),
              ),
            );
          }

          if (bloc.categories.isEmpty) {
            return Center(
              child: Text(
                "Você não tem categorias cadastradas...",
                style: TypographyStyles.paragraph1(),
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              return CategoryTile(
                  id: bloc.categories[index].id!,
                  name: bloc.categories[index].name,
                  icon: bloc.categories[index].icon,
                  color: bloc.categories[index].color);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: bloc.categories.length,
          );
        },
      ),
    );
  }
}

void _showCategoryEditorDialog(BuildContext context,
    {bool? isCategory = true}) {
  TextEditingController _nameController = TextEditingController();
  Color _selectedColor = Colors.grey; // Default color
  IconData _selectedIcon = Icons.category; // Default icon

  void onChangedName(String name) {
    // Only update local state here
  }

  void onChangedColor(Color color) {
    _selectedColor = color;
  }

  void onChangedIcon(IconData icon) {
    _selectedIcon = icon;
  }

  void onSaveToDatabase() {
    var bloc = BlocProvider.of<CategoryBloc>(context);
    bloc.add(CategoryNameChangedEvent(name: _nameController.text));
    bloc.add(CategoryColorChangedEvent(color: _selectedColor));
    bloc.add(CategoryIconChangedEvent(icon: _selectedIcon));
    bloc.add(SaveCategoryToDatabaseEvent());
  }

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            var bloc = BlocProvider.of<CategoryBloc>(context);

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
                      onChanged: (String name) {
                        onChangedName(name);
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ColorPickerButton(
                      onColorChanged: onChangedColor,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    IconPickerButton(
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
                      onSaveToDatabase();
                      Navigator.of(context).pop();
                    },
                    child: Text("Confirmar")),
              ],
            );
          },
        );
      });
}
