
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/users_bloc.dart';
import 'package:loan_admin/components/button.dart';
import 'package:loan_admin/components/placeholders.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/pages/dialogs/change_user_role_dialog.dart';
import 'package:loan_admin/pages/dialogs/create_user_dialog.dart';
import 'package:loan_admin/pages/dialogs/notification_dialog.dart';
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

          HeaderText(
            "Users Management",
            fontSize: 24
          ),
          
          CustomText(
            'Review and manage users on this platforms',
            textColor: Colors.grey.shade700,
          ),

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

          CustomButton.withIcon(
            'Add User',
            onPressed: () => showDialog(
              context: context,
              builder: (_) => CreateUserDialog()
            ),
            icon: Icons.add,
          ),

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
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (_) => _UserActionContent(user: user)
                  ),
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





class _UserActionContent extends StatelessWidget {

  final User user;

  const _UserActionContent({
    required this.user
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 560,

      decoration: const BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Center(
              child: Container(
                width: 80,
                height: 6,

                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius:
                  BorderRadius.circular(50),
                ),
              ),
            ),

            const SizedBox(height: 22),

            Row(
              children: [

                CircleAvatar(
                  radius: 34,
                  backgroundColor:
                  Colors.green.shade100,

                  child: CustomText(
                    user.username[0].toUpperCase(),

                    fontSize: 24,

                    fontWeight:
                    FontWeight.bold,

                    textColor: Colors.green,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      HeaderText(
                        '${user.lastName} ${user.firstName}',
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      CustomText(
                        user.email,
                        textColor:
                        Colors.grey,
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Row(
                        children: [

                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),

                            decoration:
                            BoxDecoration(
                              color: true ? Colors.green.shade50 : Colors.red.shade50,

                              borderRadius:
                              BorderRadius
                                  .circular(
                                50,
                              ),
                            ),

                            child:
                            CustomText(
                              'active',
                              textColor: Colors.green.shade600
                            ),
                          ),

                          const SizedBox( width: 8),

                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical:6,
                            ),

                            decoration:
                            BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(50,),
                            ),

                            child:
                            CustomText(
                              user.role,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 2.7,

                children: [

                  _action(
                    context,
                    icon: Icons.person,
                    title: "View Profile",
                    onTap: () {},
                  ),

                  // _action(
                  //   context,
                  //   icon:
                  //   Icons.edit,
                  //   title:
                  //   "Edit User",
                  //   onTap: () {},
                  // ),

                  _action(
                    context,
                    icon: Icons.lock_reset,
                    title: "Reset Password",
                    onTap: () {},
                  ),

                  if(user.role != 'student')_action(
                    context,
                    icon: Icons.badge,
                    title: "Change Role",
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => ChangeUserRoleDialog(
                        userName: user.username,
                        email: user.email,
                        currentRole: user.role
                      )
                    ),
                  ),

                  if(user.role == 'student')_action(
                    context,
                    icon: Icons.notifications,
                    title: "Notify User",
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => NotifyUserDialog(userName: user.username, userEmail: user.email)
                    ),
                  ),


                  //account activation or deactivating
                  _action(
                    context,
                    icon: true ? Icons.block : Icons.check,
                    title: true ? "Deactivate" : "Activate",
                    color: true ? Colors.red : Colors.green,
                    onTap: () {},
                  ),

                  // _action(
                  //   context,
                  //   icon: Icons.delete,
                  //   title: "Delete User",
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

  Widget _action(BuildContext context, {
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
        padding:
        const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color:
          color.withOpacity(.08),

          borderRadius:
          BorderRadius.circular(
            18,
          ),
        ),

        child: Row(
          children: [

            Container(
              height: 42,
              width: 42,

              decoration: BoxDecoration(
                color:
                color.withOpacity(.15,),
                shape: BoxShape.circle,
              ),

              child: Icon(
                icon,
                color: color,
              ),
            ),

            const SizedBox(
              width: 12,
            ),

            Expanded(
              child: CustomText(
                title,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
