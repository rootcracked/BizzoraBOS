import 'dart:convert';

import 'package:bizzora_mobile/core/api_service.dart';
import 'package:bizzora_mobile/features/auth/models/login_request.dart';
import 'package:bizzora_mobile/features/workers/models/request.dart';
import 'package:bizzora_mobile/features/workers/models/response.dart';

class WorkerService {
  final ApiClient _apiClient = ApiClient();

  Future<Response> addWorker(Request request) async {
    try {
      final response = await _apiClient.post(
        "/users/admin/add-worker",
        request.toJson(),
        auth: true,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Response.fromJson(data);
      } else {
        throw Exception(data['message'] ?? "Cant add Worker ...");
      }
    } catch (e) {
      print(e);
      throw Exception("Error adding Worker: $e");
    }
  }

  Future<List<Response>> getWorkers() async {
    try {
      final response = await _apiClient.get(
        "/users/admin/get-workers",
        auth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // If the API returns a JSON array of products:
        final List<Response> products = (data as List)
            .map((item) => Response.fromJson(item))
            .toList();

        return products;
      } else {
        // You can throw an error or return empty list if status code not OK
        throw Exception(
          'Failed to fetch products. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Handle network or parsing errors
      throw Exception('Error fetching products: $e');
    }
  }

  Future<Response> login(LoginRequest request) async {
    final response = await _apiClient.post("/worker/login", request.toJson());
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Response.fromJson(data);
    } else {
      throw Exception(data["message"] ?? 'Login Failed');
    }
  }
}
