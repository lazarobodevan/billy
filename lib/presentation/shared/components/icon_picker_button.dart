import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class IconPickerButton extends StatefulWidget {
  final Function onChangedIcon;
  final IconData? initialIcon;

  const IconPickerButton({super.key, required this.onChangedIcon, this.initialIcon});

  @override
  State<IconPickerButton> createState() => _IconPickerButtonState();
}

class _IconPickerButtonState extends State<IconPickerButton> {
  IconData? currentIconData;

  @override
  void initState() {
    if(widget.initialIcon != null){
      currentIconData = widget.initialIcon;
    }
    super.initState();
  }

  void onCofirmIcon(IconData iconData) {
    setState(() {
      currentIconData = iconData;
      widget.onChangedIcon(currentIconData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showColorPickerDialog(context, onCofirmIcon,
            prevPickedIcon: currentIconData);
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
                  child: currentIconData != null
                      ? Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: ThemeColors.primary1,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                color: ThemeColors.primary3, width: 2),
                          ),
                          child: Center(
                              child: Icon(
                            currentIconData,
                            color: ThemeColors.primary3,
                          )),
                        )
                      : const Icon(
                          Icons.insert_emoticon,
                          color: ThemeColors.primary3,
                        ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Ícone",
                  style: TypographyStyles.label2()
                      .copyWith(color: ThemeColors.primary3),
                ),
              )
            ],
          )),
    );
  }
}

void _showColorPickerDialog(BuildContext context, Function onConfirm,
    {IconData? prevPickedIcon}) async {

  IconData? icon = await showIconPicker(context,
      adaptiveDialog: true,
      showTooltips: true,
      showSearchBar: true,
      iconPickerShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      searchComparator: (String search, IconPickerIcon icon) =>
          search
              .toLowerCase()
              .contains(icon.name.replaceAll('_', ' ').toLowerCase()) ||
          icon.name.toLowerCase().contains(search.toLowerCase()),
      iconPackModes: [IconPack.fontAwesomeIcons]);

  onConfirm(icon ?? prevPickedIcon);
}
