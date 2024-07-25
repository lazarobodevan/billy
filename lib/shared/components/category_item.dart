import 'package:billy/theme/colors.dart';
import 'package:billy/theme/typography.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ThemeColors.primary3,
        boxShadow: [BoxShadow(color: Colors.black12, offset: Offset(0,0), blurRadius: 6)]
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: ThemeColors.secondary1
              ),
              child: Center(
                child: Icon(Icons.star_border_outlined, color: Colors.white, size: 24,),
              ),
            ),
            const SizedBox(height: 16,),
            Text("Alimentação", style: TypographyStyles.paragraph3(),)
          ],
        ),
      ),
    );
  }
}
