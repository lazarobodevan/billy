import 'package:billy/presentation/screens/nav_pages/transactions/widgets/transaction_filters.dart';
import 'package:billy/presentation/screens/nav_pages/transactions/widgets/transaction_tile.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/transactions_bloc.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TransactionsBloc>(context).add(LoadTransactionsDataEvent());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //_loadMore();
      }
    });
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
          BlocBuilder<TransactionsBloc, TransactionsState>(
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {

                    if(state is LoadingTransactionsDataState){
                      return const Center(child: CircularProgressIndicator(),);
                    }

                    if(state is LoadedTransactionsDataState) {
                      if(state.transactions.isEmpty){
                        return Center(child: Text("Sem transações"));
                      }
                      return Column(
                        children: [
                          TransactionTile(transaction: state.transactions[index]),
                          const SizedBox(height: 10,)
                        ],
                      );
                    }
                    return const SliverFillRemaining(child: Text("Erro ao carregar"),);
                  },
                  childCount: BlocProvider.of<TransactionsBloc>(context).transactions.length
                ),
              );
            },
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
          colors: [Colors.yellow.shade300, Colors.yellow.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight),
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
