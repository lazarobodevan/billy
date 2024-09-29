import 'package:billy/models/insight/period_filter.dart';

class MyDateUtils{
  static getFirstDayOfMonth(){
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  static getLastDayOfMonth(){
    DateTime now = DateTime.now();
    DateTime firstDayNextMonth = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 1)  // Primeiro dia do próximo mês
        : DateTime(now.year + 1, 1, 1);  // Se for dezembro, vai para janeiro do próximo ano
    return firstDayNextMonth.subtract(const Duration(days: 1));
  }
}