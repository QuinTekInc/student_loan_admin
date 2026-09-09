import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/loans_bloc.dart';
import 'package:loan_admin/components/placeholders.dart';
import 'package:loan_admin/components/shared_functions.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/models/models.dart';
import 'package:loan_admin/pages/loan_management/manual_payment_page.dart';

class LoanDetailPage extends StatefulWidget {
  const LoanDetailPage({super.key});

  @override
  State<LoanDetailPage> createState() => _LoanDetailPageState();
}

class _LoanDetailPageState extends State<LoanDetailPage> {
  late final Loan _loan;
  LoanDetailLoaded? loadedState;

  @override
  void initState() {
    super.initState();
    _loan = context.read<LoanDetailCubit>().loan;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 24,
        children: [
          FragementHeader(title: 'Loan Detail'),

          Expanded(
            child: BlocBuilder<LoanDetailCubit, LoanDetailState>(
              builder: (_, state) {
                if (state is LoanDetailInitial || state is LoanDetailLoading) {
                  return LoadingPlaceholder();
                }

                if (state is LoanDetailError) {
                  return MessagePlaceholder.error(
                    message: state.message,
                    onButtonPressed: context
                        .read<LoanDetailCubit>()
                        .fetchLoanInformation,
                  );
                }

                loadedState = state as LoanDetailLoaded;

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
        spacing: 20,
        children: [
          // ================= LOAN HEADER =================
          _loanHeader(),

          // ================= SUMMARY CARDS =================
          _summaryCards(),

          // ================= BORROWER INFO =================
          _borrowerInfo(context),

          // ================= LOAN BREAKDOWN =================
          _loanBreakdown(),

          // ================= REPAYMENT SCHEDULE =================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _repaymentSchedule()),
              const SizedBox(width: 12),
              Expanded(flex: 1, child: _adminActions()),
            ],
          ),

          // ================= ADMIN ACTIONS =================
        ],
      ),
    );
  }

  // ================= LOAN HEADER =================
  Widget _loanHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText("Loan ID", textColor: Colors.grey),

                SizedBox(height: 6),

                CustomText(
                  _loan.loanId,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(30),
            ),
            child: CustomText(
              _loan.status.toUpperCase(),
              textColor: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ================= SUMMARY =================
  Widget _summaryCards() {
    double amountRemaining = 0;

    if (['active', 'disbursed'].contains(_loan.status.toLowerCase())) {
      amountRemaining = _loan.amountRemaing;
    }

    return Row(
      spacing: 12,
      children: [
        Expanded(
          child: _summaryCard(
            "Approved Amount",
            "GHS ${_loan.approvedAmount}",
            Icons.payments,
            Colors.purpleAccent,
          ),
        ),

        Expanded(
          child: _summaryCard(
            "Interest",
            "${_loan.interestRate}%",
            Icons.percent,
            Colors.green,
          ),
        ),

        Expanded(
          child: _summaryCard(
            "Principal (Total Payable)",
            "GHS ${_loan.totalAmount}",
            Icons.payments,
            Colors.blue,
          ),
        ),

        Expanded(
          child: _summaryCard(
            "Outstanding",
            "GHS ${amountRemaining.toStringAsFixed(2)}",
            Icons.account_balance,
            Colors.orange,
          ),
        ),

        Expanded(
          child: _summaryCard(
            "Duration",
            "${_loan.duration} Months",
            Icons.timer,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          CustomText(value, fontWeight: FontWeight.bold, fontSize: 18),
          CustomText(title, textColor: Colors.grey),
        ],
      ),
    );
  }

  // ================= BORROWER =================
  Widget _borrowerInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.green.shade100,
            child: Icon(Icons.person, color: Colors.green.shade700),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  _loan.studentName,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),

                SizedBox(height: 6),

                CustomText(_loan.studentId, textColor: Colors.grey),
                CustomText(
                  "University of Energy and Natural Resources",
                  textColor: Colors.grey,
                ),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: () => SharedFunctions.handleOpenStudentProfile(
              context,
              studentId: _loan.studentId,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade50,
            ),
            child: CustomText('View Profile', textColor: Colors.green.shade700),
          ),
        ],
      ),
    );
  }

  // ================= BREAKDOWN =================
  Widget _loanBreakdown() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            "Loan Breakdown",
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),

          const SizedBox(height: 16),

          _row("Loan Amount", "GHS ${_loan.approvedAmount}"),
          _row("Interest Rate", "${_loan.interestRate}%"),
          _row("Total Payable", "GHS ${_loan.totalAmount}"),

          //TODO: add these fields later.
          _row("Paid So Far", "GHS ${_loan.amountPaid}"),
          _row("Remaining", "GHS ${_loan.amountRemaing}"),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: CustomText(label, textColor: Colors.grey)),
          CustomText(value, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }

  // ================= REPAYMENT =================
  Widget _repaymentSchedule() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            "Loan Payments",
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),

          const SizedBox(height: 16),

          if (loadedState!.loanPayments.isEmpty)
            SizedBox(
              height: 200,
              child: MessagePlaceholder(
                icon: CupertinoIcons.cube_box,
                iconColor: Colors.green.shade700,
                message: 'No repayments yet',
              ),
            ),

          if (loadedState!.loanPayments.isEmpty)
            Table(
              border: TableBorder.all(color: Colors.grey.shade200),
              children: [
                _tableRow(["Month", "Amount", "Status"]),

                _tableRow(["Jan", "GHS 800", "Paid"]),
                _tableRow(["Feb", "GHS 800", "Paid"]),
                _tableRow(["Mar", "GHS 800", "Pending"]),
                _tableRow(["Apr", "GHS 800", "Pending"]),
              ],
            ),
        ],
      ),
    );
  }

  TableRow _tableRow(List<String> data) {
    return TableRow(
      children: data
          .map(
            (e) => Padding(
              padding: const EdgeInsets.all(10),
              child: CustomText(e),
            ),
          )
          .toList(),
    );
  }

  // ================= ADMIN ACTIONS =================
  Widget _adminActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            "Admin Actions",
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),

          const SizedBox(height: 16),

          Column(
            spacing: 8,
            children: [
              _actionButton(
                onPressed: () {
                   showDialog(
                      context: context,
                      builder: (_) => ManualPaymentDialog(loan: _loan),
                    );
                },
                title: "Record Manual Payment",
                icon: Icons.payment,
                color: Colors.green,
              ),

              _actionButton(
                onPressed: () =>
                    SharedFunctions.handleMarkAsCompleted(context, loan: _loan),
                title: "Mark Completed",
                icon: Icons.check_circle,
                color: Colors.blue,
              ),

              if (_loan.status == 'awaiting_disbursement')
                _actionButton(
                  icon: Icons.payments_rounded,
                  title: 'Disburse Amount',
                  color: Colors.blue.shade700,
                  onPressed: () =>
                      SharedFunctions.handleDisbursement(context, loan: _loan),
                ),

              // _actionButton("Restructure Loan", Icons.edit, Colors.orange),
              //_actionButton("Generate Report", Icons.bar_chart, Colors.purple),
              //_actionButton("Download Agreement", Icons.download, Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(title),
    );
  }
}
