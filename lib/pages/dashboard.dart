
import 'package:flutter/material.dart';


class DashboardPage extends StatefulWidget {

  DashboardPage({super.key});

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
      child: SingleChildScrollView(
        child: Column(
          spacing: 12,
          children: [

            buildAdminWelcome(),

            buildAdminStats(),

            buildAdminMiddle(),

            buildAdminBottom()
          ],
        ),
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
              children: const [
                Text(
                  "Admin Dashboard 👨‍💼",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Manage student loans, applications, and platform activity.",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget buildAdminStats() {
    final stats = [
      DashboardStat(
        title: "Total Users",
        value: "1,240",
        subtitle: "Registered students",
        icon: Icons.people_outline,
      ),
      DashboardStat(
        title: "Active Loans",
        value: "830",
        subtitle: "Currently running",
        icon: Icons.account_balance_wallet_outlined,
      ),
      DashboardStat(
        title: "Pending Applications",
        value: "56",
        subtitle: "Awaiting approval",
        icon: Icons.pending_actions_outlined,
      ),
      DashboardStat(
        title: "Total Disbursed",
        value: "GHS 2.4M",
        subtitle: "Loans issued",
        icon: Icons.trending_up,
      ),
    ];

    return GridView.builder(
      itemCount: stats.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (_, index) => buildStatCard(stats[index]),
    );
  }


  Widget buildStatCard(DashboardStat item) {
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
          )
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
          Text(
            item.title,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Text(
            item.value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.subtitle,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }


  Widget buildAdminMiddle() {

    return Row(
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
            title: Text(item.$2),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          );
        }).toList(),
      ),
    );
  }


  Widget buildRecentApplications() {
    final apps = [
      ("Kwame Mensah", "Pending"),
      ("Ama Serwaa", "Approved"),
      ("Kojo Asante", "Rejected"),
    ];

    return dashboardCard(
      title: "Recent Applications",
      child: Column(
        children: apps.map((app) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child: Text(app.$1[0]),
            ),
            title: Text(app.$1),
            subtitle: Text(app.$2),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          );
        }).toList(),
      ),
    );
  }



  Widget buildAdminBottom() {
    return dashboardCard(
      title: "System Activity",
      child: Column(
        children: [
          ListTile(
            title: Text("Loan approved for Ama Serwaa"),
            subtitle: Text("2 mins ago"),
          ),
          ListTile(
            title: Text("New user registered"),
            subtitle: Text("10 mins ago"),
          ),
          ListTile(
            title: Text("Payment received"),
            subtitle: Text("30 mins ago"),
          ),
        ],
      ),
    );
  }



  Widget dashboardCard({
    required String title,
    required Widget child,
  }) {
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
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 22),
          child,
        ],
      ),
    );
  }

}


class DashboardStat{
  IconData icon;
  String title;
  String subtitle;
  String value;

  DashboardStat({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value
  });
}