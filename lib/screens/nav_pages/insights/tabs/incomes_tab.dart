import 'dart:ui';

import 'package:billy/screens/nav_pages/insights/components/line_chart/my_line_chart.dart';
import 'package:billy/shared/components/indicator.dart';
import 'package:billy/shared/components/toggle_time.dart';
import 'package:billy/theme/colors.dart';
import 'package:billy/theme/typography.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class IncomesTab extends StatelessWidget {
  const IncomesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      controller: ScrollController(),
      child: Column(
        children: [
          Column(
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("Ganho em "),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text("Abril")
                                ],
                              ),
                              Text(
                                "R\$9.999,99",
                                style: TypographyStyles.headline3(),
                              )
                            ],
                          ),
                          PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  color: Colors.blue,
                                  value: 15,
                                  title: '15%',
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  color: Colors.yellow,
                                  value: 30,
                                  title: '30%',
                                  radius: 50,
                                ),
                                PieChartSectionData(
                                  color: Colors.red,
                                  value: 40,
                                  title: '40%',
                                  radius: 50,
                                )
                              ],
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
                height: 10,
              ),
              Container(
                height: 100,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: ThemeColors.primary3,
                    borderRadius: BorderRadius.circular(15)),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    runSpacing: 8,
                    children: [
                      Indicator(
                        color: Colors.blue,
                        text: 'First',
                        isSquare: true,
                      ),
                      Indicator(
                        color: Colors.yellow,
                        text: 'Second',
                        isSquare: true,
                      ),
                      Indicator(
                        color: Colors.red,
                        text: 'Third',
                        isSquare: true,
                      ),
                      Indicator(
                        color: Colors.red,
                        text: 'Third',
                        isSquare: true,
                      ),
                      Indicator(
                        color: Colors.red,
                        text: 'Third',
                        isSquare: true,
                      ),
                      Indicator(
                        color: Colors.red,
                        text: 'Third',
                        isSquare: true,
                      ),
                      Indicator(
                        color: Colors.red,
                        text: 'Third',
                        isSquare: true,
                      ),
                    ],
                  ),
                ),
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
              padding: const EdgeInsets.all(16),
              child: MyLineChart(
                  text: "Ganho por mês",
                  lineColor: Colors.red,
                  minX: 0,
                  minY: 1500,
                  maxX: 11,
                  maxY: 4500),
            ),
          )
        ],
      ),
    );
  }
}
