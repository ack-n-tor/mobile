import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesthrm/page/select_employee/content/employee_list.dart';
import 'package:onesthrm/page/select_employee/content/employee_search.dart';
import 'package:onesthrm/page/phonebook/bloc/phonebook_bloc.dart';

class GetEmployeeContent extends StatelessWidget {
  final bool? complainFor;

  const GetEmployeeContent({super.key, this.complainFor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        complainFor == true ? SizedBox.shrink() : EmployeeSearch(bloc: context.read<PhoneBookBloc>()),
        const Expanded(child: EmployeeList()),
      ],
    );
  }
}
