import 'package:billy/presentation/screens/nav_pages/more/screens/backup_and_restore/bloc/drive_backup_bloc.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/presentation/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BackupButton2 extends StatelessWidget {
  const BackupButton2({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        BlocProvider.of<DriveBackupBloc>(context).add(BackupToDriveEvent());
      },
      child: Ink(
        width: double.maxFinite,
        height: 60,
        decoration: BoxDecoration(
            color: ThemeColors.semanticGreen,
            borderRadius: BorderRadius.circular(16)),
        child: BlocBuilder<DriveBackupBloc, DriveBackupState>(
          builder: (context, state) {
            if(state is BackingUpState){
              return const Center(child: CircularProgressIndicator(),);
            }
            return Center(
              child: Text(
                "Fazer backup no Google Drive",
                style: TypographyStyles.label3().copyWith(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
