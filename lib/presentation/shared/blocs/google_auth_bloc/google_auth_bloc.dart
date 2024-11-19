import 'dart:async';

import 'package:billy/services/auth_service/google_auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'google_auth_event.dart';
part 'google_auth_state.dart';

class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {

  final GoogleAuthService googleAuthService = GoogleAuthService();

  GoogleAuthBloc() : super(GoogleAuthInitial()) {
    on<GoogleLoginEvent>((event, emit) async {
      try{
        emit(GoogleLogginInState());
        var user = await googleAuthService.signInWithGoogle();
        emit(GoogleLoggedInState(user: user.user!));
      }catch(e){
        emit(GoogleLogInErrorState());
      }
    });
    on<GoogleLogoutEvent>((event, emit) async {
      try{
        emit(GoogleLogginInState());
        var user = await googleAuthService.signOut();
        emit(GoogleLoggedOutState());
      }catch(e){
        emit(GoogleLogInErrorState());
      }
    });
  }
}
