import 'package:auto_size_text/auto_size_text.dart';
import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/presentation/screens/transaction/add_transaction/components/digit_button.dart';
import 'package:billy/presentation/screens/transaction/add_transaction/components/payment_method_selector.dart';
import 'package:billy/presentation/screens/transaction/add_transaction/components/toggle_transaction_type.dart';
import 'package:billy/presentation/screens/transaction/add_transaction/components/transaction_details_form.dart';
import 'package:billy/presentation/screens/transaction/bloc/transaction_bloc.dart';
import 'package:billy/presentation/theme/colors.dart';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTransaction extends StatefulWidget {
  final TransactionType? transactionType;

  const AddTransaction({super.key, this.transactionType});

  @override
  _AddTransactionState createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  String valueText = "";

  @override
  void initState() {
    BlocProvider.of<TransactionBloc>(context).add(ResetTransaction());
    if (widget.transactionType != null) {
      BlocProvider.of<TransactionBloc>(context).add(TransactionTypeChangedEvent(
          transactionType: widget.transactionType!));
    }
    super.initState();
  }

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
    BlocProvider.of<TransactionBloc>(context)
        .add(TransactionValueDigitChangedEvent(value: value));
  }

  void onErase(BuildContext context) {
    if (valueText.isNotEmpty) {
      valueText = valueText.substring(0, valueText.length - 1);
    }
    BlocProvider.of<TransactionBloc>(context).add(EraseValue());
  }

  onSelectPaymentMethod(PaymentMethod paymentMethod) {
    BlocProvider.of<TransactionBloc>(context).add(
        TransactionPaymentMethodChangedEvent(paymentMethod: paymentMethod));
  }

  onSelectCategory(TransactionCategory category) {
    BlocProvider.of<TransactionBloc>(context)
        .add(TransactionCategoryChangedEvent(category: category));
    Navigator.of(context).pop();
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
            onTap: () {
              _showTransactionDetailsDialog(context);
            },
            child: Ink(
              padding: EdgeInsets.all(16),
              child: Icon(Icons.check),
            ),
          )
        ],
      ),
      backgroundColor: ThemeColors.primary2,
      body: SafeArea(
        child: BlocBuilder<TransactionBloc, TransactionState>(
            builder: (context, state) {
          return Column(
            children: [
              Center(
                  child: ToggleTransactionType(
                transactionType:
                    BlocProvider.of<TransactionBloc>(context).transaction.type,
                onChanged: (value) => BlocProvider.of<TransactionBloc>(context)
                    .add(TransactionTypeChangedEvent(transactionType: value)),
              )),
              Container(
                width: screenSize.width,
                height: 300,
                decoration: const BoxDecoration(
                  color: ThemeColors.primary1,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: SizedBox(
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
                    PaymentMethodSelector(
                      onPaymentMethodChanged: onSelectPaymentMethod,
                      onCategoryChanged: onSelectCategory,
                      selectedCategory:
                          BlocProvider.of<TransactionBloc>(context)
                              .transaction
                              .category,
                      selectedPaymentMethod:
                          BlocProvider.of<TransactionBloc>(context)
                              .transaction
                              .paymentMethod,
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    _buildDigitRow([7, 8, 9]),
                    _buildDigitRow([4, 5, 6]),
                    _buildDigitRow([1, 2, 3]),
                    _buildDigitRow([null, 0, null],
                        isLastRow: true, onErase: onErase),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDigitRow(List<int?> numbers,
      {bool isLastRow = false, Function? onErase}) {
    return Expanded(
      child: Row(
        children: isLastRow
            ? [
                DigitButton(number: "<-", onTap: () => onErase?.call(context)),
                DigitButton(
                    number: '0', onTap: () => onTapDigitButton(0, context)),
                const Expanded(child: SizedBox())
              ]
            : numbers.map((number) {
                if (number == null) {
                  return const Expanded(child: SizedBox());
                }
                return DigitButton(
                  number: number.toString(),
                  onTap: () => onTapDigitButton(number, context),
                );
              }).toList(),
      ),
    );
  }

  void _showTransactionDetailsDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const TransactionDetailsForm();
        });
  }
}
