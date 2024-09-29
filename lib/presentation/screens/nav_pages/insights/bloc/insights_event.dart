part of 'insights_bloc.dart';

abstract class InsightsEvent extends Equatable {
  const InsightsEvent();
}

class GetInsightEvent extends InsightsEvent{

  final TransactionType type;
  final PeriodFilter periodFilter;
  final InsightTabEnum insightsTab;
  final bool? groupByCategory;

  const GetInsightEvent({required this.periodFilter, required this.type, this.groupByCategory, required this.insightsTab});

  @override
  List<Object?> get props => [type, periodFilter, groupByCategory];

}
