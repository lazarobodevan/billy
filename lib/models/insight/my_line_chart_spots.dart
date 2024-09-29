import 'dart:ui';

import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:fl_chart/fl_chart.dart';

class MyLineChartSpots {
  List<FlSpot> spots;
  TransactionType transactionType;
  Color lineColor;

  MyLineChartSpots(
      {required this.spots,
      required this.lineColor,
      required this.transactionType});
}
