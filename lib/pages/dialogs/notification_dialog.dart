import 'package:flutter/material.dart';
import 'package:loan_admin/bloc/notification_bloc.dart';
import 'package:loan_admin/components/text.dart';
import 'package:loan_admin/bloc/repo.dart';

class NotifyUserDialog extends StatefulWidget {
  final String? studentId;
  final String? fullName;
  final String? username;

  final bool isStudent;

  bool isGlobal; //should be sent to all users except admins.
  bool isAdmins; //should be send to all admin

  NotifyUserDialog({
    super.key,
    this.studentId,
    this.fullName,
    this.username,
    this.isStudent = false,
    this.isGlobal = false,
    this.isAdmins = false,
  });

  factory NotifyUserDialog.student({
    required String studentId,
    required String fullName,
  }) {
    return NotifyUserDialog(
      studentId: studentId,
      fullName: fullName,
      isStudent: true,
    );
  }

  factory NotifyUserDialog.user({required String username}) {
    return NotifyUserDialog(username: username);
  }

  @override
  State<NotifyUserDialog> createState() => _NotifyUserDialogState();
}

class _NotifyUserDialogState extends State<NotifyUserDialog> {
  final titleController = TextEditingController();

  final messageController = TextEditingController();

  final notificationTypes = ["Info", "Success", "Warning", "Error"];

  String selectedValue = '';

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Color get typeColor {
    switch (selectedValue) {
      case "success":
        return Colors.green;

      case "warning":
        return Colors.orange;

      case "reminder":
        return Colors.deepPurple;

      default:
        return Colors.blue;
    }
  }

  IconData get typeIcon {
    switch (selectedValue) {
      case "success":
        return Icons.check_circle;

      case "warning":
        return Icons.warning;

      case "reminder":
        return Icons.notifications;

      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final headerIconColor = selectedValue.isEmpty ? Colors.green : typeColor;

    final headerIcon = selectedValue.isEmpty ? Icons.send : typeIcon;

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            //header
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8,
              children: [
                CircleAvatar(
                  backgroundColor: headerIconColor.withOpacity(.15),
                  radius: 30,
                  child: Icon(headerIcon, color: headerIconColor, size: 30),
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HeaderText('Send Notification'),
                      CustomText('Send a notification to Users'),
                    ],
                  ),
                ),
              ],
            ),

            CustomText(
              'Notification Type',
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),

            //the various notification_types
            _buildTypesRow(),

            if (widget.isStudent) ...[
              CustomText(
                'Student ID.',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              IgnorePointer(
                ignoring: true,
                child: CustomTextField(
                  controller: TextEditingController(text: widget.studentId),
                  hintText: 'Enter notification title here',
                ),
              ),

              CustomText(
                'Student Full Name',
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              IgnorePointer(
                ignoring: true,
                child: CustomTextField(
                  controller: TextEditingController(text: widget.fullName),
                  hintText: 'Enter notification title here',
                ),
              ),
            ],

            if (widget.username != null) ...[
              CustomText('User', fontWeight: FontWeight.w700, fontSize: 16),

              IgnorePointer(
                ignoring: true,
                child: CustomTextField(
                  controller: TextEditingController(text: widget.username),
                  hintText: 'Enter notification title here',
                ),
              ),
            ],

            if (widget.isAdmins) ...[
              CustomText(
                'Hello World',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              _buildDecorativeLabel('Send to all Admins'),
            ],

            if (widget.isGlobal) ...[
              CustomText(
                'Hello World',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              _buildDecorativeLabel('Send to all Users'),
            ],

            CustomText('Title', fontWeight: FontWeight.w700, fontSize: 16),

            CustomTextField(
              controller: titleController,
              hintText: 'Enter notification title here',
            ),

            CustomText('Message', fontWeight: FontWeight.w700, fontSize: 16),

            CustomTextField(
              controller: messageController,
              hintText: 'Enter notification title here',
              maxLines: 4,
              maxLength: 1000,
            ),

            CustomText(
              'Preview',
              textColor: Colors.green.shade500,
              fontWeight: FontWeight.w600,
            ),

            //build the actual preview of sending the notification
            Divider(color: Colors.grey.shade400),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 12,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(width: 1.5, color: Colors.grey.shade400),
                    ),
                  ),

                  child: CustomText('Cancel', textColor: Colors.grey.shade600),
                ),

                ElevatedButton.icon(
                  onPressed: handleSendNotification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: typeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.send_outlined, color: Colors.white),
                  label: CustomText(
                    'Send Notification',
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 12,
      children: [
        Expanded(
          child: _buildTypeButton(
            value: 'warning',
            title: 'Warning',
            detail: 'Alert users of a potential issues',
            icon: Icons.warning_outlined,
            iconColor: Colors.amber,
          ),
        ),

        Expanded(
          child: _buildTypeButton(
            value: 'reminder',
            title: 'Reminder',
            detail: 'Remind users of an upcoming action',
            icon: Icons.notifications_outlined,
            iconColor: Colors.deepPurple,
          ),
        ),

        Expanded(
          child: _buildTypeButton(
            value: 'info',
            title: 'Info',
            detail: 'Share a general information',
            icon: Icons.info_outline_rounded,
            iconColor: Colors.blue.shade700,
          ),
        ),

        Expanded(
          child: _buildTypeButton(
            value: 'success',
            title: 'Success',
            detail: 'Notify users of a sucessful action',
            icon: Icons.check_outlined,
            iconColor: Colors.green.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeButton({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String detail,
    required String value,
  }) {
    final bool isSelected = (value == selectedValue);

    return GestureDetector(
      onTap: () => setState(() => selectedValue = value),
      child: Stack(
        children: [
          Container(
            height: 110,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? Colors.green.shade700
                    : Colors.grey.shade200,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                CircleAvatar(
                  backgroundColor: iconColor.withOpacity(.15),
                  radius: 30,
                  child: Icon(icon, color: iconColor, size: 30),
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 3,
                    children: [
                      CustomText(
                        title,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),

                      CustomText(
                        detail,
                        textColor: Colors.grey.shade500,
                        softwrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (isSelected)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 8),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green.shade700,
                  size: 30,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDecorativeLabel(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(12),
      ),

      child: CustomText(value, maxLines: 1),
    );
  }

  void handleSendNotification() async {
    Map<String, dynamic> notificationBody = {
      'notification_type': selectedValue,
      'title': titleController.text.trim(),
      'message': messageController.text.trim(),
    };

    if (widget.isStudent) {
      notificationBody['student_id'] = widget.studentId;
    }

    if (widget.isGlobal || widget.isAdmins) {
      notificationBody['recipient'] = widget.isGlobal ? 'global' : 'admins';
    }

    if (widget.username != null) {
      notificationBody['username'] = widget.username;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: CustomText('Loading'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            CustomText('Please wait....'),
          ],
        ),
      ),
    );

    try {
      await Repository.sendNotification(notificationBody);
    } catch (ex) {
      Navigator.pop(context); //close the alert dialog.
    }
  }
}
