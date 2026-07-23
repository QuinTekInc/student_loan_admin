import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/dashboard_bloc.dart';
import 'package:loan_admin/components/app_colors.dart';
import 'package:loan_admin/components/placeholders.dart';
import 'package:loan_admin/models/models.dart';
import 'package:loan_admin/pages/notifications_page.dart';

import '../components/text.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (_, state) {
          if (state is DashboardLoading) {
            return Center(child: LoadingPlaceholder());
          }

          if (state is DashboardError) {
            return Center(
              child: MessagePlaceholder.error(
                message: state.message,
                onButtonPressed: () =>
                    context.read<DashboardCubit>().fetchDashboardData(),
              ),
            );
          }

          return _buildContent();
        },
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        spacing: 12,
        children: [
          buildAdminWelcome(),

          buildAdminStats(),

          buildAdminMiddle(),

          buildAdminBottom(),
        ],
      ),
    );
  }

  Widget buildAdminWelcome() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade700, Colors.green.shade500],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderText(
                  "Admin Dashboard 👨‍💼",
                  fontSize: 28,
                  textColor: Colors.white,
                ),
                SizedBox(height: 10),
                CustomText(
                  "Manage student loans, applications, and platform activity.",
                  textColor: Colors.white70,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAdminStats() {
    final stats = (context.read<DashboardCubit>().state as DashboardLoaded)
        .dashboardModel
        .dashboardStats;

    final statCards = [
      DashboardStatCard(
        title: "Total Users",
        value: stats.totalStudents.toString(),
        subtitle: "Registered students",
        icon: Icons.people_outline,
      ),

      DashboardStatCard(
        title: "Pending Applications",
        value: "56",
        subtitle: "Awaiting approval",
        icon: Icons.pending_actions_outlined,
      ),

      DashboardStatCard(
        title: "Active Loans",
        value: stats.totalActiveLoans.toString(),
        subtitle: "Currently running",
        icon: Icons.account_balance_wallet_outlined,
      ),

      DashboardStatCard(
        title: "Total Disbursed",
        value: "GHS ${stats.totalDisbursed}",
        subtitle: "Loans issued",
        icon: Icons.trending_up,
      ),

      // DashboardStatCard(
      //   title: '',
      //   value: 'GHS 0.00',
      //   subtitle: 'Amounts paid out the loans issued',
      //   icon: Icons.payment
      // )
    ];

    return GridView.builder(
      itemCount: statCards.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (_, index) => buildStatCard(statCards[index]),
    );
  }

  Widget buildStatCard(DashboardStatCard item) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0E000000),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(item.icon, color: Colors.green.shade700),
          ),
          const Spacer(),
          CustomText(item.title, textColor: Colors.black54),
          const SizedBox(height: 6),
          CustomText(item.value, fontSize: 24, fontWeight: FontWeight.bold),
          const SizedBox(height: 6),
          CustomText(item.subtitle, fontSize: 13),
        ],
      ),
    );
  }

  Widget buildAdminMiddle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: buildRecentApplications()),
        const SizedBox(width: 18),
        Expanded(child: buildAdminActions()),
      ],
    );
  }

  Widget buildAdminActions() {
    final actions = [
      (Icons.check_circle_outline, "Approve Loans"),
      (Icons.cancel_outlined, "Reject Applications"),
      (Icons.notifications_outlined, "Send Notifications"),
      (Icons.file_download_outlined, "Generate Reports"),
    ];

    return dashboardCard(
      title: "Admin Actions",
      child: Column(
        children: actions.map((item) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(item.$1, color: Colors.green.shade700),
            title: CustomText(item.$2),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          );
        }).toList(),
      ),
    );
  }

  Widget buildRecentApplications() {
    final recent_applications =
        (context.read<DashboardCubit>().state as DashboardLoaded)
            .dashboardModel
            .recentApplications;

    return dashboardCard(
      title: "Recent Applications",
      child: Column(
        children: recent_applications.map((app) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child: CustomText(
                app.studentName[0],
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            title: CustomText(
              app.studentName,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              padding: EdgeInsets.zero,
            ),
            subtitle: RichText(  
              text: TextSpan(  
                text: 'GHS ${app.amountRequested}\t',
                style: TextStyle( 
                  fontSize: 13, 
                  color: Colors.blue,
                  fontWeight: FontWeight.w600, 
                  fontFamily: 'Poppins'
                ), 

                children: [
                  TextSpan(  
                    text: '\u2022 ${app.loanReason}\t',
                    style: TextStyle( 
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.normal
                    )
                  ),


                  //TODO: add apply the status color here.
                  TextSpan(  
                    text: '\u2022 ${app.status}',
                    style: TextStyle( 
                      color: applicationStatusColor(app.status),
                      fontWeight: FontWeight.w600
                    )
                  )
                ]
                
              ),
            ),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          );
        }).toList(),
      ),
    );
  }

  Widget buildAdminBottom() {

    final auditLogs = 
        (context.read<DashboardCubit>().state as DashboardLoaded)
            .dashboardModel
            .auditLogs;

    return dashboardCard(
      title: "System Activity",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: auditLogs.map((auditLog) => ListTile(  
          leading: Icon(
            Icons.history, 
            fontWeight: FontWeight.bold, 
            size: 30,
            color: Colors.grey.shade600,
          ),

          title: CustomText( 
            auditLog.action,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),

          subtitle: Column(  
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              CustomText(
                auditLog.description
              ), 
              CustomText( 
                formatDate(auditLog.createdAt),
                fontStyle: FontStyle.italic,
              )
            ],
          ),
        )).toList()
        
      ),
    );
  }

  Widget dashboardCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0E000000),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderText(title, fontSize: 19),
          const SizedBox(height: 22),
          child,
        ],
      ),
    );
  }
}

class DashboardStatCard {
  IconData icon;
  String title;
  String subtitle;
  String value;

  DashboardStatCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
  });
}
