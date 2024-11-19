import 'package:billy/presentation/screens/backup_and_restore/list_backups_screen.dart';
import 'package:billy/presentation/shared/blocs/google_auth_bloc/google_auth_bloc.dart';
import 'package:billy/presentation/shared/components/backup_button.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/services/auth_service/google_auth_service.dart';
import 'package:billy/services/toast_service/toast_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'bloc/drive_backup_bloc.dart';

class BackupAndRestoreScreen extends StatelessWidget {
  const BackupAndRestoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Backup e restauração",
          style: TypographyStyles.label1(),
        ),
      ),
      body: BlocBuilder<DriveBackupBloc, DriveBackupState>(
        builder: (context, state) {
          var bloc = BlocProvider.of<DriveBackupBloc>(context);
          return BlocListener<DriveBackupBloc, DriveBackupState>(
            listener: (context, state) {
              if (state is BackedUpState) {
                ToastService.showToast(message: "Backup concluido");
              }
              if (state is BackUpErrorState) {
                ToastService.showToast(message: "Erro");
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Center(
                          child: Icon(
                        Icons.cloud_sync_outlined,
                        color: ThemeColors.semanticGreen,
                        size: 100,
                      )),
                      Text(bloc.lastBackup != null
                          ? "Último backup: ${bloc.lastBackup}"
                          : "Sem backups"),
                      const SizedBox(
                        height: 16,
                      ),
                      BackupButton2()
                    ],
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  Column(
                    children: [
                      Card(
                        elevation: 0,
                        child: ListTile(
                          title: Text("Restaurar..."),
                          enableFeedback: true,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ListBackupsScreen()));
                          },
                        ),
                      ),
                      BlocBuilder<GoogleAuthBloc, GoogleAuthState>(
                          builder: (context, state) {
                        var currentUser = FirebaseAuth.instance.currentUser;
                        if (state is GoogleLogginInState) {
                          return CircularProgressIndicator();
                        }
                        return currentUser != null
                            ? _buildGoogleAccountBadge(context, currentUser)
                            : _buildGoogleAccountLoginBadge(context);
                      })
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _buildGoogleAccountBadge(BuildContext context, User currentUser) {
    var bloc = BlocProvider.of<GoogleAuthBloc>(context);
    return Container(
      height: 160,
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: Theme.of(context).hoverColor,
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(currentUser.photoURL!),
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                SizedBox(
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        currentUser.displayName!,
                        style: TypographyStyles.paragraph3(),
                      ),
                      Text(
                        currentUser.email!,
                        style: TypographyStyles.paragraph3(),
                      ),
                    ],
                  ),
                )
              ],
            ),

            //LOG OUT BUTTON
            Card(
              elevation: 0,
              child: ListTile(
                title: Text("Sair"),
                enableFeedback: true,
                onTap: () {
                  bloc.add(GoogleLogoutEvent());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildGoogleAccountLoginBadge(BuildContext context) {
    return Container(
      height: 80,
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: Theme.of(context).hoverColor,
          borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text("Adicionar uma conta google"),
          leading: Icon(Icons.person),
          onTap: () {
            BlocProvider.of<GoogleAuthBloc>(context).add(GoogleLoginEvent());
          },
        ),
      ),
    );
  }
}
