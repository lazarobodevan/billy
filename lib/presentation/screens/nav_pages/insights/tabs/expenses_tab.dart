import 'package:auto_size_text/auto_size_text.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/insight/insight.dart';
import 'package:billy/models/insight/period_filter.dart';
import 'package:billy/presentation/screens/nav_pages/insights/bloc/insights_bloc.dart';
import 'package:billy/presentation/screens/nav_pages/insights/components/category_item_insight.dart';
import 'package:billy/presentation/screens/nav_pages/insights/components/insight_tab_base.dart';
import 'package:billy/presentation/screens/nav_pages/insights/components/line_chart/my_line_chart.dart';
import 'package:billy/presentation/screens/nav_pages/insights/enums/insight_tab.dart';
import 'package:billy/presentation/screens/nav_pages/insights/tabs/insights_tab.dart';
import 'package:billy/presentation/shared/components/indicator.dart';
import 'package:billy/presentation/shared/components/toggle_time.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/utils/date_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesTab extends StatelessWidget {
  const ExpensesTab({super.key});

  @override
  Widget build(BuildContext context) {
    InsightsEvent _getInsightEventInitial() {
      var bloc = BlocProvider.of<InsightsBloc>(context);

      // Garante que o filtro de período da aba atual sempre será utilizado.
      PeriodFilter currentFilter =
          bloc.getPeriodFilter(InsightTabEnum.EXPENSE) ??
              PeriodFilter(
                  beginDate: MyDateUtils.getFirstDayOfMonth(),
                  endDate: MyDateUtils.getLastDayOfMonth());

      return GetInsightEvent(
          periodFilter: currentFilter,
          insightsTab: InsightTabEnum.EXPENSE,
          type: TransactionType.EXPENSE);
    }

    InsightsEvent _getByCategory(int id) {
      var bloc = BlocProvider.of<InsightsBloc>(context);

      // Garante que o filtro de período da aba atual sempre será utilizado.
      PeriodFilter currentFilter =
          bloc.getPeriodFilter(InsightTabEnum.EXPENSE)!;

      return GetInsightEvent(
        periodFilter: currentFilter,
        insightsTab: InsightTabEnum.EXPENSE,
        type: TransactionType.EXPENSE,
        groupByCategory: false,
        categoryId: id,
      );
    }

    return InsightTabBase(
        getInsightEventInitial: _getInsightEventInitial,
        getByCategory: _getByCategory,
        pieChartText: "Gasto total",
        lineChartText: "Gasto por mês",
        tabEnum: InsightTabEnum.EXPENSE);
  }
}
