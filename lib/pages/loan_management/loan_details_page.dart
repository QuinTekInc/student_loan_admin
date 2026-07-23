import 'package:flutter/material.dart';
import 'package:loan_admin/components/shared_functions.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/models/models.dart';

class LoanDetailPage extends StatelessWidget {
  final Loan loan;
  const LoanDetailPage({super.key, required this.loan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            
            FragementHeader(
              title: 'Loan Detail',
            ),

            // ================= LOAN HEADER =================
            _loanHeader(),

            // ================= SUMMARY CARDS =================
            _summaryCards(),

            // ================= BORROWER INFO =================
            _borrowerInfo(context),

            // ================= LOAN BREAKDOWN =================
            _loanBreakdown(),

            // ================= REPAYMENT SCHEDULE =================
            _repaymentSchedule(),

            // ================= ADMIN ACTIONS =================
            _adminActions(),
          ],
        ),
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
                  loan.loanId,
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
              loan.status.toUpperCase(),
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

    if (['active', 'disbursed'].contains(loan.status.toLowerCase())) {
      amountRemaining = loan.amountRemaing;
    }

    return Row(
      spacing: 12,
      children: [

        Expanded(
          child: _summaryCard(
            "Approved Amount",
            "GHS ${loan.approvedAmount}",
            Icons.payments,
            Colors.purpleAccent,
          ),
        ),


        Expanded(
          child: _summaryCard(
            "Interest",
            "${loan.interestRate}%",
            Icons.percent,
            Colors.green,
          ),
        ),

        Expanded(
          child: _summaryCard(
            "Principal (Total Payable)",
            "GHS ${loan.totalAmount}",
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
            "${loan.duration} Months",
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
            child: Icon(Icons.person, color: Colors.green.shade700)
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  loan.studentName,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),

                SizedBox(height: 6),

                CustomText(loan.studentId, textColor: Colors.grey),
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
              studentId: loan.studentId
            ), 
            style: ElevatedButton.styleFrom(  
              backgroundColor: Colors.green.shade50
            ),
            child: CustomText('View Profile', textColor: Colors.green.shade700,)
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

          _row("Loan Amount", "GHS ${loan.approvedAmount}"),
          _row("Interest Rate", "${loan.interestRate}%"),
          _row("Total Payable", "GHS ${loan.totalAmount}"),

          //TODO: add these fields later.
          _row("Paid So Far", "GHS ${loan.amountPaid}"),
          _row("Remaining", "GHS ${loan.amountRemaing}"),
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
            "Repayment Schedule",
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),

          const SizedBox(height: 16),

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

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _actionButton("Record Payment", Icons.payment, Colors.green),
              _actionButton("Restructure Loan", Icons.edit, Colors.orange),
              _actionButton("Mark Completed", Icons.check_circle, Colors.blue),
              _actionButton("Generate Report", Icons.bar_chart, Colors.purple),
              _actionButton("Download Agreement", Icons.download, Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(String title, IconData icon, Color color) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
      ),
      onPressed: () {},
      icon: Icon(icon),
      label: Text(title),
    );
  }
}
