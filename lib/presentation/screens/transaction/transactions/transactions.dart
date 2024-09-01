import 'package:billy/presentation/screens/transaction/transactions/bloc/list_transactions_bloc.dart';
import 'package:billy/presentation/screens/transaction/transactions/widgets/transaction_filters.dart';
import 'package:billy/presentation/screens/transaction/transactions/widgets/transaction_tile.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../models/transaction/transaction_model.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    BlocProvider.of<ListTransactionsBloc>(context).add(LoadTransactionsEvent());
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //_loadMore();
      }
    });
  }

  String formatDate(DateTime date){
    final now = DateTime.now();
    final difference =now.difference(date);
    final dateFormat = DateFormat('EEE, dd/MM', 'pt_BR');

    if(difference.isNegative){
      var formattedDate = dateFormat.format(date);
      formattedDate =
          formattedDate.substring(0, 1).toUpperCase() + formattedDate.substring(1);
      formattedDate = formattedDate.replaceAll('.', '');
      return formattedDate;
    }

    if (difference.inDays == 0) {
      return 'Hoje';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays == 2) {
      return 'Anteontem';
    } else {
      var formattedDate = dateFormat.format(date);
      formattedDate =
          formattedDate.substring(0, 1).toUpperCase() + formattedDate.substring(1);
      formattedDate = formattedDate.replaceAll('.', '');
      return formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeColors.primary2,
        title: Text(
          "Transações",
          style: TypographyStyles.headline3(),
        ),
      ),
      backgroundColor: ThemeColors.primary2,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildCreditCardManagementCard(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TransactionFilters(),
            ),
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<ListTransactionsBloc, ListTransactionsState>(
              bloc: BlocProvider.of<ListTransactionsBloc>(context),
              builder: (context, state) {
                if (state is LoadingTransactionsDataState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is LoadedTransactionsDataState) {
                  if (state.transactions.isEmpty) {
                    return const Center(child: Text("Sem transações"));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Impede scroll independente
                    itemCount: state.transactions.length,
                    itemBuilder: (context, index) {
                      DateTime date = state.transactions.keys.elementAt(index);
                      List<Transaction> transactionsForDate = state.transactions[date]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0, left: 16),
                            child: Text(
                              formatDate(date), // Formata a data para exibição
                              style: TypographyStyles.paragraph3(),
                            ),
                          ),
                          ...transactionsForDate.map((transaction) {
                            return Column(
                              children: [
                                TransactionTile(transaction: transaction),
                                const SizedBox(height: 10),
                              ],
                            );
                          }).toList(),
                        ],
                      );
                    },
                  );
                }

                return const Text("Erro ao carregar");
              },
            ),
          )
        ],
      ),
    );
  }
}

Widget _buildCreditCardManagementCard(BuildContext context) {
  final screenSize = MediaQuery.of(context).size;
  return Container(
    height: screenSize.height * .2,
    width: screenSize.width,
    decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: [Color(0xfffbd07c), Color(0xfff7f779)],
          end: Alignment.bottomRight,
          begin: Alignment.topLeft),
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            offset: Offset(0, 2),
            spreadRadius: 2)
      ],
    ),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "LAZARO BODEVAN",
            style: TypographyStyles.label2(),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "**** **** **** ****",
            style: TypographyStyles.label3(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                "Gerenciar fatura",
                style: TypographyStyles.label3(),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
