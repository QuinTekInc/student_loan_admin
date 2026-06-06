
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/components/button.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/pages/applications_page.dart';
import 'package:loan_admin/pages/loans_page.dart';
import 'package:loan_admin/pages/users_page.dart';
import '../bloc/navigation_bloc.dart';
import 'dashboard.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  int selectedIndex = 0;

  final List<DashboardMenuItem> menuItems = [

    DashboardMenuItem(
      title: 'Dashboard',
      icon: Icons.dashboard,
    ),

    DashboardMenuItem(
      title: 'Loans',
      icon: Icons.credit_card
    ),

    DashboardMenuItem(
      title: 'Loan Applications',
      icon: Icons.edit_note,
    ),

    DashboardMenuItem(
      title: 'Users',
      icon: Icons.people
    )

  ];


  late final List<Widget> fragments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fragments = [
      DashboardPage(),
      LoansPage(),
      LoanApplicationPage(),
      UsersPage()
    ];

    context.read<NavigationCubit>().push(fragments[0]);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        spacing: 12,
        children:[

          buildSidebar(),

          Expanded(
            child: BlocBuilder<NavigationCubit, Widget>(
              builder: (context, state) => state
            ),
          )

        ]
      ),
    );
  }


  Widget buildSidebar() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.18,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.school_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Student Loans(Admin)",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),


          const Divider(height: 1),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: menuItems.length,
              itemBuilder: (_, index) {

                final item = menuItems[index];
                final isSelected = selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => selectedIndex = index);
                      context.read<NavigationCubit>().pushReplacement(fragments[index]);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green.shade50 : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            color: isSelected ? Colors.green.shade700 : Colors.black54,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected ? Colors.green.shade800 : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          _buildCurrentUserCard()
        ],
      ),
    );
  }


  Widget _buildCurrentUserCard(){

    return  Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [

          _buildProfileAvatar(),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //todo: put the username here.
                CustomText(
                  "Quin Sefalloyd",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                SizedBox(height: 4),
                Text(
                  "Administrator",
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildProfileAvatar(){

    return CircleAvatar(
      radius: 22,
      backgroundColor: Colors.green.shade200,
      child: Text(
        "Q",
        style: TextStyle(
          color: Colors.green.shade900,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
