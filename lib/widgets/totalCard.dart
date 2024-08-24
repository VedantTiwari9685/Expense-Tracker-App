import 'package:expense_tracker/providers/total_provider.dart';
import 'package:expense_tracker/widgets/expenses_list/edit_total_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Totalcard extends ConsumerWidget {
  Totalcard({super.key, required this.resetAll});
  final void Function() resetAll;
  void _openEditBudgetScreen(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return EditBudgetScreen(
          resetAll: resetAll,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalExpense = ref.watch(totalProviderNotifierProvider);
    final Color cardTextColor = Colors.white;

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (context) {
            return EditBudgetScreen(
              resetAll: resetAll,
            );
          },
        );
      },
      child: Card(
        color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 26,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    "Budget",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: cardTextColor),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                  Text(
                    "₹${totalExpense.totalBudget.toString()}",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 16,
                          color: cardTextColor,
                        ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Spent",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: cardTextColor,
                        ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                  Text(
                    "₹${totalExpense.totalSpent.toString()}",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 16,
                          color: cardTextColor,
                        ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Remaining",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: cardTextColor,
                        ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                  Text(
                    "₹${totalExpense.remaining.toString()}",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 16,
                          color: totalExpense.remaining <= 500
                              ? const Color.fromARGB(255, 207, 99, 91)
                              : Colors.green,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
