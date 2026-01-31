class ProductRequest {
  final String productName;
  final int buyingPrice;
  final int sellingPrice;
  final int quantity;
  
 ProductRequest({
    
    required this.productName,
    required this.buyingPrice,
    required this.sellingPrice,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
      
        'product_name': productName,
        'buying_price': buyingPrice,
        'selling_price': sellingPrice,
        'quantity': quantity
      }; 
  
}
