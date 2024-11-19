part of 'google_auth_bloc.dart';

abstract class GoogleAuthEvent extends Equatable {
  const GoogleAuthEvent();
}

class GoogleLoginEvent extends GoogleAuthEvent{
  @override
  List<Object?> get props => [];
}

class GoogleLogoutEvent extends GoogleAuthEvent{
  @override
  List<Object?> get props => [];
}