
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageServices{

  static const String _AUTH_TOKEN_KEY = "authtoken";
  static const String _LOAN_DRAFT_KEY = "loan_draft";

  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: _AUTH_TOKEN_KEY);
  }

  static Future<void> saveAuthToken(String token) async {
    await _secureStorage.write(key: _AUTH_TOKEN_KEY, value: token);
  }


  static Future<void> saveDraft(Map<String, dynamic> draftMap) async {
    await _secureStorage.write(key: _LOAN_DRAFT_KEY, value: jsonEncode(draftMap));
  }

  static Future<Map<String, dynamic>> getDraftMap() async {
    if(!(await _secureStorage.containsKey(key: _LOAN_DRAFT_KEY))){
      throw Exception("No draft saved yet");
    }
    String draftString = (await _secureStorage.read(key: _LOAN_DRAFT_KEY))!;
    Map<String, dynamic> draftMap = jsonDecode(draftString);

    return draftMap;
  }


}