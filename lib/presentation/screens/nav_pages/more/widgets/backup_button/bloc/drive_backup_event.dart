part of 'drive_backup_bloc.dart';

abstract class DriveBackupEvent extends Equatable {
  const DriveBackupEvent();
}

class LoginToGoogleEvent extends DriveBackupEvent{
  @override
  List<Object?> get props => [];

}

class BackupToDriveEvent extends DriveBackupEvent{
  @override
  List<Object?> get props => [];
}

class RestoreFromDriveEvent extends DriveBackupEvent{
  @override
  List<Object?> get props => [];

}
