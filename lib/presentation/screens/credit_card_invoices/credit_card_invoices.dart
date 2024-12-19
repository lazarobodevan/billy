import 'package:billy/presentation/screens/credit_card_invoices/update_invoice/update_invoice_screen.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/credit_card_invoice_bloc.dart';

class CreditCardInvoices extends StatefulWidget {
  const CreditCardInvoices({super.key});

  @override
  State<CreditCardInvoices> createState() => _CreditCardInvoicesState();
}

class _CreditCardInvoicesState extends State<CreditCardInvoices> {

  @override
  void initState() {
    BlocProvider.of<CreditCardInvoiceBloc>(context).add(LoadInvoicesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faturas", style: TypographyStyles.headline3(),),
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<CreditCardInvoiceBloc, CreditCardInvoiceState>(
          builder: (context, state) {
            if(state is LoadingInvoicesState){
              return const Center(child: CircularProgressIndicator(),);
            }

            if(state is LoadedInvoicesState) {
              return Column(
                children: state.invoices.map((el){
                  return Card(
                    child: ListTile(
                      title: Text(el.name!, style: TypographyStyles.label2(),),
                      subtitle: Text(CurrencyFormatter.format(el.total), style: TypographyStyles.paragraph4(),),
                      trailing: const Icon(Icons.open_in_new),
                      enableFeedback: true,
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateInvoiceScreen()));
                      },
                    ),
                  );
                }).toList(),
              );
            }

            if(state is LoadInvoicesErrorState) {
              return Text(state.message);
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
