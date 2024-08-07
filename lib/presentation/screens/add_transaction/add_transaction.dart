import 'package:auto_size_text/auto_size_text.dart';
import 'package:billy/presentation/screens/add_transaction/bloc/add_transaction_bloc.dart';
import 'package:billy/presentation/screens/add_transaction/components/digit_button.dart';
import 'package:billy/presentation/screens/add_transaction/components/payment_method_selector.dart';
import 'package:billy/presentation/screens/add_transaction/components/toggle_transaction_type.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTransaction extends StatefulWidget {
  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  String valueText = "";

  @override
  void dispose() {
    super.dispose();
  }

  String formatCurrency(String amount) {
    final formatter = CurrencyTextInputFormatter.currency(
      locale: 'pt-BR',
      symbol: 'R\$',
      minValue: 0,
    );
    return formatter.formatString(amount);
  }

  void onTapDigitButton(int value, BuildContext context) {
    if (valueText == '0') {
      valueText = '';
    }
    valueText += value.toString();
    BlocProvider.of<AddTransactionBloc>(context)
        .add(TriggerValue(value: value));
  }

  void onErase(BuildContext context){
    if (valueText.isNotEmpty) {
      valueText = valueText.substring(0, valueText.length - 1);
    }
    BlocProvider.of<AddTransactionBloc>(context).add(EraseValue());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
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
      body: BlocBuilder<AddTransactionBloc, AddTransactionState>(
        bloc: BlocProvider.of<AddTransactionBloc>(context)..add(ResetValue()),
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                Center(child: ToggleTransactionType()),
                Container(
                  width: screenSize.width,
                  height: 300,
                  decoration: BoxDecoration(
                    color: ThemeColors.primary1,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Container(
                          width: double.maxFinite,
                          height: 200,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: AutoSizeText(
                              formatCurrency(valueText),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenSize.height * .11),
                              maxLines: 1,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ),
                      PaymentMethodSelector()
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _buildDigitRow([7, 8, 9]),
                      _buildDigitRow([4, 5, 6]),
                      _buildDigitRow([1, 2, 3]),
                      _buildDigitRow([null, 0, null], isLastRow: true, onErase: onErase),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDigitRow(List<int?> numbers, {bool isLastRow = false, Function? onErase}) {
    return Expanded(
      child: Row(
        children: isLastRow
            ? [
                DigitButton(number: "<-", onTap: ()=>onErase?.call(context)),
                DigitButton(
                    number: '0', onTap: () => onTapDigitButton(0, context)),
                const Expanded(child: SizedBox())
              ]
            : numbers.map((number) {
                if (number == null) {
                  return Expanded(child: SizedBox());
                }
                return DigitButton(
                  number: number.toString(),
                  onTap: () => onTapDigitButton(number, context),
                );
              }).toList(),
      ),
    );
  }
}
