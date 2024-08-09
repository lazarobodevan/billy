import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerButton extends StatefulWidget {
  final Function onColorChanged;
  final Color? initalColor;
  const ColorPickerButton({super.key, required this.onColorChanged, this.initalColor});

  @override
  State<ColorPickerButton> createState() => _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  Color? currentColor;
  bool isColorSelected = false;

  @override
  void initState() {
    if(widget.initalColor != null){
      currentColor = widget.initalColor;
      isColorSelected = true;
    }
    super.initState();
  }

  void onCofirmColor(Color color) {
    setState(() {
      currentColor = color;
      isColorSelected = true;
      widget.onColorChanged(currentColor);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showColorPickerDialog(context, onCofirmColor, prevPickedColor: currentColor);
      },
      child: Ink(
          height: 50,
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: ThemeColors.primary1,
              borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: isColorSelected == true
                      ? Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: currentColor,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: ThemeColors.primary3, width: 2),
                          ),
                        )
                      : const Icon(
                          Icons.color_lens_outlined,
                          color: ThemeColors.primary3,
                        ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Cor",
                  style: TypographyStyles.label2()
                      .copyWith(color: ThemeColors.primary3),
                ),
              )
            ],
          )),
    );
  }
}

void _showColorPickerDialog(BuildContext context, Function onConfirm, {Color? prevPickedColor}) {
  Color pickerColor = prevPickedColor ?? Color(0xff443a49);
  Color? currentColor;

  showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: pickerColor,
          onColorChanged: (Color color) {
            currentColor = color;
          },
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Cancelar")),
        TextButton(onPressed: (){
          onConfirm(currentColor ?? prevPickedColor);
          Navigator.of(context).pop();
        }, child: Text("Confirmar"))
      ],
    );
  });
}
