
import 'package:flutter/material.dart';
import 'package:loan_admin/components/text.dart';

class AdminUserProfilePage extends StatelessWidget {
  const AdminUserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          HeaderText("Administrator Profile"),

          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                flex: 2,
                child: _personalInformationCard(),
              ),

              const SizedBox(width: 20),

              Expanded(
                child: _roleCard(),
              ),
            ],
          ),

          const SizedBox(height: 20),

          _statisticsCard(),

          const SizedBox(height: 20),

          _recentActivityCard(),

          const SizedBox(height: 20),

          _loginHistoryCard(),

          const SizedBox(height: 20),

          _securityCard(),
        ],
      ),
    );
  }

  Widget _personalInformationCard() {
    return _sectionCard(
      "Personal Information",
      Column(
        children: [

          Row(
            children: [

              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green.shade100,
                child: const Icon(
                  Icons.admin_panel_settings,
                  size: 40,
                ),
              ),

              const SizedBox(width: 16),

              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  CustomText(
                    "Kwame Mensah",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),

                  SizedBox(height: 4),

                  CustomText(
                    "ADM-001",
                    textColor: Colors.grey,
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

              _infoTile("Email", "kwame@loanboard.gov.gh"),
              _infoTile("Phone", "+233 24 000 0000"),
              _infoTile("Department", "Loan Processing"),
              _infoTile("Position", "Senior Loan Officer"),
              _infoTile("Joined", "12 Jan 2023"),
              _infoTile("Status", "Active"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roleCard() {
    return _sectionCard(
      "Role & Permissions",
      Column(
        children: [

          _permissionTile("Loan Application Review"),
          _permissionTile("Approve Applications"),
          _permissionTile("Reject Applications"),
          _permissionTile("Manage Students"),
          _permissionTile("View Reports"),
          _permissionTile("Manage Documents"),
        ],
      ),
    );
  }

  Widget _statisticsCard() {
    return _sectionCard(
      "Account Statistics",
      Row(
        children: [

          Expanded(
            child: _statCard(
              "Applications Reviewed",
              "1,245",
              Icons.description_outlined,
              Colors.blue,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: _statCard(
              "Approved",
              "962",
              Icons.check_circle_outline,
              Colors.green,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: _statCard(
              "Rejected",
              "283",
              Icons.cancel_outlined,
              Colors.red,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: _statCard(
              "Years Active",
              "3",
              Icons.timeline_outlined,
              Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentActivityCard() {
    return _sectionCard(
      "Recent Activity",
      Column(
        children: [

          _activityTile(
            "Approved Application APP-2026-001",
            "Today, 09:45 AM",
          ),

          _activityTile(
            "Reviewed Student Documents",
            "Today, 08:12 AM",
          ),

          _activityTile(
            "Rejected Application APP-2026-008",
            "Yesterday",
          ),

          _activityTile(
            "Updated User Permissions",
            "2 Days Ago",
          ),
        ],
      ),
    );
  }

  Widget _loginHistoryCard() {
    return _sectionCard(
      "Recent Login History",
      Column(
        children: [

          _loginTile(
            "Accra, Ghana",
            "Chrome on Windows",
            "Today 08:00 AM",
          ),

          _loginTile(
            "Accra, Ghana",
            "Chrome on Ubuntu",
            "Yesterday",
          ),

          _loginTile(
            "Accra, Ghana",
            "Microsoft Edge",
            "3 Days Ago",
          ),
        ],
      ),
    );
  }

  Widget _securityCard() {
    return _sectionCard(
      "Security",
      Row(
        children: [

          Expanded(
            child: ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text("Password"),
              subtitle: const Text("Last changed 30 days ago"),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text("Change"),
              ),
            ),
          ),

          Expanded(
            child: ListTile(
              leading: const Icon(Icons.security_outlined),
              title: const Text("Two Factor Authentication"),
              subtitle: const Text("Enabled"),
              trailing: Switch(
                value: true,
                onChanged: (_) {},
              ),
            ),
          ),
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
        children: [

          HeaderText(title),

          const SizedBox(height: 18),

          child,
        ],
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

          CustomText(
            title,
            textColor: Colors.grey,
          ),

          const SizedBox(height: 4),

          CustomText(
            value,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _permissionTile(String permission) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [

          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 18,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: CustomText(permission),
          ),
        ],
      ),
    );
  }

  Widget _activityTile(String title, String time) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.history),
      title: CustomText(title),
      subtitle: CustomText(
        time,
        textColor: Colors.grey,
      ),
    );
  }

  Widget _loginTile(
      String location,
      String device,
      String time,
      ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.login),
      title: CustomText(location),
      subtitle: CustomText("$device • $time"),
    );
  }

  Widget _statCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [

          Icon(
            icon,
            color: color,
          ),

          const SizedBox(height: 10),

          CustomText(
            value,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            textColor: color,
          ),

          const SizedBox(height: 4),

          CustomText(
            title,
            textColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}