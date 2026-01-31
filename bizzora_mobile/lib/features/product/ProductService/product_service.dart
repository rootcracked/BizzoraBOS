import 'dart:convert';

import 'package:bizzora_mobile/core/api_service.dart';
import 'package:bizzora_mobile/features/product/Models/product_request.dart';
import 'package:bizzora_mobile/features/product/Models/product_response.dart';

class ProductService {
  final ApiClient _apiClient = ApiClient();

  Future<ProductResponse> addProduct(ProductRequest request) async {
    try {
      final response = await _apiClient.post(
        "/users/admin/add-product",
        request.toJson(),
        auth: true,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ProductResponse.fromJson(data);
      } else {
        throw Exception(data['message'] ?? "Cant add Product ...");
      }
    } catch (e) {
      throw Exception("Error adding product: $e");
    }
  }

  Future<List<ProductResponse>> getProducts() async {
    try {
      final response = await _apiClient.get(
        "/users/admin/get-products",
        auth: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // If the API returns a JSON array of products:
        final List<ProductResponse> products = (data as List)
            .map((item) => ProductResponse.fromJson(item))
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
}
