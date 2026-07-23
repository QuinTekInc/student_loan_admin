import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/navigation_bloc.dart';
import 'package:loan_admin/bloc/users_bloc.dart';
import 'package:loan_admin/components/alert.dart';
import 'package:loan_admin/pages/user_management/student_profile_page.dart';

class SharedFunctions {
  static void handleOpenStudentProfile(BuildContext context, {required String studentId}) async {
    showLoadingDialog(context: context);

    try {
      final profileCubit = await UserProfileCubit.fromStudentId(studentId);

      Navigator.pop(context); //close the loading dialog

      context.read<NavigationCubit>().push(
        BlocProvider(
          create: (_) => profileCubit,
          child: StudentUserProfilePage(),
        ),
      );
    } catch (ex) {
      Navigator.pop(context); //close the loading dialog
      showAlertDialog(
        context: context,
        alertType: AlertType.error,
        title: 'Error',
        contentText: ex.toString(),
      );
    }
  }
}
