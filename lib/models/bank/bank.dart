import 'package:billy/enums/bank/bank_type.dart';

class Bank {
  final String name;
  final BankType bankType;
  final String imagePath;

  Bank({required this.name, required this.bankType, required this.imagePath});
}
