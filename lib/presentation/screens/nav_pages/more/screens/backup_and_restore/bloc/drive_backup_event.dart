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
  final String database;

  const RestoreFromDriveEvent({required this.database});
  @override
  List<Object?> get props => [database];

}

class ListBackupsEvent extends DriveBackupEvent{
  @override
  List<Object?> get props => [];

}
