class expenseRequest {
  final String expenseName;
  final int amount;

  expenseRequest({required this.expenseName, required this.amount});

  Map<String, dynamic> toJson() => {'expense': expenseName, 'amount': amount};
}
