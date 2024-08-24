import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/lendborrow_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('dd/MM/yyyy');

class NewLendBorrow extends ConsumerStatefulWidget {
  const NewLendBorrow({super.key, required this.onAddLendBorrow});

  final void Function(LendBorrow lendborrow) onAddLendBorrow;

  @override
  _NewLendBorrowState createState() => _NewLendBorrowState();
}

class _NewLendBorrowState extends ConsumerState<NewLendBorrow> {
  final _personController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _selectedDate;
  LDCat _selectedCategory = LDCat.lend;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
                title: const Text("Invalid Input"),
                content: const Text(
                    "Please make sure a valid Person Name, Description, Amount, Date and Category was entered."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text("Okay"))
                ],
              ));
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text(
              "Please make sure a valid Person Name, Description, Amount, Date and Category was entered."),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text("Okay"))
          ],
        ),
      );
    }
  }

  void _submitLendBorrowData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amoutIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_personController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        amoutIsInvalid ||
        _selectedDate == null) {
      _showDialog();

      return;
    }

    widget.onAddLendBorrow(
      LendBorrow(
        person: _personController.text,
        description: _descriptionController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        ldCat: _selectedCategory,
      ),
    );
    final totalLendBorrowNotifier = ref.read(totalLendBorrowProvider.notifier);

    if (_selectedCategory == LDCat.lend) {
      totalLendBorrowNotifier.addLend(enteredAmount.toInt());
    } else {
      totalLendBorrowNotifier.addBorrow(enteredAmount.toInt());
    }
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _personController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;

        return SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 48, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _personController,
                            maxLength: 50,
                            decoration: const InputDecoration(
                              label: Text("Person Name"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _descriptionController,
                            maxLength: 50,
                            decoration: const InputDecoration(
                              label: Text("Description"),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: _personController,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        label: Text("Person Name"),
                      ),
                    ),
                  if (width >= 600)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: "₹ ",
                              label: Text("Amount"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 44,
                        ),
                        DropdownButton(
                          value: _selectedCategory,
                          items: LDCat.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(_selectedDate == null
                                  ? "No Date Selected"
                                  : formatter.format(_selectedDate!)),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(
                                  Icons.calendar_month,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              prefixText: "₹ ",
                              label: Text("Amount"),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _descriptionController,
                                  decoration: const InputDecoration(
                                    label: Text("Description"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (width >= 600)
                    SizedBox()
                  else
                    Row(
                      children: [
                        DropdownButton(
                          value: _selectedCategory,
                          items: LDCat.values
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.name.toUpperCase(),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                        ),
                        const Spacer(),
                        Text(_selectedDate == null
                            ? "No Date Selected"
                            : formatter.format(_selectedDate!)),
                        IconButton(
                          onPressed: _presentDatePicker,
                          icon: const Icon(
                            Icons.calendar_month,
                          ),
                        )
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: _submitLendBorrowData,
                        child: const Text("Save Transaction"),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
