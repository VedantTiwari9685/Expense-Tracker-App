import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/lendborrow_list/lendborrow_item.dart';
import 'package:flutter/material.dart';

class LendborrowList extends StatelessWidget {
  const LendborrowList(
      {super.key, required this.lendborrow, required this.onRemoveLendBorrow});

  final List<LendBorrow> lendborrow;
  final void Function(LendBorrow lendborrow) onRemoveLendBorrow;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(lendborrow[index]),
        background: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error.withOpacity(0.75),
              borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.delete,
                color: Colors.white,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        onDismissed: (direction) {
          onRemoveLendBorrow(
            lendborrow[index],
          );
        },
        child: LendBorrowItem(
          lendborrow: lendborrow[index],
        ),
      ),
      itemCount: lendborrow.length,
    );
  }
}
