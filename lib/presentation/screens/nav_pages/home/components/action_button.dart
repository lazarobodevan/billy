import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/material.dart';

class HomeActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;

  const HomeActionButton(
      {super.key, required this.text, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Ink(
        width: double.maxFinite,
        height: 40,
        decoration: BoxDecoration(
            color: ThemeColors.primary1,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TypographyStyles.label3()
                  .copyWith(color: ThemeColors.primary3),
            ),
            const SizedBox(
              width: 5,
            ),
            Icon(
              icon,
              color: ThemeColors.primary3,
            )
          ],
        ),
      ),
    );
  }
}
