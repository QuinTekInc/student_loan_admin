import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/users_bloc.dart';
import 'package:loan_admin/components/placeholders.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/models/models.dart';
import 'package:loan_admin/pages/notifications_page.dart';

class StudentUserProfilePage extends StatefulWidget {
  const StudentUserProfilePage({super.key});

  @override
  State<StudentUserProfilePage> createState() => _StudentUserProfilePageState();
}

class _StudentUserProfilePageState extends State<StudentUserProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<UserProfileCubit>().fetchStudentInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [

          FragementHeader(title: 'Student Profile'),

          Expanded(
            child: BlocBuilder<UserProfileCubit, UserProfileState>(
              builder: (_, state) {
                if (state is UserProfileLoading) {
                  return LoadingPlaceholder();
                }

                if (state is UserProfileError) {
                  return MessagePlaceholder.error(
                    message: state.message,
                    onButtonPressed: () =>
                        context.read<UserProfileCubit>().fetchStudentInfo(),
                  );
                }

                return _buildContent();
              },
            ),
          ),
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
        spacing: 20,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _studentInfoCard()),

              const SizedBox(width: 20),

              Expanded(child: _loanSummaryCard()),
            ],
          ),

          _currentLoanCard(),

          _applicationsCard(),

          _loanHistoryCard(),

          _documentsCard(),
        ],
      ),
    );
  }

  Widget _studentInfoCard() {
    final loaded =
        context.read<UserProfileCubit>().state as StudentProfileLoaded;

    return _sectionCard(
      "Student Information",
      Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.green.shade100,
                child: const Icon(Icons.person, size: 40),
              ),

              const SizedBox(width: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  CustomText(
                    context.read<UserProfileCubit>().user.fullName,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),

                  CustomText(loaded.studentInfo['id'], textColor: Colors.grey),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 2,
                    children: [
                      CustomText('Institution:', fontWeight: FontWeight.w600),

                      CustomText(
                        'University of Energy and Natural Resources',
                        textColor: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _infoTile('Gender', loaded.studentInfo['gender']),

              _infoTile("Email", loaded.studentInfo['email']),

              _infoTile("Phone", loaded.studentInfo['phone_number']),

              _infoTile(
                'Ghana Card Number',
                loaded.studentInfo['ghana_card_number'],
              ),

              // _infoTile(
              //   "Institution",
              //   "University of Energy and Natural Resources",
              // ),
              _infoTile("Programme", "Computer Science"),

              _infoTile("Level", "300"),

              _infoTile("Status", context.read<UserProfileCubit>().user.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _loanSummaryCard() {
    final loaded =
        context.read<UserProfileCubit>().state as StudentProfileLoaded;

    final loan = loaded.loans.lastOrNull;

    double amountRemaining = 0;

    if (loan != null && loan.status == 'active') {
      amountRemaining = loan.amountRemaing;
    }


    final approvedCount = loaded.applications.where(
      (app) => app.status=='approved').length;
    
    final rejectedCount = loaded.applications.where(
      (app) => app.status=='rejected').length;

    return _sectionCard(
      "Loan Summary",
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          _summaryTile("Current Balance", "GHS $amountRemaining", Colors.orange),

          _summaryTile("Applications", loaded.applications.length.toString(), Colors.blue),
          
          _summaryTile("Approved Loans", approvedCount.toString(), Colors.green),

          _summaryTile('Rejected Applications', rejectedCount.toString(), Colors.red),

          // _summaryTile("Repayments", "18", Colors.purple),
        ],
      ),
    );
  }

  Widget _currentLoanCard() {
    Loan? loan =
        (context.read<UserProfileCubit>().state as StudentProfileLoaded)
            .loans
            .lastOrNull;

    if (loan == null || loan.status == 'completed') {
      return _sectionCard(
        'Current Active Loan',
        Container(
          height: 200,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: MessagePlaceholder(
            icon: Icons.account_balance,
            iconColor: Colors.grey.shade600,
            message: 'No Active loans yet.',
          ),
        ),
      );
    }

    double percentagePaid = (loan.amountPaid / loan.totalAmount);

    return _sectionCard(
      "Current Active Loan",
      Column(
        children: [
          Row(
            spacing: 12,
            children: [
              Expanded(child: _infoTile("Loan ID", loan.loanId)),

              Expanded(child: _infoTile("Amount", "GHS ${loan.totalAmount}")),

              Expanded(
                child: _infoTile("Outstanding", "GHS ${loan.amountRemaing}"),
              ),

              Expanded(child: _infoTile("Status",  prettyFormat(loan.status))),
            ],
          ),

          const SizedBox(height: 16),

          LinearProgressIndicator(
            value: percentagePaid,
            minHeight: 10,
            borderRadius: BorderRadius.circular(30),
          ),
        ],
      ),
    );
  }

  Widget _applicationsCard() {
    final loanApplications =
        (context.read<UserProfileCubit>().state as StudentProfileLoaded)
            .applications;

    return _sectionCard(
      "Applications",
      Column(
        children: [
          _tableHeader(["Application ID", "Date", "Amount", "Status"]),

          const Divider(),

          if (loanApplications.isEmpty)
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: MessagePlaceholder(
                icon: Icons.edit_note,
                iconColor: Colors.green.shade600,
                message: 'No Applications yet',
              ),
            ),

          if (loanApplications.isNotEmpty)
            ...List.generate(loanApplications.length, (index) {
              final loanApplication = loanApplications[index];
              return _tableRow([
                loanApplication.applicationId,
                formatDate(loanApplication.createdAt),
                "GHS ${loanApplication.amountRequested}",
                loanApplication.status,
              ]);
            }),
        ],
      ),
    );
  }

  Widget _loanHistoryCard() {
    final loans =
        (context.read<UserProfileCubit>().state as StudentProfileLoaded).loans;
    return _sectionCard(
      "Loan History",
      Column(
        children: [
          _tableHeader(["Loan ID", "Amount", "Issued", "Status"]),

          const Divider(),

          if (loans.isEmpty)
            Container(
              height: 200,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: MessagePlaceholder(
                icon: Icons.account_balance,
                iconColor: Colors.green.shade600,
                message: 'All user\'s loans appear here.',
              ),
            ),

          if (loans.isNotEmpty)
            ...List.generate(loans.length, (index) {
              Loan loan = loans[index];
              return _tableRow([
                loan.loanId,
                'GHS ${loan.approvedAmount}',
                loan.createdAt.year.toString(),
                loan.status,
              ]);
            }),
        ],
      ),
    );
  }

  Widget _documentsCard() {
    return _sectionCard(
      "Documents",
      Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _documentCard("Passport Photo"),
          _documentCard("Transcript"),
          _documentCard("Admission Letter"),
          _documentCard("National ID"),
        ],
      ),
    );
  }

  Widget _sectionCard(String title, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [HeaderText(title), const SizedBox(height: 18), child],
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(title, textColor: Colors.grey),

          const SizedBox(height: 6),

          CustomText(value, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }

  Widget _summaryTile(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: CustomText(title)),

          CustomText(value, textColor: color, fontWeight: FontWeight.bold),
        ],
      ),
    );
  }

  Widget _tableHeader(List<String> headers) {
    return Row(
      children: headers
          .map(
            (e) => Expanded(child: CustomText(e, fontWeight: FontWeight.bold)),
          )
          .toList(),
    );
  }

  Widget _tableRow(List<String> values) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: values.map((e) => Expanded(child: CustomText(e))).toList(),
      ),
    );
  }

  Widget _documentCard(String title) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.description_outlined, size: 36),

          const SizedBox(height: 10),

          CustomText(title),

          const SizedBox(height: 12),

          OutlinedButton(onPressed: () {}, child: const Text("View")),
        ],
      ),
    );
  }
}
