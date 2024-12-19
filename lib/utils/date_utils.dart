import 'package:billy/models/insight/period_filter.dart';
import 'package:intl/intl.dart';

class MyDateUtils {
  static DateTime getFirstDayOfMonth() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  static DateTime getLastDayOfMonth() {
    DateTime now = DateTime.now().toLocal();
    DateTime firstDayNextMonth = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 1) // Primeiro dia do próximo mês
        : DateTime(now.year + 1, 1,
            1); // Se for dezembro, vai para janeiro do próximo ano

    DateTime lastDayOfMonth =
        firstDayNextMonth.subtract(const Duration(days: 1));

    return DateTime(
      lastDayOfMonth.year,
      lastDayOfMonth.month,
      lastDayOfMonth.day,
      23,
      // hora
      59,
      // minuto
      59,
      // segundo
      999, // milissegundo
    );
  }

  static String formatDateRange(DateTime begin, DateTime end) {
    final fullDateFormat = DateFormat('d, MMM/yy');
    final monthYearFormat = DateFormat('MMM/yy');
    final dayMonthFormat = DateFormat('d/MMM');

    bool isLastDayOfMonth(DateTime date) {
      return date.day == DateTime(date.year, date.month + 1, 0).day;
    }

    if (begin.isAtSameMomentAs(end)) {
      return fullDateFormat.format(begin);
    }

    if (begin.year == end.year && begin.month == end.month) {
      if (begin.day == 1 && isLastDayOfMonth(end)) {
        return monthYearFormat.format(begin);
      }
      return "${fullDateFormat.format(begin)} - ${dayMonthFormat.format(end)}";
    }

    if (begin.day == 1 && isLastDayOfMonth(end)) {
      return "${monthYearFormat.format(begin)} - ${monthYearFormat.format(end)}";
    }

    return "${fullDateFormat.format(begin)} - ${fullDateFormat.format(end)}";
  }

  static bool isDateBetween(
      {required DateTime targetDate,
      required DateTime startDate,
      required DateTime endDate}) {

    // Remove a hora das datas
    DateTime target =
        DateTime(targetDate.year, targetDate.month, targetDate.day);
    DateTime start = DateTime(startDate.year, startDate.month, startDate.day);
    DateTime end = DateTime(endDate.year, endDate.month, endDate.day);

    // Verifica se a data alvo está entre a data inicial e a data final (inclusive)
    return target.isAfter(start) && target.isBefore(end) ||
        target == start ||
        target == end;
  }

  static bool isSameDate(DateTime date1, DateTime date2) {
    // Ignora a parte da hora, minuto, segundo e milissegundo
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
