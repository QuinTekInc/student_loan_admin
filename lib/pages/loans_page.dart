import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/loans_bloc.dart';
import 'package:loan_admin/bloc/navigation_bloc.dart';
import 'package:loan_admin/components/placeholders.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/models/models.dart';
import 'package:loan_admin/pages/loan_management/details_page.dart';
import 'package:loan_admin/pages/loan_management/manual_payment_page.dart';
import 'package:loan_admin/pages/loan_management/payment_history.dart';
import 'package:loan_admin/pages/loan_management/repayment_schedule.dart';

class LoansPage extends StatefulWidget {
  const LoansPage({super.key});

  @override
  State<LoansPage> createState() => _LoansPageState();
}

class _LoansPageState extends State<LoansPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<LoansCubit>().fetchLoans();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [

          HeaderText("Loans Management"),


          Expanded(
            child: BlocBuilder<LoansCubit, LoansState>(
              builder: (context, state){

                if(state is LoansLoading){
                  return LoadingPlaceholder();
                }


                if(state is LoansError) {
                  return MessagePlaceholder.error(
                    message: state.message,
                    onButtonPressed: () => context.read<LoansCubit>().fetchLoans()
                  );
                }



                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    _buildStatistics(),

                    _buildFilters(),

                    Expanded(
                      child: _buildLoansTable(context),
                    ),
                  ],
                );
              }
            ),
          )

        ],
      ),
    );
  }

  // ================= TABLE =================
  Widget _buildLoansTable(BuildContext context) {

    LoansLoaded loaded = context.read<LoansCubit>().state as LoansLoaded;


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

          if(loaded.loans.isEmpty) Expanded(
            child: MessagePlaceholder(
              icon: CupertinoIcons.cube_box,
              iconColor: Colors.green.shade400,
              message: 'All Loans appear here',
            ),
          ),

          if(loaded.loans.isNotEmpty)Expanded(
            child: ListView.builder(
              itemCount: loaded.loans.length,
              itemBuilder: (context, index){
                return _loanRow(loaded.loans[index]);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _loanRow(Loan loan) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [


          //loan id
          Expanded(
            flex: 2,
            child: CustomText(loan.loanId),
          ),


          //student name
          Expanded(
            flex: 3,
            child: CustomText(loan.studentName),
          ),


          //loan amount
          Expanded(
            flex: 2,
            child: CustomText("GHS ${loan.totalAmount}"),
          ),

          //outstanding amount
          Expanded(
            flex: 2,
            child: CustomText("GHS ${loan.interestRate}"),
          ),

          //percentage
          Expanded(
            flex: 2,
            child: CustomText("${loan.totalAmount}%"),
          ),

          //duration
          Expanded(
            flex: 2,
            child: CustomText("${loan.duration} Months"),
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
  Widget _buildStatistics() {

    LoansLoaded loaded = context.read<LoansCubit>().state as LoansLoaded;

    return Row(
      children: [

        Expanded(
          child: _statCard("Total Loans", loaded.loans.length.toString(), Icons.account_balance, Colors.blue)
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _statCard("Active", loaded.activeLoansCount.toString(), Icons.check_circle, Colors.green)
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statCard("Completed", loaded.completedLoansCount.toString(), Icons.task_alt, Colors.orange)
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _statCard("Defaulted", "N/A", Icons.warning, Colors.red)
        ),
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
