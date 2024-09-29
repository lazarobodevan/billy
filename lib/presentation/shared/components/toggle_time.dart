import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

class ToggleTime extends StatefulWidget {
  
  final DatePeriod? selectedDate;
  final ValueChanged<DatePeriod> onSelect;
  
  const ToggleTime({super.key, this.selectedDate, required this.onSelect});

  @override
  State<ToggleTime> createState() => _ToggleTimeState();
}

class _ToggleTimeState extends State<ToggleTime> {

  late DatePeriod _selectedDate;

  @override
  void initState() {
    _selectedDate = widget.selectedDate ?? DatePeriod(MyDateUtils.getFirstDayOfMonth(), MyDateUtils.getLastDayOfMonth());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: ()async{
          final result = await showDateRangePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime.now().add(const Duration(days: 365)));
      
          if(result != null){
            setState(() {
              _selectedDate = DatePeriod(result.start, result.end);
              widget.onSelect(_selectedDate);
            });
          }
        },
        child: Ink(
          width: 150,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(color: ThemeColors.primary1, width: 1),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(MyDateUtils.formatDateRange(_selectedDate.start, _selectedDate.end),style: TypographyStyles.paragraph4(),),
          ) ,
        ),
      ),
    );
  }
}
