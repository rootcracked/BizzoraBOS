import 'dart:convert';

import 'package:bizzora_mobile/core/api_service.dart';
import 'package:bizzora_mobile/features/expenses/models/expense.dart';
import 'package:bizzora_mobile/features/expenses/models/response.dart';

class Expenseservice {
  final ApiClient _apiClient = ApiClient();

  Future<ExpenseResponse> addExpense(expenseRequest request) async {
    try {
      final response = await _apiClient.post(
        "/users/admin/add-expense",
        request.toJson(),
        auth: true,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ExpenseResponse.fromJson(data);
      } else {
        throw Exception(data['message'] ?? "Cant add Expense");
      }
    } catch (e) {
      throw Exception("Error adding expense: $e");
    }
  }
}
