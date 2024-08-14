import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  DateTime? initialDate;
  String? label;
  Function onSelect;

  DatePicker({this.label, this.initialDate, required this.onSelect, super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final formatter = new DateFormat('dd/MM/yyyy');
  DateTime _dateTime = DateTime.now();

  void _showDatePicker() {
    showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    ).then((value){
      setState(() {
        _dateTime = value!;
        widget.onSelect(_dateTime);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.label != null)
          Text(widget.label!, style: TypographyStyles.label2(),),
        InkWell(
          onTap: () {
            _showDatePicker();
          },
          child: Ink(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: ThemeColors.primary1, width: 1),
              borderRadius: BorderRadius.circular(16)
            ),
            child: Center(
              child: Text(widget.initialDate != null
                  ? formatter.format(widget.initialDate!)
                  : formatter.format(_dateTime), style: TypographyStyles.paragraph3(),),
            ),
          ),
        ),
      ],
    );
  }
}
