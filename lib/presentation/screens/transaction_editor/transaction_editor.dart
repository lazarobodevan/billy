import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../add_transaction/components/payment_method_selector.dart';

class TransactionEditor extends StatefulWidget {
  final Transaction transaction;

  const TransactionEditor({super.key, required this.transaction});

  @override
  State<TransactionEditor> createState() => _TransactionEditorState();
}

class _TransactionEditorState extends State<TransactionEditor> {
  TextEditingController _nameController = TextEditingController();
  late Transaction _updatedTransaction;

  @override
  void initState() {
    _nameController.text = widget.transaction.name;
    _updatedTransaction = widget.transaction.copyWith();
    super.initState();
  }

  onCategoryChanged(TransactionCategory newCategory){
    _updatedTransaction.category = newCategory;
  }

  onPaymentMethodChanged(PaymentMethod newPaymentMethod){
    _updatedTransaction.paymentMethod = newPaymentMethod;
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              maxLength: 30,
              maxLengthEnforcement:
                  MaxLengthEnforcement.truncateAfterCompositionEnds,
              decoration: InputDecoration(hintText: "Nome da transação",),
              onChanged: (value){
                setState(() {
                  _updatedTransaction.name = value;
                });
              },
            ),
            PaymentMethodSelector(
              selectedPaymentMethod: widget.transaction.paymentMethod,
              selectedCategory: widget.transaction.category,
              onCategoryChanged: onCategoryChanged,
              onPaymentMethodChanged: onPaymentMethodChanged,
            )
          ],
        ),
      ),
    );
  }
}
