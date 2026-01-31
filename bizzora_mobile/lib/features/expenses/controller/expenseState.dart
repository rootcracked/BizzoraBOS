import 'package:bizzora_mobile/features/expenses/models/response.dart';

class Expensestate {
  final List<ExpenseResponse> expenses;

  Expensestate({this.expenses = const []});

  Expensestate copyWith({List<ExpenseResponse>? expenses}) {
    return Expensestate(expenses: expenses ?? this.expenses);
  }

  factory Expensestate.initial() => Expensestate();
}
