
import 'package:flutter/material.dart';
import 'package:student_loan/components/button.dart';

import 'admin_dashboard.dart';

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

  ];


  late final List<Widget> fragments;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fragments = [
      AdminDashboardPage()
    ];

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        spacing: 12,
        children:[

          buildSidebar(),

          Expanded(
            child: fragments[selectedIndex],
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
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });

                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.green.shade50
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.icon,
                            color: isSelected
                                ? Colors.green.shade700
                                : Colors.black54,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? Colors.green.shade800
                                    : Colors.black87,
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
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.green.shade200,
                  child: Text(
                    "Q",
                    style: TextStyle(
                      color: Colors.green.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Quin Sefalloyd",
                          style: TextStyle(fontWeight: FontWeight.bold)),
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
          ),
        ],
      ),
    );
  }
}
