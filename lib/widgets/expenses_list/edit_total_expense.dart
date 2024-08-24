import 'dart:io';

import 'package:expense_tracker/providers/total_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditBudgetScreen extends ConsumerStatefulWidget {
  EditBudgetScreen({super.key, required this.resetAll});
  final void Function() resetAll;

  @override
  _EditBudgetScreenState createState() => _EditBudgetScreenState();
}

class _EditBudgetScreenState extends ConsumerState<EditBudgetScreen> {
  late final TextEditingController _addBudgetController;

  @override
  void initState() {
    super.initState();
    _addBudgetController = TextEditingController();
  }

  @override
  void dispose() {
    _addBudgetController.dispose();
    super.dispose();
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text("Invalid Input"),
          content: const Text("Please make sure a valid amount was entered."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("Okay"),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text("Please make sure a valid amount was entered."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text("Okay"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalNotifier = ref.read(totalProviderNotifierProvider.notifier);

    void _submitEdit() {
      final enteredBudget = int.tryParse(_addBudgetController.text);
      if (enteredBudget == null) {
        _showDialog();
        return;
      }
      totalNotifier.addBudget(enteredBudget);
      Navigator.of(context).pop(); // Close the modal after updating
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Edit Budget',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TextField(
                  controller: _addBudgetController,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Add budget",
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton.icon(
                onPressed: _submitEdit,
                icon: Icon(Icons.add),
                label: Text("Add"),
              ),
            ],
          ),
          const SizedBox(height: 80),
          ElevatedButton.icon(
            onPressed: () {
              // Show confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('New Month Reset'),
                    content: const Text(
                        'Are you sure you want to reset everything to month start?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Call the reset method and close the modal
                          totalNotifier.resetAllToZero();
                          widget.resetAll();
                          Navigator.of(context)
                              .pop(); // Close the confirmation dialog
                          Navigator.of(context).pop(); // Close the modal
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.reset_tv_outlined,
              color: Colors.white,
            ),
            label: const Text(
              'New Month Reset',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
