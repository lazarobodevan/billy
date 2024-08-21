import 'package:billy/presentation/screens/nav_pages/categories/categories.dart';
import 'package:billy/presentation/screens/nav_pages/home/bloc/home_bloc.dart';
import 'package:billy/presentation/screens/nav_pages/home/home.dart';
import 'package:billy/presentation/screens/nav_pages/insights/insights.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/repositories/balance/balance_repository.dart';
import 'package:billy/repositories/transaction/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  List pages = [
    _buildHome(),
    Insights(),
    Categories(
      isSelectableCategories: false,
    ),
    Home()
  ];
  List barItems = [
    {"text": "Home", "icon": Icons.home_outlined},
    {"text": "Insights", "icon": Icons.pie_chart_outline},
    {"text": "Categorias", "icon": Icons.category_outlined},
    {"text": "Mais", "icon": Icons.more_vert_outlined}
  ];

  void _onIndexChanged(int newIndex) {
    setState(() {
      currentIndex = newIndex;
    });
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(canvasColor: ThemeColors.primary1),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.white54,
          onTap: _onIndexChanged,
          selectedItemColor: ThemeColors.primary3,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_outline),
              label: 'Insights',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              label: 'Categorias',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_vert_outlined),
              label: 'Mais',
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHome() {
  return BlocProvider(
    create: (context) => HomeBloc(
      transactionRepository:
          RepositoryProvider.of<TransactionRepository>(context),
      balanceRepository: RepositoryProvider.of<BalanceRepository>(context)
    ),
    child: Home(),
  );
}
