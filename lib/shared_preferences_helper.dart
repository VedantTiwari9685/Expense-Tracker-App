import 'dart:convert';

import 'package:expense_tracker/models/expense.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const _expensesKey = 'expenses';
  static const _totalExpenseKey = 'totalExpense';
  static const _lendBorrowKey = 'lendBorrow'; // New key for LendBorrow data

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

  // Save total expense data to shared preferences
  static Future<void> saveTotalExpense(TotalExpense totalExpense) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(totalExpense.toJson());
    await prefs.setString(_totalExpenseKey, json);
  }

  // Load total expense data from shared preferences
  static Future<TotalExpense> loadTotalExpense() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_totalExpenseKey);

    if (jsonString == null) {
      return TotalExpense();
    }

    final jsonMap = jsonDecode(jsonString);
    return TotalExpense.fromJson(jsonMap);
  }

  // Save LendBorrow data to shared preferences
  static Future<void> saveLendBorrow(List<LendBorrow> lendBorrowList) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encodedLendBorrow =
        lendBorrowList.map((lb) => jsonEncode(lb.toJson())).toList();
    await prefs.setStringList(_lendBorrowKey, encodedLendBorrow);
  }

  // Load LendBorrow data from shared preferences
  static Future<List<LendBorrow>> loadLendBorrow() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? encodedLendBorrow = prefs.getStringList(_lendBorrowKey);

    if (encodedLendBorrow == null) {
      return [];
    }

    return encodedLendBorrow
        .map((lb) => LendBorrow.fromJson(jsonDecode(lb)))
        .toList();
  }
}
