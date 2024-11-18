part of 'drive_backup_bloc.dart';

abstract class DriveBackupState extends Equatable {
  const DriveBackupState();
}

class DriveBackupInitial extends DriveBackupState {
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