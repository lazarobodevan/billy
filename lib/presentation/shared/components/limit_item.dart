import 'package:billy/models/limit/limit_model.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:flutter/material.dart';

import '../../screens/nav_pages/more/screens/limits/limit_editor/limit_editor_screen.dart';

class LimitItem extends StatelessWidget {
  final LimitModel limit;

  const LimitItem({super.key, required this.limit});

  double _getPercentage() {
    return ((limit.currentValue * 100) / limit.maxValue);
  }

  Color _getSemanticColor() {
    var percentage = _getPercentage();
    if (percentage >= 0 && percentage <= 50) {
      return ThemeColors.semanticGreen;
    }
    if (percentage > 50 && percentage <= 80) {
      return ThemeColors.semanticYellow;
    }
    return ThemeColors.semanticRed;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LimitEditorScreen(
              limitModel: limit,
            ),
          ),
        );
      },
      child: Ink(
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: ThemeColors.primary1.withOpacity(.3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(limit.limitTargetName),
                  Row(
                    children: [
                      Text(
                        'R\$${(limit.maxValue - limit.currentValue).toStringAsFixed(2)}',
                      ),
                      const SizedBox(width: 10),
                      Text('${_getPercentage().toStringAsFixed(0)}%'),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 4),
              Stack(
                children: [
                  Container(
                    height: 4,
                    color: Colors.grey.shade200,
                  ),
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: _getPercentage()),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) {
                      return Container(
                        height: 4,
                        width: MediaQuery.of(context).size.width * (value / 100),
                        color: _getSemanticColor(),
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
