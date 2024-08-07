import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 60,
              decoration: BoxDecoration(color: ThemeColors.primary1),
              child: DropdownButton(
                onChanged: (value) {},
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                isExpanded: true,
                isDense: true,
                underline: SizedBox(),
                iconSize: 38,
                dropdownColor: ThemeColors.primary1,
                value: "1",
                hint: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.money_rounded, color: Colors.white,),
                      const SizedBox(width: 10,),
                      Text(
                        "Dinheiro",
                        style: TypographyStyles.label3()
                            .copyWith(color: ThemeColors.primary3),
                      ),
                    ],
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    onTap: (){},
                    value: "1",
                    child: MoneyType("Pix", Icons.currency_exchange_rounded)
                  ),
                  DropdownMenuItem(
                    onTap: (){},
                    value: "2",
                    child: MoneyType("Transferência", Icons.money_rounded)
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 1,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("/categories");
              },
              child: Ink(
                height: 60,
                decoration: BoxDecoration(color: ThemeColors.primary1),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.money_rounded,
                          color: ThemeColors.primary3,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Categoria",
                          style: TypographyStyles.label3()
                              .copyWith(color: ThemeColors.primary3),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}


Widget MoneyType(String text, IconData icon){
  return Center(
    child: Container(
      width: 130,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white,),
            const SizedBox(width: 10,),
            Text(
              text,
              style: TypographyStyles.label3().copyWith(
                color: ThemeColors.primary3,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}