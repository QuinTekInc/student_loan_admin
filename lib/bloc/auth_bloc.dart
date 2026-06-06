

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/repo.dart';
import 'package:loan_admin/models/models.dart';

abstract class AuthState{}

class AuthInitial extends AuthState{}

class AuthLoading extends AuthState{}

class AuthAuthenticated extends AuthState{
  final User user;

  AuthAuthenticated(this.user);
}

class AuthUnAuthenticated extends AuthState{}

class AuthError extends AuthState{
  final String message;
  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState>{

  AuthCubit() : super(AuthInitial());

  void login(String username, String password) async {

    try{
      User user = await Repository.login(username, password);
      emit(AuthAuthenticated(user));
    }catch(ex, trace){
      emit(AuthError(ex.toString()));
      debugPrintStack(stackTrace: trace);
    }

  }


  void logout(String username, String password) async {

    try{
      await Repository.logout();
      emit(AuthUnAuthenticated());
    }catch(ex, _){
      //throw some sort of error here.
    }
  }
}