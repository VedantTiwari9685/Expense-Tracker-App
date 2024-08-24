import 'package:expense_tracker/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final formatter = DateFormat.yMd();
const uuid = Uuid();

enum Category {
  food,
  travel,
  movie,
  work,
  shopping,
  medical,
  personalCare,
  education,
  sports,
  esports,
}

enum LDCat {
  lend,
  borrow,
}

const ldCatIcons = {
  LDCat.lend: Icons.arrow_upward,
  LDCat.borrow: Icons.arrow_downward,
};

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.movie: Icons.movie_creation_sharp,
  Category.work: Icons.work,
  Category.shopping: Icons.shopping_cart,
  Category.medical: Icons.medical_services_rounded,
  Category.personalCare: Icons.bathtub,
  Category.education: Icons.school_sharp,
  Category.sports: Icons.sports_cricket,
  Category.esports: Icons.sports_esports,
};

class LendBorrow {
  LendBorrow({
    required this.person,
    required this.description,
    required this.amount,
    required this.ldCat,
    required this.date,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String person;
  final String description;
  final double amount;
  final DateTime date;
  final LDCat ldCat;

  String get formattedDate {
    return formatter.format(date);
  }

  // Convert LendBorrow object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'person': person,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'ldCat': ldCat.name,
    };
  }

  // Create LendBorrow object from JSON map
  factory LendBorrow.fromJson(Map<String, dynamic> json) {
    return LendBorrow(
      id: json['id'] as String,
      person: json['person'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      ldCat: LDCat.values.firstWhere(
        (e) => e.name == (json['ldCat'] as String),
      ),
    );
  }
}

class TotalLendBorrow {
  TotalLendBorrow({
    int totalLend = 0,
    int totalBorrow = 0,
  })  : _totalLend = totalLend,
        _totalBorrow = totalBorrow;

  int _totalLend;
  int _totalBorrow;
  int get totalLend => _totalLend;
  int get totalBorrow => _totalBorrow;
}

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    String? id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }

  // Convert Expense object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category.name,
    };
  }

  // Create Expense object from JSON map
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      category: Category.values.firstWhere(
        (e) => e.name == (json['category'] as String),
      ),
    );
  }
}

class TotalExpense {
  TotalExpense({
    int totalBudget = 0,
    int totalSpent = 0,
    int remaining = 0,
  })  : _totalBudget = totalBudget,
        _totalSpent = totalSpent,
        _remaining = remaining;

  int _totalBudget;
  int _totalSpent;
  int _remaining;

  int get totalBudget => _totalBudget;
  int get totalSpent => _totalSpent;
  int get remaining => _remaining;

  // Update total budget
  void addBudget(int newBudget) {
    _totalBudget += newBudget;
    _remaining = _totalBudget - _totalSpent;
    _saveData();
  }

  void substractBudget(int newBudget) {
    _totalBudget -= newBudget;
    _remaining = _totalBudget - _totalSpent;
    _saveData();
  }

  // Update total spent
  void addSpent(int amount) {
    _totalSpent += amount;
    _remaining = _totalBudget - _totalSpent;
    _saveData();
  }

  void resetSpentToZero() {
    _totalSpent = 0;
    _remaining = _totalBudget - _totalSpent;
    _saveData();
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBudget': _totalBudget,
      'totalSpent': _totalSpent,
      'remaining': _remaining,
    };
  }

  // Create from JSON
  factory TotalExpense.fromJson(Map<String, dynamic> json) {
    return TotalExpense(
      totalBudget: json['totalBudget'] as int,
      totalSpent: json['totalSpent'] as int,
      remaining: json['remaining'] as int,
    );
  }

  // Save data to shared preferences
  Future<void> _saveData() async {
    await SharedPreferencesHelper.saveTotalExpense(this);
  }
}

class ExpenseBucket {
  ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }
}
