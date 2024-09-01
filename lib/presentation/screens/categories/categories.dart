import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/presentation/shared/components/category_editor_dialog.dart';
import 'package:billy/presentation/shared/components/category_tile.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_bloc/category_bloc.dart';

class Categories extends StatelessWidget {
  final bool? isSelectableCategories;
  final Function(TransactionCategory category) onSelect;
  const Categories({super.key, this.isSelectableCategories = false, required this.onSelect});

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
                CategoryEditorDialog.showCategoryEditorDialog(context);
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
              return CategoryTile(category: bloc.categories[index],isClickable: isSelectableCategories,onSelectCategory: onSelect,);
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


