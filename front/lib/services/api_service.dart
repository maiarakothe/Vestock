// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Altere para o IP/URL do seu servidor Spring Boot
  //static String baseUrl = 'http://192.168.0.101:8000';
  static String baseUrl = 'http://localhost:8000';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<dynamic> get(String path) async {
    final res = await http.get(Uri.parse('$baseUrl$path'), headers: headers);
    _check(res);
    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: headers,
      body: jsonEncode(body),
    );
    _check(res);
    if (res.body.isEmpty) return null;
    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  static Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('$baseUrl$path'),
      headers: headers,
      body: jsonEncode(body),
    );
    _check(res);
    if (res.body.isEmpty) return null;
    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  static Future<void> delete(String path) async {
    final res = await http.delete(Uri.parse('$baseUrl$path'), headers: headers);
    _check(res);
  }

  static Future<dynamic> patch(String path) async {
    final res = await http.patch(Uri.parse('$baseUrl$path'), headers: headers);
    _check(res);
    if (res.body.isEmpty) return null;
    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  static Future<String> login(String username, String senha) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'username': username, 'senha': senha},
    );
    if (res.statusCode != 200) {
      throw Exception(res.body.isNotEmpty ? res.body : 'Erro ${res.statusCode}');
    }
    return res.body;
  }

  static void _check(http.Response res) {
    if (res.statusCode >= 400) {
      String msg = 'Erro ${res.statusCode}';
      try {
        final body = jsonDecode(utf8.decode(res.bodyBytes));
        msg = body['message'] ?? body['erro'] ?? msg;
      } catch (_) {
        if (res.body.isNotEmpty) msg = res.body;
      }
      throw Exception(msg);
    }
  }
}