class ExpenseResponse {
  final String id;
  final String businessId;
  final String businessName;
  final String expenseName;
  final int amount;

  ExpenseResponse({
    required this.id,
    required this.businessId,
    required this.businessName,
    required this.expenseName,
    required this.amount,
  });

  factory ExpenseResponse.fromJson(Map<String, dynamic> json) {
    return ExpenseResponse(
      id: json["ID"]?.toString() ?? '',
      businessId: json["Business_ID"] ?? '',
      businessName: json["Business_Name"] ?? '',
      expenseName: json["Expense"] ?? '',
      amount: json["Amount"] ?? '',
    );
  }
}
