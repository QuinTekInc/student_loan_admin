import 'package:flutter/material.dart';
import 'package:loan_admin/bloc/applications_bloc.dart';
import 'package:loan_admin/bloc/navigation_bloc.dart';
import 'package:loan_admin/components/app_colors.dart';
import 'package:loan_admin/components/placeholders.dart';
import 'package:loan_admin/components/shared_functions.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/models/models.dart';
import 'package:loan_admin/pages/application_management/loan_review.page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/pages/dialogs/application_approval_dialog.dart';
import 'package:loan_admin/pages/dialogs/application_rejection_dialog.dart';
import 'package:loan_admin/pages/dialogs/notification_dialog.dart';

class LoanApplicationPage extends StatefulWidget {
  const LoanApplicationPage({super.key});

  @override
  State<LoanApplicationPage> createState() => _LoanApplicationPageState();
}

class _LoanApplicationPageState extends State<LoanApplicationPage> {
  final searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    context.read<LoanApplicationsCubit>().fetchLoanApplications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FragementHeader(
            title: 'Loan Applications',
            subtitle: 'Review and Manage loan applications',
          ),

          Expanded(
            child: BlocBuilder<LoanApplicationsCubit, LoanApplicationsState>(
              builder: (_, state) {
                if (state is LoanApplicationsLoading) {
                  return LoadingPlaceholder();
                }

                if (state is LoanApplicationsError) {
                  return MessagePlaceholder.error(
                    message: state.message,
                    onButtonPressed: () => context
                        .read<LoanApplicationsCubit>()
                        .fetchLoanApplications(),
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
        children: [
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
    LoanApplicationsLoaded appsLoaded =
        context.read<LoanApplicationsCubit>().state as LoanApplicationsLoaded;

    return Row(
      spacing: 16,
      children: [
        Expanded(
          child: _buildStatCard(
            "Pending Review",
            appsLoaded.pendingApplicationCount.toString(),
            Icons.pending_actions_outlined,
            Colors.blue,
          ),
        ),

        Expanded(
          child: _buildStatCard(
            "Under Review",
            appsLoaded.reviewApplicationCount.toString(),
            Icons.pending_actions_outlined,
            Colors.deepPurple,
          ),
        ),

        Expanded(
          child: _buildStatCard(
            "Approved",
            appsLoaded.approvedApplicationCount.toString(),
            Icons.check_circle_outline,
            Colors.green,
          ),
        ),

        Expanded(
          child: _buildStatCard(
            "Rejected",
            appsLoaded.rejectedApplicationCount.toString(),
            Icons.cancel_outlined,
            Colors.red,
          ),
        ),

        Expanded(
          child: _buildStatCard(
            "Unknown",
            appsLoaded.unknownApplicationCount.toString(),
            Icons.warning_outlined,
            Colors.orange,
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
          ),
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
              CustomText(value, fontSize: 24, fontWeight: FontWeight.bold),

              CustomText(title, textColor: Colors.black54),
            ],
          ),
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
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
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
                DropdownMenuItem(value: "All", child: Text("All Statuses")),
                DropdownMenuItem(value: "Pending", child: Text("Pending")),
                DropdownMenuItem(value: "Approved", child: Text("Approved")),
                DropdownMenuItem(value: "Rejected", child: Text("Rejected")),
              ],
              onChanged: (_) {
                //TODO: Program the sorting.
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationsTable() {
    final loanApplications =
        (context.read<LoanApplicationsCubit>().state as LoanApplicationsLoaded)
            .applications;

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
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(flex: 2, child: CustomText("Application ID")),
              Expanded(
                flex: 3,
                child: CustomText("Student", fontWeight: FontWeight.bold),
              ),
              Expanded(
                flex: 3,
                child: CustomText("Institution", fontWeight: FontWeight.bold),
              ),
              Expanded(
                flex: 2,
                child: CustomText("Amount", fontWeight: FontWeight.bold),
              ),
              Expanded(
                flex: 2,
                child: CustomText("Status", fontWeight: FontWeight.bold),
              ),
              Expanded(
                flex: 1,
                child: CustomText("Actions", fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const Divider(height: 30),

          ...List.generate(
            loanApplications.length,
            (index) =>
                LoanApplicationCell(loanApplication: loanApplications[index]),
          ),
        ],
      ),
    );
  }
}

class LoanApplicationCell extends StatelessWidget {
  final LoanApplication loanApplication;

  const LoanApplicationCell({super.key, required this.loanApplication});

  @override
  Widget build(BuildContext context) {
    final statusColor = applicationStatusColor(loanApplication.status);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          //==========Loan Application ID==========
          Expanded(
            flex: 2,
            child: CustomText(
              loanApplication.applicationId,
              maxLines: 1,
              softwrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          //============Student Name=================
          Expanded(flex: 3, child: CustomText(loanApplication.studentName)),

          //============Institution=================
          Expanded(
            flex: 3,
            child: CustomText("University of Energy and Natural Resources"),
          ),

          //============Amount Requested=================
          Expanded(
            flex: 2,
            child: CustomText(
              loanApplication.amountRequested.toStringAsFixed(2),
            ),
          ),

          //============Application Status=================
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(.12),
                borderRadius: BorderRadius.circular(30),
              ),
              child: CustomText(
                loanApplication.status,
                textAlignment: TextAlign.center,
                textColor: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          //============Actions=================
          Expanded(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility_outlined),
                  onPressed: () => context.read<NavigationCubit>().push(
                    BlocProvider(
                      create: (_) => ReviewCubit(loanApplication),
                      child: LoanApplicationReview(),
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (_) =>
                        _LoanApplicationSheet(application: loanApplication),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoanApplicationSheet extends StatelessWidget {
  final LoanApplication application;

  const _LoanApplicationSheet({required this.application});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,

      decoration: const BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),

      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Center(
              child: Container(
                width: 80,
                height: 6,

                decoration: BoxDecoration(
                  color: Colors.grey.shade300,

                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Container(
                  height: 60,
                  width: 60,

                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),

                  child: Icon(Icons.description, color: Colors.green.shade700),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      HeaderText("Loan Application"),

                      const SizedBox(height: 4),

                      CustomText(
                        application.applicationId,
                        textColor: Colors.grey,
                      ),

                      const SizedBox(height: 4),

                      CustomText(application.studentName),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,

                    borderRadius: BorderRadius.circular(50),
                  ),

                  child: CustomText(
                    application.status,
                    textColor: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Expanded(
              child: GridView.count(
                crossAxisCount: 3,

                crossAxisSpacing: 16,

                mainAxisSpacing: 16,

                childAspectRatio: 2.5,

                children: [
                  _action(
                    context,
                    icon: Icons.visibility,
                    title: "View Application",
                    onTap: () async {},
                  ),

                  // _action(
                  //   context,
                  //   icon: Icons.fact_check,
                  //   title: "Review",
                  //   onTap: () {},
                  // ),
                  if (!['approved', 'rejected'].contains(application.status))
                    _action(
                      context,
                      icon: Icons.check_circle,
                      title: "Approve",
                      color: Colors.green,
                      onTap: () => handleApproveApplication(context),
                    ),

                  if (!['approved', 'rejected'].contains(application.status))
                    _action(
                      context,
                      icon: Icons.cancel,
                      title: "Reject",
                      color: Colors.red,
                      onTap: () => handleRejectApplication(context),
                    ),

                  // _action(
                  //   context,
                  //   icon:
                  //   Icons.folder,
                  //   title:
                  //   "Documents",
                  //   onTap: () {},
                  // ),

                  // _action(
                  //   context,
                  //   icon:
                  //   Icons.psychology,
                  //   title:
                  //   "AI Scan",
                  //   onTap: () {},
                  // ),
                  _action(
                    context,
                    icon: Icons.person,
                    title: "Student",
                    onTap: () => SharedFunctions.handleOpenStudentProfile(
                      context,
                      studentId: application.studentId,
                    ),
                  ),

                  _action(
                    context,
                    icon: Icons.notifications,
                    title: "Notify",
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => NotifyUserDialog.student(
                        studentId: application.studentId,
                        fullName: application.studentName,
                      ),
                    ),
                  ),

                  //TODO: if the current user of the system in superuser,
                  //we give them the option to delete the application

                  // _action(
                  //   context,
                  //   icon: Icons.delete,
                  //   title: "Delete",
                  //   color: Colors.red,
                  //   onTap: () {},
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _action(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.green,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),

      onTap: () {
        Navigator.pop(context);

        onTap();
      },

      child: Container(
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: color.withOpacity(.08),

          borderRadius: BorderRadius.circular(18),
        ),

        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,

              decoration: BoxDecoration(
                color: color.withOpacity(.15),

                shape: BoxShape.circle,
              ),

              child: Icon(icon, color: color),
            ),

            const SizedBox(width: 14),

            Expanded(child: CustomText(title, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void handleApproveApplication(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider(
        create: (_) => ReviewCubit(application),
        child: LoanApprovalDialog(),
      ),
    );
  }

  void handleRejectApplication(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider(
        create: (_) => ReviewCubit(application),
        child: RejectLoanApplicationDialog(),
      ),
    );
  }
}
