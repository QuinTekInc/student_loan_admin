



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/repo.dart';
import 'package:loan_admin/models/models.dart';

abstract class LoanApplicationsState{}

class LoanApplicationsInitial extends LoanApplicationsState{}

class LoanApplicationsLoading extends  LoanApplicationsState{}

class LoanApplicationsLoaded extends LoanApplicationsState{

  final List<LoanApplication> applications;

  int get pendingApplicationCount => applications.where(
      (application) => ["pending", 'submitted'].contains(application.status)).toList().length;

  int get reviewApplicationCount => applications.where(
          (application) => application.status == "under_review").toList().length;

  int get approvedApplicationCount => applications.where(
      (application) => application.status == "approved").toList().length;

  int get rejectedApplicationCount => applications.where(
          (application) => application.status == "rejected").toList().length;

  int get unknownApplicationCount => applications.where(
      (application) => !['submitted', 'pending', 'approved', 'rejected'].contains(application.status))
      .length;
  
  LoanApplicationsLoaded(this.applications);

}

class LoanApplicationsError extends LoanApplicationsState{

  final String message;
  LoanApplicationsError(this.message);
}


class LoanApplicationsCubit extends Cubit<LoanApplicationsState>{

  LoanApplicationsCubit() : super(LoanApplicationsInitial());

  void fetchLoanApplications() async {
    emit(LoanApplicationsLoading());

    try{

      //todo: get the loans from the backend.
      List<LoanApplication> applications = await Repository.fetchApplications();
      emit(LoanApplicationsLoaded(applications));

    }catch(ex, trace){
      debugPrint(ex.toString());
      debugPrintStack(stackTrace: trace);
      emit(LoanApplicationsError('Error'));
    }
  }


  void dispose(){

    if(state is LoanApplicationsLoaded){
      (state as LoanApplicationsLoaded).applications.clear();
    }

    emit(LoanApplicationsInitial());
  }

}




abstract class ReviewState{}

class ReviewInitial extends ReviewState{}

class ReviewLoading extends ReviewState{}

class ReviewLoaded extends ReviewState{

  final LoanApplicationInfo applicationInfo;
  final List<ApplicationDocument> documents;
  final ApplicationReview review;

  ReviewLoaded({
    required this.applicationInfo,
    required this.documents,
    required this.review
  });
}


class ReviewError extends ReviewState{
  final String message;
  ReviewError(this.message);
}

class ReviewCubit extends Cubit<ReviewState>{

  final LoanApplication loanApplication;

  ReviewCubit(this.loanApplication) : super(ReviewInitial());

  void fetchLoanApplicationInfo() async {

    emit(ReviewLoading());

    try{
      Map<String, dynamic> reviewMap = await Repository.getApplicationReview(loanApplication.applicationId);

      print(reviewMap);
      
      LoanApplicationInfo info = LoanApplicationInfo.fromJson(reviewMap['application_info']);

      ApplicationReview review = ApplicationReview.fromJson(
          Map<String, dynamic>.from(reviewMap['review']));

      List<ApplicationDocument> documents = List<dynamic>.from(reviewMap['documents'])
          .map((documentMap) => ApplicationDocument.fromJson(documentMap)).toList();

      emit(ReviewLoaded(
        applicationInfo: info,
        review: review,
        documents: documents
      ));

    }catch(ex, trace){
      emit(ReviewError(ex.toString()));
      debugPrintStack(stackTrace: trace);
    }
    
  }


  //this function is used when
  Future<void> updateApplicationReview(String comments) async {

  }


  Future<void> acceptApplication({
    required double amount,
    required double percentage,
    required int duration,
    String comment=''
  }) async {

    try{
     await Repository.approveLoanApplication(
       applicationId: loanApplication.applicationId,
       approvedAmount: amount,
       duration: duration,
     );
    }catch(ex, trace){
      debugPrint(ex.toString());
      debugPrintStack(stackTrace: trace);
      rethrow;
    }

  }

  void rejectApplication(String rejectionReason) async {

    try{
      await Repository.rejectApplication(
        applicationId: loanApplication.applicationId,
        rejectionReason: rejectionReason,
      );
    }catch(e, trace){
      debugPrintStack(stackTrace: trace);
      rethrow;
    }

  }
}



