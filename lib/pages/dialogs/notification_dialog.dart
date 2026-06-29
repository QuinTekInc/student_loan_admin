

import 'package:flutter/material.dart';
import 'package:loan_admin/components/text.dart';

class NotifyUserDialog extends StatefulWidget {
  const NotifyUserDialog({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  final String userName;
  final String userEmail;

  @override
  State<NotifyUserDialog> createState() =>
      _NotifyUserDialogState();
}

class _NotifyUserDialogState extends State<NotifyUserDialog> {
  final titleController = TextEditingController();

  final messageController = TextEditingController();

  bool sendImmediately = true;

  String notificationType = "Info";

  final notificationTypes = [
    "Info",
    "Success",
    "Warning",
    "Error",
  ];

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Color get typeColor {
    switch (notificationType) {
      case "Success":
        return Colors.green;

      case "Warning":
        return Colors.orange;

      case "Error":
        return Colors.red;

      default:
        return Colors.blue;
    }
  }

  IconData get typeIcon {
    switch (notificationType) {
      case "Success":
        return Icons.check_circle;

      case "Warning":
        return Icons.warning;

      case "Error":
        return Icons.error;

      default:
        return Icons.info;
    }
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

            Row(
              children: [

                Container(
                  height: 58,
                  width: 58,

                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(.12,),
                    shape: BoxShape.circle,
                  ),

                  child: Icon(
                    typeIcon,
                    color: typeColor,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      HeaderText(
                        "Notify User",
                      ),

                      const SizedBox(height: 4),

                      CustomText(
                        widget.userName,
                        textColor: Colors.grey,
                      ),

                      CustomText(
                        widget.userEmail,
                        textColor: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 24,
            ),

            const CustomText(
              "Notification Type",
              fontWeight:
              FontWeight.bold,
            ),

            const SizedBox(
              height: 10,
            ),

            DropdownButtonFormField<
                String>(
              value:
              notificationType,

              decoration:
              InputDecoration(
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
              notificationTypes
                  .map(
                    (e) =>
                    DropdownMenuItem(
                      value: e,

                      child:
                      Text(
                        e,
                      ),
                    ),
              )
                  .toList(),

              onChanged:
                  (value) {
                setState(() {
                  notificationType =
                  value!;
                });
              },
            ),

            const SizedBox(
              height: 18,
            ),

            TextField(
              controller:
              titleController,

              decoration:
              InputDecoration(
                labelText:
                "Title",

                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius
                      .circular(
                    14,
                  ),
                ),
              ),

              onChanged:
                  (_) =>
                  setState(
                        () {},
                  ),
            ),

            const SizedBox(
              height: 18,
            ),

            TextField(
              controller:
              messageController,

              maxLines: 5,

              decoration:
              InputDecoration(
                labelText:
                "Message",

                border:
                OutlineInputBorder(
                  borderRadius:
                  BorderRadius
                      .circular(
                    14,
                  ),
                ),
              ),

              onChanged:
                  (_) =>
                  setState(
                        () {},
                  ),
            ),

            const SizedBox(
              height: 18,
            ),

            SwitchListTile(
              value:
              sendImmediately,

              activeColor:
              Colors.green,

              title:
              const Text(
                "Send Immediately",
              ),

              subtitle:
              const Text(
                "Send instantly after confirmation",
              ),

              onChanged:
                  (v) {
                setState(() {
                  sendImmediately =
                      v;
                });
              },
            ),

            const SizedBox(
              height: 20,
            ),

            Container(
              width:
              double.infinity,

              padding:
              const EdgeInsets
                  .all(
                18,
              ),

              decoration: BoxDecoration(
                color:
                typeColor
                    .withOpacity(
                  .08,
                ),

                borderRadius:
                BorderRadius
                    .circular(
                  18,
                ),
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment
                    .start,

                children: [

                  Row(
                    children: [

                      Icon(
                        typeIcon,
                        color:
                        typeColor,
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      CustomText(
                        notificationType,

                        fontWeight:
                        FontWeight
                            .bold,

                        textColor:
                        typeColor,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  CustomText(
                    titleController
                        .text
                        .isEmpty
                        ? "Notification title"
                        : titleController
                        .text,

                    fontWeight:
                    FontWeight
                        .w600,
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  CustomText(
                    messageController
                        .text
                        .isEmpty
                        ? "Notification message"
                        : messageController
                        .text,

                    textColor:
                    Colors.grey,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 24,
            ),

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
                    width: 12),

                ElevatedButton
                    .icon(
                  style:
                  ElevatedButton
                      .styleFrom(
                    backgroundColor:
                    typeColor,
                  ),

                  onPressed:
                      () {
                    // submit
                  },

                  icon:
                  const Icon(
                    Icons.send,
                  ),

                  label:
                  const Text(
                    "Send",
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