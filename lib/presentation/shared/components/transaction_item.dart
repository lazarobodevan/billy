import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
        color: ThemeColors.primary3,
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1,
          ),
        ),
        borderRadius: BorderRadius.circular(50)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: ThemeColors.secondary1,
                borderRadius: BorderRadius.circular(50)
              ),
              child: Icon(Icons.star_border_outlined, color: ThemeColors.primary3,),
            ),
            const SizedBox(width: 5,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Padaria do seu zé", style: TypographyStyles.label3(),),
                Text("Seg, 10/05", style: TypographyStyles.paragraph3().copyWith(color: Colors.black38),)
              ],
            )
          ],
        ),
      ),
    );
  }
}
