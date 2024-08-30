import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:flutter/material.dart';

class ToggleTransactionType extends StatelessWidget {
  TransactionType? transactionType;
  final ValueChanged<TransactionType> onChanged;
  ToggleTransactionType({super.key, this.transactionType, required this.onChanged});


  @override
  Widget build(BuildContext context) {
    var selected = transactionType ?? TransactionType.EXPENSE;
    return Container(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTransactionTypeItem("Despesa", () {
            onChanged(TransactionType.EXPENSE);
          }, selected == TransactionType.EXPENSE),
          const SizedBox(
            width: 1,
          ),
          _buildTransactionTypeItem("Receita", () {
            onChanged(TransactionType.INCOME);
          }, selected == TransactionType.INCOME),
        ],
      ),
    );
  }
}

Widget _buildTransactionTypeItem(String text, Function onTap,
    bool? isSelected) {
  return Expanded(
    child: InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        onTap();
      },
      child: Ink(
        decoration: BoxDecoration(
            color: isSelected == true
                ? ThemeColors.primary1
                : ThemeColors.primary1.withOpacity(.99)),
        child: Stack(
          children: [
            Center(
              child: Text(
                text,
                style: TypographyStyles.paragraph2().copyWith(
                  color: isSelected == true
                      ? ThemeColors.primary3
                      : ThemeColors.primary3.withOpacity(.7),
                ),
              ),
            ),
            if(isSelected == true)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: ThemeColors.secondary1,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    ),
  );
}
