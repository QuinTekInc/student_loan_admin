
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/pages/student_profile_page.dart';

import '../bloc/navigation_bloc.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          HeaderText("Users Management"),

          const SizedBox(height: 24),

          _buildStatistics(),

          const SizedBox(height: 24),

          _buildFilters(),

          const SizedBox(height: 24),

          _buildUsersTable(),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    return Row(
      children: [

        Expanded(
          child: _statCard(
            "Total Users",
            "2,543",
            Icons.people_outline,
            Colors.blue,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _statCard(
            "Students",
            "2,497",
            Icons.school_outlined,
            Colors.green,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _statCard(
            "Admins",
            "18",
            Icons.admin_panel_settings_outlined,
            Colors.orange,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _statCard(
            "Suspended",
            "28",
            Icons.block_outlined,
            Colors.red,
          ),
        ),
      ],
    );
  }

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
            flex: 3,
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search users...",
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

          const SizedBox(width: 16),

          SizedBox(
            width: 180,
            child: DropdownButtonFormField<String>(
              value: "All Roles",
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xffF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: "All Roles",
                  child: Text("All Roles"),
                ),
                DropdownMenuItem(
                  value: "Student",
                  child: Text("Student"),
                ),
                DropdownMenuItem(
                  value: "Admin",
                  child: Text("Admin"),
                ),
              ],
              onChanged: (_) {},
            ),
          ),

          const SizedBox(width: 16),

          SizedBox(
            width: 180,
            child: DropdownButtonFormField<String>(
              value: "All Status",
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xffF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: "All Status",
                  child: Text("All Status"),
                ),
                DropdownMenuItem(
                  value: "Active",
                  child: Text("Active"),
                ),
                DropdownMenuItem(
                  value: "Suspended",
                  child: Text("Suspended"),
                ),
              ],
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTable() {
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
                (index) => _userRow(index),
          ),
        ],
      ),
    );
  }

  Widget _tableHeader() {
    return Row(
      children: const [

        Expanded(
          flex: 2,
          child: CustomText(
            "User ID",
            fontWeight: FontWeight.bold,
          ),
        ),

        Expanded(
          flex: 3,
          child: CustomText(
            "Name",
            fontWeight: FontWeight.bold,
          ),
        ),

        Expanded(
          flex: 4,
          child: CustomText(
            "Email",
            fontWeight: FontWeight.bold,
          ),
        ),

        Expanded(
          flex: 3,
          child: CustomText(
            "Phone",
            fontWeight: FontWeight.bold,
          ),
        ),

        Expanded(
          flex: 2,
          child: CustomText(
            "Role",
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
    );
  }

  Widget _userRow(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [

          Expanded(
            flex: 2,
            child: CustomText(
              "USR-${1000 + index}",
            ),
          ),

          const Expanded(
            flex: 3,
            child: CustomText(
              "Quin Sefalloyd",
            ),
          ),

          const Expanded(
            flex: 4,
            child: CustomText(
              "quin@email.com",
            ),
          ),

          const Expanded(
            flex: 3,
            child: CustomText(
              "+233 24 000 0000",
            ),
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
                  "Student",
                  textColor: Colors.green,
                ),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                child: CustomText(
                  "Active",
                  textColor: Colors.blue,
                ),
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Row(
              children: [

                IconButton(
                  onPressed: ()  => context.read<NavigationCubit>().push(StudentUserProfilePage()),
                  icon: const Icon(
                    Icons.visibility_outlined,
                  ),
                ),

                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [

          CircleAvatar(
            radius: 24,
            backgroundColor: color.withOpacity(.1),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 14),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CustomText(
                value,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),

              const SizedBox(height: 4),

              CustomText(
                title,
                textColor: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}