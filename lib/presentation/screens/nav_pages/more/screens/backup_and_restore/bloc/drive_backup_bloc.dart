import 'dart:async';

import 'package:billy/models/backup/backup_model.dart';
import 'package:billy/services/auth_service/google_auth_service.dart';
import 'package:billy/services/toast_service/toast_service.dart';
import 'package:billy/use_cases/google_drive/google_drive_backup_and_restore.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'drive_backup_event.dart';

part 'drive_backup_state.dart';

class DriveBackupBloc extends Bloc<DriveBackupEvent, DriveBackupState> {
  final GoogleDriveBackupAndRestore googleDriveBackupAndRestore;
  final GoogleAuthService googleAuthService = GoogleAuthService();
  DateTime? lastBackup;

  DriveBackupBloc({required this.googleDriveBackupAndRestore})
      : super(DriveBackupInitial()) {

    //GET LAST BACKUP DATETIME
    Future<void> _initializeLastBackup() async {
      var lastBackupString =
          await FlutterSecureStorage().read(key: "lastBackup");
      lastBackup =
          lastBackupString != null ? DateTime.tryParse(lastBackupString) : null;
    }
    _initializeLastBackup();

    on<DriveBackupEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<BackupToDriveEvent>((event, emit) async {
      try {
        emit(BackingUpState());
        if (googleAuthService.currentUser == null) {
          await googleAuthService.signInWithGoogle();
        }
        await googleDriveBackupAndRestore.backupDatabase();
        const FlutterSecureStorage()
            .write(key: "lastBackup", value: DateTime.now().toIso8601String());
        lastBackup = DateTime.now();
        emit(BackedUpState());
      } catch (e) {
        emit(BackUpErrorState());
      }
    });

    on<ListBackupsEvent>((event, emit)async{
      try {
        emit(ListingBackupsState());
        var backups = await googleDriveBackupAndRestore.listBackups();
        emit(ListedBackupsState(backups: backups));
      }on Exception catch(e){
        emit(ListingBackupsErrorState(message: e.toString()));
      }
    });

    on<RestoreFromDriveEvent>((event, emit) async {
      try {
        emit(RestoringState());
        await googleDriveBackupAndRestore.restoreDatabase(event.database);
        emit(RestoredState());
      } catch (e) {
        emit(RestoreErrorState());
      }
    });
  }
}
