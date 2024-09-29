import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/models/subcategory/subcategory.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/utils/color_utils.dart';
import 'package:flutter/material.dart';

class CategoryItemInsight extends StatelessWidget {
  final TransactionCategory? category;
  final Subcategory? subcategory;
  final double value;
  final int percentage;

  const CategoryItemInsight(
      {super.key,
      this.category,
      required this.value,
      this.subcategory,
      required this.percentage});

  String _getCategoryName() {
    if (category != null) return category!.name;
    if (subcategory != null) return subcategory!.name;
    return "Undefined";
  }

  Color _getCategoryColor() {
    if (category != null) return category!.color;
    if (subcategory != null) return subcategory!.color;
    return Colors.brown;
  }

  @override
  Widget build(BuildContext context) {
    final scrSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: scrSize.width * .3,
                child: Text(
                  _getCategoryName(),
                  style: TypographyStyles.paragraph3(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: scrSize.width * .4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "R\$$value",
                    style: TypographyStyles.paragraph3(),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                width: scrSize.width * .12,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: _getCategoryColor()),
                child: Center(
                  child: Text(
                    "$percentage%",
                    style: TypographyStyles.paragraph3().copyWith(color: ColorUtils.getContrastingTextColor(_getCategoryColor())),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(width: double.maxFinite, height: 1, color: Colors.black12,)
      ],
    );
  }
}
