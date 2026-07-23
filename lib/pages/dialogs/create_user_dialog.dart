import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loan_admin/bloc/users_bloc.dart';
import 'package:loan_admin/components/text.dart';

class CreateUserDialog extends StatefulWidget {
  const CreateUserDialog({super.key});

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final lastNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();

  String selectedRole = "Admin";

  final roles = ["Admin", "Super Admin"];

  @override
  void dispose() {
    lastNameController.dispose();
    firstNameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,

      child: Container(
        width: 720,

        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(24),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            HeaderText("Create New User"),

            const SizedBox(height: 6),

            const CustomText(
              "Fill in the details below to create a new system user.",
              textColor: Colors.grey,
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: firstNameController,
                    hintText: 'First Name(s)',
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: CustomTextField(
                    controller: lastNameController,
                    hintText: 'Last Name',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            CustomTextField(
              controller: usernameController,
              hintText: 'Username',
            ),

            const SizedBox(height: 18),

            CustomTextField(controller: emailController, hintText: 'Email'),

            const SizedBox(height: 18),

            DropdownButtonFormField<String>(
              value: selectedRole,

              decoration: InputDecoration(
                labelText: "Role",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              items: roles
                  .map(
                    (role) => DropdownMenuItem(value: role, child: Text(role)),
                  )
                  .toList(),

              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                });
              },
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.green.shade50,

                borderRadius: BorderRadius.circular(16),
              ),

              child: const CustomText(
                "Note: The password is auto generated and will be sent to the user's email address.",
                textColor: Colors.green,
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
                  onPressed: handleCreateUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  icon: const Icon(Icons.person_add, color: Colors.white),

                  label: CustomText('Create user', textColor: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void handleCreateUser() async {
    Map<String, dynamic> userInfo = {
      'first_name': firstNameController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'username': usernameController.text.trim(),
      'email': emailController.text.trim(),
      'role': selectedRole,
    };

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: HeaderText('Creating User'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [CircularProgressIndicator(), CustomText('Please wait')],
        ),
      ),
    );

    try {
      await context.read<UsersCubit>().createUser(userInfo);

      Navigator.pop(context); //close the loading dialog.

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          icon: Icon(Icons.check_circle, color: Colors.green.shade700, size: 50,),
          title: HeaderText('User Created'),
          content: CustomText(
            'A new admin user has be successfully added to the database.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: CustomText('OKAY', textColor: Colors.green.shade700),
            ),
          ],
        ),
      );

      //todo: show sucess dialog.
    } catch (ex, trace) {
      debugPrintStack(stackTrace: trace);
      Navigator.pop(context); //close the loading dialog

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          icon: Icon(Icons.error, color: Colors.red.shade700, size: 50,),
          title: HeaderText('User Creation Failed'),
          content: CustomText(ex.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: CustomText('CLOSE', textColor: Colors.red.shade700),
            ),
          ],
        ),
      );
    }
  }
}
