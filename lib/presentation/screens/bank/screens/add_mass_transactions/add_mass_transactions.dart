import 'package:billy/enums/bank/bank_type.dart';
import 'package:billy/presentation/screens/bank/widgets/mass_transaction_tile.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/mass_transactions_bloc.dart';

class AddMassTransactions extends StatefulWidget {
  final BankType bankType;
  final bool isInvoice;

  const AddMassTransactions(
      {required this.bankType, required this.isInvoice, super.key});

  @override
  State<AddMassTransactions> createState() => _AddMassTransactionsState();
}

class _AddMassTransactionsState extends State<AddMassTransactions> {
  @override
  void initState() {
    BlocProvider.of<MassTransactionsBloc>(context).add(
        LoadMassTransactionsEvent(
            bankType: widget.bankType, isInvoice: widget.isInvoice));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Import massivo",
          style: TypographyStyles.headline3(),
        ),
      ),
      body: BlocConsumer<MassTransactionsBloc, MassTransactionsState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is LoadingMassTransactionsState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is LoadMassTransactionsErrorState) {
            return Center(
              child: Text(state.message),
            );
          }
          var bloc = BlocProvider.of<MassTransactionsBloc>(context);

          return ListView.separated(
              itemBuilder: (context, index) {
                return MassTransactionTile(
                  transaction: bloc.transactions[index],
                  index: index,
                  onSelectionChanged: (val){},
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: bloc.transactions.length);
        },
      ),
    );
  }
}
