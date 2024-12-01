import 'package:billy/enums/limit/limit_type.dart';
import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/category/transaction_category.dart';
import 'package:billy/models/limit/limit_model.dart';
import 'package:billy/models/subcategory/subcategory.dart';
import 'package:billy/presentation/screens/limits/limit_editor/widgets/limit_picker/limit_picker.dart';
import 'package:billy/presentation/shared/components/date_picker.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/services/toast_service/toast_service.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/limits_bloc.dart';

class LimitEditorScreen extends StatefulWidget {
  final LimitModel? limitModel;

  const LimitEditorScreen({super.key, this.limitModel});

  @override
  State<LimitEditorScreen> createState() => _LimitEditorScreenState();
}

class _LimitEditorScreenState extends State<LimitEditorScreen> {
  CurrencyTextInputFormatter maxValueFormatter =
      CurrencyTextInputFormatter.currency(
          minValue: 0, decimalDigits: 2, symbol: "R\$", enableNegative: false);

  late LimitModel limitModel;

  onChanged(LimitType limitType, int id) {
    if (limitType == LimitType.CATEGORY) {
      limitModel = limitModel.copyWith(
          category: TransactionCategory.empty().copyWith(id: id));
    } else if (limitType == LimitType.SUBCATEGORY) {
      limitModel = limitModel.copyWith(
          subcategory: Subcategory.empty().copyWith(id: id));
    } else if (limitType == LimitType.TRANSACTION_TYPE) {
      limitModel = limitModel.copyWith(
          transactionType: TransactionTypeExtension.fromIndex(id));
    } else if (limitType == LimitType.PAYMENT_METHOD) {
      limitModel = limitModel.copyWith(
          paymentMethod: PaymentMethodExtension.fromIndex(id));
    }
  }

  onSave() {
    if (widget.limitModel == null) {
      BlocProvider.of<LimitsBloc>(context)
          .add(CreateLimitEvent(limit: limitModel));
    } else {
      BlocProvider.of<LimitsBloc>(context)
          .add(UpdateLimitEvent(limit: limitModel));
    }
  }

  onDelete() {
    BlocProvider.of<LimitsBloc>(context)
        .add(DeleteLimitEvent(id: widget.limitModel!.id!));
  }

  @override
  void initState() {
    if (widget.limitModel != null) {
      setState(() {
        limitModel = widget.limitModel!;
      });
    } else {
      limitModel = LimitModel.empty();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LimitsBloc, LimitsState>(
      listener: (context, state) {

        if(state is CreatedLimitState || state is DeletedLimitState || state is UpdatedLimitState){
          Navigator.of(context).pop();
        }

        if (state is CreateLimitErrorState) {
          ToastService.showError(message: state.message);
        }

        if(state is DeleteLimitErrorState){
          ToastService.showError(message: state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [

            //DELETE
            if (widget.limitModel != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  onTap: onDelete,
                  borderRadius: BorderRadius.circular(50),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.delete,
                        color: ThemeColors.semanticRed,
                        size: 28,
                      ),
                    ),
                  ),
                ),
              ),

            //CREATE OR UPDATE
            Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: onSave,
                borderRadius: BorderRadius.circular(50),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LimitPicker(
                  onChanged: onChanged,
                  limitModel: limitModel,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  initialValue:
                      maxValueFormatter.formatDouble(limitModel.currentValue),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    limitModel = limitModel.copyWith(
                        maxValue: maxValueFormatter.getDouble());
                  },
                  decoration: InputDecoration(
                    labelText: "Valor máximo",
                  ),
                  inputFormatters: [maxValueFormatter],
                ),
                const SizedBox(
                  height: 26,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: DatePicker(
                          label: "Data de início",
                          initialDate: limitModel.beginDate,
                          onSelect: (val) {
                            limitModel = limitModel.copyWith(beginDate: val);
                          }),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Flexible(
                      child: DatePicker(
                          label: "Data de fim",
                          initialDate: limitModel.endDate,
                          onSelect: (val) {
                            limitModel = limitModel.copyWith(endDate: val);
                          }),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Column(
                  children: [
                    Text(
                      'Recorrente?',
                      style: TypographyStyles.label3(),
                    ),
                    Switch(
                      value: limitModel.recurrent ?? false,
                      onChanged: (val) {
                        setState(() {
                          limitModel = limitModel.copyWith(recurrent: val);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
