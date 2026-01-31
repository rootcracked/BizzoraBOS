import 'package:bizzora_mobile/features/product/Models/product_response.dart';

class ProductState {
  
  final List<ProductResponse> products;
  

  ProductState({
    
    this.products = const [],
  
  });

  ProductState copyWith({
  
    List<ProductResponse>? products,
    
  }) {
    return ProductState(
      
      products: products ?? this.products,
      
    );
  }

  factory ProductState.initial() => ProductState();
}
