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
  final FlutterSecureStorage secureStorage;
  DateTime? lastBackup;

  DriveBackupBloc({required this.googleDriveBackupAndRestore, required this.secureStorage})
      : super(DriveBackupInitial()) {

    //GET LAST BACKUP DATETIME
    Future<void> _initializeLastBackup() async {
      var lastBackupString =
          await secureStorage.read(key: "lastBackup");
      lastBackup =
          lastBackupString != null ? DateTime.tryParse(lastBackupString) : null;
    }

    on<LoadLastBackupDate>((event, emit) async {
      emit(LoadingLastBackupDate());
      await _initializeLastBackup();
      emit(LoadedLastBackupDate(lastBackup: lastBackup));
    });

    on<BackupToDriveEvent>((event, emit) async {
      try {
        emit(BackingUpState());
        if (googleAuthService.currentUser == null) {
          await googleAuthService.signInWithGoogle();
        }
        await googleDriveBackupAndRestore.backupDatabase();
        secureStorage
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
