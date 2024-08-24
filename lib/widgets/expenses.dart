import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/lendborrow_provider.dart'; // Import your provider
import 'package:expense_tracker/screens/lend_borrow_screen.dart';
import 'package:expense_tracker/shared_preferences_helper.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/lendborrow_list/lendborrow_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/new_lendborrow.dart';
import 'package:expense_tracker/widgets/totalCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Expenses extends StatefulWidget {
  Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  List<Expense> _registeredExpenses = [];
  List<LendBorrow> _registeredLendBorrow = [];
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
    _loadLendBorrow();
  }

  Future<void> _loadExpenses() async {
    _registeredExpenses = await SharedPreferencesHelper.loadExpenses();
    setState(() {});
  }

  Future<void> _saveExpenses() async {
    await SharedPreferencesHelper.saveExpenses(_registeredExpenses);
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _openAddLendBorrowOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewLendBorrow(onAddLendBorrow: _addLendBorrow),
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
      _registeredExpenses.sort((a, b) => b.date.compareTo(a.date));
      _saveExpenses();
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
      _saveExpenses();
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text("Expense Deleted"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
                _registeredExpenses.sort((a, b) => b.date.compareTo(a.date));
                _saveExpenses();
              });
            }),
      ),
    );
  }

  Future<void> _loadLendBorrow() async {
    _registeredLendBorrow = await SharedPreferencesHelper.loadLendBorrow();
    setState(() {});
  }

  Future<void> _saveLendBorrow() async {
    await SharedPreferencesHelper.saveLendBorrow(_registeredLendBorrow);
  }

  void _addLendBorrow(LendBorrow lendborrow) {
    setState(() {
      _registeredLendBorrow.add(lendborrow);
      _registeredLendBorrow.sort((a, b) => b.date.compareTo(a.date));

      _saveLendBorrow();
    });
  }

  void _removeLendBorrow(LendBorrow lendborrow, WidgetRef ref) {
    final lendborrowIndex = _registeredLendBorrow.indexOf(lendborrow);
    setState(() {
      _registeredLendBorrow.remove(lendborrow);

      // Use Riverpod to call removeLend or removeBorrow
      final totalLendBorrowNotifier =
          ref.read(totalLendBorrowProvider.notifier);

      if (lendborrow.ldCat == LDCat.lend) {
        totalLendBorrowNotifier.removeLend(lendborrow.amount.toInt());
      } else {
        totalLendBorrowNotifier.removeBorrow(lendborrow.amount.toInt());
      }

      _saveLendBorrow();
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: const Text("Transaction Deleted"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registeredLendBorrow.insert(lendborrowIndex, lendborrow);
                final totalLendBorrowNotifier =
                    ref.read(totalLendBorrowProvider.notifier);

                if (lendborrow.ldCat == LDCat.lend) {
                  totalLendBorrowNotifier.addLend(lendborrow.amount.toInt());
                } else {
                  totalLendBorrowNotifier.addBorrow(lendborrow.amount.toInt());
                }
                _registeredLendBorrow.sort((a, b) => b.date.compareTo(a.date));
                _saveLendBorrow();
              });
            }),
      ),
    );
  }

  void _resetAll() {
    setState(() {
      _registeredExpenses.clear();
      _saveExpenses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = Center(
      child: _registeredExpenses.isEmpty
          ? const Text("No expenses found. Start adding some!")
          : ExpensesList(
              expenses: _registeredExpenses,
              onRemoveExpense: _removeExpense,
            ),
    );

    Widget activeAddButton = IconButton(
      onPressed: _openAddExpenseOverlay,
      icon: const Icon(Icons.add),
    );

    Widget activeScreen = width < 600
        ? Column(
            children: [
              Chart(expenses: _registeredExpenses),
              Totalcard(resetAll: _resetAll),
              SizedBox(height: 8),
              Expanded(child: mainContent),
            ],
          )
        : Row(
            children: [
              Expanded(child: Chart(expenses: _registeredExpenses)),
              Expanded(child: mainContent),
            ],
          );

    if (_selectedPageIndex == 1) {
      mainContent = Consumer(
        builder: (context, ref, child) {
          return Center(
            child: _registeredLendBorrow.isEmpty
                ? const Text("No Transactions found. Start adding some!")
                : LendborrowList(
                    lendborrow: _registeredLendBorrow,
                    onRemoveLendBorrow: (lendborrow) {
                      _removeLendBorrow(lendborrow, ref);
                    },
                  ),
          );
        },
      );
      activeScreen = LendBorrowScreen(
        mainContent: mainContent,
      );
      activeAddButton = IconButton(
        onPressed: _openAddLendBorrowOverlay,
        icon: const Icon(Icons.add),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedPageIndex == 0 ? "Expenses" : "Lends & Borrows"),
        actions: [activeAddButton],
      ),
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: "Expenses"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance), label: "Lends & Borrows")
        ],
      ),
    );
  }
}
