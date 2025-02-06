
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/insight/period_filter.dart';
import 'package:billy/presentation/screens/nav_pages/insights/bloc/insights_bloc.dart';
import 'package:billy/presentation/screens/nav_pages/insights/components/insight_tab_base.dart';
import 'package:billy/presentation/screens/nav_pages/insights/enums/insight_tab.dart';

import 'package:billy/utils/date_utils.dart';
import 'package:flutter/material.dart';

class IncomesTab extends StatelessWidget {
  const IncomesTab({super.key});

  InsightsEvent _getInsightEventInitial() {
    DateTime beginDate = MyDateUtils.getFirstDayOfMonth();
    DateTime endDate = MyDateUtils.getLastDayOfMonth();

    return GetInsightEvent(
        periodFilter: PeriodFilter(beginDate: beginDate, endDate: endDate),
        insightsTab: InsightTabEnum.INCOME,
        type: TransactionType.INCOME);
  }

  InsightsEvent getByCategory(int id) {
    DateTime beginDate = MyDateUtils.getFirstDayOfMonth();
    DateTime endDate = MyDateUtils.getLastDayOfMonth();

    return GetInsightEvent(
        periodFilter: PeriodFilter(beginDate: beginDate, endDate: endDate),
        insightsTab: InsightTabEnum.INCOME,
        type: TransactionType.INCOME,
      groupByCategory: false,
      categoryId: id
    );
  }

  @override
  Widget build(BuildContext context) {
    return InsightTabBase(
        getInsightEventInitial: _getInsightEventInitial,
        getByCategory: getByCategory,
        pieChartText: "Ganho total",
        lineChartText: "Ganho por mês",
        tabEnum: InsightTabEnum.INCOME);
  }
}
