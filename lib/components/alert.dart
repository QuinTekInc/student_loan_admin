import 'package:flutter/material.dart';
import 'package:loan_admin/components/text.dart';

Future<void> showAlertDialog({
  required BuildContext context,
  String? title,
  required String contentText,
  IconData? icon,
  AlertType alertType = AlertType.info,
  List<Widget>? actions,
}) async {
  Color iconColor;

  switch (alertType) {
    case AlertType.warning:
      iconColor = Colors.amber.shade700;
      break;

    case AlertType.sucess:
      iconColor = Colors.green.shade700;
      break;

    case AlertType.error:
      iconColor = Colors.red.shade700;
      break;

    case AlertType.info:
      iconColor = Colors.blue.shade700;
      break;
  }

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      icon: icon == null ? null : Icon(icon, color: iconColor, size: 40),
      title: title == null ? null : HeaderText(title),
      content: SizedBox(
        width: 450,
        child: CustomText(contentText, softwrap: true),
      ),

      actions: actions != null && actions.isNotEmpty
        ? actions
        : [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: CustomText('CLOSE', textColor: iconColor),
            ),
          ],
    ),
  );
}

Future<void> showLoadingDialog({
  required BuildContext context,
  String? title,
  String? contentText,
}) async {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: HeaderText(title ?? 'Loading'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),

          CustomText(contentText ?? 'Please wait...'),
        ],
      ),
    ),
  );
}

enum AlertType { warning, info, sucess, error }
