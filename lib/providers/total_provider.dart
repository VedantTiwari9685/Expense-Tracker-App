import 'dart:convert';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final totalProviderNotifierProvider =
    StateNotifierProvider<TotalProviderNotifier, TotalExpense>(
  (ref) => TotalProviderNotifier(),
);

class TotalProviderNotifier extends StateNotifier<TotalExpense> {
  TotalProviderNotifier() : super(TotalExpense()) {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('totalExpense');
    if (jsonString != null) {
      state = TotalExpense.fromJson(jsonDecode(jsonString));
    }
  }

  // Save the data to shared preferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('totalExpense', jsonEncode(state.toJson()));
  }

  // Methods to update the total budget and spent
  void addBudget(int newBudget) {
    state = TotalExpense(
      totalBudget: state.totalBudget + newBudget,
      totalSpent: state.totalSpent,
      remaining: state.remaining + newBudget,
    );
    _saveData();
  }

  void subtractBudget(int amount) {
    state = TotalExpense(
      totalBudget: state.totalBudget - amount,
      totalSpent: state.totalSpent,
      remaining: state.totalBudget - state.totalSpent,
    );
    _saveData();
  }

  void resetAllToZero() {
    state = TotalExpense(totalBudget: 0, totalSpent: 0, remaining: 0);
  }

  void addSpent(int amount) {
    state = TotalExpense(
      totalBudget: state.totalBudget,
      totalSpent: state.totalSpent + amount,
      remaining: state.remaining - amount,
    );
    _saveData();
  }

  void resetSpentToZero() {
    state = TotalExpense(
      totalBudget: state.totalBudget,
      totalSpent: 0,
      remaining: state.remaining,
    );
    _saveData();
  }
}
