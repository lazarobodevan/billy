import 'package:billy/models/insight/period_filter.dart';
import 'package:intl/intl.dart';

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


  static String formatDateRange(DateTime begin, DateTime end) {
    // Formatos de data
    final fullDateFormat = DateFormat('d, MMM/yy');
    final monthYearFormat = DateFormat('MMM/yy');
    final dayMonthFormat = DateFormat('d/MMM');

    // Caso as datas sejam no mesmo dia
    if (begin.isAtSameMomentAs(end)) {
      return fullDateFormat.format(begin);
    }

    // Caso as datas sejam o primeiro e o último dia do mesmo mês
    if (begin.year == end.year && begin.month == end.month &&
        begin.day == 1 && end.day == DateTime(end.year, end.month + 1, 0).day) {
      return monthYearFormat.format(begin); // Exibe apenas o mês e o ano
    }

    // Caso as datas sejam o primeiro dia de um mês e o último dia de outro mês
    if (begin.day == 1 && end.day == DateTime(end.year, end.month + 1, 0).day) {
      return "${monthYearFormat.format(begin)} - ${monthYearFormat.format(end)}"; // Exibe mês, ano - mês, ano
    }

    // Caso as datas sejam no mesmo mês e ano, mas não primeiro e último dia
    if (begin.year == end.year && begin.month == end.month) {
      return "${fullDateFormat.format(begin)} - ${dayMonthFormat.format(end)}";
    }

    // Caso a diferença de meses seja menor que 12 meses
    if (begin.year == end.year || (end.year - begin.year == 1 && end.month < begin.month)) {
      return "${fullDateFormat.format(begin)} - ${fullDateFormat.format(end)}";
    }

    // Caso os meses redondos sejam de diferentes anos
    if ((end.year - begin.year == 1) && begin.month == end.month) {
      return "${monthYearFormat.format(begin)} - ${monthYearFormat.format(end)}";
    }

    // Caso a diferença seja entre meses
    return "${dayMonthFormat.format(begin)} - ${dayMonthFormat.format(end)}";
  }


}