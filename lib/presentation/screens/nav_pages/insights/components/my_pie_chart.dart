import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/insight/insight.dart';
import 'package:billy/models/insight/period_filter.dart';
import 'package:billy/presentation/shared/components/toggle_time.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/insights_bloc.dart';
import '../data/fake_pie_chart_data.dart';
import '../enums/insight_tab.dart';

class MyPieChart extends StatelessWidget {
  final String text;

  //final Insight insight;
  final InsightTabEnum tabEnum;
  final InsightsEvent Function() getInsightEventInitial;

  const MyPieChart(
      {super.key,
      required this.text,
      required this.tabEnum,
      required this.getInsightEventInitial});

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<InsightsBloc>(context);

    bool _hasInsightData(InsightsBloc bloc) {
      return (tabEnum == InsightTabEnum.EXPENSE &&
                  bloc.expensesInsight!.insightsByCategory.isNotEmpty ||
              bloc.expensesInsight!.insightsBySubcategory.isNotEmpty) ||
          (tabEnum == InsightTabEnum.INCOME &&
                  bloc.incomeInsight!.insightsByCategory.isNotEmpty ||
              bloc.incomeInsight!.insightsBySubcategory.isNotEmpty);
    }

    return Column(
      children: [
        const SizedBox(
          height: 18,
        ),
        BlocBuilder<InsightsBloc, InsightsState>(
          builder: (context, state) {
            if (state is LoadingInsightsError) {
              return const Center(
                child: Text("Erro ao carregar insights"),
              );
            }

            if (state is LoadingExpensesInsights &&
                    tabEnum == InsightTabEnum.EXPENSE ||
                state is LoadingIncomesInsights &&
                    tabEnum == InsightTabEnum.INCOME) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is LoadedInsights) {
              var bloc = BlocProvider.of<InsightsBloc>(context);
              var insight = tabEnum == InsightTabEnum.EXPENSE
                  ? bloc.expensesInsight
                  : tabEnum == InsightTabEnum.INCOME
                      ? bloc.incomeInsight
                      : bloc.expensesInsight;

              return AspectRatio(
                aspectRatio: 1.3,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(text),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .35,
                            child: AutoSizeText(
                              "R\$${insight.totalExpent.toStringAsFixed(2)}",
                              style: TypographyStyles.headline3(),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              minFontSize: 22,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ),
                    _buildPieChart(insight),
                    if (!_hasInsightData(bloc)) _buildNotEnoughDataOverlay()
                  ],
                ),
              );
            }
            return CircularProgressIndicator();
          },
        ),
        const SizedBox(
          height: 16,
        ),
        ToggleTime(
          onSelect: (val) {
            print("Time: ${val.start} / ${val.end}");
            bloc.add(
              GetInsightEvent(
                  type: tabEnum == InsightTabEnum.EXPENSE
                      ? TransactionType.EXPENSE
                      : TransactionType.INCOME,
                  insightsTab: tabEnum,
                  periodFilter:
                      PeriodFilter(beginDate: val.start, endDate: val.end),
                  groupByCategory: bloc.insightsByCategory,
                  categoryId: bloc.categoryId),
            );
          },
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  Widget _buildPieChart(Insight insight) {
    String _getPercentageAsText(double value, double total) {
      var percentage = (value / total) * 100;

      return "${percentage.toStringAsFixed(0)}%";
    }

    List<PieChartSectionData> _getCategories() {
      return insight.insightsByCategory
          .map(
            (el) => PieChartSectionData(
                color: el.category.color,
                value: el.value,
                title: "",
                badgeWidget: Container(
                  width: 60,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 2, spreadRadius: 2)
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _getPercentageAsText(el.value, insight.totalExpent),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                badgePositionPercentageOffset: 1.2),
          )
          .toList();
    }

    List<PieChartSectionData> _getSubategories() {
      return insight.insightsBySubcategory!
          .map(
            (el) => PieChartSectionData(
                color: el.subcategory.color,
                value: el.value,
                title: "",
                badgeWidget: Container(
                  width: 60,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12, blurRadius: 2, spreadRadius: 2)
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _getPercentageAsText(el.value, insight.totalExpent),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                badgePositionPercentageOffset: 1.2),
          )
          .toList();
    }

    List<PieChartSectionData> _getSections() {
      if (insight.insightsByCategory.isNotEmpty) {
        return _getCategories();
      } else if (insight.insightsBySubcategory != null &&
          insight.insightsBySubcategory!.isNotEmpty) {
        return _getSubategories();
      } else {
        return getPieChartMockedData();
      }
    }

    return PieChart(
      swapAnimationCurve: Curves.easeInCubic,
      swapAnimationDuration: const Duration(milliseconds: 700),
      PieChartData(sections: _getSections()),
    );
  }

  Widget _buildNotEnoughDataOverlay() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
          width: double.maxFinite,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.9),
          ),
          child: const Center(
            child: Text(
              "Sem informações suficientes",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
          ),
        ),
      ),
    );
  }
}
