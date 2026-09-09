import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/loans_bloc.dart';
import 'package:loan_admin/bloc/navigation_bloc.dart';
import 'package:loan_admin/bloc/users_bloc.dart';
import 'package:loan_admin/components/alert.dart';
import 'package:loan_admin/models/models.dart';
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



  static void handleDisbursement(BuildContext context, {required Loan loan}) async {
    showLoadingDialog(context: context);

    try {
      await context.read<LoansCubit>().disburseLoan(loan.loanId);
      Navigator.pop(context); //close the loading dialog.

      showAlertDialog(
        context: context,
        title: 'Disbursement Success',
        contentText:
            'Amount of GHS ${loan.approvedAmount} has been disbursed to student',
      );
    } catch (ex) {
      Navigator.pop(context); //close the loading dialog

      showAlertDialog(
        context: context,
        alertType: AlertType.error,
        icon: Icons.error,
        title: 'Disbursement Error',
        contentText: ex.toString(),
      );
    }
  }


  static void handleMarkAsCompleted(BuildContext context, {required Loan loan}) async {
    if (loan.amountPaid != loan.totalAmount) {
      showAlertDialog(
        context: context,
        alertType: AlertType.error,
        title: 'Error',
        contentText:
            'You cannot mark this loan as completed'
            'as user has not finished paying.\n'
            'Total Payable Amount: GHS ${loan.totalAmount}\n'
            'Amount Paid:       GHS ${loan.amountPaid}\n'
            'Remaining:         GHS ${loan.amountRemaing}',
      );
      return;
    }

    showLoadingDialog(context: context);

    try {
      await context.read<LoansCubit>().markLoanAsCompleted(loan.loanId);
      Navigator.pop(context); //close the loading dialog
      showAlertDialog(
        context: context,
        icon: Icons.check_circle,
        contentText: 'You have successfully marked this loan as completed.',
      );
    } catch (ex) {
      Navigator.pop(context); //close the loading dialog
      showAlertDialog(
        context: context,
        alertType: AlertType.error,
        title: 'Operation Failed',
        contentText: ex.toString(),
      );
    }
  }

}
