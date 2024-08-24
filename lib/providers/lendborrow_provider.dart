import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final totalLendBorrowProvider =
    StateNotifierProvider<TotalLendBorrowNotifier, TotalLendBorrow>(
  (ref) => TotalLendBorrowNotifier(),
);

class TotalLendBorrow {
  TotalLendBorrow({
    int totalLend = 0,
    int totalBorrow = 0,
  })  : _totalLend = totalLend,
        _totalBorrow = totalBorrow;

  final int _totalLend;
  final int _totalBorrow;

  int get totalLend => _totalLend;
  int get totalBorrow => _totalBorrow;

  // Convert TotalLendBorrow object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'totalLend': _totalLend,
      'totalBorrow': _totalBorrow,
    };
  }

  // Create from JSON
  factory TotalLendBorrow.fromJson(Map<String, dynamic> json) {
    return TotalLendBorrow(
      totalLend: json['totalLend'] as int,
      totalBorrow: json['totalBorrow'] as int,
    );
  }
}

class TotalLendBorrowNotifier extends StateNotifier<TotalLendBorrow> {
  TotalLendBorrowNotifier() : super(TotalLendBorrow()) {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('totalLendBorrow');
    if (jsonString != null) {
      state = TotalLendBorrow.fromJson(jsonDecode(jsonString));
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('totalLendBorrow', jsonEncode(state.toJson()));
  }

  void addLend(int amount) {
    state = TotalLendBorrow(
      totalLend: state.totalLend + amount,
      totalBorrow: state.totalBorrow,
    );
    _saveData();
  }

  void removeLend(int amount) {
    state = TotalLendBorrow(
      totalLend: state.totalLend - amount,
      totalBorrow: state.totalBorrow,
    );
    _saveData();
  }

  // Method to add borrow amount
  void addBorrow(int amount) {
    state = TotalLendBorrow(
      totalLend: state.totalLend,
      totalBorrow: state.totalBorrow + amount,
    );
    _saveData();
  }

  void removeBorrow(int amount) {
    state = TotalLendBorrow(
      totalLend: state.totalLend,
      totalBorrow: state.totalBorrow - amount,
    );
    _saveData();
  }
}
