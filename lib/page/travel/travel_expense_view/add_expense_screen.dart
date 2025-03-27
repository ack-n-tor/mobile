import 'package:flutter/material.dart';
import 'package:onesthrm/page/travel/travel_expense_view/contents/travel_expense_inof_card.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: TravelExpenseInfoCard(),
    );
  }
}
