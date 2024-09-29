import 'dart:async';

import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/insight/insight.dart';
import 'package:billy/models/insight/period_filter.dart';
import 'package:billy/presentation/screens/nav_pages/insights/enums/insight_tab.dart';
import 'package:billy/presentation/screens/nav_pages/insights/tabs/insights_tab.dart';
import 'package:billy/repositories/insight/i_insight_repository.dart';
import 'package:billy/use_cases/insight/get_insight_use_case.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'insights_event.dart';

part 'insights_state.dart';

class InsightsBloc extends Bloc<InsightsEvent, InsightsState> {
  final IInsightRepository insightsRepository;
  Insight expensesInsight = Insight.empty();
  Insight incomeInsight = Insight.empty();

  late final GetInsightUseCase getInsightUseCase;

  InsightsBloc({required this.insightsRepository}) : super(InsightsInitial()) {
    getInsightUseCase = GetInsightUseCase(repository: insightsRepository);

    on<InsightsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetInsightEvent>((event, emit) async {
      try {
        emit(LoadingInsights());
        final insight = await getInsightUseCase.execute(
            periodFilter: event.periodFilter,
            type: event.type,
            groupByCategory: event.groupByCategory,
            showExpenses: _showExpenses(event.insightsTab),
            showIncomes: _showIncomes(event.insightsTab));

        emit(LoadedInsights(insight: insight));
      } catch (e) {
        emit(LoadingInsightsError());
      }
    });
  }
  
  bool _showExpenses(InsightTabEnum tab){
    return tab != InsightTabEnum.INCOME ? true: false;
  }
  
  bool _showIncomes(InsightTabEnum tab){
    return tab != InsightTabEnum.EXPENSE ? true : false;
  }
}
