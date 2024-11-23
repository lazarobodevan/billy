import 'package:billy/models/insight/my_line_chart_spots.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyLineChart extends StatelessWidget {
  final String text;
  final Color lineColor;
  final Gradient? belowChartColor;
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;
  final Function? getXLabels;
  final List<MyLineChartSpots>? spots;

  const MyLineChart(
      {super.key,
      required this.text,
      required this.lineColor,
      this.belowChartColor,
      required this.minX,
      required this.minY,
      required this.maxX,
      required this.maxY,
      this.getXLabels,
      this.spots});

  String formatToAbbreviation(num value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1).replaceAll('.0', '')}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1).replaceAll('.0', '')}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: TypographyStyles.label1(),
        ),
        const SizedBox(
          height: 20,
        ),
        spots != null && spots!.isNotEmpty
            ? Container(
                height: 200,
                child: LineChart(
                  LineChartData(
                      minX: minX,
                      maxX: maxX,
                      minY: minY,
                      maxY: maxY,
                      baselineY: minY,
                      lineTouchData:
                          LineTouchData(touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (List<LineBarSpot> touchedSpots) {
                          return touchedSpots.map((LineBarSpot touchedSpot) {
                            return LineTooltipItem(
                              '${touchedSpot.y}',
                              const TextStyle(
                                color: Colors.white, // Cor do texto do tooltip
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList();
                        },
                      )),
                      titlesData: FlTitlesData(
                        show: true,
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value == meta.max) {
                                  return const Text('');
                                } else if (value == meta.min) {
                                  return const Text('');
                                }
                                return Text(formatToAbbreviation(value));
                              }),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: false,
                          ),
                        ),
                        bottomTitles: const AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1,
                              getTitlesWidget: bottomTitleWidgets),
                        ),
                      ),
                      gridData: const FlGridData(
                        show: true,
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: spots!
                          .map((el) => LineChartBarData(
                              isCurved: true,
                              barWidth: 3,
                              color: el.lineColor,
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: belowChartColor ??
                                    const LinearGradient(
                                        begin: Alignment(0, 1),
                                        colors: [
                                          Colors.transparent,
                                          Colors.transparent
                                        ]),
                              ),
                              spots: el.spots))
                          .toList()),
                ),
              )
            : const AspectRatio(
                aspectRatio: 2,
                child: Center(
                  child: Text("Sem registros suficientes"),
                )),
      ],
    );
  }
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  var style = TypographyStyles.paragraph4();
  Widget text;
  switch (value.toInt()) {
    case 0:
      text = Text('J', style: style);
      break;
    case 1:
      text = Text('F', style: style);
      break;
    case 2:
      text = Text('M', style: style);
      break;
    case 3:
      text = Text('A', style: style);
      break;
    case 4:
      text = Text('M', style: style);
      break;
    case 5:
      text = Text('J', style: style);
      break;
    case 6:
      text = Text('J', style: style);
      break;
    case 7:
      text = Text('A', style: style);
      break;
    case 8:
      text = Text('S', style: style);
      break;
    case 9:
      text = Text('O', style: style);
      break;
    case 10:
      text = Text('N', style: style);
      break;
    case 11:
      text = Text('D', style: style);
      break;
    default:
      text = Text('-', style: style);
      break;
  }
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}
