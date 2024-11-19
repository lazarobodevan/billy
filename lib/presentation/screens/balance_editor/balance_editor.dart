import 'package:billy/models/balance/balance_model.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/repositories/balance/balance_repository.dart';
import 'package:billy/services/toast_service/toast_service.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis/apigeeregistry/v1.dart';
import 'package:googleapis/chat/v1.dart';

import 'bloc/balance_bloc.dart';

class BalanceEditor extends StatefulWidget {
  const BalanceEditor({super.key});

  @override
  State<BalanceEditor> createState() => _BalanceEditorState();

}

class _BalanceEditorState extends State<BalanceEditor> {

  final CurrencyTextInputFormatter _creditLimitFormatter = CurrencyTextInputFormatter.currency(symbol: "R\$", decimalDigits: 2);
  final CurrencyTextInputFormatter _creditLimitUsedFormatter = CurrencyTextInputFormatter.currency(symbol: "R\$", decimalDigits: 2);
  final CurrencyTextInputFormatter _balanceFormatter = CurrencyTextInputFormatter.currency(symbol: "R\$", decimalDigits: 2);

  Balance? getBalanceDouble(){
    double balance = _balanceFormatter.getDouble();
    double creditLimit = _creditLimitFormatter.getDouble();
    double creditLimitUsed = _creditLimitUsedFormatter.getDouble();

    return Balance(balance: balance, creditLimit: creditLimit, limitUsed: creditLimitUsed);

  }

  void updateBalance(BuildContext context){

    Balance? balance = getBalanceDouble();

    if(balance != null) {
       BlocProvider.of<BalanceBloc>(context).add(
           UpdateBalanceEvent(balance: balance));
       ToastService.showSuccess(message: "Dados atualizados!");
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    BlocProvider.of<BalanceBloc>(context).add(LoadBalanceEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Editar conta bancária",
          style: TypographyStyles.label3(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<BalanceBloc, BalanceState>(
            bloc: BlocProvider.of<BalanceBloc>(context),
            builder: (context, state) {
              if (state is LoadingBalanceState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is LoadedBalanceState) {

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      initialValue: _balanceFormatter.formatDouble(state.balance.balance),
                      decoration:
                          InputDecoration(label: Text("Valor na conta")),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        _balanceFormatter
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue: _creditLimitFormatter.formatDouble(state.balance.creditLimit),
                      decoration:
                          InputDecoration(label: Text("Limite de crédito")),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        _creditLimitFormatter
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue: _creditLimitUsedFormatter.formatDouble(state.balance.limitUsed),
                      decoration: InputDecoration(
                          label: Text("Limite de crédito usado")),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        _creditLimitUsedFormatter
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: 130,
                      child: ElevatedButton(
                          onPressed: () {
                            updateBalance(context);
                          },
                          style: ButtonStyle(),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: ThemeColors.semanticGreen,
                              ),
                              const SizedBox(width: 5,),
                              Text(
                                "Salvar",
                                style: TypographyStyles.paragraph3()
                                    .copyWith(color: Colors.black),
                              )
                            ],
                          )),
                    )
                  ],
                );
              }

              return SizedBox.shrink();
            }),
      ),
    );
  }
}
