import 'dart:math';

import 'package:billy/enums/limit/limit_type.dart';
import 'package:billy/enums/transaction/payment_method.dart';
import 'package:billy/enums/transaction/transaction_type.dart';
import 'package:billy/models/limit/limit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/limit_picker_bloc.dart';

class LimitPicker extends StatefulWidget {
  final LimitModel? limitModel;
  final Function(LimitType, int) onChanged;

  const LimitPicker({super.key, this.limitModel, required this.onChanged});

  @override
  State<LimitPicker> createState() => _LimitPickerState();
}

class _LimitPickerState extends State<LimitPicker> {
  late LimitType? pickedLimitType;
  late int? pickedId;

  List<DropdownMenuItem> getDropdownItems(LimitPickerState state) {
    if (pickedLimitType != null) {
      if (state is ListedCategoriesState &&
          pickedLimitType == LimitType.CATEGORY) {
        return state.categories.map((el) {
          return DropdownMenuItem(
            child: Text(el.name),
            value: el.id,
          );
        }).toList();
      }

      if (state is ListedSubcategoriesState &&
          pickedLimitType == LimitType.SUBCATEGORY) {
        return state.subcategories.map<DropdownMenuItem<int>>((el) {
          return DropdownMenuItem(
            child: Text(el.name),
            value: el.id,
          );
        }).toList();
      }

      if (pickedLimitType == LimitType.PAYMENT_METHOD) {
        return <DropdownMenuItem<int>>[
          DropdownMenuItem(
            child: Text("Cartão de crédito"),
            value: PaymentMethodExtension.toDatabase(PaymentMethod.CREDIT_CARD),
          ),
          DropdownMenuItem(
            child: Text("Pix"),
            value: PaymentMethodExtension.toDatabase(PaymentMethod.PIX),
          ),
          DropdownMenuItem(
            child: Text("Dinheiro"),
            value: PaymentMethodExtension.toDatabase(PaymentMethod.MONEY),
          )
        ];
      }

      if (pickedLimitType == LimitType.TRANSACTION_TYPE) {
        return <DropdownMenuItem<int>>[
          DropdownMenuItem(
            child: Text("Despesa"),
            value: TransactionTypeExtension.toDatabase(TransactionType.EXPENSE),
          ),
          DropdownMenuItem(
            child: Text("Receita"),
            value: TransactionTypeExtension.toDatabase(TransactionType.INCOME),
          ),
        ];
      }
    }
    return <DropdownMenuItem>[];
  }

  int _getPickedId(){
    if(widget.limitModel!.limitType! == LimitType.CATEGORY){
      return widget.limitModel!.category!.id!;
    }
    if(widget.limitModel!.limitType! == LimitType.SUBCATEGORY){
      return widget.limitModel!.subcategory!.id!;
    }
    if(widget.limitModel!.limitType! == LimitType.TRANSACTION_TYPE){
      return widget.limitModel!.transactionType!.index;
    }
    return widget.limitModel!.paymentMethod!.index;

  }

  @override
  void initState() {
    if (widget.limitModel != null && widget.limitModel!.id != null) {
      pickedLimitType = widget.limitModel!.limitType;
      pickedId = _getPickedId();
      if (pickedLimitType != null) {
        switch (pickedLimitType!) {
          case LimitType.CATEGORY:
            // Dispara evento para listar categorias e carrega o ID da primeira categoria como exemplo
            BlocProvider.of<LimitPickerBloc>(context)
                .add(ListCategoriesEvent());
            break;
          case LimitType.SUBCATEGORY:
            // Dispara evento para listar subcategorias
            BlocProvider.of<LimitPickerBloc>(context)
                .add(ListSubcategoriesEvent());
            break;
          case LimitType.PAYMENT_METHOD:
            // Define um valor padrão ou o valor anterior de pickedId relacionado a método de pagamento
            pickedId =
                PaymentMethodExtension.toDatabase(PaymentMethod.CREDIT_CARD);
            break;
          case LimitType.TRANSACTION_TYPE:
            // Define um valor padrão ou o valor anterior de pickedId relacionado a tipo de transação
            pickedId =
                TransactionTypeExtension.toDatabase(TransactionType.EXPENSE);
            break;
        }
      }
    }else{
      pickedLimitType = null;
      pickedId = null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<LimitPickerBloc>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        DropdownButton<LimitType>(
          hint: Text("Escolha o tipo de limite"),
          isExpanded: true,
          value: pickedLimitType,
          onChanged: (value) {
            setState(() {
              pickedLimitType = value;

              if (pickedLimitType == LimitType.CATEGORY) {
                pickedId = null;
                bloc.add(ListCategoriesEvent());
              } else if (pickedLimitType == LimitType.SUBCATEGORY) {
                pickedId = null;
                bloc.add(ListSubcategoriesEvent());
              }
            });
          },
          items: const <DropdownMenuItem<LimitType>>[
            DropdownMenuItem(
              child: Text("Categoria"),
              value: LimitType.CATEGORY,
            ),
            DropdownMenuItem(
              child: Text("Subcategoria"),
              value: LimitType.SUBCATEGORY,
            ),
            DropdownMenuItem(
              child: Text("Metodo de pagamento"),
              value: LimitType.PAYMENT_METHOD,
            ),
            DropdownMenuItem(
              child: Text("Tipo de transação"),
              value: LimitType.TRANSACTION_TYPE,
            )
          ],
        ),
        if (pickedLimitType != null)
          BlocBuilder<LimitPickerBloc, LimitPickerState>(
            builder: (context, state) {
              return DropdownButton(
                  value: pickedId,
                  isExpanded: true,
                  hint: Text("Categorias"),
                  onChanged: (val) {
                    setState(() {
                      pickedId = val;
                      widget.onChanged(pickedLimitType!, val);
                    });
                  },
                  items: getDropdownItems(state));
            },
          )
      ],
    );
  }
}
