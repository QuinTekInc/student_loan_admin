
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:loan_admin/components/services.dart';
import 'services.dart';
import 'package:web_socket_client/web_socket_client.dart';

class ServerConnector{

  static String url = "http://127.0.0.1:8000/admin-api";

  static String _concatUrl(String endpoint) => '$url/$endpoint';

  static Future<Map<String, String>> _initHeaders() async{
    //get the user's authorization token from the flutter secure storage.
    Map<String, String> headers = {
      'Content-Type': 'application/json'
    };

    String? authToken = await SecureStorageServices.getAuthToken();

    if(authToken != null){
      headers['Authorization']  = "Token $authToken";
      //print the authorization token if exists.
      print('Authorization token: $authToken}');
    }

    return headers;
  }


  static Future<http.Response> getRequest(String endpoint) async {

    Uri url = Uri.parse(_concatUrl(endpoint));

    return await http.get(url, headers: await _initHeaders());
  }

  static Future<http.Response> postRequest(String endpoint, {required dynamic body}) async {
    Uri url = Uri.parse(_concatUrl(endpoint));

    return await http.post(url, body: body, headers: await _initHeaders());
  }


  static Future<http.Response> putRequest(String endpoint, {required dynamic body}) async {
    Uri url = Uri.parse(_concatUrl(endpoint));

    return await http.put(url, body: body, headers: await _initHeaders());
  }


  static Future<http.Response> deleteRequest(String endpoint) async {
    Uri url = Uri.parse(_concatUrl(endpoint));
    return await http.post(url, headers: await _initHeaders());
  }


  static Future<http.StreamedResponse> multipartRequest({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String?>? filePaths
  }) async {

    final url = Uri.parse(_concatUrl(endpoint));

    final request = http.MultipartRequest(method, url);

    String token = (await SecureStorageServices.getAuthToken()) ?? '';

    if(token.trim().isNotEmpty){
      request.headers['Authorization'] = 'Token $token';
    }

    print('[SERVERCONNECTOR] Multipart Headers: ${request.headers}');


    if(body != null){
      for(String k in body.keys){
        request.fields[k] = body[k].toString();
      }
    }

    if(filePaths != null){
      for(String fk in filePaths.keys){
        String? filePath = filePaths[fk];

        if(filePath == null) continue;

        request.files.add(
            await http.MultipartFile.fromPath(fk, filePath)
        );
      }
    }


    final response = await request.send();
    return response;
  }



  Future<void> uploadFile(File file) async {

    var uri = Uri.parse(
      "http://127.0.0.1:8000/upload-document/",
    );

    var request = http.MultipartRequest(
      'POST',
      uri,
    );

    // file field name MUST match Django serializer field
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
      ),
    );

    // optional extra fields
    request.fields['title'] = 'Passport Photo';

    var response = await request.send();

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      print("Upload successful");
    } else {
      print("Upload failed");
    }
  }

}



class WebSocketService {

  late WebSocket _socket;
  final StreamController<dynamic> _streamController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<dynamic> get dataStream =>  _streamController.stream;

  final String endpoint;
  final bool Function(dynamic data) streamValidator;

  WebSocketService({ required this.endpoint, required this.streamValidator}){
    connect();
  }

  void connect() async {

    String token = (await SecureStorageServices.getAuthToken()) ?? '';

    try{
      _socket = WebSocket(Uri.parse(endpoint), headers: {'Authorization': 'Token ${token.trim()}'});

      _socket.messages.listen(
              (message) {
            // Assuming the incoming message is a JSON string
            dynamic data =  jsonDecode(message);

            if(streamValidator(data)){
              _streamController.add(data);
            }

          },
          onError: (error) async  {
            _streamController.addError(error);
            await _streamController.close();
          },

          onDone: () => _socket.close()
      );

    }catch(ex){
      throw Exception(ex.toString());
    }
  }



  void send(Map<String, dynamic> data){
    _socket.send(jsonEncode(data));
  }


  void dispose(){
    _socket.close();
    _streamController.close();
  }

}