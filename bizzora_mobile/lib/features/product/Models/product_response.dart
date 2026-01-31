class ProductResponse {
  final String id;
  final String businessId;
  final String businessName;
  final String productName;
  final int buyingPrice;
  final int sellingPrice;
  final int quantity;

  ProductResponse({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.productName,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.quantity,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      id: json['ID']?.toString() ?? '',
      businessName: json['Business_Name'] ?? '',
      businessId: json['Business_ID']?.toString() ?? '',
      productName: json["Product_Name"] ?? '',
      buyingPrice: json["Buying_Price"] ?? '',
      sellingPrice: json["Selling_Price"] ?? '',
      quantity: json["Quantity"] ?? '',
    );
  }
}
