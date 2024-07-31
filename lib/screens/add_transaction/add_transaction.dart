import 'package:billy/screens/add_transaction/components/payment_method_selector.dart';
import 'package:billy/screens/add_transaction/components/digit_button.dart';
import 'package:billy/screens/add_transaction/components/toggle_transaction_type.dart';
import 'package:billy/theme/colors.dart';
import 'package:billy/theme/typography.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

class AddTransaction extends StatelessWidget {
  const AddTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.primary1,
        foregroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () {},
            child: Ink(
              padding: EdgeInsets.all(16),
              child: Icon(Icons.check),
            ),
          )
        ],
      ),
      backgroundColor: ThemeColors.primary2,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Center(child: ToggleTransactionType()),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                decoration: BoxDecoration(
                  color: ThemeColors.primary1,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                          hintText: 'R\$00,00',
                          focusedBorder: InputBorder.none,
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: ThemeColors.primary3,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16)),
                      textAlign: TextAlign.right,
                      style: TypographyStyles.paragraph1().copyWith(
                        fontSize: screenHeight * .11,
                        color: ThemeColors.primary3,
                      ),
                      inputFormatters: [
                        CurrencyTextInputFormatter.currency(
                          locale: 'pt-BR',
                          symbol: "R\$",
                          minValue: 0,
                        )
                      ],
                      keyboardType: TextInputType.none,
                    ),
                    PaymentMethodSelector()
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          DigitButton(
                            number: '7',
                            onTap: () {},
                          ),
                          DigitButton(
                            number: '8',
                            onTap: () {},
                          ),
                          DigitButton(
                            number: '9',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          DigitButton(
                            number: '4',
                            onTap: () {},
                          ),
                          DigitButton(
                            number: '5',
                            onTap: () {},
                          ),
                          DigitButton(
                            number: '6',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          DigitButton(
                            number: '1',
                            onTap: () {},
                          ),
                          DigitButton(
                            number: '2',
                            onTap: () {},
                          ),
                          DigitButton(
                            number: '3',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          DigitButton(
                            number: '<-',
                            onTap: () {},
                          ),
                          DigitButton(
                            number: '0',
                            onTap: () {},
                          ),
                          DigitButton(
                            number: '=',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
