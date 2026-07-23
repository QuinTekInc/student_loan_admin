import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/repo.dart';
import 'package:loan_admin/models/models.dart';

abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<User> users;

  int get totalUsersCount => users.length;

  int get adminUsersCount => users
      .where(
        (user) =>
            user.role.toLowerCase() == 'admin' ||
            user.role.toLowerCase() == 'superuser',
      )
      .length;

  int get studentUsersCount =>
      users.where((user) => user.role.toLowerCase() == 'student').length;

  int get suspendedUsersCount =>
      users.where((user) => user.status.toLowerCase() == 'suspended').length;

  UsersLoaded(this.users);
}

class UsersError extends UsersState {
  final String message;

  UsersError(this.message);
}

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersInitial());

  void fetchUsers() async {
    emit(UsersLoading());

    try {
      List<User> users = await Repository.fetchUsers();
      emit(UsersLoaded(users));
    } catch (ex, trace) {
      debugPrintStack(stackTrace: trace);
      emit(UsersError(ex.toString()));
    }
  }

  Future<void> changeUserRole(String username, String newRole) async {}

  Future<void> changeUserStatus(String username, bool isActive) async {}

  Future<void> createUser(Map<String, dynamic> userInfo) async {
    try {
      User user = await Repository.createAdminUser(userInfo);

      if (state is! UsersLoaded) {
        emit(UsersLoaded([user]));
        return;
      }

      emit(UsersLoaded([...(state as UsersLoaded).users, user]));
    } catch (_) {
      rethrow;
    }
  }
}

//=============================USER PROFILE CUBIT=========================================
abstract class UserProfileState {}

class UserPropfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final List<AuditLog> userActivities;
  final Map<String, dynamic> statistics;

  UserProfileLoaded({required this.userActivities, required this.statistics});
}

class StudentProfileLoaded extends UserProfileState {
  final Map<String, dynamic> studentInfo;
  final List<LoanApplication> applications;
  final List<Loan> loans;

  StudentProfileLoaded({
    required this.studentInfo,
    required this.applications,
    required this.loans,
  });
}

class UserProfileError extends UserProfileState {
  final String message;
  UserProfileError(this.message);
}

class UserProfileCubit extends Cubit<UserProfileState> {
  final User user;

  //on no circumstance should
  UserProfileCubit(this.user) : super(UserPropfileInitial());

  static Future<UserProfileCubit> fromStudentId(String studentId) async {
    try {
      User user = await Repository.getUserFromStudentId(studentId);
      return UserProfileCubit(user);
    } catch (_) {
      rethrow;
    }
  }

  void fetchUserInfo() async {
    emit(UserProfileLoading());

    try {
      final activity = await Repository.fetchUserActivity(user!.username);
      final statistics = await Repository.fetchReviewStatics(user!.username);
      emit(UserProfileLoaded(statistics: statistics, userActivities: activity));
    } catch (ex) {
      emit(UserProfileError(ex.toString()));
    }
  }

  void fetchStudentInfo() async {
    emit(UserProfileLoading());

    try {
      Map<String, dynamic> studentInfo = await Repository.fetchStudentInfo(
        user!.username,
      );

      List<LoanApplication> applications =
          await Repository.fetchStudentApplications(user!.username);

      List<Loan> loans = await Repository.fetchStudentLoans(user!.username);

      emit(
        StudentProfileLoaded(
          studentInfo: studentInfo,
          applications: applications,
          loans: loans,
        ),
      );
    } catch (ex) {
      emit(UserProfileError(ex.toString()));
    }
  }
}
