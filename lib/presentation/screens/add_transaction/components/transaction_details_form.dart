import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../enums/transaction/transaction_type.dart';
import '../../../shared/components/date_picker.dart';
import '../../../theme/colors.dart';
import '../../../theme/typography.dart';
import '../bloc/add_transaction_bloc.dart';

class TransactionDetailsForm extends StatefulWidget {
  const TransactionDetailsForm({super.key});

  @override
  State<TransactionDetailsForm> createState() => _TransactionDetailsFormState();
}

class _TransactionDetailsFormState extends State<TransactionDetailsForm> {

  TextEditingController _controller = TextEditingController();
  bool isPaid = false;
  DateTime beginDate = DateTime.now();
  DateTime? endDate;

  FocusNode _focusNode = FocusNode();


  void onSave() {
    final bloc = BlocProvider.of<AddTransactionBloc>(context);
    bloc.add(ChangeTransactionIsPaidEvent(isPaid: isPaid));
    bloc.add(ChangeTransactionDateEvent(date: beginDate));
    bloc.add(ChangeTransactionEndDateEvent(date: endDate));
    bloc.add(ChangeTransactionNameEvent(name: _controller.text));
    bloc.add(SaveTransactionToDatabaseEvent());
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void onSelectBeginDate(DateTime datetime) {
    beginDate = datetime;
  }

  void onSelectEndDate(DateTime datetime){
    endDate = datetime;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    final bloc = BlocProvider.of<AddTransactionBloc>(context);
    return AlertDialog(
      title: Text(
        "Detalhes da transação",
        style: TypographyStyles.label1(),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (str) {},
              maxLength: 30,
              maxLengthEnforcement:
              MaxLengthEnforcement.truncateAfterCompositionEnds,
              style: TypographyStyles.paragraph2(),
              decoration: InputDecoration(hintText: "Nome da transação"),
              autocorrect: false,
            ),
            DatePicker(label: "Data", onSelect: onSelectBeginDate),
            const SizedBox(height: 10,),
            if(bloc.transaction.type == TransactionType.EXPENSE)
              DatePicker(label: "Data de Expiração", onSelect: onSelectEndDate),
            const SizedBox(height: 10,),
            if (bloc.transaction.type == TransactionType.EXPENSE)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Pago?", style: TypographyStyles.label2(),),
                  Switch(
                    value: isPaid,
                    onChanged: (val) {
                      setState(() {
                        isPaid = val;
                      });
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      backgroundColor: ThemeColors.primary2,
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancelar")),
        TextButton(
            onPressed: () {
              onSave();
            },
            child: Text("Confirmar")),
      ],
    );
  }
}
