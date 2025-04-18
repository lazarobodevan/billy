import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/insight/insight.dart';
import 'package:billy/models/insight/line_chart_data.dart';
import 'package:billy/models/insight/my_line_chart_spots.dart';
import 'package:billy/models/insight/period_filter.dart';
import 'package:billy/presentation/screens/nav_pages/insights/components/category_item_insight.dart';
import 'package:billy/presentation/screens/nav_pages/insights/components/line_chart/my_line_chart.dart';
import 'package:billy/presentation/screens/nav_pages/insights/components/my_pie_chart.dart';
import 'package:billy/presentation/screens/nav_pages/insights/data/fake_pie_chart_data.dart';
import 'package:billy/presentation/screens/nav_pages/insights/enums/insight_tab.dart';
import 'package:billy/presentation/shared/components/toggle_time.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/insights_bloc.dart';

class InsightTabBase extends StatefulWidget {
  final InsightsEvent Function() getInsightEventInitial;
  final InsightsEvent Function(int) getByCategory;
  final String pieChartText;
  final String lineChartText;
  final InsightTabEnum tabEnum;

  const InsightTabBase(
      {super.key,
      required this.getInsightEventInitial,
      required this.pieChartText,
      required this.lineChartText,
      required this.tabEnum,
      required this.getByCategory});

  @override
  State<InsightTabBase> createState() => _InsightTabBaseState();
}

class _InsightTabBaseState extends State<InsightTabBase>
    with AutomaticKeepAliveClientMixin<InsightTabBase> {
  @override
  void initState() {
    BlocProvider.of<InsightsBloc>(context).add(widget.getInsightEventInitial());
    super.initState();
  }

  void getBySubcategory(int id) {
    BlocProvider.of<InsightsBloc>(context).add(widget.getByCategory(id));
  }

  void getByCategory() {
    BlocProvider.of<InsightsBloc>(context).add(widget.getInsightEventInitial());
  }

  bool getShowResetButton() {
    var bloc = BlocProvider.of<InsightsBloc>(context);
    return bloc.categoryId != null ? !bloc.insightsByCategory! : false;
  }

  void onReset() {
    var bloc = BlocProvider.of<InsightsBloc>(context);
  }

  @override
  bool get wantKeepAlive => true;

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
    super.build(context);
    var bloc = BlocProvider.of<InsightsBloc>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      controller: ScrollController(),
      child: Column(
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
                child: MyPieChart(
                    text: widget.pieChartText,
                    //insight: insight,
                    tabEnum: widget.tabEnum,
                    getInsightEventInitial: widget.getInsightEventInitial),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Separação de gastos", style: TypographyStyles.label2()),
                  //RESET BUTTON
                  BlocBuilder<InsightsBloc, InsightsState>(
                    builder: (context, state) {
                      if (getShowResetButton()) {
                        return Material(
                          shape: const CircleBorder(),
                          elevation: 1,
                          child: GestureDetector(
                            onTap: () {
                              getByCategory();
                            },
                            child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape
                                      .circle, // Forma circular para garantir clique em bordas.
                                ),
                                width: 40,
                                height: 40,
                                child: Center(
                                  child: const Icon(
                                    Icons.restart_alt_rounded,
                                    size: 18,
                                  ),
                                )),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              BlocBuilder<InsightsBloc, InsightsState>(
                builder: (context, state) {
                  var bloc = BlocProvider.of<InsightsBloc>(context);
                  var insights = widget.tabEnum == InsightTabEnum.INCOME
                      ? bloc.incomeInsight
                      : bloc.expensesInsight;
                  if (state is LoadedInsights) {
                    if (insights.insightsByCategory.isNotEmpty) {
                      return Column(
                        children: insights.insightsByCategory
                            .map((el) => CategoryItemInsight(
                                  value: el.value,
                                  percentage:
                                      ((el.value / insights.totalExpent) * 100)
                                          .toInt(),
                                  category: el.category,
                                  onTap: () {
                                    if (el.category.id == null) return;
                                    bloc.add(
                                        widget.getByCategory(el.category.id!));
                                  },
                                ))
                            .toList(),
                      );
                    }

                    if (state.insight.insightsBySubcategory.isNotEmpty) {
                      return Column(
                        children: state.insight.insightsBySubcategory!
                            .map((el) => CategoryItemInsight(
                                  value: el.value,
                                  percentage:
                                      ((el.value / state.insight.totalExpent) *
                                              100)
                                          .toInt(),
                                  subcategory: el.subcategory,
                                  onTap: () {},
                                ))
                            .toList(),
                      );
                    }
                  }

                  return SizedBox.shrink();
                },
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          BlocBuilder<InsightsBloc, InsightsState>(
            builder: (context, state) {
              if (state is LoadedInsights) {
                bool isIncomeTab = widget.tabEnum == state.tabEnum && widget.tabEnum == InsightTabEnum.INCOME;
                return MyLineChart(
                  text: widget.lineChartText,
                  lineColor: Colors.red,
                  minX: 0,
                  minY: _getLineChartMinValue(
                      isIncomeTab ? bloc.incomesLineChartData.minValue : bloc.expensesLineChartData.minValue),
                  maxX: 11,
                  maxY: _getLineChartMaxValue(
                      isIncomeTab ? bloc.incomesLineChartData.maxValue : bloc.expensesLineChartData.maxValue),
                  spots: _getLineSpots( isIncomeTab
                      ? bloc.incomesLineChartData
                      : bloc.expensesLineChartData),
                );
              }
              return CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }
}
