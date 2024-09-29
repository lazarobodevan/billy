part of 'insights_bloc.dart';

abstract class InsightsState extends Equatable {
  const InsightsState();
}

class InsightsInitial extends InsightsState {
  @override
  List<Object> get props => [];
}

class LoadingInsights extends InsightsState{
  @override
  List<Object?> get props => [];

}

class LoadedInsights extends InsightsState{

  final Insight insight;

  const LoadedInsights({required this.insight});

  @override
  List<Object?> get props => [insight];

}

class LoadingInsightsError extends InsightsState{

  @override
  List<Object?> get props => [];
}