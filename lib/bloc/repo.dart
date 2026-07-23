import 'dart:convert';

import 'package:loan_admin/components/server_connector.dart';
import 'package:loan_admin/components/services.dart';
import 'package:loan_admin/models/models.dart';

class Repository {
  static Future<User> login(String username, String password) async {
    final response = await ServerConnector.postRequest(
      'login/',
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception('An error occurred: ${response.statusCode}');
    }

    Map<String, dynamic> jsonMap = Map<String, dynamic>.from(
      jsonDecode(response.body),
    );

    await SecureStorageServices.saveAuthToken(jsonMap['token']);

    return User.fromJson(jsonMap);
  }

  static Future<void> logout() async {
    final response = await ServerConnector.getRequest('logout/');

    if (response.statusCode != 200) {
      throw Exception('Could not logout. ${response.statusCode}');
    }

    //this here means the user has been succesfully logged out.
  }

  //===============================LOAN APPLICATION MANAGEMENT API FUNCTIONS===========================

  static Future<List<LoanApplication>> fetchApplications() async {
    final response = await ServerConnector.getRequest('applications/');

    if (response.statusCode != 200) {
      throw Exception("An Exception occurred: ${response.statusCode}");
    }

    List<dynamic> responseBody = List<dynamic>.from(jsonDecode(response.body));

    return responseBody
        .map((jsonMap) => LoanApplication.fromJson(jsonMap))
        .toList();
  }

  static Future<Map<String, dynamic>> getApplicationReview(
    String applicationId,
  ) async {
    final response = await ServerConnector.getRequest(
      'applications/$applicationId/review/details/',
    );

    if (response.statusCode != 200) {
      throw Exception("An Error occurred: ${response.statusCode}");
    }

    Map<String, dynamic> responseMap = Map<String, dynamic>.from(
      jsonDecode(response.body),
    );

    return responseMap;
  }

  static Future<void> approveLoanApplication({
    required String applicationId,
    required double approvedAmount,
    required int duration,
  }) async {
    final request = await ServerConnector.postRequest(
      'applications/$applicationId/approve/',
      body: jsonEncode({
        'approved_amount': approvedAmount,
        'duration': duration,
      }),
    );

    if (request.statusCode != 200) {
      throw Exception('An Exception occurred: ${request.statusCode}');
    }
  }

  static Future<void> rejectApplication({
    required String applicationId,
    required String rejectionReason,
    String? adminNotes,
  }) async {
    Map<String, dynamic> body = {'rejection_reason': rejectionReason};

    if (adminNotes != null && adminNotes.isNotEmpty) {
      body['comments'] = adminNotes;
    }

    final response = await ServerConnector.postRequest(
      "application/$applicationId/reject",
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "An error occurred while rejecting the application: ${response.statusCode}",
      );
    }
  }

  //=========================LOAN MANAGEMENT API CALL FUNCTIONS=====================================

  static Future<List<Loan>> fetchLoans() async {
    final response = await ServerConnector.getRequest('loans/');

    if (response.statusCode != 200) {
      throw Exception("An exception occurred: ${response.statusCode}");
    }

    List<dynamic> responseBody = List<dynamic>.from(jsonDecode(response.body));

    return responseBody.map((jsonMap) => Loan.fromJson(jsonMap)).toList();
  }

  static Future<Map<String, dynamic>> fetchLoanInformation(
    String loanId,
  ) async {
    final response = await ServerConnector.getRequest('loans/$loanId/detail');

    if (response.statusCode != 200) {
      throw Exception('An erro occurred: ${response.statusCode}');
    }

    return Map<String, dynamic>.from(jsonDecode(response.body));
  }

  static Future<void> disburseLoan(String loanId) async {
    final response = await ServerConnector.getRequest(
      'loans/$loanId/disburse/',
    );

    if (response.statusCode != 200) {
      throw Exception(
        'There was an error in carrying out fund disbursement: ${response.statusCode}',
      );
    }
  }

  static Future<List<LoanPayment>> fetchLoanPayments(String loanId) async {
    final response = await ServerConnector.getRequest(
      'loans/$loanId/payments/',
    );

    if (response.statusCode != 200) {
      throw Exception('An error occurred: ${response.statusCode}');
    }

    List<Map<String, dynamic>> responseBody = List<Map<String, dynamic>>.from(
      jsonDecode(response.body),
    );

    return responseBody
        .map((jsonMap) => LoanPayment.fromJson(jsonMap))
        .toList();
  }

  static Future<void> recordManualPayment(
    Map<String, dynamic> paymentInfo,
  ) async {
    final response = await ServerConnector.postRequest(
      'loans/record-manual-payment/',
      body: jsonEncode(paymentInfo),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'There was an error in recording loan payment: ${response.statusCode}',
      );
    }

    //leave everything as it is.
  }

  static Future<void> markLoanAsCompleted(String loanId) async {
    final response = await ServerConnector.getRequest(
      'loans/$loanId/mark-completed',
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Could not mark loan as completed: ${response.statusCode}',
      );
    }
  }

  //===========================USER MANAGEMENT API CALL FUNCTIONS===============================
  static Future<List<User>> fetchUsers() async {
    final response = await ServerConnector.getRequest('get-users/');

    if (response.statusCode != 200) {
      throw Exception("An error occurred: ${response.statusCode}");
    }

    final List<Map<String, dynamic>> responseBody =
        List<Map<String, dynamic>>.from(jsonDecode(response.body));

    return responseBody.map((jsonMap) => User.fromJson(jsonMap)).toList();
  }

  //TODO: change the return type from void to user.
  static Future<User> createAdminUser(Map<String, dynamic> userDetail) async {
    final response = await ServerConnector.postRequest(
      'create-user/',
      body: jsonEncode(userDetail),
    );

    if (response.statusCode != 200) {
      throw Exception('Could not create a new user: ${response.statusCode}');
    }

    print(response.body);

    final responseBody = Map<String, dynamic>.from(jsonDecode(response.body));

    return User.fromJson(responseBody);
  }

  static Future<void> updateRole(String username, String newRole) async {
    final response = await ServerConnector.postRequest(
      'change-user-role',
      body: jsonEncode({'username': username, 'role': newRole}),
    );

    if (response.statusCode != 200) {
      throw Exception('Could update user\'s role: ${response.statusCode}');
    }
  }

  static Future<void> updateUserStatus(String username, bool isActive) async {
    final response = await ServerConnector.postRequest(
      'change-user-status/',
      body: jsonEncode({'username': username, 'is_active': isActive}),
    );

    if (response.statusCode != 200) {
      throw Exception('Could not update user status: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> fetchReviewStatics(
    String username,
  ) async {
    final response = await ServerConnector.getRequest(
      'users/$username/review-statistics/',
    );

    if (response.statusCode != 200) {
      throw Exception('An error occurred: ${response.statusCode}');
    }

    final responseBody = Map<String, dynamic>.from(jsonDecode(response.body));

    return responseBody;
  }

  static Future<List<AuditLog>> fetchUserActivity(String username) async {
    final response = await ServerConnector.getRequest(
      'users/$username/activity/',
    );

    if (response.statusCode != 200) {
      throw Exception('An error occurred: ${response.statusCode}');
    }

    final responseBody = List<Map<String, dynamic>>.from(
      jsonDecode(response.body),
    );

    return responseBody.map((jsonMap) => AuditLog.fromJson(jsonMap)).toList();
  }

  static Future<User> getUserFromStudentId(String studentId) async {
    final response = await ServerConnector.getRequest(
      'users/student/$studentId/',
    );

    if (response.statusCode != 200) {
      throw Exception('Could not fetch user object: ${response.statusCode}');
    }

    final responseBody = Map<String, dynamic>.from(jsonDecode(response.body));
    return User.fromJson(responseBody);
  }

  static Future<Map<String, dynamic>> fetchStudentInfo(String username) async {
    final response = await ServerConnector.getRequest(
      'users/$username/studentInfo',
    );

    if (response.statusCode != 200) {
      throw Exception('An Error occurred: ${response.statusCode}');
    }

    return Map<String, dynamic>.from(jsonDecode(response.body));
  }

  static Future<List<LoanApplication>> fetchStudentApplications(
    String username,
  ) async {
    final response = await ServerConnector.getRequest(
      'users/$username/loan-applications/',
    );

    if (response.statusCode != 200) {
      throw Exception('An Error occurred: ${response.statusCode}');
    }

    final responseBody = List<Map<String, dynamic>>.from(
      jsonDecode(response.body),
    );

    return responseBody
        .map((jsonMap) => LoanApplication.fromJson(jsonMap))
        .toList();
  }

  static Future<List<Loan>> fetchStudentLoans(String username) async {
    final response = await ServerConnector.getRequest('users/$username/loans/');

    if (response.statusCode != 200) {
      throw Exception('An unknown occurred: ${response.statusCode}');
    }

    List<Map<String, dynamic>> responseBody = List<Map<String, dynamic>>.from(
      jsonDecode(response.body),
    );

    return responseBody.map((jsonMap) => Loan.fromJson(jsonMap)).toList();
  }

  //=========================NOTIFICATION MANAGEMENT============================================
  static Future<void> sendNotification(
    Map<String, dynamic> notificationBody,
  ) async {
    final response = await ServerConnector.postRequest(
      'send-notification/',
      body: jsonEncode(notificationBody),
    );

    if (response.statusCode != 200) {
      throw Exception('Could not send notification: ${response.statusCode}');
    }
  }
}
