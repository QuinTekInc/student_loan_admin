

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/repo.dart';
import 'package:loan_admin/models/models.dart';

abstract class LoansState{}

class LoansInitial extends LoansState{}

class LoansLoading extends  LoansState{}

class LoansLoaded extends LoansState{

  final List<Loan> loans;
  LoansLoaded(this.loans);

}

class LoansError extends LoansState{

  final String message;

  LoansError(this.message);
}


class LoansCubit extends Cubit<LoansState>{

  LoansCubit() : super(LoansInitial());

  void fetchLoans() async {
    emit(LoansLoading());

    try{

      //todo: get the loans from the backend.
      List<Loan> loans = await Repository.fetchLoans();
      emit(LoansLoaded(loans));

    }catch(ex, trace){
      debugPrintStack(stackTrace: trace);
      emit(LoansError('Error'));
    }
  }


  void dispose(){

    if(state is LoansLoaded){
      (state as LoansLoaded).loans.clear();
    }

    emit(LoansInitial());
  }

}