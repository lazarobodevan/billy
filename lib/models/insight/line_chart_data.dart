class MyLineChartData {
  double minValue;
  double maxValue;
  Map<int, double> values;

  MyLineChartData(
      {required this.minValue, required this.maxValue, required this.values});

  MyLineChartData.empty(
      {this.minValue = 0, this.maxValue = 0, Map<int, double>? values})
      : values = {};
}
