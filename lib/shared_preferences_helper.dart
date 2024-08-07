import 'dart:convert';

import 'package:expense_tracker/models/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const _expensesKey = 'expenses';

  // Save expenses to shared preferences
  static Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encodedExpenses =
        expenses.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_expensesKey, encodedExpenses);
  }

  // Load expenses from shared preferences
  static Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encodedExpenses = prefs.getStringList(_expensesKey);

    if (encodedExpenses == null) {
      return [];
    }

    return encodedExpenses.map((e) => Expense.fromJson(jsonDecode(e))).toList();
  }
}
