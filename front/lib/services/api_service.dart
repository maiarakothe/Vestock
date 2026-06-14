// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Altere para o IP/URL do seu servidor Spring Boot
  //static String baseUrl = 'http://192.168.0.101:8000';
  static String baseUrl = 'http://localhost:8000';

  // Armazena o ID da loja da sessão atual para evitar nulos no banco
  static int? lojaId;

  static Map<String, String> get headers {
    final Map<String, String> h = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (lojaId != null) {
      h['lojaId'] = lojaId.toString();
    }
    return h;
  }

  static Uri _buildUri(String path) {
    final uri = Uri.parse('$baseUrl$path');
    if (lojaId == null) return uri;
    final params = Map<String, String>.from(uri.queryParameters);
    params['lojaId'] = lojaId.toString();
    return uri.replace(queryParameters: params);
  }

  static Future<dynamic> get(String path) async {
    final res = await http.get(_buildUri(path), headers: headers);
    _check(res);
    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  static Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(
      _buildUri(path),
      headers: headers,
      body: jsonEncode(body),
    );
    _check(res);
    if (res.body.isEmpty) return null;
    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  static Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final res = await http.put(
      _buildUri(path),
      headers: headers,
      body: jsonEncode(body),
    );
    _check(res);
    if (res.body.isEmpty) return null;
    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  static Future<void> delete(String path) async {
    final res = await http.delete(_buildUri(path), headers: headers);
    _check(res);
  }

  static Future<dynamic> patch(String path) async {
    final res = await http.patch(_buildUri(path), headers: headers);
    _check(res);
    if (res.body.isEmpty) return null;
    return jsonDecode(utf8.decode(res.bodyBytes));
  }

  static Future<dynamic> login(String email, String senha) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'email': email, 'senha': senha},
    );

    _check(res);

    if (res.body.isEmpty) {
      return null;
    }

    return jsonDecode(utf8.decode(res.bodyBytes));
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
