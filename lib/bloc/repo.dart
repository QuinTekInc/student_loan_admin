
import 'dart:convert';

import 'package:loan_admin/components/server_connector.dart';
import 'package:loan_admin/components/services.dart';
import 'package:loan_admin/models/models.dart';

class Repository{

  static Future<User> login(String username, String password) async {

    final response = await ServerConnector.postRequest(
      'login/',
      body: jsonEncode({'username': username, 'password': password})
    );

    if(response.statusCode != 200){
      throw Exception('An error occurred: ${response.statusCode}');
    }

    Map<String, dynamic> jsonMap = Map<String, dynamic>.from(jsonDecode(response.body));

    await SecureStorageServices.saveAuthToken(jsonMap['token']);

    return User.fromJson(jsonMap);
  }

  static Future<void> logout() async {

  }


  static Future<List<LoanApplication>> fetchApplications() async {
    
    final response = await ServerConnector.getRequest('applications/');
    
    if(response.statusCode != 200){
      throw Exception("An Exception occurred: ${response.statusCode}");
    }
    
    List<dynamic> responseBody = List<dynamic>.from(jsonDecode(response.body));

    return responseBody.map((jsonMap) => LoanApplication.fromJson(jsonMap)).toList();
  }


  static Future<Map<String, dynamic>> getApplicationReview(String applicationId) async {

    final response = await ServerConnector.getRequest('applications/$applicationId/review/details/');

    if(response.statusCode != 200) throw Exception("An Error occurred: ${response.statusCode}");

    Map<String, dynamic> responseMap = Map<String, dynamic>.from(jsonDecode(
      response.body));

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
      })
    );

    if(request.statusCode != 200){
      throw Exception('An Exception occurred: ${request.statusCode}');
    }
  }

  static Future<List<Loan>> fetchLoans() async {

    final response = await ServerConnector.getRequest('loans/');

    if(response.statusCode != 200) throw Exception("An exception occurred: ${response.statusCode}");

    List<dynamic> responseBody = List<dynamic>.from(jsonDecode(response.body));

    return responseBody.map((jsonMap) => Loan.fromJson(jsonMap)).toList();
  }

  static Future<List<User>> fetchUsers() async {

    final response = await ServerConnector.getRequest('get-users/');

    if(response.statusCode != 200) throw Exception("An error occurred: ${response.statusCode}");

    final List<Map<String, dynamic>> responseBody = List<Map<String, dynamic>>.from(
        jsonDecode(response.body));

    return responseBody.map((jsonMap) => User.fromJson(jsonMap)).toList();
  }
}