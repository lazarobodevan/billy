part of 'drive_backup_bloc.dart';

abstract class DriveBackupState extends Equatable {
  const DriveBackupState();
}

class DriveBackupInitial extends DriveBackupState{
  @override
  List<Object?> get props => [];

}

class LoadingLastBackupDate extends DriveBackupState{
  @override
  List<Object?> get props => [];

}

class LoadedLastBackupDate extends DriveBackupState {
  final DateTime? lastBackup;

  const LoadedLastBackupDate({this.lastBackup});

  @override
  List<Object> get props => [];
}

class AuthenticatingState extends DriveBackupState{
  @override
  List<Object?> get props => [];
}

class AuthenticatedState extends DriveBackupState{
  @override
  List<Object?> get props => [];
}

class AuthenticationError extends DriveBackupState{
  @override
  List<Object?> get props => [];
}

class BackingUpState extends DriveBackupState{
  @override
  List<Object?> get props => [];
}

class BackedUpState extends DriveBackupState{
  @override
  List<Object?> get props => [];
}

class BackUpErrorState extends DriveBackupState{
  @override
  List<Object?> get props => [];
}

class RestoringState extends DriveBackupState{
  @override
  List<Object?> get props => [];
}

class RestoredState extends DriveBackupState{
  @override
  List<Object?> get props => [];
}

class RestoreErrorState extends DriveBackupState{
  @override
  List<Object?> get props => [];
}

class ListingBackupsState extends DriveBackupState{
  @override
  List<Object?> get props => [];
}

class ListedBackupsState extends DriveBackupState{
  final List<BackupModel>? backups;

  const ListedBackupsState({required this.backups});

  @override
  List<Object?> get props => [backups];
}

class ListingBackupsErrorState extends DriveBackupState{
  final String message;

  const ListingBackupsErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}