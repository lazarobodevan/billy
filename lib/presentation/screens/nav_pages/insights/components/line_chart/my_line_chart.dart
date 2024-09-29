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
  final List<FlSpot>? spots;

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TypographyStyles.label1(),
        ),
        const SizedBox(
          height: 20,
        ),
        spots != null && spots!.isNotEmpty ? Container(
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
                      TextStyle(
                        color: Colors.white, // Cor do texto do tooltip
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              )),
              titlesData: const FlTitlesData(
                  show: true,
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false, )),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: bottomTitleWidgets))),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  barWidth: 3,
                  color: Colors.red,
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: belowChartColor ??
                        const LinearGradient(
                          begin: Alignment(0, 1),
                          colors: [Colors.transparent, Colors.transparent],
                        ),
                  ),
                  spots: spots ?? []
                ),
              ],
            ),
          ),
        ): AspectRatio(aspectRatio:2, child: Center(child: Text("Sem registros suficientes"),)),
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
