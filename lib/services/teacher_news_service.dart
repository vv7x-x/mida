import 'dart:convert';
import 'package:http/http.dart' as http;

class TeacherNewsService {
  Future<List<dynamic>> getNews() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/news'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load news');
    }
  }
}