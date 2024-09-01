import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/category/transaction_category.dart';

import 'package:billy/presentation/screens/categories/categories.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/enums/transaction/payment_method.dart';
import 'package:flutter/material.dart';

class PaymentMethodSelector extends StatelessWidget {
  final ValueChanged<PaymentMethod> onPaymentMethodChanged;
  final ValueChanged<TransactionCategory> onCategoryChanged;
  final TransactionCategory? selectedCategory;
  final PaymentMethod? selectedPaymentMethod;

  const PaymentMethodSelector(
      {super.key,
      this.selectedPaymentMethod,
      this.selectedCategory,
      required this.onPaymentMethodChanged,
      required this.onCategoryChanged});

  onGetSelectedCategory() {
    final category = selectedCategory;
    if (category != null && category.id != null) {
      if (category.subcategories != null &&
          category.subcategories!.isNotEmpty) {
        return category.subcategories![0];
      }
      return category;
    }
    return null;
  }

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
                value: selectedPaymentMethod,
                hint: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.money_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
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
                      onTap: () {
                        onPaymentMethodChanged(PaymentMethod.PIX);
                      },
                      value: PaymentMethod.PIX,
                      child: MoneyType("Pix", Icons.currency_exchange_rounded)),
                  DropdownMenuItem(
                      onTap: () {
                        onPaymentMethodChanged(PaymentMethod.MONEY);
                      },
                      value: PaymentMethod.MONEY,
                      child: MoneyType("Dinheiro", Icons.attach_money_rounded)),
                  DropdownMenuItem(
                      onTap: () {
                        onPaymentMethodChanged(PaymentMethod.CREDIT_CARD);
                      },
                      value: PaymentMethod.CREDIT_CARD,
                      child: MoneyType("Cartão", Icons.credit_card_rounded)),
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Categories(
                      onSelect: onCategoryChanged,
                      isSelectableCategories: true,
                    ),
                  ),
                );
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
                          onGetSelectedCategory() != null
                              ? onGetSelectedCategory().icon
                              : Icons.money_rounded,
                          color: ThemeColors.primary3,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          onGetSelectedCategory() != null
                              ? onGetSelectedCategory().name
                              : "Categoria",
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

Widget MoneyType(String text, IconData icon) {
  return Center(
    child: Container(
      width: 130,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
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
