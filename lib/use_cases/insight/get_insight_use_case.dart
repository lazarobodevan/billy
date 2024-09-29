import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/insight/insight.dart';
import 'package:billy/models/insight/period_filter.dart';
import 'package:billy/repositories/insight/i_insight_repository.dart';

import '../../repositories/category/i_category_repository.dart';

class GetInsightUseCase {
  final IInsightRepository repository;

  const GetInsightUseCase({required this.repository});

  Future<Insight> execute(
      {TransactionType? type = TransactionType.EXPENSE,
      required PeriodFilter periodFilter,
      bool? groupByCategory = true,
      required bool showIncomes,
      required bool showExpenses}) async {

    final insight = await repository.getInsights(
        periodFilter: periodFilter,
        type: type ?? TransactionType.EXPENSE,
        groupByCategory: groupByCategory ?? true);

    insight.lineChartData = await repository.getLineChartData(
        showIncomes: showIncomes, showExpenses: showExpenses);

    return insight;
  }
}
