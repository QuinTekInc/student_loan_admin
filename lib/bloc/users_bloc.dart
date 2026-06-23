

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/repo.dart';
import 'package:loan_admin/models/models.dart';


abstract class UsersState{}

class UsersInitial extends UsersState{}

class UsersLoading extends UsersState{}

class UsersLoaded extends UsersState{

  final List<User> users;

  int get totalUsersCount => users.length;

  int get adminUsersCount => users.where(
          (user) => user.role.toLowerCase()=='admin' || user.role.toLowerCase() == 'superuser').length;

  int get studentUsersCount => users.where(
          (user) => user.role.toLowerCase() == 'student').length;

  int get suspendedUsersCount => users.where(
          (user) => user.status.toLowerCase() == 'suspended').length;

  UsersLoaded(this.users);
}

class UsersError extends UsersState{

  final String message;

  UsersError(this.message);

}




class UsersCubit extends Cubit<UsersState>{

  UsersCubit() : super(UsersInitial());

  void fetchUsers () async{
    emit(UsersLoading());

    try{
      List<User> users = await Repository.fetchUsers();
      emit(UsersLoaded(users));
    }catch(ex, trace){
      debugPrintStack(stackTrace: trace);
      emit(UsersError(ex.toString()));
    }
  }
}


