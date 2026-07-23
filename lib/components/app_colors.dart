import 'package:flutter/material.dart';

class AppColors {
  Color get scaffoldColor => Colors.grey.shade700;

  Color get containerColor => Colors.grey.shade500;
}

Color applicationStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'submitted':
    case 'pending':
      return Colors.blue;

    case 'under_review':
      return Colors.purple;

    case 'approved':
      return Colors.green.shade700;

    case 'rejected':
      return Colors.red.shade700;

    case 'unknown':
    default:
      return Colors.orange;
  }
}
