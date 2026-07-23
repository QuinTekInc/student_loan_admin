import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/users_bloc.dart';
import 'package:loan_admin/components/placeholders.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/models/models.dart';
import 'package:loan_admin/pages/notifications_page.dart';

class AdminUserProfilePage extends StatefulWidget {
  const AdminUserProfilePage({super.key});

  @override
  State<AdminUserProfilePage> createState() => _AdminUserProfilePageState();
}

class _AdminUserProfilePageState extends State<AdminUserProfilePage> {
  late User user;

  @override
  void initState() {
    super.initState();

    user = context.read<UserProfileCubit>().user;

    context.read<UserProfileCubit>().fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          HeaderText("Administrator Profile"),

          Expanded(
            child: BlocBuilder<UserProfileCubit, UserProfileState>(
              builder: (_, state) {
                if (state is UserProfileLoading) {
                  return LoadingPlaceholder();
                }

                if (state is UserProfileError) {
                  return MessagePlaceholder.error(
                    message: state.message,
                    onButtonPressed: () =>
                        context.read<UserProfileCubit>().fetchUserInfo(),
                  );
                }

                return buildContent();
              },
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _personalInformationCard()),

              const SizedBox(width: 20),

              Expanded(child: _roleCard()),
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
      title: "Personal Information",
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.green.shade100,
                child: const Icon(Icons.admin_panel_settings, size: 40),
              ),

              const SizedBox(width: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    user.fullName,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),

                  SizedBox(height: 4),

                  CustomText(user.username, textColor: Colors.grey),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _infoTile("Email", user.email),
              _infoTile("Phone", ''),
              _infoTile("Role", user.role),
              //_infoTile("Joined", "12 Jan 2023"),
              _infoTile("Status", user.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roleCard() {
    return _sectionCard(
      title: "Role & Permissions",
      child: Column(
        children: [
          _permissionTile("Loan Application Review"),
          _permissionTile("Approve Applications"),
          _permissionTile("Reject Applications"),
          _permissionTile("Manage Students"),
          _permissionTile("Manage Document and View reports"),
        ],
      ),
    );
  }

  Widget _statisticsCard() {

    UserProfileLoaded loaded =
        context.read<UserProfileCubit>().state as UserProfileLoaded;

    return _sectionCard(
      title: "Account Statistics",
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              "Applications Reviewed",
              loaded.statistics['total_reviews'].toString(),
              Icons.description_outlined,
              Colors.blue,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: _statCard(
              "Approved",
              loaded.statistics['approved'].toString(),
              Icons.check_circle_outline,
              Colors.green,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: _statCard(
              "Rejected",
              loaded.statistics['rejected'].toString(),
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

    UserProfileLoaded loaded =
        context.read<UserProfileCubit>().state as UserProfileLoaded;

    return _sectionCard(
      title:  "Recent Activity",
      child: Column(
        children: loaded.userActivities.map(
          (activity) => _activityTile(
            title: activity.description, 
            time: formatTime(activity.createdAt)
            )
          ).toList()

      )
    );
  }

  Widget _loginHistoryCard() {
    return _sectionCard(
      title: "Recent Login History",
      child: Column(
        children: [
          _loginTile("Accra, Ghana", "Chrome on Windows", "Today 08:00 AM"),

          _loginTile("Accra, Ghana", "Chrome on Ubuntu", "Yesterday"),

          _loginTile("Accra, Ghana", "Microsoft Edge", "3 Days Ago"),
        ],
      ),
    );
  }

  Widget _securityCard() {
    return _sectionCard(
      title: "Security",
      child: Row(
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
              trailing: Switch(value: true, onChanged: (_) {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [HeaderText(title), const SizedBox(height: 18), child],
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
          CustomText(title, textColor: Colors.grey),

          const SizedBox(height: 4),

          CustomText(value, fontWeight: FontWeight.w600),
        ],
      ),
    );
  }

  Widget _permissionTile(String permission) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 18),

          const SizedBox(width: 10),

          Expanded(child: CustomText(permission)),
        ],
      ),
    );
  }

  Widget _activityTile({required String title, required String time}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.history),
      title: CustomText(title),
      subtitle: CustomText(time, textColor: Colors.grey),
    );
  }

  Widget _loginTile(String location, String device, String time) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.login),
      title: CustomText(location),
      subtitle: CustomText("$device • $time"),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),

          const SizedBox(height: 10),

          CustomText(
            value,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            textColor: color,
          ),

          const SizedBox(height: 4),

          CustomText(title, textColor: Colors.grey),
        ],
      ),
    );
  }
}
