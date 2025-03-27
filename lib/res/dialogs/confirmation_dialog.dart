import 'package:flutter/material.dart';

showConfirmationDialog({required BuildContext context,required String title,required String description,required VoidCallback? onDelete}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Expense'),
        content: Text('Are you sure you want to delete this expense item?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onDelete!();
            },
            child: Text('Delete',style: TextStyle(color: Colors.white),),
          ),
        ],
      );
    },
  );
}
