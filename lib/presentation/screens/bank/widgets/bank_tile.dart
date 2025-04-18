import 'package:billy/presentation/screens/bank/screens/add_mass_transactions/add_mass_transactions.dart';
import 'package:billy/presentation/theme/typography.dart';

import 'package:flutter/material.dart';

import '../../../../models/bank/bank.dart';

class BankTile extends StatelessWidget {
  final Bank bank;

  const BankTile({super.key, required this.bank});

  void showScanOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          "Tipo de documento",
          style: TypographyStyles.label1(),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddMassTransactions(
                    bankType: bank.bankType,
                    isInvoice: false,
                  ),
                ),
              );
            },
            child: Text("Extrato"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddMassTransactions(
                    bankType: bank.bankType,
                    isInvoice: true,
                  ),
                ),
              );
            },
            child: Text("Fatura"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        showScanOptions(context);
      },
      child: Ink(
        width: 100,
        height: 100,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                spreadRadius: 2,
              )
            ],
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              bank.imagePath,
              height: 40,
            ),
            Text(
              bank.name,
              style: TypographyStyles.label3(),
            )
          ],
        ),
      ),
    );
  }
}
