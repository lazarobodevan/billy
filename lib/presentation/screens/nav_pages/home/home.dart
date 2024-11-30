import 'dart:math';
import 'dart:ui';

import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/limit/limit_model.dart';
import 'package:billy/presentation/screens/nav_pages/home/widgets/draggable_transactions_container.dart';
import 'package:billy/presentation/screens/transaction/bloc/transaction_bloc.dart';
import 'package:billy/presentation/shared/blocs/google_auth_bloc/google_auth_bloc.dart';
import 'package:billy/presentation/shared/components/action_button.dart';
import 'package:billy/presentation/shared/components/limit_item.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/repositories/transaction/transaction_repository.dart';
import 'package:billy/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/home_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isContainerHidden = false;
  double _currentChildSize = 1.0;

  @override
  void initState() {
    super.initState();
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.add(LoadHomeEvent());
  }

  void toggleContainerVisibility() {
    setState(() {
      isContainerHidden = !isContainerHidden;
      if (!isContainerHidden) {
        _currentChildSize = 1.0;
      }
    });
  }

  void updateChildSize(double size) {
    setState(() {
      _currentChildSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary2,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is LoadingHomeState) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is LoadedHomeState) {
              return _buildBalanceSection(state, isContainerHidden);
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildBalanceSection(LoadedHomeState state, bool isContainerHidden) {
    var loggedUser =
        BlocProvider.of<GoogleAuthBloc>(context).googleAuthService.currentUser;

    _getProfilePicture() {
      if (loggedUser != null && loggedUser.photoURL != null) {
        return loggedUser.photoURL;
      }
      return null;
    }

    return BlocListener<TransactionBloc, TransactionState>(
        listener: (context, state) {
          if (state is SavedTransactionToDatabaseState) {
            BlocProvider.of<HomeBloc>(context).add(LoadHomeEvent());
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Material(
              color: Colors.transparent,
              child: Column(
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
                            child: _getProfilePicture() != null
                                ? Image.network(_getProfilePicture()!)
                                : SizedBox(),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            loggedUser?.displayName ?? "Você",
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
          
                  const SizedBox(height: 30,),
                  Text("Orçamentos", style: TypographyStyles.label2(),),
                  const SizedBox(height: 4,),
          

                ],
              ),
            ),
          ),
        ));
  }

  double getCreditLimitWidth(
      {required double limit, required double limitUsed}) {
    if (limit == 0) return 0;

    const padding = 2 * 16;
    final screenWidth = MediaQuery.of(context).size.width - padding;
    final percentage = (limitUsed * 100) / limit;

    return screenWidth * (percentage / 100);
  }
}
