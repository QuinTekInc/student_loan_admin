

import 'package:flutter/material.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/pages/dialogs/change_password_dialog.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  bool emailNotifications = true;
  bool smsNotifications = false;
  bool aiFraudDetection = true;
  bool autoApproval = false;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [

          HeaderText("Settings"),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [



                  const SizedBox(height: 24),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Expanded(
                        child: _sectionCard(
                          title: "System Settings",
                          children: [

                            _settingTile(
                              title: "AI Fraud Detection",
                              subtitle:
                              "Analyze uploaded documents for potential fraud",
                              trailing: Switch(
                                value: aiFraudDetection,
                                activeColor: Colors.green,
                                onChanged: (value) {
                                  setState(() {
                                    aiFraudDetection = value;
                                  });
                                },
                              ),
                            ),

                            const Divider(),

                            _settingTile(
                              title: "Automatic Loan Approval",
                              subtitle:
                              "Automatically approve low-risk applications",
                              trailing: Switch(
                                value: autoApproval,
                                activeColor: Colors.green,
                                onChanged: (value) {
                                  setState(() {
                                    autoApproval = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: _sectionCard(
                          title: "Notification Settings",
                          children: [

                            _settingTile(
                              title: "Email Notifications",
                              subtitle:
                              "Receive application and repayment updates",
                              trailing: Switch(
                                value: emailNotifications,
                                activeColor: Colors.green,
                                onChanged: (value) {
                                  setState(() {
                                    emailNotifications = value;
                                  });
                                },
                              ),
                            ),

                            const Divider(),

                            _settingTile(
                              title: "SMS Notifications",
                              subtitle:
                              "Receive alerts via SMS",
                              trailing: Switch(
                                value: smsNotifications,
                                activeColor: Colors.green,
                                onChanged: (value) {
                                  setState(() {
                                    smsNotifications = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Expanded(
                        child: _sectionCard(
                          title: "Admin Account",
                          children: [

                            _infoRow("Username", "admin"),

                            const Divider(),

                            _infoRow(
                              "Email",
                              "admin@studentloans.gov.gh",
                            ),

                            const Divider(),

                            _infoRow(
                              "Role",
                              "Super Administrator",
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.lock_reset),
                                label: const Text("Change Password"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => ChangePasswordDialog()
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        child: _sectionCard(
                          title: "Appearance",
                          children: [

                            _settingTile(
                              title: "Dark Mode",
                              subtitle:
                              "Switch between light and dark themes",
                              trailing: Switch(
                                value: darkMode,
                                activeColor: Colors.green,
                                onChanged: (value) {
                                  setState(() {
                                    darkMode = value;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.save),
                                label: const Text("Save Changes"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _sectionCard(
                    title: "System Information",
                    children: [

                      _infoRow("Platform Version", "1.0.0"),

                      const Divider(),

                      _infoRow("Backend Version", "v1"),

                      const Divider(),

                      _infoRow(
                        "Database",
                        "PostgreSQL",
                      ),

                      const Divider(),

                      _infoRow(
                        "Last Backup",
                        "25 June 2026, 08:30 AM",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          HeaderText(title),

          const SizedBox(height: 16),

          ...children,
        ],
      ),
    );
  }

  Widget _settingTile({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Row(
      children: [

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CustomText(
                title,
                fontWeight: FontWeight.bold,
              ),

              const SizedBox(height: 4),

              CustomText(
                subtitle,
                textColor: Colors.grey,
              ),
            ],
          ),
        ),

        trailing,
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [

        Expanded(
          child: CustomText(
            label,
            textColor: Colors.grey,
          ),
        ),

        CustomText(
          value,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}