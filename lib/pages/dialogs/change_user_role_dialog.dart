import 'package:flutter/material.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/models/models.dart';

class ChangeUserRoleDialog extends StatefulWidget {

  final User user;

  const ChangeUserRoleDialog({
    super.key,
    required this.user,
  });


  @override
  State<ChangeUserRoleDialog> createState() => _ChangeUserRoleDialogState();
}

class _ChangeUserRoleDialogState extends State<ChangeUserRoleDialog> {
  late String selectedRole;

  bool notifyUser = true;

  final roles = ['admin', "superuser"];

  @override
  void initState() {
    super.initState();
    selectedRole = widget.user.role;
  }

  Color get roleColor {
    switch (selectedRole) {
      case "admin":
        return Colors.blue;

      case "superuser":
        return Colors.green;

      default:
        return Colors.red;
    }
  }

  IconData get roleIcon {
    switch (selectedRole) {
      case "admin":
        return Icons.fact_check;

      case "superuser":
        return Icons.admin_panel_settings;

      default:
        return Icons.security;
    }
  }

  String get permissionPreview {
    switch (selectedRole) {
      case "admin":
        return "Can review application, verify documents, and manage loans";

      case 'superuser':
        return "Full unrestricted administrative access";

      default:
        return "Undefined";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,

      child: Container(
        width: 760,

        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(24),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Container(
                  height: 58,
                  width: 58,

                  decoration: BoxDecoration(
                    color: roleColor.withOpacity(.12),

                    shape: BoxShape.circle,
                  ),

                  child: Icon(roleIcon, color: roleColor),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      HeaderText("Change User Role"),

                      const SizedBox(height: 4),

                      CustomText(widget.user.username),

                      CustomText(widget.user.email, textColor: Colors.grey),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            _readonly("Current Role", widget.user.role),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: selectedRole,

              decoration: InputDecoration(
                labelText: "New Role",
                labelStyle: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.green.shade400,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide(color: Colors.green.shade400),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.green.shade400),
                ),
              ),

              items: roles
                  .map(
                    (role) => DropdownMenuItem(value: role, child: Text(role)),
                  )
                  .toList(),

              onChanged: (value) => setState(() => selectedRole = value!),
            ),

            // SwitchListTile(
            //   value: notifyUser,

            //   activeColor: Colors.green,

            //   title: CustomText(
            //     "Notify User",
            //   ),

            //   subtitle: CustomText(
            //     "Send role change notification",
            //   ),

            //   onChanged: (value,) => setState(() => notifyUser =value,),
            // ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: roleColor.withOpacity(.08),
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Icon(roleIcon, color: roleColor),

                      const SizedBox(width: 8),

                      CustomText(
                        selectedRole,
                        fontWeight: FontWeight.bold,
                        textColor: roleColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  CustomText(permissionPreview, textColor: Colors.grey),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: CustomText('Cancel'),
                ),

                const SizedBox(width: 12),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),

                  onPressed: handleUpdate,

                  icon: const Icon(Icons.save, color: Colors.white),

                  label: CustomText('Update Role', textColor: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _readonly(String label, String value) {
    return TextField(
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        hintText: value,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void handleUpdate() async {}
}
