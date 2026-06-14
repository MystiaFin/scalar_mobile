import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  Future<String> _getBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('base_url') ?? '';
    if (url.isEmpty) throw Exception('No endpoint set. Configure it in settings.');
    return url;
  }

  Future<dynamic> get(String path) async {
    final base = await _getBaseUrl();
    final response = await http.get(Uri.parse('$base$path'));
    if (response.statusCode == 200) return jsonDecode(response.body);
    throw Exception('GET $path failed: ${response.statusCode}');
  }

  Future<dynamic> patch(String path, Map<String, dynamic> body) async {
    final base = await _getBaseUrl();
    final response = await http.patch(
      Uri.parse('$base$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    }
    throw Exception('PATCH $path failed: ${response.statusCode}');
  }
}
