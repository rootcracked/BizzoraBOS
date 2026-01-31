import 'package:bizzora_mobile/features/product/Models/product_response.dart';
import 'package:riverpod/riverpod.dart';

import 'package:bizzora_mobile/features/product/Models/product_request.dart';
import 'package:bizzora_mobile/features/product/ProductService/product_service.dart';
import './productState.dart';

// Provider for ProductService
final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService();
});

// ProductNotifier using the new Notifier API
class ProductNotifier extends Notifier<ProductState> {
  late final ProductService _productService = ref.read(productServiceProvider);

  @override
  ProductState build() {
    // Initialize ProductService via ref

    return ProductState.initial();
  }

  Future<ProductResponse> addProduct(
    String productName,
    buyingPrice,
    sellingPrice,
    quantity,
  ) async {
    try {
      final productData = ProductRequest(
        productName: productName,
        buyingPrice: buyingPrice,
        sellingPrice: sellingPrice,
        quantity: quantity,
      );
      final newProduct = await _productService.addProduct(productData);

      state = state.copyWith(products: [...state.products, newProduct]);

      return newProduct;
    } catch (e) {
      throw Exception("Error adding product $e");
    }
  }

  Future<void> getProducts() async {
    try {
      final products = await _productService.getProducts();
      state = state.copyWith(products: products);
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}

// Notifier provider
final productProvider = NotifierProvider<ProductNotifier, ProductState>(
  ProductNotifier.new,
);
