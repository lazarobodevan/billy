import 'package:billy/presentation/screens/categories/categories.dart';
import 'package:billy/presentation/screens/nav_pages/more/widgets/backup_button/backup_button.dart';
import 'package:billy/presentation/screens/nav_pages/more/widgets/backup_button/bloc/drive_backup_bloc.dart';
import 'package:billy/presentation/screens/nav_pages/more/widgets/more_item.dart';
import 'package:billy/presentation/theme/colors.dart';
import 'package:billy/use_cases/google_drive/google_drive_backup_and_restore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class More extends StatelessWidget {
  const More({super.key});

  @override
  Widget build(BuildContext context) {
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
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ThemeColors.primary1),
              ),
              const SizedBox(
                height: 36,
              ),
              MoreItem(
                text: "Categorias",
                icon: Icons.add,
                onClick: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Categories(
                      onSelect: (val) {},
                      isSelectableCategories: false,
                    ),
                  ));
                },
              ),
              const SizedBox(
                height: 20,
              ),
              BlocProvider(
                create: (context) => DriveBackupBloc(
                    googleDriveBackupAndRestore: GoogleDriveBackupAndRestore()),
                child: BackupButton(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
