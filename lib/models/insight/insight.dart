import 'dart:convert';
import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/models/insight/category_insight.dart';
import 'package:billy/models/insight/line_chart_data.dart';
import 'package:billy/models/insight/subcategory_insight.dart';
import 'package:billy/models/subcategory/subcategory.dart';
import 'package:billy/utils/color_converter.dart';
import 'package:billy/utils/icon_converter.dart';

class Insight {
  double totalExpent;
  List<CategoryInsight> insightsByCategory;
  List<SubcategoryInsight>? insightsBySubcategory;
  MyLineChartData lineChartData;

  Insight(
      {required this.totalExpent,
      required this.insightsByCategory,
      required this.lineChartData});

  Insight.empty(
      {this.totalExpent = 0,
      List<CategoryInsight>? insightsByCategory,
      MyLineChartData? lineChartData})
      : insightsByCategory = [],
        lineChartData = MyLineChartData.empty();

  static Insight fromMap(List<Map<String, dynamic>> listMap) {
    var insight = Insight.empty();
    listMap.forEach((el) {
      insight.totalExpent += (el["total_value"] as num).toDouble();
      insight.insightsByCategory.add(CategoryInsight(
          category: TransactionCategory(
              id: el['group_id'],
              name: el['group_name'],
              color:
                  ColorConverter.intToColor((el['group_color'] as num).toInt()),
              icon:
                  IconConverter.parseIconFromDb(jsonDecode(el['group_icon']))),
          value: (el['total_value'] as num).toDouble()));
    });

    return insight;
  }

  static Insight fromMapSubcategory(List<Map<String, dynamic>> listMap) {
    var insight = Insight.empty();
    listMap.forEach((el) {
      insight.totalExpent += (el["total_value"] as num).toDouble();
      insight.insightsBySubcategory!.add(
        SubcategoryInsight(
          subcategory: Subcategory(
            parentId: el["group_id"],
            name: el["group_name"],
            color: el["group_color"],
            icon: IconConverter.parseIconFromDb(jsonDecode(el['group_icon'])),
          ),
          value: (el["group_value"] as num).toDouble(),
        ),
      );
    });

    return insight;
  }

  double calculateTotalValue(List<Map<String, dynamic>> listMap) {
    double totalValue = 0;

    listMap.forEach((el) {
      totalValue += (el["total_value"] as num).toDouble();
    });

    return totalValue;
  }
}
