import 'package:flutter/material.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/models/models.dart';
import 'package:loan_admin/pages/dialogs/application_approval_dialog.dart';

class LoanApplicationReview extends StatefulWidget {
  final LoanApplication application;

  const LoanApplicationReview({
    super.key,
    required this.application,
  });

  @override
  State<LoanApplicationReview> createState() => _LoanApplicationReviewState();
}

class _LoanApplicationReviewState extends State<LoanApplicationReview> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          HeaderText("Loan Application Review"),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                child: _buildFirstCol(),
              ),

              Expanded(
                child: _buildSecondCol(),
              )

            ],
          ),


          const SizedBox(height: 20,),


          // ================= NOTES =================
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

          const SizedBox(height: 20),

          // ================= ACTIONS =================
          Row(
            children: [

              ElevatedButton.icon(
                onPressed: handleApproveLoan,
                icon: const Icon(Icons.check),
                label: const Text("Approve"),
              ),

              const SizedBox(width: 16),

              ElevatedButton.icon(
                onPressed: handleRejectLoan,
                icon: const Icon(Icons.close),
                label: const Text("Reject"),
              ),

              const SizedBox(width: 16),

              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.info_outline),
                label: const Text("Request Info"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsInformation() {
    return _sectionCard(
      useMaxWidth: true,
      "Uploaded Documents",
      Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [

          _documentCard("Passport Photo", "Authentic"),
          _documentCard("Admission Letter", "Authentic"),
          _documentCard("Transcript", "Suspicious"),
          _documentCard("National ID", "Authentic"),
        ],
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
            "GHS ${widget.application.amountRequested}",
          ),

          _infoTile(
            "Loan Reason",
            widget.application.loanReason,
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicinformation() {
    return _sectionCard(
      "Academic Information",
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [

          _infoTile("Institution", "University of Energy and Natural Resources"),
          _infoTile("Programme", "Computer Science"),
          _infoTile("Level", "300"),
          _infoTile("Academic Year", "2025/2026"),
        ],
      ),
    );
  }

  Widget _buildParentalInformation() {
    return _sectionCard(
      "Parent Information",
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [

          _infoTile("Guardian Name", "John Sefalloyd"),
          _infoTile("Relationship", "Father"),
          _infoTile("Phone", "+233 20 000 0000"),
          _infoTile("Occupation", "Teacher"),
        ],
      ),
    );
  }

  Widget _buildPersonalInformation() {
    return _sectionCard(
      "Personal Information",
      Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [

          _infoTile("Full Name", "Quin Sefalloyd"),
          _infoTile("Email", "quin@email.com"),
          _infoTile("Phone", "+233 24 000 0000"),
          _infoTile("Index Number", "UENR/CS/2022/001"),
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

          _infoTile("Application ID", widget.application.applicationId),
          _infoTile("Student ID", widget.application.studentId),
          _infoTile("Status", widget.application.status),
          _infoTile("Created", widget.application.createdAt.toString()),
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
        _buildAcademicinformation()

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

        _buildLoanInformation(),
        _fraudSection(),
        _buildDocumentsInformation(),

      ],
    );
  }

  // ================= FRAUD SECTION =================
  Widget _fraudSection() {
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

          _fraudItem("Passport Photo", "Authentic", Colors.green),
          _fraudItem("Admission Letter", "Authentic", Colors.green),
          _fraudItem("Transcript", "Suspicious", Colors.orange),
          _fraudItem("National ID", "Authentic", Colors.green),
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
  Widget _documentCard(String title, String status) {
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

          CustomText(title, textColor: Colors.black),

          const SizedBox(height: 6),

          CustomText(
            status,
            textColor: status == "Suspicious" ? Colors.orange : Colors.green,
          ),

          const SizedBox(height: 12),

          OutlinedButton(
            onPressed: () {},
            child: const Text("View"),
          ),
        ],
      ),
    );
  }

  // ================= FRAUD ITEM =================
  Widget _fraudItem(String doc, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [

          Icon(Icons.verified, color: color),

          const SizedBox(width: 10),

          Expanded(
            child: CustomText(doc, textColor: Colors.black),
          ),

          CustomText(status, textColor: color),
        ],
      ),
    );
  }

  void handleApproveLoan(){
    showDialog(
      context: context,
      builder: (_) => LoanApprovalDialog()
    );
  }

  void handleRejectLoan(){

  }
}