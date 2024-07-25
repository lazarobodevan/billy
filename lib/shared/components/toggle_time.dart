import 'package:billy/theme/typography.dart';
import 'package:flutter/material.dart';

class ToggleTime extends StatefulWidget {
  const ToggleTime({super.key});

  @override
  State<ToggleTime> createState() => _ToggleTimeState();
}

class _ToggleTimeState extends State<ToggleTime> {
  var selected = 1;

  void setSelected(int index) {
    setState(() {
      selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          // Arrastou para a direita
          setSelected((selected + 1) % 3); // Aumenta e mantém no intervalo 0-2
        } else if (details.velocity.pixelsPerSecond.dx < 0) {
          // Arrastou para a esquerda
          setSelected(
              (selected - 1 + 3) % 3); // Diminui e mantém no intervalo 0-2
        }
      },
      child: Container(
        height: 40,
        width: 300,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setSelected(0);
              },
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 100),
                style: selected == 0
                    ? TypographyStyles.label1().copyWith(color: Colors.black)
                    : TypographyStyles.paragraph4().copyWith(color: Colors.grey),
                child: const Text("Semana"),
              ),
            ),
            const SizedBox(width: 10,),
            GestureDetector(
              onTap: () {
                setSelected(1);
              },
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 100),
                style: selected == 1
                    ? TypographyStyles.label1().copyWith(color: Colors.black)
                    : TypographyStyles.paragraph4().copyWith(color: Colors.grey),
                child: const Text("Mês"),
              ),
            ),
            const SizedBox(width: 10,),
            GestureDetector(
              onTap: () {
                setSelected(2);
              },
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 100),
                style: selected == 2
                    ? TypographyStyles.label1().copyWith(color: Colors.black)
                    : TypographyStyles.paragraph4().copyWith(color: Colors.grey),
                child: const Text("Ano"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
