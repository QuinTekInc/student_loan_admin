
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


  static Future<List<Map<String, dynamic>>> getApplications() async {

    return <Map<String, dynamic>>[];
  }
}