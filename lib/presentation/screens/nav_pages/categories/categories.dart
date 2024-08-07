import 'package:billy/presentation/shared/components/category_item.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary2,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeColors.primary2,
        title: Text("Categorias", style: TypographyStyles.headline3(),),
      ),
      body: GridView(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        children: [
          Center(child: const CategoryItem()),
          Center(child: const CategoryItem()),
          Center(child: const CategoryItem()),
          Center(child: const CategoryItem()),
          Center(child: const CategoryItem()),
          Center(child: const CategoryItem()),
          Center(child: const CategoryItem()),
        ],
      )
    );
  }
}
