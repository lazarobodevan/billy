import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/insight/period_filter.dart';
import 'package:billy/presentation/screens/nav_pages/insights/bloc/insights_bloc.dart';
import 'package:billy/presentation/screens/nav_pages/insights/components/category_item_insight.dart';
import 'package:billy/presentation/screens/nav_pages/insights/components/line_chart/my_line_chart.dart';
import 'package:billy/presentation/screens/nav_pages/insights/enums/insight_tab.dart';
import 'package:billy/presentation/shared/components/toggle_time.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/utils/date_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomesTab extends StatelessWidget {
  const IncomesTab({super.key});

  InsightsEvent _getIncomesInsightEventInitial() {
    DateTime beginDate = MyDateUtils.getFirstDayOfMonth();
    DateTime endDate = MyDateUtils.getLastDayOfMonth();

    return GetInsightEvent(
        periodFilter: PeriodFilter(beginDate: beginDate, endDate: endDate),
        insightsTab: InsightTabEnum.INCOME,
        type: TransactionType.INCOME);
  }

  String _getPercentageAsText(double value, double total) {
    var percentage = (value / total) * 100;

    return "${percentage.toStringAsFixed(0)}%";
  }

  List<FlSpot> _getLineSpots(Map<int, double> map) {
    var result =
        map.entries.map((el) => FlSpot(el.key.toDouble(), el.value)).toList();
    return result;
  }

  double _getLineChartMinValue(double minValue) {
    double newValue = minValue - 1000;
    if (newValue < 0) {
      return 0;
    }
    return newValue;
  }

  double _getLineChartMaxValue(double maxValue) {
    return maxValue + 200;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      controller: ScrollController(),
      child: BlocBuilder<InsightsBloc, InsightsState>(
        bloc: BlocProvider.of<InsightsBloc>(context)
          ..add(_getIncomesInsightEventInitial()),
        builder: (context, state) {
          if (state is LoadingInsightsError) {
            return const Center(
              child: Text("Erro ao carregar insights"),
            );
          }

          if (state is LoadingInsights) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is LoadedInsights) {
            if (state.insight.insightsByCategory.isEmpty) {
              return const Center(
                child: Text("Sem dados suficientes"),
              );
            }
            return Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: ThemeColors.primary3,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 5),
                                blurRadius: 10)
                          ]),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 18,
                          ),
                          AspectRatio(
                            aspectRatio: 1.3,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("Total gasto"),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .35,
                                        child: AutoSizeText(
                                          "R\$${state.insight.totalExpent}",
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
                                PieChart(
                                  swapAnimationCurve: Curves.easeInCubic,
                                  swapAnimationDuration:
                                      Duration(milliseconds: 700),
                                  PieChartData(
                                    sections: state.insight.insightsByCategory
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black12,
                                                          blurRadius: 2,
                                                          spreadRadius: 2)
                                                    ]),
                                                child: Center(
                                                    child: Text(
                                                  _getPercentageAsText(
                                                      el.value,
                                                      state
                                                          .insight.totalExpent),
                                                  textAlign: TextAlign.center,
                                                )),
                                              ),
                                              badgePositionPercentageOffset:
                                                  1.2),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ToggleTime(),
                          const SizedBox(
                            height: 16,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text("Separação de gastos",
                        style: TypographyStyles.label2()),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      children: state.insight.insightsByCategory
                          .map((el) => CategoryItemInsight(
                                value: el.value,
                                percentage:
                                    ((el.value / state.insight.totalExpent) *
                                            100)
                                        .toInt(),
                                category: el.category,
                              ))
                          .toList(),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: ThemeColors.primary3,
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: MyLineChart(
                        text: "Gasto por mês",
                        lineColor: Colors.red,
                        minX: 0,
                        minY: _getLineChartMinValue(
                            state.insight.lineChartData.minValue),
                        maxX: 11,
                        maxY:
                            state.insight.lineChartData.maxValue,
                        spots: _getLineSpots(state.insight.lineChartData.values)
                        ),
                  ),
                )
              ],
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}
