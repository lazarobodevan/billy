import 'package:billy/presentation/screens/nav_pages/insights/bloc/insights_bloc.dart';
import 'package:billy/presentation/screens/nav_pages/insights/tabs/expenses_tab.dart';
import 'package:billy/presentation/screens/nav_pages/insights/tabs/incomes_tab.dart';
import 'package:billy/presentation/screens/nav_pages/insights/tabs/insights_tab.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/repositories/insight/insight_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Insights extends StatefulWidget {
  const Insights({super.key});

  @override
  State<Insights> createState() => _InsightsState();
}

class _InsightsState extends State<Insights>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary2,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeColors.primary2,
        title: Text(
          "Insights",
          style: TypographyStyles.headline3(),
        ),
        bottom: TabBar(
          controller: tabController,
          tabs: const [
            Tab(
              text: "Despesas",
            ),
            Tab(
              text: "Receita",
            ),
            Tab(
              text: "Insights",
            )
          ],
        ),
      ),
      body: RepositoryProvider(
        create: (context) => InsightRepository(),
        child: BlocProvider(
          create: (context) => InsightsBloc(
              insightsRepository:
                  RepositoryProvider.of<InsightRepository>(context)),
          child: TabBarView(controller: tabController, children: const [
            ExpensesTab(),
            IncomesTab(),
            InsightsTab(),
          ]),
        ),
      ),
    );
  }
}
