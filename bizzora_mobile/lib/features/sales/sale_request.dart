class SaleRequest {
  final String productId;
  final int quantity;

  SaleRequest({
    required this.productId,
    required this.quantity
  });

  Map<String, dynamic> toJson() => {
    'product_id': productId,
    'quantity' : quantity
  };
}
