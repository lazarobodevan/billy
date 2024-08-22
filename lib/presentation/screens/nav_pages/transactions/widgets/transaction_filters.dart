import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/models/transaction/transaction_model.dart';
import 'package:billy/presentation/shared/components/date_picker.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/transactions_bloc.dart';

class TransactionFilters extends StatefulWidget {
  const TransactionFilters({super.key});

  @override
  State<TransactionFilters> createState() => _TransactionFiltersState();
}

class _TransactionFiltersState extends State<TransactionFilters> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
          icon: const Icon(Icons.filter_alt),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.maxFinite,
          height: _isVisible ? 100.0 : 0.0,
          child: _isVisible
              ? SingleChildScrollView(child: _buildFilters(context))
              : null,
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      builder: (context, state) {
        return Container(
          color: Colors.grey[200],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildPeriodsFilter(context)
            ],
          ),
        );
      },
    );
  }

  Widget _buildPeriodsFilter(BuildContext context){
    DateTime? beginDate;
    DateTime? endDate;

    return Flexible(
      child: Material(
        color: ThemeColors.primary2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: DatePicker(onSelect: (val){}, label: "Data")),
            const SizedBox(width: 20,),
            Expanded(child: DatePicker(onSelect: (val){}, label: "Vencimento",))
          ],
        ),
      ),
    );
  }
}
