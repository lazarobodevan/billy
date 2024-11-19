import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/drive_backup_bloc.dart';

class ListBackupsScreen extends StatelessWidget {
  const ListBackupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<DriveBackupBloc, DriveBackupState>(
        bloc: BlocProvider.of<DriveBackupBloc>(context)..add(ListBackupsEvent()),
        builder: (context, state) {
          if(state is ListingBackupsState){
            return const Center(child: CircularProgressIndicator(),);
          }
          if(state is ListedBackupsState) {
            if(state.backups == null){
              return const Center(child: Text("Sem backups..."),);
            }
            return ListView.builder(itemCount: state.backups!.length, itemBuilder: (context, index) {
              final backup = state.backups![index];
              return ListTile(
                title: Text(backup.name),
                subtitle: Text(backup.date.toIso8601String()),
                onTap: (){
                  BlocProvider.of<DriveBackupBloc>(context).add(RestoreFromDriveEvent(database: backup.name));

                },
              );
            });
          }
          return Center(child: Text("Erro"),);
        },
      ),
    );
  }
}
