import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/insight/insight.dart';
import 'package:billy/models/insight/line_chart_data.dart';
import 'package:billy/models/insight/period_filter.dart';

abstract class IInsightRepository {
  Future<Insight> getInsights(
      {TransactionType? type = TransactionType.EXPENSE,
      required PeriodFilter periodFilter,
      bool? groupByCategory = true});

  Future<MyLineChartData> getLineChartData({required bool showIncomes, required bool showExpenses});
}
