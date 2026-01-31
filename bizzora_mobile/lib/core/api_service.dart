import 'dart:convert';
import 'package:http/http.dart' as http;
import './storage_service.dart';
import './api.dart';

class ApiClient {
  final http.Client _client = http.Client();

  Future<http.Response> post(String endpoint, Map<String, dynamic> data, {bool auth = false}) async {
    final url = Uri.parse('$apiUrl$endpoint');
    final headers = {'Content-Type': 'application/json'};

    // Attach token only if it's an authenticated request
    if (auth) {
      final token = await StorageService.getToken();
      headers['Authorization'] = 'Bearer $token';
    }

    return await _client.post(url, headers: headers, body: jsonEncode(data));
  }

  Future<http.Response> get(String endpoint, {bool auth = false}) async {
    final url = Uri.parse('$apiUrl$endpoint');
    final headers = {'Content-Type': 'application/json'};

    if (auth) {
      final token = await StorageService.getToken();
      headers['Authorization'] = 'Bearer $token';
    }

    return await _client.get(url, headers: headers);
  }
}

