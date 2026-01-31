import 'package:bizzora_mobile/features/expenses/controller/expenseState.dart';
import 'package:bizzora_mobile/features/expenses/models/expense.dart';
import 'package:bizzora_mobile/features/expenses/models/response.dart';
import 'package:bizzora_mobile/features/expenses/service/expenseService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final expenseProvider = Provider<Expenseservice>((ref) {
  return Expenseservice();
});

class expenseNotifier extends Notifier<Expensestate> {
  late final Expenseservice _expenseservice = ref.read(expenseProvider);

  @override
  Expensestate build() {
    return Expensestate.initial();
  }

  Future<ExpenseResponse> addExpense(String name, int amount) async {
    try {
      final expenseData = expenseRequest(expenseName: name, amount: amount);

      final newExpense = await _expenseservice.addExpense(expenseData);
      state = state.copyWith(expenses: [...state.expenses, newExpense]);

      return newExpense;
    } catch (e) {
      throw Exception("Error adding expense $e");
    }
  }
}
