import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/applications_bloc.dart';
import 'package:loan_admin/components/placeholders.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/models/models.dart';
import 'package:loan_admin/pages/dialogs/application_approval_dialog.dart';
import 'package:loan_admin/pages/dialogs/application_rejection_dialog.dart';

class LoanApplicationReview extends StatefulWidget {

  const LoanApplicationReview({
    super.key,
  });

  @override
  State<LoanApplicationReview> createState() => _LoanApplicationReviewState();
}

class _LoanApplicationReviewState extends State<LoanApplicationReview> {

  late LoanApplication application;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    application = context.read<ReviewCubit>().loanApplication;
    context.read<ReviewCubit>().fetchLoanApplicationInfo();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [

          HeaderText("Loan Application Review"),
          
          Expanded( 
            child: BlocBuilder<ReviewCubit, ReviewState>( 
              builder: (_, state){
                
                if(state is ReviewLoading){
                  return LoadingPlaceholder();
                }
                
                if(state is ReviewError){
                  return MessagePlaceholder.error(
                    message: state.message, 
                    onButtonPressed: () => context.read<ReviewCubit>().fetchLoanApplicationInfo()
                  );
                }
                
                return _buildContent();
              },
            ),
          )
          
        ],
      ),
    );
  }

  SingleChildScrollView _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
    
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 24,
            children: [
    
              Expanded(
                child: _buildFirstCol(),
              ),
    
              Expanded(
                child: _buildSecondCol(),
              )
    
            ],
          ),

        ],
      ),
    );
  }



  Row _buildReviewActions() {
    return Row(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        ElevatedButton.icon(
          onPressed: handleApproveLoan,
          icon: const Icon(Icons.check, color: Colors.white,),
          label: CustomText("Approve", fontSize: 15, textColor: Colors.white,),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            )
          ),
        ),



        ElevatedButton.icon(
          onPressed: handleRejectLoan,
          icon: const Icon(Icons.close, color: Colors.white,),
          label: CustomText("Reject", fontSize: 15, textColor: Colors.white,),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              )
          ),
        ),

        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.info_outline),
          label: const Text("Request Info"),
        ),
      ],
    );
  }
  
  
  
  

  Widget _buildDocumentsInformation() {

    ReviewLoaded loaded = context.read<ReviewCubit>().state as ReviewLoaded;

    List<Widget> children = loaded.documents.map(
        (applicationDocument) => _documentCard(applicationDocument)).toList();

    return _sectionCard(
      useMaxWidth: true,
      "Uploaded Documents",
      Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: children
      ),
    );
  }

  Widget _buildLoanInformation() {
    return _sectionCard(
      useMaxWidth: true,
      "Loan Information",
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [

          _infoTile(
            "Amount Requested",
            "GHS ${application.amountRequested}",
          ),

          _infoTile(
            "Loan Reason",
            application.loanReason,
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicInformation() {
    
    final applicationInfo = (context.read<ReviewCubit>().state as ReviewLoaded).applicationInfo;
    
    return _sectionCard(
      "Academic Information",
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [

          _infoTile("Institution", "University of Energy and Natural Resources"),
          _infoTile("Reference Number", applicationInfo.referenceNumber),
          _infoTile("Index Number", applicationInfo.indexNumber),
          _infoTile("Level",  applicationInfo.level),
          _infoTile("Program", applicationInfo.program),
          _infoTile("Department", applicationInfo.department),
        ],
      ),
    );
  }

  Widget _buildParentalInformation() {

    final applicationInfo = (context.read<ReviewCubit>().state as ReviewLoaded).applicationInfo;

    return _sectionCard(
      "Parent Information",
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [

          _infoTile("Guardian Name", applicationInfo.guardianName),
          _infoTile("Relationship", applicationInfo.guardianRelationship),
          _infoTile("Phone", applicationInfo.guardianPhoneNumber),
          //_infoTile("Occupation", "Teacher"),
        ],
      ),
    );
  }

  Widget _buildPersonalInformation() {

    final applicationInfo = (context.read<ReviewCubit>().state as ReviewLoaded).applicationInfo;

    return _sectionCard(
      "Personal Information",
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [

          _infoTile("Full Name", applicationInfo.fullName),
          _infoTile("Gender", applicationInfo.gender),
          _infoTile("Ghana Card Number", applicationInfo.ghanaCardNumber),
          _infoTile("Nationality", applicationInfo.nationality),
          _infoTile("Email", applicationInfo.email),
          _infoTile("Phone", applicationInfo.phoneNumber),

        ],
      ),
    );
  }

  Widget _buildSummaryInformation() {
    return _sectionCard(
      "Application Summary",
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [

          _infoTile("Application ID", application.applicationId),
          _infoTile("Student ID", application.studentId),
          _infoTile("Status", application.status),
          _infoTile("Created", application.createdAt.toString()),
        ],
      ),
    );
  }

  //===================FIRST COLUMN ===================
  Widget _buildFirstCol(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: [

        //application progress summary
        _buildSummaryInformation(),

        //personal information,
        _buildPersonalInformation(),

        //parental information,
        _buildParentalInformation(),

        //academic information
        _buildAcademicInformation(),

        //document information
        _buildDocumentsInformation(),

      ],
    );
  }

  Widget _buildSecondCol(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 20,
      children: [

        //loan information
        _buildLoanInformation(),

        _fraudSection(),

        //admin notes
        _sectionCard(
          "Admin Notes",
          TextFormField(
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Enter review comments...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),



        //review actions
        _buildReviewActions(),

      ],
    );
  }

  // ================= FRAUD SECTION =================
  Widget _fraudSection() {

    final reviewLoaded = context.read<ReviewCubit>().state as ReviewLoaded;

    return _sectionCard(
      "AI Fraud Detection",
      Column(
        children: [

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const CustomText(
              "Transcript shows moderate risk indicators. Manual review recommended.",
              textColor: Colors.black87,
            ),
          ),

          const SizedBox(height: 16),

          ...reviewLoaded.documents.map(
                  (applicationDocument) => _fraudItem(applicationDocument))

          // _fraudItem("Passport Photo", "Authentic", Colors.green),
          // _fraudItem("Admission Letter", "Authentic", Colors.green),
          // _fraudItem("Transcript", "Suspicious", Colors.orange),
          // _fraudItem("National ID", "Authentic", Colors.green),
        ],
      ),
    );
  }

  // ================= CARD =================
  Widget _sectionCard(String title, Widget child, {bool useMaxWidth = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: useMaxWidth ? double.infinity : null,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          HeaderText(title, textColor: Colors.black),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }

  // ================= TILE =================
  Widget _infoTile(String title, String value) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          CustomText(title, textColor: Colors.grey),

          const SizedBox(height: 6),

          CustomText(value, textColor: Colors.black),
        ],
      ),
    );
  }

  // ================= DOCUMENT =================
  Widget _documentCard(ApplicationDocument applicationDocument) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [

          const Icon(Icons.description_outlined, size: 40),

          const SizedBox(height: 10),

          CustomText(
            applicationDocument.documentType.split('_')
                .map((word) => word[0].toUpperCase() + word.substring(1, word.length))
                .join(""),

            textColor: Colors.black
          ),

          const SizedBox(height: 6),

          CustomText(
            applicationDocument.status,
            textColor: applicationDocument.status == "Suspicious" ? Colors.orange : Colors.green,
          ),

          const SizedBox(height: 12),

          OutlinedButton(
            //todo: implement a logic to view the application
            onPressed: () {},
            child: const Text("View"),
          ),
        ],
      ),
    );
  }

  // ================= FRAUD ITEM =================
  Widget _fraudItem(ApplicationDocument applicationDocument) {

    String verificationStatus = applicationDocument.fraudAnalysis.verificationStatus;
    final bool requiresManualReview = applicationDocument.fraudAnalysis.requiresManualReview;

    Color color;
    if(verificationStatus == "FAIL"){
      color = Colors.red.shade700;
    }else if(verificationStatus.isEmpty){
      color = Colors.orange.shade700;
    }else{
      color = Colors.green.shade700;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Icon(Icons.verified, color: color),

              const SizedBox(width: 10),

              CustomText(

                applicationDocument.documentType.split('_').map(
                  (word){
                    String capitalized = word[0].toUpperCase() + word.substring(1, word.length);
                    return capitalized;
                  }).join(" "),

                textColor: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ],
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12)
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [

                Row(
                  children: [
                    CustomText(
                      'Verification Score',
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                    Spacer(),
                    CustomText(
                      applicationDocument.fraudAnalysis.verificationStatus,
                      textColor: color,
                      fontWeight: FontWeight.w800,
                    )
                  ],
                ),

                Row(
                  children: [
                    CustomText(
                      'OCR Confidence',
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                    Spacer(),
                    CustomText(applicationDocument.fraudAnalysis.ocrConfidence.toString())
                  ],
                ),

                Row(
                  children: [
                    CustomText(
                      'Risk Level',
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                    Spacer(),
                    CustomText(applicationDocument.fraudAnalysis.riskLevel)
                  ],
                ),

                Row(
                  children: [
                    CustomText(
                      'Risk Score',
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                    Spacer(),
                    CustomText(applicationDocument.fraudAnalysis.riskScore.toString())
                  ],
                ),

                CustomText(
                  'Indicators :',
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),

                CustomText(applicationDocument.fraudAnalysis.indicators.join('\n')),



                Row(
                  children: [
                    CustomText(
                      'Requires Manual Review',
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                    Spacer(),
                    CustomText(
                      requiresManualReview ? 'Yes' : 'No',
                      textColor: requiresManualReview ? Colors.red.shade700 : Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    )
                  ],
                ),

              ],
            ),
          )
        ],
      ),
    );
  }

  void handleApproveLoan(){
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ReviewCubit>(),
        child: LoanApprovalDialog()
      )
    );
  }

  void handleRejectLoan(){
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ReviewCubit>(),
        child: RejectLoanApplicationDialog()
      )
    );
  }
}