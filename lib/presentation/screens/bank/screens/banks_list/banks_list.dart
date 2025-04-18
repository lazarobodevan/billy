import 'package:billy/presentation/screens/bank/widgets/bank_tile.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/material.dart';

import '../../data/banks_data.dart';

class BanksList extends StatelessWidget {
  const BanksList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bancos",
          style: TypographyStyles.headline3(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runAlignment: WrapAlignment.center,
          direction: Axis.horizontal,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: getBanksData().map((el) {
            return BankTile(
              bank: el,
            );
          }).toList(),
        ),
      ),
    );
  }
}
