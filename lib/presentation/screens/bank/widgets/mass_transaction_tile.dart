import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/presentation/screens/nav_pages/more/screens/categories/categories.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MassTransactionTile extends StatefulWidget {
  final Transaction transaction;
  final int index;
  final bool? isSelected;
  final Function(bool) onSelectionChanged;

  const MassTransactionTile({
    super.key,
    required this.transaction,
    required this.index,
    this.isSelected,
    required this.onSelectionChanged,
  });

  @override
  State<MassTransactionTile> createState() => _MassTransactionTileState();
}

class _MassTransactionTileState extends State<MassTransactionTile> {
  late Transaction _transaction;

  @override
  void initState() {
    _transaction = widget.transaction;
    super.initState();
  }

  String getFormattedDate() {
    return DateFormat("dd/MM").format(_transaction.date);
  }

  String getFormattedValue() {
    return CurrencyFormatter.format(_transaction.value);
  }

  void onSelectedCategory(TransactionCategory category) {
    setState(() {
      _transaction = _transaction.copyWith(category: category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Checkbox para seleção da transação
            Checkbox(
              value: widget.isSelected ?? false,
              onChanged: (bool? value) {
                widget.onSelectionChanged(value ?? false);
              },
            ),
            // Data da transação
            Text(
              getFormattedDate(),
              style: TypographyStyles.paragraph3(),
            ),
            const SizedBox(width: 12),
            // Descrição e valor
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.transaction.description ?? '',
                    style: TypographyStyles.paragraph3(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    getFormattedValue(),
                    style: TypographyStyles.label3(),
                  ),
                ],
              ),
            ),
            // Botão de seleção de categoria
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Categories(
                      onSelect: onSelectedCategory,
                      isSelectableCategories: true,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _transaction.category?.name ?? "Selecionar",
                      style: TypographyStyles.paragraph4(),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
