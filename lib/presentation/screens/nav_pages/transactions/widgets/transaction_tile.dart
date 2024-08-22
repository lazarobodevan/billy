import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
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
        return subcategory.color;
      }
      return category.color;
    }
    return Colors.grey;
  }

  IconData getCategoryIcon() {
    final category = transaction.category;
    final subcategory =
        category?.subcategories != null && category!.subcategories!.isNotEmpty
            ? category.subcategories!.first
            : null;

    if (category != null) {
      if (subcategory != null) {
        return subcategory.icon;
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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        height: 140, // Ajuste a altura conforme necessário
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: ThemeColors.primary3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      child:
                          Icon(getCategoryIcon(), color: ThemeColors.primary3),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        children: [
                          Text(
                            transaction.name,
                            style: TypographyStyles
                                .label1(), // Ajuste o estilo conforme necessário
                          ),
                          Text(
                            formatCurrencyValue(),
                            style: TypographyStyles.label2().copyWith(
                                color:
                                    transaction.type == TransactionType.EXPENSE
                                        ? ThemeColors.semanticRed
                                        : ThemeColors.primary1),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // Três pontinhos à direita
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: PopupMenuButton(
                    icon: Icon(Icons.more_horiz),
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          child: Text("Editar"),
                          onTap: () {},
                        ),
                        PopupMenuItem(
                          child: Text("Deletar"),
                          onTap: () {},
                        )
                      ];
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Data: ${formatDate(transaction.date)}"),
                  if (transaction.endDate != null)
                    Text("Venc: ${formatDate(transaction.endDate!)}")
                ],
              ),
            ),
            if(transaction.type == TransactionType.EXPENSE)
              Center(child: _buildIsPaidBadge())
          ],
        ),
      ),
    );
  }

  Widget _buildIsPaidBadge() {
    return Container(
      width: 80,
      height: 20,
      decoration: BoxDecoration(
          color: transaction.isPaid == true ? ThemeColors.semanticGreen : ThemeColors.semanticRed,
          borderRadius: BorderRadius.circular(50)),
      child: Center(
        child: Text(
          transaction.isPaid == true ? "Pago" : "Não pago",
          style:
              TypographyStyles.label3().copyWith(color: ThemeColors.primary3),
        ),
      ),
    );
  }
}
