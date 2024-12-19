import 'dart:async';

import 'package:billy/presentation/screens/transaction/transactions/bloc/list_transactions_bloc.dart';
import 'package:billy/presentation/screens/transaction/transactions/widgets/transaction_filters.dart';
import 'package:billy/presentation/screens/transaction/transactions/widgets/transaction_tile.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
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
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<ListTransactionsBloc>(context).add(const LoadTransactionsEvent(isFirstFetch: true));

    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels != 0) {
          BlocProvider.of<ListTransactionsBloc>(context)
              .add(LoadTransactionsEvent());

          Timer(Duration(milliseconds: 20),(){
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          });

        }
      }
    });
  }

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    final dateFormat = DateFormat('EEE, dd/MM', 'pt_BR');

    if (difference.isNegative) {
      var formattedDate = dateFormat.format(date);
      formattedDate = formattedDate.substring(0, 1).toUpperCase() +
          formattedDate.substring(1);
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
      formattedDate = formattedDate.substring(0, 1).toUpperCase() +
          formattedDate.substring(1);
      formattedDate = formattedDate.replaceAll('.', '');
      return formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<ListTransactionsBloc>(context);

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
              child: TransactionFilters(),
            ),
          ),
          BlocConsumer<ListTransactionsBloc, ListTransactionsState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is LoadingTransactionsDataState && state.isFirstFetch) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              var isLoading = state is LoadingTransactionsDataState;

              final transactionsData = bloc.transactions;
              if (transactionsData.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      "Sem transações",
                      style: TypographyStyles.paragraph3(),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {

                    if (isLoading && index == transactionsData.length) {
                      return Center(child: CircularProgressIndicator());
                    }

                    DateTime date = transactionsData.keys.elementAt(index);
                    List<Transaction> transactionsForDate =
                        transactionsData[date]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, left: 16, top: 8),
                          child: Text(
                            formatDate(date),
                            style: TypographyStyles.paragraph3(),
                          ),
                        ),
                        ...List.generate(
                          transactionsForDate.length,
                          (i) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TransactionTile(
                                    transaction: transactionsForDate[i])

                          ),
                        ),
                      ],
                    );
                  },
                  childCount: transactionsData.length + (isLoading ? 1 : 0),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
