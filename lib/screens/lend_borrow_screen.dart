import 'package:expense_tracker/widgets/lendborrowCard.dart';
import 'package:flutter/material.dart';

class LendBorrowScreen extends StatefulWidget {
  LendBorrowScreen({super.key, required this.mainContent});
  final Widget mainContent;
  @override
  State<LendBorrowScreen> createState() => _LendBorrowScreenState();
}

class _LendBorrowScreenState extends State<LendBorrowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          LendBorrowCard(),
          Expanded(child: widget.mainContent),
        ],
      ),
    );
  }
}
