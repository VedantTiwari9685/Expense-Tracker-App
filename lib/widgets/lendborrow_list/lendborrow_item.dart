import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class LendBorrowItem extends StatelessWidget {
  LendBorrowItem({
    super.key,
    required this.lendborrow,
  });

  final LendBorrow lendborrow;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: lendborrow.ldCat == LDCat.lend
          ? const Color.fromARGB(255, 15, 93, 18)
          : const Color.fromARGB(255, 169, 36, 29),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  lendborrow.person,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Spacer(),
                Text(
                  lendborrow.description,
                  style: Theme.of(context).textTheme.titleSmall,
                )
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                    '₹${lendborrow.amount.toStringAsFixed(2)}' // To make 12.3443 to 12.34
                    ),
                const Spacer(),
                Row(
                  children: [
                    Icon(ldCatIcons[lendborrow.ldCat]),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(lendborrow.formattedDate),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
