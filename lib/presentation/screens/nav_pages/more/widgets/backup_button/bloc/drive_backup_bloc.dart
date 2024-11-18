import 'dart:async';

import 'package:billy/services/auth_service/google_auth_service.dart';
import 'package:billy/services/toast_service/toast_service.dart';
import 'package:billy/use_cases/google_drive/google_drive_backup_and_restore.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'drive_backup_event.dart';
part 'drive_backup_state.dart';

class DriveBackupBloc extends Bloc<DriveBackupEvent, DriveBackupState> {

  final GoogleDriveBackupAndRestore googleDriveBackupAndRestore;
  final GoogleAuthService googleAuthService = GoogleAuthService();

  DriveBackupBloc({required this.googleDriveBackupAndRestore}) : super(DriveBackupInitial()) {
    on<DriveBackupEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<LoginToGoogleEvent>((event, emit) async{
      try {
        emit(AuthenticatingState());
        final auth = await googleAuthService.signInWithGoogle();
        if(auth.user != null) {
          emit(AuthenticatedState());
        }else{
          emit(AuthenticationError());
        }
      }catch(e){
        emit(AuthenticationError());
      }
    });

    on<BackupToDriveEvent>((event, emit) async{
      try{
        emit(BackingUpState());
        if(googleAuthService.currentUser == null) await googleAuthService.signInWithGoogle();
        await googleDriveBackupAndRestore.backupDatabase();
        emit(BackedUpState());
      }catch(e){
        emit(BackUpErrorState());
      }
    });

    on<RestoreFromDriveEvent>((event, emit) async{
      try{
        emit(RestoringState());
        await googleDriveBackupAndRestore.restoreDatabase();
        emit(RestoredState());
      }catch(e){
        emit(RestoreErrorState());
      }
    });
  }
}
