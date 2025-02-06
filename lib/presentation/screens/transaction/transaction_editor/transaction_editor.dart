import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/presentation/screens/transaction/add_transaction/components/toggle_transaction_type.dart';
import 'package:billy/presentation/screens/transaction/bloc/transaction_bloc.dart';
import 'package:billy/presentation/shared/components/action_button.dart';
import 'package:billy/presentation/shared/components/date_picker.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/services/toast_service/toast_service.dart';
import 'package:billy/utils/currency_formatter.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../add_transaction/components/payment_method_selector.dart';

class TransactionEditor extends StatefulWidget {
  final Transaction transaction;

  const TransactionEditor({super.key, required this.transaction});

  @override
  State<TransactionEditor> createState() => _TransactionEditorState();
}

class _TransactionEditorState extends State<TransactionEditor> {
  late TextEditingController _descriptionController;
  late TextEditingController _valueController;

  @override
  void initState() {
    BlocProvider.of<TransactionBloc>(context)
        .add(SetTransactionEvent(transaction: widget.transaction));
    _descriptionController = TextEditingController(text: widget.transaction.description);
    _valueController = TextEditingController(
        text: CurrencyFormatter.format(widget.transaction.value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Editar transação",
          style: TypographyStyles.label1(),
        ),
        backgroundColor: ThemeColors.primary2,
      ),
      backgroundColor: ThemeColors.primary2,
      body: BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is SavedTransactionToDatabaseState) {
            Navigator.of(context).pop();
            ToastService.showSuccess(message: "Transação atualizada");
          }
        },
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            final bloc = BlocProvider.of<TransactionBloc>(context);

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ToggleTransactionType(
                          onChanged: (val) {
                            bloc.add(TransactionTypeChangedEvent(
                                transactionType: val));
                          },
                          transactionType: bloc.transaction.type,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextField(
                          controller: _descriptionController,
                          maxLength: 30,
                          maxLengthEnforcement:
                              MaxLengthEnforcement.truncateAfterCompositionEnds,
                          decoration: const InputDecoration(
                            hintText: "Descrição da transação",
                          ),
                          onChanged: (value) {
                            bloc.add(TransactionDescriptionChangedEvent(description: value));
                          },
                        ),
                        TextFormField(
                          controller: _valueController,
                          decoration: const InputDecoration(hintText: "Valor"),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            bloc.add(
                                TransactionValueChangedEvent(value: value));
                          },
                          inputFormatters: [
                            CurrencyTextInputFormatter.currency(
                              symbol: 'R\$',
                              decimalDigits: 2,
                              locale: 'pt_BR',
                              enableNegative: false,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        PaymentMethodSelector(
                          selectedPaymentMethod: bloc.transaction.paymentMethod,
                          selectedCategory: bloc.transaction.category,
                          onCategoryChanged: (cat) {
                            bloc.add(
                                TransactionCategoryChangedEvent(category: cat));
                            Navigator.of(context).pop();
                          },
                          onPaymentMethodChanged: (pay) {
                            bloc.add(
                              TransactionPaymentMethodChangedEvent(
                                  paymentMethod: pay),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Flexible(
                                child: DatePicker(
                              onSelect: (date) {
                                bloc.add(
                                    TransactionDateChangedEvent(date: date));
                              },
                              initialDate: widget.transaction.date,
                              label: 'Data',
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ActionButton(
                      text: "Concluir",
                      icon: Icons.edit,
                      onTap: () {
                        bloc.add(UpdateTransactionToDatabaseEvent());
                      }),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
