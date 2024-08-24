import 'package:expense_tracker/providers/lendborrow_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LendBorrowCard extends ConsumerWidget {
  LendBorrowCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalLendBorrow = ref.watch(totalLendBorrowProvider);
    final Color cardTextColor = Colors.white;

    return Card(
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
                  "Lends",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cardTextColor),
                ),
                Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                Text(
                  "₹${totalLendBorrow.totalLend.toString()}",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 101, 241, 106),
                      ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "Borrows",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: cardTextColor,
                      ),
                ),
                Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                Text(
                  "₹${totalLendBorrow.totalBorrow.toString()}",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                        color: const Color.fromARGB(255, 255, 153, 146),
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
