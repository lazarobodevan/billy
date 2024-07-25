import 'package:billy/theme/colors.dart';
import 'package:billy/theme/typography.dart';
import 'package:flutter/material.dart';

class ToggleTransactionType extends StatelessWidget {
  const ToggleTransactionType({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TransactionTypeItem("Despesa", () {}, true),
          const SizedBox(
            width: 1,
          ),
          TransactionTypeItem("Receita", () {}, false),
        ],
      ),
    );
  }
}

Widget TransactionTypeItem(String text, Function onTap, bool? isSelected) {
  return Expanded(
    child: InkWell(
      onTap: () {
        onTap();
      },
      child: Ink(
        decoration: BoxDecoration(
            color: isSelected == true
                ? ThemeColors.primary1
                : ThemeColors.primary1.withOpacity(.8)),
        child: Center(
          child: Text(
            text,
            style: TypographyStyles.paragraph2().copyWith(
              color: isSelected == true
                  ? ThemeColors.primary3
                  : ThemeColors.primary3.withOpacity(.7),
            ),
          ),
        ),
      ),
    ),
  );
}
