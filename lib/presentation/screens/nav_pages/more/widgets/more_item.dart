import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/material.dart';

class MoreItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onClick;

  const MoreItem(
      {super.key,
      required this.text,
      required this.icon,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {onClick();},
      child: Ink(
        height: 40,
        decoration: BoxDecoration(
            border: Border(
                bottom:
                    BorderSide(color: ThemeColors.primary1.withOpacity(.2)))),
        child: Row(
          children: [
            Icon(
              icon,
              size: 26,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              text,
              style: TypographyStyles.label2(),
            )
          ],
        ),
      ),
    );
  }
}
