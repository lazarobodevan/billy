import 'package:billy/presentation/screens/nav_pages/more/widgets/backup_button/bloc/drive_backup_bloc.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:billy/services/toast_service/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BackupButton extends StatelessWidget {
  const BackupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DriveBackupBloc, DriveBackupState>(
      listener: (context, state) {
        if (state is BackedUpState) {
          ToastService.showToast(message: "Backup concluído!");
        }
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          BlocProvider.of<DriveBackupBloc>(context).add(BackupToDriveEvent());
        },
        child: Ink(
          height: 70,
          width: double.maxFinite,
          decoration: BoxDecoration(
              border: Border.all(color: ThemeColors.semanticGreen),
              borderRadius: BorderRadius.circular(50)),
          child: BlocBuilder<DriveBackupBloc, DriveBackupState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: ThemeColors.semanticGreen, width: 2)),
                      child: state is BackingUpState
                          ? CircularProgressIndicator()
                          : const Icon(
                              Icons.add_to_drive,
                              size: 28,
                            ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Backup com Google Drive",
                      style: TypographyStyles.label2(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
