import 'package:billy/models/insight/my_line_chart_spots.dart';

class MyLineChartData {
  double minValue;
  double maxValue;
  List<MyLineChartSpots> spots;

  MyLineChartData(
      {required this.minValue,
      required this.maxValue,
      required this.spots});

  MyLineChartData.empty(
      {this.minValue = 0,
      this.maxValue = 0,
      Map<int, double>? values,
      List<MyLineChartSpots>? spots})
      :  spots = [];
}
