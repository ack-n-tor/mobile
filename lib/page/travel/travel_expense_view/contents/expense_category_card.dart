import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/travel/bloc/travel_expense_bloc/travel_expense_bloc.dart';
import 'package:onesthrm/res/dialogs/confirmation_dialog.dart';

class ExpenseCategoryCard extends StatelessWidget {
  final ExpenseBodyModel? categoryData;
  final int index;

  const ExpenseCategoryCard({super.key, this.categoryData, required this.index});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(title: "Category", value: categoryData?.categoryName ?? ""),
                      const SizedBox(height: 8),
                      _buildDetailRow(title: "Title", value: categoryData?.title ?? ""),
                      const SizedBox(height: 8),
                      _buildDetailRow(title: "Remark", value: categoryData?.remark ?? ""),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildDetailRow(title: "Amount", value: categoryData?.amount ?? "0.0"),
                      const SizedBox(height: 8),
                      Image.network(
                          categoryData?.imageURL ??
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTNNLEL-qmmLeFR1nxJuepFOgPYfnwHR56vcw&s",
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            right: 0,
            top: 0,
            child: InkWell(
                onTap: () {
                  showConfirmationDialog(context: context, title: "Delete Expense", description: "Are you sure you want to delete this expense item?",
                      onDelete: () {
                        context.read<TravelExpenseBloc>().add(RemoveExpenseItemEvent(index: index));
                      });
                },
                child: Image.asset("assets/images/ic_close.png", height: 24, width: 24)))
      ],
    );
  }

  Widget _buildDetailRow({required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title: ",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 14),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
