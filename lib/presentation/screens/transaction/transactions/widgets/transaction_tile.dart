import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/presentation/screens/transaction/transaction_editor/transaction_editor.dart';
import 'package:billy/presentation/screens/transaction/transactions/bloc/list_transactions_bloc.dart';
import 'package:billy/presentation/shared/components/slide_widget.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  Color getCategoryColor() {
    final category = transaction.category;
    final subcategory =
        category?.subcategories != null && category!.subcategories!.isNotEmpty
            ? category.subcategories!.first
            : null;

    if (category != null) {
      if (subcategory != null) {
        return subcategory.color!;
      }
      return category.color;
    }
    return Colors.grey;
  }

  String getCategoryOrSubcategoryName(){
    final category = transaction.category;
    final subcategory =
    category?.subcategories != null && category!.subcategories!.isNotEmpty
        ? category.subcategories!.first
        : null;

    if (category != null) {
      if (subcategory != null) {
        return subcategory.name;
      }
      return category.name;
    }
    return "Sem categoria";
  }

  IconData getCategoryIcon() {
    final category = transaction.category;
    final subcategory =
        category?.subcategories != null && category!.subcategories!.isNotEmpty
            ? category.subcategories!.first
            : null;

    if (category != null) {
      if (subcategory != null) {
        return subcategory.icon!;
      }
      return category.icon;
    }
    return Icons.question_mark;
  }

  String formatCurrencyValue() {
    if (transaction.type == TransactionType.EXPENSE) {
      return "-${CurrencyFormatter.format(transaction.value)}";
    }
    return CurrencyFormatter.format(transaction.value);
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat('EEE, dd/MM', 'pt_BR');

    var formatted = formatter.format(date);

    formatted = formatted.replaceAll(".", "");
    formatted =
        formatted.substring(0, 1).toUpperCase() + formatted.substring(1);

    return formatted;
  }

  onUpdate(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            TransactionEditor(transaction: transaction)));
  }

  onDelete(BuildContext context){
    BlocProvider.of<ListTransactionsBloc>(context)
        .add(DeleteTransactionEvent(id: transaction.id!));
  }

  @override
  Widget build(BuildContext context) {
    return SlideWidget(
      onUpdate: (){
        onUpdate(context);
      },
      onDelete: (){
        onDelete(context);
      },
      child: Container(
        height: 80, // Ajuste a altura conforme necessário
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
            color: ThemeColors.primary3),
        padding: EdgeInsets.only(right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: getCategoryColor(),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(getCategoryIcon(),
                              color: ThemeColors.primary3),
                        ),
                      ),
                    ),
                    Flex(
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getCategoryOrSubcategoryName(),
                          style: TypographyStyles.label2(),
                        ),
                        if(transaction.description != null && transaction.description!.isNotEmpty)
                          Text(transaction.description!, style: TypographyStyles.paragraph4(),),

                      ],
                    )
                  ],
                ),
                Text(
                  formatCurrencyValue(),
                  style: TypographyStyles.paragraph2(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
