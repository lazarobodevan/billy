import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/material.dart';

class ToggleTransactionType extends StatefulWidget {
  const ToggleTransactionType({super.key});

  @override
  State<ToggleTransactionType> createState() => _ToggleTransactionTypeState();
}

class _ToggleTransactionTypeState extends State<ToggleTransactionType> {
  var selected = 1;

  onSelect(value){
    setState(() {
      selected = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TransactionTypeItem("Despesa", () {onSelect(0);}, selected == 0),
          const SizedBox(
            width: 1,
          ),
          TransactionTypeItem("Receita", () {onSelect(1);}, selected == 1),
        ],
      ),
    );
  }
}

Widget TransactionTypeItem(String text, Function onTap, bool? isSelected) {
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
