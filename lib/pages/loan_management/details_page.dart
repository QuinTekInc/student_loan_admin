import 'package:flutter/material.dart';
import 'package:loan_admin/components/text.dart';

class LoanDetailPage extends StatelessWidget {
  final String loanId;

  const LoanDetailPage({
    super.key,
    required this.loanId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            HeaderText('Loan Detail'),

            const SizedBox(height: 20,),

            // ================= LOAN HEADER =================
            _loanHeader(),

            const SizedBox(height: 20),

            // ================= SUMMARY CARDS =================
            _summaryCards(),

            const SizedBox(height: 20),

            // ================= BORROWER INFO =================
            _borrowerInfo(),

            const SizedBox(height: 20),

            // ================= LOAN BREAKDOWN =================
            _loanBreakdown(),

            const SizedBox(height: 20),

            // ================= REPAYMENT SCHEDULE =================
            _repaymentSchedule(),

            const SizedBox(height: 20),

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
              children: const [

                CustomText(
                  "Loan ID",
                  textColor: Colors.grey,
                ),

                SizedBox(height: 6),

                CustomText(
                  "LN-1001",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const CustomText(
              "ACTIVE",
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
    return Row(
      children: [
        Expanded(child: _summaryCard("Principal", "GHS 18,000", Icons.payments, Colors.blue)),
        const SizedBox(width: 12),
        Expanded(child: _summaryCard("Outstanding", "GHS 12,500", Icons.account_balance, Colors.orange)),
        const SizedBox(width: 12),
        Expanded(child: _summaryCard("Interest", "12%", Icons.percent, Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _summaryCard("Duration", "24 Months", Icons.timer, Colors.purple)),
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
  Widget _borrowerInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [

          const CircleAvatar(
            radius: 30,
            child: Icon(Icons.person),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [

                CustomText(
                  "Quin Sefalloyd",
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),

                SizedBox(height: 6),

                CustomText("STU-2026-001", textColor: Colors.grey),
                CustomText("University of Energy and Natural Resources",
                    textColor: Colors.grey),
              ],
            ),
          ),

          ElevatedButton(
            onPressed: () {},
            child: const Text("View Profile"),
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

          _row("Loan Amount", "GHS 18,000"),
          _row("Interest Rate", "12%"),
          _row("Total Payable", "GHS 20,160"),
          _row("Paid So Far", "GHS 7,660"),
          _row("Remaining", "GHS 12,500"),
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