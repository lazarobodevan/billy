import 'package:billy/theme/colors.dart';
import 'package:billy/theme/typography.dart';
import 'package:flutter/material.dart';

class DigitButton extends StatelessWidget {
  final String number;
  final Function onTap;

  const DigitButton({super.key, required this.number, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Ink(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: ThemeColors.primary2),
          child: Center(
            child: Text(
              number,
              style: TypographyStyles.label1().copyWith(
                color: ThemeColors.primary1,
                fontSize: 26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
