part of 'google_auth_bloc.dart';

abstract class GoogleAuthState extends Equatable {
  const GoogleAuthState();
}

class GoogleAuthInitial extends GoogleAuthState {
  @override
  List<Object> get props => [];
}

class GoogleLogginInState extends GoogleAuthState{
  @override
  List<Object> get props => [];
}

class GoogleLoggedOutState extends GoogleAuthState{
  @override
  List<Object> get props => [];
}

class GoogleLoggedInState extends GoogleAuthState{
  final User user;

  const GoogleLoggedInState({required this.user});

  @override
  List<Object> get props => [user];
}

class GoogleLogInErrorState extends GoogleAuthState{
  @override
  List<Object> get props => [];
}
