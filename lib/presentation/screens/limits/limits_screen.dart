import 'package:billy/presentation/screens/limits/limit_editor/limit_editor_screen.dart';
import 'package:billy/presentation/shared/components/limit_item.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/services/toast_service/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/limits_bloc.dart';

class LimitsScreen extends StatelessWidget {
  const LimitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.primary2,
      appBar: AppBar(
        backgroundColor: ThemeColors.primary2,
        title: Text(
          "Limites",
          style: TypographyStyles.headline3(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LimitEditorScreen()));
              },
              borderRadius: BorderRadius.circular(50),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Center(
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.green,
                    size: 28,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: BlocListener<LimitsBloc, LimitsState>(
        listener: (context, state) {

          if(state is CreatedLimitState){
            ToastService.showSuccess(message: "Limite criado com sucesso!");
          }

          if(state is UpdatedLimitState){
            ToastService.showSuccess(message: "Limite atualizado com sucesso!");
          }

          if(state is DeletedLimitState){
            ToastService.showSuccess(message: "Limite deletado com sucesso!");
          }

          if(state is CreatedLimitState || state is UpdatedLimitState || state is DeletedLimitState){
           BlocProvider.of<LimitsBloc>(context).add(ListLimitsEvent());
          }

        },
        child: BlocBuilder<LimitsBloc, LimitsState>(
          bloc: BlocProvider.of<LimitsBloc>(context)
            ..add(ListLimitsEvent()),
          builder: (context, state) {
            if (state is ListingLimitsState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ListLimitsErrorState) {
              return Center(child: Text(state.message),);
            }

            if (state is ListedLimitsState) {
              if (state.limits.isEmpty) {
                return const Center(child: Text("Sem orçamentos"),);
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: state.limits.map((el) {
                    return LimitItem(limit: el);
                  }).toList(),
                ),
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
