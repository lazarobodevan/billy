import 'package:billy/presentation/screens/balance_editor/balance_editor.dart';
import 'package:billy/presentation/screens/nav_pages/more/widgets/more_item.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/services/auth_service/google_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/blocs/google_auth_bloc/google_auth_bloc.dart';
import 'screens/backup_and_restore/backup_and_restore_screen.dart';
import 'screens/categories/categories.dart';
import 'screens/credit_card_invoices/credit_card_invoices.dart';
import 'screens/limits/limits_screen.dart';

class More extends StatelessWidget {
  const More({super.key});

  @override
  Widget build(BuildContext context) {
    var user = GoogleAuthService().currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ThemeColors.primary3,
      ),
      backgroundColor: ThemeColors.primary3,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocConsumer<GoogleAuthBloc, GoogleAuthState>(
                listener: (context, state) {
                  if(state is GoogleLoggedInState){
                    user = state.user;
                  }
                  if(state is GoogleLoggedOutState){
                    user = null;
                  }
                },
                builder: (context, state) {

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: ThemeColors.primary1),
                      child: user != null && user?.photoURL != null
                          ? Image.network(user!.photoURL!)
                          : SizedBox(),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 36,
              ),
              MoreItem(
                text: "Categorias",
                icon: Icons.add,
                onClick: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        Categories(
                          onSelect: (val) {},
                          isSelectableCategories: false,
                        ),
                  ));
                },
              ),
              const SizedBox(
                height: 20,
              ),
              MoreItem(
                text: "Orçamentos",
                icon: Icons.percent_rounded,
                onClick: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LimitsScreen()));
                },
              ),
              const SizedBox(
                height: 20,
              ),
              MoreItem(
                text: "Faturas",
                icon: Icons.credit_card_rounded,
                onClick: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreditCardInvoices()));
                },
              ),
              const SizedBox(
                height: 20,
              ),
              MoreItem(
                  text: "Editar conta bancária",
                  icon: Icons.edit_outlined,
                  onClick: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BalanceEditor()));
                  }),

              const SizedBox(
                height: 20,
              ),
              MoreItem(
                text: "Backup e restauração",
                icon: Icons.cloud_sync_outlined,
                onClick: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BackupAndRestoreScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
