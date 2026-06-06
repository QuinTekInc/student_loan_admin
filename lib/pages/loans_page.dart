import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/navigation_bloc.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/pages/loan_management/details_page.dart';
import 'package:loan_admin/pages/loan_management/manual_payment_page.dart';
import 'package:loan_admin/pages/loan_management/payment_history.dart';
import 'package:loan_admin/pages/loan_management/repayment_schedule.dart';

class LoansPage extends StatelessWidget {
  const LoansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          HeaderText("Loans Management"),

          const SizedBox(height: 24),

          _buildStatistics(),

          const SizedBox(height: 24),

          _buildFilters(),

          const SizedBox(height: 24),

          _buildLoansTable(context),
        ],
      ),
    );
  }

  // ================= TABLE =================
  Widget _buildLoansTable(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [

          _tableHeader(),

          const Divider(height: 30),

          ...List.generate(
            10,
                (index) => _loanRow(context, index),
          ),
        ],
      ),
    );
  }

  Widget _loanRow(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [

          const Expanded(
            flex: 2,
            child: CustomText("LN-1001"),
          ),

          const Expanded(
            flex: 3,
            child: CustomText("Quin Sefalloyd"),
          ),

          const Expanded(
            flex: 2,
            child: CustomText("GHS 18,000"),
          ),

          const Expanded(
            flex: 2,
            child: CustomText("GHS 12,500"),
          ),

          const Expanded(
            flex: 2,
            child: CustomText("12%"),
          ),

          const Expanded(
            flex: 2,
            child: CustomText("24 Months"),
          ),

          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: CustomText(
                  "Active",
                  textColor: Colors.green,
                ),
              ),
            ),
          ),

          const Expanded(
            flex: 2,
            child: CustomText("15 Jul 2026"),
          ),

          Expanded(
            flex: 2,
            child: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showLoanActions(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================= ACTION SHEET =================
  void _showLoanActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) => LoanActionsSheet()
    );
  }

  // ================= ACTION TILE =================


  // ================= STATS (UNCHANGED) =================
  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(child: _statCard("Total Loans", "1,248", Icons.account_balance, Colors.blue)),
        const SizedBox(width: 16),
        Expanded(child: _statCard("Active", "918", Icons.check_circle, Colors.green)),
        const SizedBox(width: 16),
        Expanded(child: _statCard("Completed", "287", Icons.task_alt, Colors.orange)),
        const SizedBox(width: 16),
        Expanded(child: _statCard("Defaulted", "43", Icons.warning, Colors.red)),
      ],
    );
  }

  // ================= FILTERS (UNCHANGED) =================
  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search loans...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xffF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          //TODO: add a drop down to handle filtering loans by the loan status.
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return const Row(
      children: [
        Expanded(flex: 2, child: CustomText("Loan ID", fontWeight: FontWeight.bold)),
        Expanded(flex: 3, child: CustomText("Student", fontWeight: FontWeight.bold)),
        Expanded(flex: 2, child: CustomText("Amount", fontWeight: FontWeight.bold)),
        Expanded(flex: 2, child: CustomText("Outstanding", fontWeight: FontWeight.bold)),
        Expanded(flex: 2, child: CustomText("Interest", fontWeight: FontWeight.bold)),
        Expanded(flex: 2, child: CustomText("Duration", fontWeight: FontWeight.bold)),
        Expanded(flex: 2, child: CustomText("Status", fontWeight: FontWeight.bold)),
        Expanded(flex: 2, child: CustomText("Next Payment", fontWeight: FontWeight.bold)),
        Expanded(flex: 2, child: CustomText("Actions", fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(value, fontWeight: FontWeight.bold, fontSize: 18),
              CustomText(title, textColor: Colors.grey),
            ],
          )
        ],
      ),
    );
  }
}




class LoanActionsSheet extends StatelessWidget {
  const LoanActionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          HeaderText("Loan Actions"),

          const SizedBox(height: 16),

          _actionTile(
            icon: Icons.visibility_outlined,
            title: "View Loan Details",
            onTap: () {
              Navigator.pop(context); //close the modal dialog.
              context.read<NavigationCubit>().push(LoanDetailPage(loanId: '12334567'));
            },
          ),

          _actionTile(
            icon: Icons.schedule_outlined,
            title: "Repayment Schedule",
            onTap: () {
              context.read<NavigationCubit>().push(RepaymentSchedulePage(loanId: '1234567'));
            },
          ),

          _actionTile(
            icon: Icons.person_outline,
            title: "View Borrower Profile",
            onTap: () {},
          ),

          _actionTile(
            icon: Icons.history,
            title: "Payment History",
            onTap: () {
              Navigator.pop(context); //close the modal sheet.
              context.read<NavigationCubit>().push(PaymentHistoryPage(loanId: '1234567',));
            },
          ),

          _actionTile(
            icon: Icons.payment_outlined,
            title: "Record Manual Payment",
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) => ManualPaymentDialog(outstandingAmount: 1000)
              );
            },
          ),

          _actionTile(
            icon: Icons.check_circle_outline,
            title: "Mark as Completed",
            onTap: handleMarkAsCompleted,
          ),

          _actionTile(
            icon: Icons.edit_outlined,
            title: "Restructure Loan",
            onTap: () {},
          ),

          _actionTile(
            icon: Icons.download_outlined,
            title: "Download Loan Agreement",
            onTap: () {},
          ),
        ],
      ),
    );
  }


  Widget _actionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: CustomText(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }


  void handleMarkAsCompleted(){

  }



}
