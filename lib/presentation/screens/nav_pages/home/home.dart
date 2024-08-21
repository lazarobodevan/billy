import 'package:billy/presentation/screens/add_transaction/add_transaction.dart';
import 'package:billy/presentation/screens/add_transaction/add_transaction.dart';
import 'package:billy/presentation/shared/components/action_button.dart';
import 'package:billy/presentation/shared/components/transaction_item.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/repositories/transaction/transaction_repository.dart';
import 'package:billy/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../add_transaction/bloc/add_transaction_bloc.dart';
import 'bloc/home_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.add(LoadHomeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary2,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is LoadingHomeState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is LoadedHomeState) {
                    return _buildBalanceSection(state);
                  }
                  return SizedBox();
                },
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: ThemeColors.primary3,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, -2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Operações", style: TypographyStyles.label2()),
                        Text(
                          "Ver todas",
                          style: TypographyStyles.label2()
                              .copyWith(color: ThemeColors.secondary1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          if (state is LoadingHomeState) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: ThemeColors.primary1,
                              ),
                            );
                          }
                          if (state is LoadedHomeState) {
                            if (state.transactions.isEmpty) {
                              return Center(
                                child: Text(
                                  "Sem transações",
                                  style: TypographyStyles.paragraph3(),
                                ),
                              );
                            }
                            return ListView.builder(
                              itemCount: state.transactions.length,
                              itemBuilder: (context, index) {
                                return TransactionItem(
                                  transaction: state.transactions[index],
                                );
                              },
                            );
                          }
                          return SizedBox();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSection(LoadedHomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ThemeColors.primary1,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "Lázaro Bodevan",
                  style: TypographyStyles.label3(),
                ),
              ],
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: ThemeColors.primary3,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(Icons.notifications_none),
            ),
          ],
        ),
        const SizedBox(height: 17),
        Text(
          "Disponível na conta",
          style: TypographyStyles.paragraph3(),
        ),
        Text(
          CurrencyFormatter.format(state.balance.balance),
          style: TypographyStyles.headline3(),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Limite no cartão",
              style: TypographyStyles.label2(),
            ),
            Text(
              CurrencyFormatter.format(state.balance.creditLimit),
              style: TypographyStyles.paragraph3(),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1,
              color: Colors.black12,
            ),
            Container(
              width: getCreditLimitWidth(
                limit: state.balance.creditLimit,
                limitUsed: state.balance.limitUsed,
              ),
              height: 2,
              color: ThemeColors.primary1,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          "Fatura: ${CurrencyFormatter.format(state.balance.limitUsed)}",
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: ActionButton(
                text: "Pagar",
                icon: Icons.payments_sharp,
                onTap: () {
                  Navigator.of(context).pushNamed("/transaction");
                },
              ),
            ),
            const SizedBox(width: 40),
            Flexible(
              child: ActionButton(
                text: "Receber",
                icon: Icons.add_circle,
                onTap: () {
                  Navigator.of(context).pushNamed("/transaction");
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  double getCreditLimitWidth({required double limit, required double limitUsed}) {
    if (limit == 0) return 0;

    const padding = 2 * 16;
    final screenWidth = MediaQuery.of(context).size.width - padding;
    final percentage = (limitUsed * 100) / limit;

    return screenWidth * (percentage/100);
  }
}

