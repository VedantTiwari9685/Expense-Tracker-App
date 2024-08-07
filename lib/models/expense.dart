// expense.dart
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
