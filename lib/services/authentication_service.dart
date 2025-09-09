import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AuthenticationService {
  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5179/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(Map<String, String> userData, Uint8List imageBytes, String imageName) async {
    var request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:5179/api/register'));
    request.fields.addAll(userData);
    request.files.add(http.MultipartFile.fromBytes('idImage', imageBytes, filename: imageName));

    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}