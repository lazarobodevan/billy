import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/insight/insight.dart';
import 'package:billy/models/insight/line_chart_data.dart';
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
  late Insight incomeInsight = Insight.empty();
  bool? insightsByCategory = false;
  int? categoryId;

  late MyLineChartData expensesLineChartData;
  late MyLineChartData incomesLineChartData;

  final Map<InsightTabEnum, PeriodFilter> _periodFilters = {};

  late final GetInsightUseCase getInsightUseCase;

  PeriodFilter? getPeriodFilter(InsightTabEnum tab) {
    return _periodFilters[tab];
  }

  InsightsBloc({required this.insightsRepository}) : super(InsightsInitial()) {
    getInsightUseCase = GetInsightUseCase(repository: insightsRepository);

    on<InsightsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetInsightEvent>((event, emit) async {

      try {
        if(event.insightsTab == InsightTabEnum.EXPENSE){
          emit(LoadingExpensesInsights());
        }
        if(event.insightsTab == InsightTabEnum.INCOME) {
          emit(LoadingIncomesInsights());
        }

        _periodFilters[event.insightsTab] = event.periodFilter;

        final insight = await getInsightUseCase.execute(
            periodFilter: event.periodFilter,
            type: event.type,
            groupByCategory: event.groupByCategory,
            categoryId: event.categoryId,
            showExpenses: _showExpenses(event.insightsTab),
            showIncomes: _showIncomes(event.insightsTab));

        if(event.insightsTab == InsightTabEnum.EXPENSE){
          expensesInsight = insight;
          expensesLineChartData = insight.lineChartData;
        }
        if(event.insightsTab == InsightTabEnum.INCOME){
          incomeInsight = insight;
          incomesLineChartData = insight.lineChartData;
        }

        insightsByCategory = event.groupByCategory;
        categoryId = event.categoryId;

        emit(LoadedInsights(insight: insight,tabEnum: event.insightsTab));
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
