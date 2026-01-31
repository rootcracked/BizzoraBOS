import 'dart:convert';

import 'package:bizzora_mobile/core/api_service.dart';
import './sale_request.dart';
class SalesService {

  final ApiClient _apiClient = ApiClient();
  Future<void> sellProduct(SaleRequest request  ) async {
    
    try {
      final response = await _apiClient.post(
        "/users/admin/sales",
        request.toJson(),
        auth: true, 
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw Exception(data['error'] ?? "Failed to sell product");
      }

      
    } catch (e) {
      throw Exception(" Error selling product: $e");
    }

    
     
    

  } 
}
