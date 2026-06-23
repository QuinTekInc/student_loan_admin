
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/users_bloc.dart';
import 'package:loan_admin/components/placeholders.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/pages/user_management/admin_profile_page.dart';
import 'package:loan_admin/pages/user_management/student_profile_page.dart';

import '../bloc/navigation_bloc.dart';
import '../models/models.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<UsersCubit>().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [

          HeaderText("Users Management"),

          Expanded(
            child: BlocBuilder<UsersCubit, UsersState>(
              builder: (_, state){

                if(state is UsersLoading || state is UsersInitial){
                  return LoadingPlaceholder();
                }

                if(state is UsersError){
                  return MessagePlaceholder.error(
                    message: state.message,
                    onButtonPressed: () => context.read<UsersCubit>().fetchUsers(),
                  );
                }

                return _buildContent();
              }
            ),
          )
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
    
    UsersLoaded loaded = context.read<UsersCubit>().state as UsersLoaded;
    
    return Row(
      children: [

        Expanded(
          child: _statCard(
            "Total Users",
            loaded.totalUsersCount.toString(),
            Icons.people_outline,
            Colors.blue,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _statCard(
            "Students",
            loaded.studentUsersCount.toString(),
            Icons.school_outlined,
            Colors.green,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _statCard(
            "Admins",
            loaded.adminUsersCount.toString(),
            Icons.admin_panel_settings_outlined,
            Colors.orange,
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: _statCard(
            "Suspended",
            loaded.suspendedUsersCount.toString(),
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

    UsersLoaded usersLoaded = context.read<UsersCubit>().state as UsersLoaded;

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

          ...usersLoaded.users.map(
                (user) => UserRow(user: user)),
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
            "User ID(username)",
            fontWeight: FontWeight.bold,
          ),
        ),

        Expanded(
          flex: 3,
          child: CustomText(
            "Last Name",
            fontWeight: FontWeight.bold,
          ),
        ),

        Expanded(
          flex: 4,
          child: CustomText(
            "First Name(s)",
            fontWeight: FontWeight.bold,
          ),
        ),

        Expanded(
          flex: 3,
          child: CustomText(
            "Email",
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



class UserRow extends StatelessWidget {

  final User user;

  const UserRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [

          //the user's username
          Expanded(
            flex: 2,
            child: CustomText(
              user.username,
            ),
          ),


          //last name
          Expanded(
            flex: 3,
            child: CustomText(
              user.lastName,
            ),
          ),

          //first names
          Expanded(
            flex: 3,
            child: CustomText(
              user.firstName,
            ),
          ),


          //the user's email.
          Expanded(
            flex: 4,
            child: CustomText(
              user.email,
            ),
          ),


          //the user's role.
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
              child: Center(
                child: CustomText(
                  user.role,
                  textColor: Colors.green,
                ),
              ),
            ),
          ),

          //the user's status.
          //this indicates whether is active or not.
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
                  onPressed: () {
                    if(user.role.toLowerCase() == 'student'){
                      context.read<NavigationCubit>().push(StudentUserProfilePage());
                    }else{
                      context.read<NavigationCubit>().push(AdminUserProfilePage());
                    }
                  },
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
}
