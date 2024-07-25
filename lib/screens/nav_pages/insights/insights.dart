import 'package:billy/screens/nav_pages/insights/tabs/expenses_tab.dart';
import 'package:billy/screens/nav_pages/insights/tabs/incomes_tab.dart';
import 'package:billy/screens/nav_pages/insights/tabs/insights_tab.dart';
import 'package:billy/shared/components/indicator.dart';
import 'package:billy/shared/components/toggle_time.dart';
import 'package:billy/theme/colors.dart';
import 'package:billy/theme/typography.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Insights extends StatefulWidget {
  const Insights({super.key});

  @override
  State<Insights> createState() => _InsightsState();
}

class _InsightsState extends State<Insights> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
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
          tabs: [
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
      body: TabBarView(
        controller: tabController,
          children: [
            ExpensesTab(),
            IncomesTab(),
            InsightsTab()
      ]),
    );
  }
}
