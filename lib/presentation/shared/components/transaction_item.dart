import 'package:billy/models/subcategory/subcategory.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/transaction/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  IconData? getCategoryIcon(){
    final category = transaction.category;
    final Subcategory? subcategory = (category?.subcategories?.isNotEmpty ?? false)
        ? category!.subcategories![0]
        : null;

    if(category != null){
      if(subcategory != null){
        return subcategory.icon;
      }
      return category.icon;
    }
    return null;
  }

  Color? getCategoryColor(){
    final category = transaction.category;
    final Subcategory? subcategory = (category?.subcategories?.isNotEmpty ?? false)
        ? category!.subcategories![0]
        : null;

    if(category != null){
      if(subcategory != null){
        return subcategory.color;
      }
      return category.color;
    }
    return null;
  }

  String formatDate(){
    final formatter = DateFormat('EEE, dd/MM', 'pt_BR');

    var formatted =  formatter.format(transaction.date);

    formatted = formatted.replaceAll(".", "");
    formatted = formatted.substring(0, 1).toUpperCase() + formatted.substring(1);

    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
          color: ThemeColors.primary3,
          border: Border(
            bottom: BorderSide(
              color: Colors.black12,
              width: 1,
            ),
          ),
          borderRadius: BorderRadius.circular(50)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  color: getCategoryColor(),
                  borderRadius: BorderRadius.circular(50)),
              child: Icon(
                getCategoryIcon() ?? Icons.star_border_outlined,
                color: ThemeColors.primary3,
                size: 18,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name,
                  style: TypographyStyles.label3(),
                ),
                Text(
                  formatDate(),
                  style: TypographyStyles.paragraph3()
                      .copyWith(color: Colors.black38),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
