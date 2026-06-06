
import 'package:flutter/material.dart';
import 'package:loan_admin/bloc/navigation_bloc.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/models/models.dart';
import 'package:loan_admin/pages/application_management/loan_review.page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoanApplicationPage extends StatefulWidget {

  const LoanApplicationPage({super.key});

  @override
  State<LoanApplicationPage> createState() => _LoanApplicationPageState();
}

class _LoanApplicationPageState extends State<LoanApplicationPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          HeaderText(
            "Loan Applications",
            fontSize: 30
          ),

          const SizedBox(height: 8),

          CustomText(
            "Review and manage student loan applications.",
            textColor: Colors.black54,
            fontSize: 15,
          ),

          const SizedBox(height: 24),

          _buildStatistics(),

          const SizedBox(height: 24),

          _buildFilters(),

          const SizedBox(height: 24),

          _buildApplicationsTable(),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            "Pending Review",
            "42",
            Icons.pending_actions_outlined,
            Colors.orange,
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: _buildStatCard(
            "Approved",
            "128",
            Icons.check_circle_outline,
            Colors.green,
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: _buildStatCard(
            "Rejected",
            "19",
            Icons.cancel_outlined,
            Colors.red,
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: _buildStatCard(
            "Disbursed",
            "97",
            Icons.payments_outlined,
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(.12),
            child: Icon(icon, color: color),
          ),

          const SizedBox(width: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CustomText(
                value,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),

              CustomText(
                title,
                textColor: Colors.black54,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search applications...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xffF5F7FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 18),

          SizedBox(
            width: 180,
            child: DropdownButtonFormField<String>(
              value: "All",
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xffF5F7FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: "All",
                  child: Text("All Statuses"),
                ),
                DropdownMenuItem(
                  value: "Pending",
                  child: Text("Pending"),
                ),
                DropdownMenuItem(
                  value: "Approved",
                  child: Text("Approved"),
                ),
                DropdownMenuItem(
                  value: "Rejected",
                  child: Text("Rejected"),
                ),
              ],
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationsTable() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(
                flex: 2,
                child: CustomText(
                  "Application ID",
                ),
              ),
              Expanded(
                flex: 3,
                child: CustomText(
                  "Student",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 3,
                child: CustomText(
                  "Institution",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 2,
                child: CustomText(
                  "Amount",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 2,
                child: CustomText(
                  "Status",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 2,
                child: CustomText(
                  "Actions",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const Divider(height: 30),

          ...List.generate(
            8,
            (index) => _applicationRow(),
          )
        ],
      ),
    );
  }

  Widget _applicationRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: CustomText("APP-2026-001"),
          ),

          const Expanded(
            flex: 3,
            child: CustomText("Quin Sefalloyd"),
          ),

          const Expanded(
            flex: 3,
            child: CustomText(
              "University of Energy and Natural Resources",
            ),
          ),

          const Expanded(
            flex: 2,
            child: CustomText("GHS 18,000"),
          ),

          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(30),
              ),
              child: CustomText(
                "Pending",
                textAlignment: TextAlign.center,
                textColor: Colors.orange.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Row(
              children: [

                IconButton(
                  icon: const Icon(Icons.visibility_outlined),
                  onPressed: () => context.read<NavigationCubit>().push(LoanApplicationReview(
                    application: LoanApplication(
                      applicationId: '121434-12232345',
                      studentId: '121434-12232345',
                      status: 'pending',
                      amountRequested: 1500,
                      loanReason: 'To Pay off hostel Bills',
                      createdAt: DateTime.now()),
                    )
                  ),
                ),


                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}