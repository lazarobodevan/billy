import 'package:billy/models/insight/line_chart_data.dart';
import 'package:billy/repositories/insight/i_insight_repository.dart';

class GetTransactionsAmountUseCase{
  final IInsightRepository repository;

  const GetTransactionsAmountUseCase({required this.repository});

  Future<MyLineChartData> execute(
      {required bool showIncomes, required bool showExpenses}) async {

    return await repository.getLineChartData(showIncomes: showIncomes, showExpenses: showExpenses);

  }
}