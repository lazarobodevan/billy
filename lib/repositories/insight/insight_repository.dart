import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/insight/insight.dart';
import 'package:billy/models/insight/line_chart_data.dart';
import 'package:billy/models/insight/my_line_chart_spots.dart';
import 'package:billy/models/insight/period_filter.dart';
import 'package:billy/repositories/database_helper.dart';
import 'package:billy/repositories/insight/i_insight_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class InsightRepository extends IInsightRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  Future<Insight> getInsights(
      {TransactionType? type = TransactionType.EXPENSE,
      required PeriodFilter periodFilter,
      bool? groupByCategory = true,
      int? categoryId}) async {
    final db = await _databaseHelper.database;

    final String query = groupByCategory!
        ? '''
        -- Agrupamento por categoria
        SELECT 
          categories.id as group_id,
          categories.name as group_name,
          categories.color as group_color,
          categories.icon as group_icon,
          SUM(transactions.value) as total_value
        FROM transactions
        LEFT JOIN categories ON transactions.category_id = categories.id
        LEFT JOIN subcategories ON transactions.subcategory_id = subcategories.id
        WHERE transactions.type_id = ${TransactionTypeExtension.toDatabase(type!)}
        AND transactions.date >= ?
        AND transactions.date <= ?
        GROUP BY categories.id, categories.name, categories.color, categories.icon
        '''
        : '''
          -- Agrupamento por subcategoria
          SELECT 
            subcategories.category_id as parent_id,
            subcategories.id as group_id,
            subcategories.name as group_name,
            subcategories.color as group_color,
            subcategories.icon as group_icon,
            categories.name as category_name,
            categories.color as category_color,
            SUM(transactions.value) as total_value
        FROM transactions
        LEFT JOIN categories ON transactions.category_id = categories.id
        LEFT JOIN subcategories ON transactions.subcategory_id = subcategories.id
        WHERE transactions.type_id = ${TransactionTypeExtension.toDatabase(type!)}
        AND subcategories.id IS NOT NULL
        AND categories.id = $categoryId  
        AND transactions.date >= ?
        AND transactions.date <= ?
        GROUP BY subcategories.id, subcategories.name, subcategories.color, subcategories.icon, categories.name, categories.color
        
        UNION ALL
        
        -- Transações não especificadas (sem subcategoria)
        SELECT 
            NULL as parent_id,  -- Placeholder para manter o número de colunas
            categories.id as group_id,
            'Unspecified' as group_name,
            categories.color as group_color,
            categories.icon as group_icon,
            categories.name as category_name,  -- Placeholder (valor real da categoria)
            categories.color as category_color,  -- Placeholder para manter o número de colunas
            SUM(transactions.value) - (
                SELECT COALESCE(SUM(t2.value), 0)
                FROM transactions t2
                LEFT JOIN subcategories s2 ON t2.subcategory_id = s2.id
                WHERE t2.category_id = categories.id
                AND t2.subcategory_id IS NOT NULL
            ) as total_value
        FROM transactions
        LEFT JOIN categories ON transactions.category_id = categories.id
        WHERE transactions.type_id = ${TransactionTypeExtension.toDatabase(type!)}
        AND transactions.subcategory_id IS NULL
        AND categories.id = $categoryId
        AND transactions.date >= ?
        AND transactions.date <= ?
        GROUP BY categories.id, categories.color, categories.icon, categories.name;
        ''';

    List<Map<String, Object?>> queryResult;

    if (groupByCategory) {
      queryResult = await db.rawQuery(query, [
        periodFilter.beginDate.toIso8601String(),
        periodFilter.endDate.toIso8601String()
      ]);
      return Insight.fromMap(queryResult);
    } else {
      queryResult = await db.rawQuery(query, [
        periodFilter.beginDate.toIso8601String(),
        periodFilter.endDate.toIso8601String(),
        periodFilter.beginDate.toIso8601String(),
        periodFilter.endDate.toIso8601String()
      ]);
      return Insight.fromMapSubcategory(queryResult);
    }


  }

  @override
  Future<MyLineChartData> getLineChartData(
      {required bool showIncomes, required bool showExpenses}) async {
    var db = await _databaseHelper.database;

    String filterWhere = "";

    if (showIncomes && showExpenses) {
      filterWhere = '''
      WHERE (transactions.type_id = ${TransactionTypeExtension.toDatabase(TransactionType.EXPENSE)} 
      OR transactions.type_id = ${TransactionTypeExtension.toDatabase(TransactionType.INCOME)})''';
    } else if (showIncomes) {
      filterWhere =
          "WHERE transactions.type_id = ${TransactionTypeExtension.toDatabase(TransactionType.INCOME)}";
    } else {
      filterWhere =
          "WHERE transactions.type_id = ${TransactionTypeExtension.toDatabase(TransactionType.EXPENSE)}";
    }

    // Ajustar a query para pegar o intervalo de todo o ano
    String query = '''
      SELECT SUM(transactions.value) as total,
      strftime('%m', transactions.date) AS month,
      transactions.type_id as type
      FROM transactions
      $filterWhere
      AND transactions.date >= ?
      AND transactions.date <= ?
      GROUP BY month
      ORDER BY month
    ''';

    // Definir o intervalo de datas (do início ao fim do ano atual)
    var result = await db.rawQuery(query, [
      DateTime(DateTime.now().year, 1, 1).toIso8601String(), // Início do ano
      DateTime(DateTime.now().year, 12, 31, 23, 59, 59)
          .toIso8601String() // Fim do ano
    ]);

    MyLineChartData data = MyLineChartData(minValue: 0, maxValue: 0, spots: []);

    MyLineChartSpots incomeSpots = MyLineChartSpots(
        spots: [],
        lineColor: Colors.transparent,
        transactionType: TransactionType.INCOME);

    MyLineChartSpots expenseSpots = MyLineChartSpots(
        spots: [],
        lineColor: Colors.transparent,
        transactionType: TransactionType.EXPENSE);

    result.forEach((el) {

      int month = int.parse(el['month'] as String) - 1;
      double total = (el['total'] as num).toDouble();
      if (el['type'] ==
          TransactionTypeExtension.toDatabase(TransactionType.EXPENSE)) {
        expenseSpots.spots.add(FlSpot(month.toDouble(), total));
      } else {
        incomeSpots.spots.add(FlSpot(month.toDouble(), total));
      }

    });

    data.spots = [expenseSpots, incomeSpots];

    double minY = 0;
    double maxY = 0;

    // Encontrar o valor mínimo e máximo nos valores retornados
    data.spots.forEach((line) {
      if (line.spots.isNotEmpty) {
        double lineMinY =
            line.spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
        double lineMaxY =
            line.spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

        // Atualizar os valores mínimos e máximos gerais
        if (lineMinY < minY) minY = lineMinY;
        if (lineMaxY > maxY) maxY = lineMaxY;
      }
    });

    data.minValue = minY;
    data.maxValue = maxY;

    return data;
  }
}
