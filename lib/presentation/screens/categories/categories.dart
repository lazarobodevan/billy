import 'package:billy/presentation/shared/components/category_tile.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/material.dart';

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
          centerTitle: true,
        ),
        backgroundColor: ThemeColors.primary2,
        body: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              return CategoryTile();
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: 20));
  }
}
