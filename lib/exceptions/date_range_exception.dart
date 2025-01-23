
class DateRangeException implements Exception{

  @override
  String toString() {
    return 'A data de início não deve ser depois da data de fim';
  }

}