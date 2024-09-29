import 'package:auto_size_text/auto_size_text.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/insight/insight.dart';
import 'package:billy/models/insight/line_chart_data.dart';
import 'package:billy/models/insight/my_line_chart_spots.dart';
import 'package:billy/models/insight/period_filter.dart';
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

import '../bloc/insights_bloc.dart';

class InsightTabBase extends StatefulWidget {
  final InsightsEvent Function() getInsightEventInitial;
  final String pieChartText;
  final String lineChartText;
  final InsightTabEnum tabEnum;

  const InsightTabBase(
      {super.key,
      required this.getInsightEventInitial,
      required this.pieChartText,
      required this.lineChartText,
      required this.tabEnum});

  @override
  State<InsightTabBase> createState() => _InsightTabBaseState();
}

class _InsightTabBaseState extends State<InsightTabBase> {
  @override
  void initState() {
    BlocProvider.of<InsightsBloc>(context).add(widget.getInsightEventInitial());
    super.initState();
  }

  String _getPercentageAsText(double value, double total) {
    var percentage = (value / total) * 100;

    return "${percentage.toStringAsFixed(0)}%";
  }

  List<MyLineChartSpots> _getLineSpots(MyLineChartData data) {
    var result = data.spots
        .map((chartSpot) => MyLineChartSpots(
            spots: chartSpot.spots,
            lineColor: _getChartLineColor(chartSpot.transactionType),
            transactionType: chartSpot.transactionType))
        .toList();
    return result;
  }

  Color _getChartLineColor(TransactionType type) {
    if (type == TransactionType.EXPENSE) {
      return ThemeColors.semanticRed;
    }
    return ThemeColors.semanticGreen;
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
      child:
          BlocBuilder<InsightsBloc, InsightsState>(builder: (context, state) {
        if (state is LoadingInsightsError) {
          return const Center(
            child: Text("Erro ao carregar insights"),
          );
        }

        if (state is LoadingExpensesInsights &&
                widget.tabEnum == InsightTabEnum.EXPENSE ||
            state is LoadingIncomesInsights &&
                widget.tabEnum == InsightTabEnum.INCOME) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var bloc = BlocProvider.of<InsightsBloc>(context);
        var insight = widget.tabEnum == InsightTabEnum.EXPENSE
            ? bloc.expensesInsight
            : widget.tabEnum == InsightTabEnum.INCOME
                ? bloc.incomeInsight
                : bloc.expensesInsight;

        if (insight.insightsByCategory.isEmpty) {
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
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 5),
                          blurRadius: 10)
                    ],
                  ),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(widget.pieChartText),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .35,
                                    child: AutoSizeText(
                                      "R\$${insight.totalExpent}",
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
                                  const Duration(milliseconds: 700),
                              PieChartData(
                                sections: insight.insightsByCategory
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
                                                  BorderRadius.circular(10),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 2,
                                                    spreadRadius: 2)
                                              ],
                                            ),
                                            child: Center(
                                              child: Text(
                                                _getPercentageAsText(el.value,
                                                    insight.totalExpent),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          badgePositionPercentageOffset: 1.2),
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
                      ToggleTime(
                        onSelect: (val) {
                          bloc.add(
                            GetInsightEvent(
                              type: widget.tabEnum == InsightTabEnum.EXPENSE
                                  ? TransactionType.EXPENSE
                                  : TransactionType.INCOME,
                              insightsTab: widget.tabEnum,
                              periodFilter: PeriodFilter(
                                  beginDate: val.start, endDate: val.end),
                              groupByCategory: true,
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text("Separação de gastos", style: TypographyStyles.label2()),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  children: insight.insightsByCategory
                      .map((el) => CategoryItemInsight(
                            value: el.value,
                            percentage: ((el.value / insight.totalExpent) * 100)
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
            MyLineChart(
              text: widget.lineChartText,
              lineColor: Colors.red,
              minX: 0,
              minY: _getLineChartMinValue(insight.lineChartData.minValue),
              maxX: 11,
              maxY: _getLineChartMaxValue(insight.lineChartData.maxValue),
              spots: _getLineSpots(insight.lineChartData),
            )
          ],
        );
      }),
    );
  }
}
