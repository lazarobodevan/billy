import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

List<PieChartSectionData> getPieChartMockedData(){
  return [
    PieChartSectionData(
      color: Colors.yellow,
      value: 25,
      title: "25%",
    ),
    PieChartSectionData(
      color: Colors.blue,
      value: 40,
      title: "40%",
    ),
    PieChartSectionData(
      color: Colors.orange,
      value: 5,
      title: "5%",
    ),
    PieChartSectionData(
      color: Colors.red,
      value: 30,
      title: "30%",
    )
  ];
}