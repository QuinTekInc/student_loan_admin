

import 'package:flutter/material.dart';
import 'package:loan_admin/components/text.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool hideCurrentPassword = true;
  bool hideNewPassword = true;
  bool hideConfirmPassword = true;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  double get passwordStrength {
    final password = newPasswordController.text;

    if (password.length < 6) return 0.25;
    if (password.length < 8) return 0.5;
    if (password.length < 12) return 0.75;
    return 1.0;
  }

  String get passwordStrengthLabel {
    final password = newPasswordController.text;

    if (password.length < 6) return "Weak";
    if (password.length < 8) return "Fair";
    if (password.length < 12) return "Good";
    return "Strong";
  }

  Color get passwordStrengthColor {
    final password = newPasswordController.text;

    if (password.length < 6) return Colors.red;
    if (password.length < 8) return Colors.orange;
    if (password.length < 12) return Colors.blue;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [

                HeaderText("Change Password"),

                Spacer(),

                IconButton(
                  onPressed: () => Navigator.pop(context),//close the popup
                  icon: Icon(Icons.close, color: Colors.red.shade700,),
                )
              ],
            ),

            const SizedBox(height: 8),

            const CustomText(
              "Update your administrator password.",
              textColor: Colors.grey,
            ),

            const SizedBox(height: 24),

            TextField(
              controller: currentPasswordController,
              obscureText: hideCurrentPassword,
              decoration: InputDecoration(
                labelText: "Current Password",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    hideCurrentPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      hideCurrentPassword = !hideCurrentPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: newPasswordController,
              obscureText: hideNewPassword,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: "New Password",
                prefixIcon: const Icon(Icons.lock_reset),
                suffixIcon: IconButton(
                  icon: Icon(
                    hideNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      hideNewPassword = !hideNewPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 12),

            LinearProgressIndicator(
              value: passwordStrength,
              minHeight: 8,
              borderRadius: BorderRadius.circular(50),
              color: passwordStrengthColor,
            ),

            const SizedBox(height: 8),

            CustomText(
              "Password Strength: $passwordStrengthLabel",
              textColor: passwordStrengthColor,
              fontWeight: FontWeight.w600,
            ),

            const SizedBox(height: 16),

            TextField(
              controller: confirmPasswordController,
              obscureText: hideConfirmPassword,
              decoration: InputDecoration(
                labelText: "Confirm New Password",
                prefixIcon: const Icon(Icons.verified_user_outlined),
                suffixIcon: IconButton(
                  icon: Icon(
                    hideConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      hideConfirmPassword = !hideConfirmPassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [

                  Icon(
                    Icons.security,
                    color: Colors.green,
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: CustomText(
                      "Use a strong password with letters, numbers and special characters.",
                      textColor: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),

                const SizedBox(width: 12),

                ElevatedButton.icon(
                  onPressed: handleChangePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  icon: const Icon(Icons.check),
                  label: const Text("Update Password"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void handleChangePassword(){

  }
}