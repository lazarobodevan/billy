import 'package:billy/enums/bank/bank_type.dart';
import 'package:billy/models/bank/bank.dart';

List<Bank> getBanksData() {
  List<Bank> banksData =  [
    Bank(
      name: "Sicoob",
      bankType: BankType.SICOOB,
      imagePath: "assets/banks_logos/sicoob.png",
    ),
  ];
  banksData.sort((a,b) => a.name.compareTo(b.name));

  return banksData;
}
