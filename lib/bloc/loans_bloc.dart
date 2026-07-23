import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/repo.dart';
import 'package:loan_admin/models/models.dart';

abstract class LoansState {}

class LoansInitial extends LoansState {}

class LoansLoading extends LoansState {}

class LoansLoaded extends LoansState {
  final List<Loan> loans;

  int get activeLoansCount =>
      loans.where((loan) => loan.status == 'active').length;
  int get completedLoansCount =>
      loans.where((loan) => loan.status == 'completed').length;

  LoansLoaded(this.loans);
}

class LoansError extends LoansState {
  final String message;

  LoansError(this.message);
}

class LoansCubit extends Cubit<LoansState> {
  LoansCubit() : super(LoansInitial());

  void fetchLoans() async {
    emit(LoansLoading());

    try {
      //todo: get the loans from the backend.
      List<Loan> loans = await Repository.fetchLoans();
      emit(LoansLoaded(loans));
    } catch (ex, trace) {
      debugPrint(ex.toString());
      debugPrintStack(stackTrace: trace);
      emit(LoansError(ex.toString()));
    }
  }

  Future<void> updateLoanStatus(
    String loanId,
    Map<String, dynamic> statusInfo,
  ) async {
    try {} catch (ex, trace) {
      debugPrintStack(stackTrace: trace);
      rethrow;
    }
  }

  Future<void> disburseLoan(String loanId) async {
    if (state is! LoansLoaded) return;

    try {
      Repository.disburseLoan(loanId);

      final updated = (state as LoansLoaded).loans.map((loan) {
        if (loan.loanId == loanId) {
          loan.status = 'disbursed';
        }
        return loan;
      }).toList();

      emit(LoansLoaded(updated));
      
    } catch (ex, trace) {
      debugPrint(ex.toString());
      debugPrintStack(stackTrace: trace);
      rethrow;
    }
  }

  //some extra actions
  Future<void> markLoanAsCompleted(String loanId) async {
    try {
      Repository.markLoanAsCompleted(loanId);

      final newLoans = (state as LoansLoaded).loans.map((loan) {
        if (loan.loanId == loanId) {
          loan.status = 'completed';
        }
        return loan;
      }).toList();

      emit(LoansLoaded(newLoans));
    } catch (ex, trace) {
      debugPrint(ex.toString());
      debugPrintStack(stackTrace: trace);
      rethrow;
    }
  }

  void dispose() {
    if (state is LoansLoaded) {
      (state as LoansLoaded).loans.clear();
    }

    emit(LoansInitial());
  }
}

//loan details cubit
abstract class LoanDetailState {}

class LoanDetailInitial extends LoanDetailState {}

class LoanDetailLoading extends LoanDetailState {}

class LoanDetailLoaded extends LoanDetailState {}

class LoanDetailError extends LoanDetailState {
  String message;

  LoanDetailError(this.message);
}

class LoanDetailCubit extends Cubit<LoanDetailState> {
  final Loan loan;

  Map<String, dynamic>? loanInformation;

  LoanDetailCubit(this.loan) : super(LoanDetailInitial());

  void fetchLoanInformation() async {
    emit(LoanDetailLoading());

    try {
      loanInformation = await Repository.fetchLoanInformation(loan.loanId);
      emit(LoanDetailLoaded());
    } catch (ex) {
      emit(LoanDetailError(ex.toString()));
    }
  }
}
