
import 'package:flutter/material.dart';
import 'package:loan_admin/components/text.dart';

class CreateUserDialog extends StatefulWidget {
  const CreateUserDialog({super.key});

  @override
  State<CreateUserDialog> createState() =>
      _CreateUserDialogState();
}

class _CreateUserDialogState
    extends State<CreateUserDialog> {
  final lastNameController =
  TextEditingController();

  final firstNameController =
  TextEditingController();

  final emailController =
  TextEditingController();

  String selectedRole = "Admin";

  final roles = [
    "Admin",
    "Super Admin",
  ];

  @override
  void dispose() {
    lastNameController.dispose();
    firstNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,

      child: Container(
        width: 720,

        padding:
        const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
          BorderRadius.circular(
            24,
          ),
        ),

        child: Column(
          mainAxisSize:
          MainAxisSize.min,

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            HeaderText(
              "Create New User",
            ),

            const SizedBox(height: 6),

            const CustomText(
              "Fill in the details below to create a new system user.",
              textColor: Colors.grey,
            ),

            const SizedBox(height: 24),

            Row(
              children: [

                Expanded(
                  child: TextField(
                    controller:
                    firstNameController,

                    decoration:
                    InputDecoration(
                      labelText:
                      "First Name",

                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                          14,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  width: 16,
                ),

                Expanded(
                  child: TextField(
                    controller:
                    lastNameController,

                    decoration:
                    InputDecoration(
                      labelText:
                      "Last Name",

                      border:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                          14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            TextField(
              controller:
              emailController,

              decoration:
              InputDecoration(
                labelText:
                "Email Address",

                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius
                      .circular(
                    14,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            DropdownButtonFormField<
                String>(
              value:
              selectedRole,

              decoration:
              InputDecoration(
                labelText: "Role",

                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius
                      .circular(
                    14,
                  ),
                ),
              ),

              items:
              roles
                  .map(
                    (role) =>
                    DropdownMenuItem(
                      value:
                      role,

                      child:
                      Text(
                        role,
                      ),
                    ),
              )
                  .toList(),

              onChanged: (value) {
                setState(() {
                  selectedRole =
                  value!;
                });
              },
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,

              padding:
              const EdgeInsets
                  .all(16),

              decoration: BoxDecoration(
                color: Colors.green
                    .shade50,

                borderRadius:
                BorderRadius
                    .circular(
                  16,
                ),
              ),

              child: const CustomText(
                "Note: The password is auto generated and will be sent to the user's email address.",
                textColor: Colors.green,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment:
              MainAxisAlignment
                  .end,

              children: [

                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },

                  child:
                  const Text(
                    "Cancel",
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                ElevatedButton.icon(
                  style:
                  ElevatedButton
                      .styleFrom(
                    backgroundColor:
                    Colors.green,
                  ),

                  onPressed: () {
                    // TODO: create user API call
                  },

                  icon: const Icon(
                    Icons.person_add,
                  ),

                  label: const Text(
                    "Create User",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}